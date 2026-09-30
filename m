Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6ED0951993C;
	Wed, 30 Sep 2026 18:31:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793074; cv=none; b=ZQbmfQAajp3EeKEHqdLw9HiQ84Gk6yhBryxUEPmRtB/QW+o7BmNcGoi77fg2bDdxaVApCzdV0rKWasDDy7ohwfdIMGveGchte0KBeZ70k7beyHFC1BQN9LVr/9N71MicFeS6ATc41x5GGvL4KGklBjCj2MmtbaKbsNuDKAfVIDU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793074; c=relaxed/simple;
	bh=ymyDS/fxLaHMx6pHbf4DtRXxL0rPm8ddqF3ABXwKk+s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f6vIx+a2WuudAPxgcCv8GwhTHemZvUKlmMHtYTP8jaAcvFmGr7SQpoK4D+iWGhP4lzRf1X1W3NWq45Y8pUXcwA9EXDl5TBUm5ju72LQ6r8c1j6rYP0EXR9UFuqwyODnVkRGIU6zf7jRTBHbw5ILAqguMxelzwUV7X15XE8myyoU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/v+9c/5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/v+9c/5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4F4F1F000FF;
	Wed, 30 Sep 2026 18:31:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793073;
	bh=IyumhMhM7Mtjw4yBeP4jrkicbuO2k+Y13TxXybExr40=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F/v+9c/5eDmanY+XgEZkFZi01FCmldqE60nCT6+pGX5G8VVlmY7VkE4Z8lMa6Iq0H
	 hx56Heu3pVa6mVgo3N/4XK5YNaciA9bMTkbiuuvmq9L1AFm5ocPqJxJdU+JozVv1+l
	 Djz1A6CnUJIcd+h7TmBGR7d3jqLzpZmVmBEgpJ84=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Duyck <alexanderduyck@fb.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 081/395] eth: fbnic: reset num_napi when the napi vectors are freed
Date: Wed, 30 Sep 2026 17:25:43 +0200
Message-ID: <20260930152342.395910061@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexanderduyck@fb.com>

[ Upstream commit 4bcc4a92c603fe7f062cea22e20da2e0ad6b12c3 ]

fbn->num_napi is the count of live napi vectors, each of which owns an
IRQ.  The PM path had freed them without clearing the count.
fbnic_pm_suspend() tears the datapath down via ndo_stop() and frees the
IRQs, but leaves netif_running() true so resume knows to re-open.  Resume
rebuilds the datapath in __fbnic_pm_resume() and fbnic_reset_queues() sets
num_napi and __fbnic_open() re-allocates the vectors.

When the datapath is torn down but never rebuilt, num_napi is left
pointing at freed vectors under 2 different scenarios:
 - a PCIe error recovery that fails (fbnic_err_slot_reset() ->
   __fbnic_pm_resume() returns an error -> PCI_ERS_RESULT_DISCONNECT), so
   .resume never runs; or
 - an __fbnic_open() that fails partway on resume and unwinds, freeing
   the vectors after fbnic_reset_queues() has already set num_napi.

The netdev is then running with num_napi > 0 but napi[] freed, and the
eventual remove/unbind close re-enters fbnic_down() -> fbnic_dbg_down()
and dereferences the freed vectors:
  BUG: kernel NULL pointer dereference, address: 0000000000000210
  RIP: fbnic_dbg_down+0x28

Clear num_napi when the vectors are freed: in the suspend teardown (a
good resume re-establishes it before __fbnic_open()) and on the resume
open failure.  A redundant ndo_stop() then walks an empty napi[].  The
normal ndo_stop() down/up cycle is untouched and keeps num_napi for the
next ndo_open().

Fixes: bc6107771bb4 ("eth: fbnic: Allocate a netdevice and napi vectors with queues")
Signed-off-by: Alexander Duyck <alexanderduyck@fb.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/178942021809.7700.10804028989308077839.stgit@ahduyck-xeon-server.home.arpa
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/meta/fbnic/fbnic_pci.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
index 99b7c0718e80e..cabbc88bb92db 100644
--- a/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
+++ b/drivers/net/ethernet/meta/fbnic/fbnic_pci.c
@@ -414,6 +414,7 @@ static int fbnic_pm_suspend(struct device *dev)
 {
 	struct fbnic_dev *fbd = dev_get_drvdata(dev);
 	struct net_device *netdev = fbd->netdev;
+	struct fbnic_net *fbn;
 
 	if (fbnic_init_failure(fbd))
 		goto null_uc_addr;
@@ -421,11 +422,16 @@ static int fbnic_pm_suspend(struct device *dev)
 	rtnl_lock();
 	netdev_lock(netdev);
 
+	fbn = netdev_priv(netdev);
+
 	netif_device_detach(netdev);
 
 	if (netif_running(netdev))
 		netdev->netdev_ops->ndo_stop(netdev);
 
+	/* The IRQs are about to be freed, so drop the napi vector count */
+	fbn->num_napi = 0;
+
 	netdev_unlock(netdev);
 	rtnl_unlock();
 
@@ -488,16 +494,20 @@ static int __fbnic_pm_resume(struct device *dev)
 	if (fbnic_init_failure(fbd))
 		return 0;
 
+	rtnl_lock();
+	netdev_lock(netdev);
+
 	fbn = netdev_priv(netdev);
 
 	/* Reset the queues if needed */
 	fbnic_reset_queues(fbn, fbn->num_tx_queues, fbn->num_rx_queues);
 
-	rtnl_lock();
-	netdev_lock(netdev);
-
-	if (netif_running(netdev))
+	if (netif_running(netdev)) {
 		err = __fbnic_open(fbn);
+		/* On failure the vectors are freed, so drop the count */
+		if (err)
+			fbn->num_napi = 0;
+	}
 
 	netdev_unlock(netdev);
 	rtnl_unlock();
-- 
2.53.0



