Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D2B2AEE1;
	Mon, 17 Aug 2026 14:44:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977846; cv=none; b=UaSxbc7dMQiSegSuPZ2HEaAuFIVFVoGyDGOWSSBkELmoWIeOMx7eEbyQuB/3ReV5V6oaSk1imZfcd+8AOwA4rMkyIXm8jQLCbFMobZN0iF6g4tmguCqiqPa8HNKZ6bT/YIlUM6DZeodnewgFeXh0KmdacGPD6w1Rs9IukwmbAWg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977846; c=relaxed/simple;
	bh=SVxQWa38LPOIcFvJ25/XNmEYKL1U3IqrZkTbYgJAb3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VxgAR0Dwv5lg4OVoXCYG89fPTX4qIdOhU+BvAlSMEvh3CUCpEq5tdc5dIuT4ftfm6SnDo0VMxGLrNSE2StS0oq6lMx2O3j98x6ciQOAa3NSAH4o4SrA0B2mSsf6oEm/O3wCN8IizOiF2SuoZ7V/wIcya0QGWafkkNCDbUz/J7Ac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lxGAFyy5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lxGAFyy5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC1751F000E9;
	Mon, 17 Aug 2026 14:44:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977845;
	bh=t/Aa6aVR1QirXWgAF/vRfBnH/7BwvHNIDsrAQmV5z6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lxGAFyy57r56lZbBblp/01LVlLB3IDhe4s3LXc0Do9x+684gHNIsagBlSeH7rFP2I
	 JI0WF7GMqrCa7BFaFBCrSl6Td2gyHLqJm9D0OIxaWNQRHo/O0oK/qVV1uos8/oXu8j
	 keMLaHnGH8HrssRBQqVa63geWcULjI5zDX/UJBwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Satish Kharat <satishkh@cisco.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 014/181] enic: fix tx_hang_reset use-after-free on device removal
Date: Mon, 17 Aug 2026 15:31:48 +0200
Message-ID: <20260817132535.957063265@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Satish Kharat <satishkh@cisco.com>

[ Upstream commit ec680ea4ba1bca92a767fb7e7869758bfdd886e3 ]

enic_remove() cancels the reset and change_mtu_work items but does not
cancel tx_hang_reset. A TX timeout that fires while the device is being
removed can schedule enic_tx_hang_reset() so that it runs after
free_netdev(), resulting in a use-after-free.

cancel_work_sync() alone is not sufficient here: the still-live watchdog
and notify paths can re-schedule these work items in the window between
the cancel and unregister_netdev(). Use disable_work_sync(), which
cancels the work and blocks any subsequent schedule_work() from
requeuing it, and apply it to the reset and change_mtu_work items as
well so the same requeue race is closed for all teardown work.

Fixes: 937317c7c109 ("enic: do hang reset only in case of tx timeout")
Signed-off-by: Satish Kharat <satishkh@cisco.com>
Link: https://patch.msgid.link/20260728062730.2394873-1-satishkh@cisco.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/cisco/enic/enic_main.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/cisco/enic/enic_main.c b/drivers/net/ethernet/cisco/enic/enic_main.c
index a432783756d8c..e474cef720630 100644
--- a/drivers/net/ethernet/cisco/enic/enic_main.c
+++ b/drivers/net/ethernet/cisco/enic/enic_main.c
@@ -3141,8 +3141,9 @@ static void enic_remove(struct pci_dev *pdev)
 	if (netdev) {
 		struct enic *enic = netdev_priv(netdev);
 
-		cancel_work_sync(&enic->reset);
-		cancel_work_sync(&enic->change_mtu_work);
+		disable_work_sync(&enic->reset);
+		disable_work_sync(&enic->tx_hang_reset);
+		disable_work_sync(&enic->change_mtu_work);
 		unregister_netdev(netdev);
 		enic_dev_deinit(enic);
 		vnic_dev_close(enic->vdev);
-- 
2.53.0



