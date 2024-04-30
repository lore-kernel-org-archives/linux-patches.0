Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 269E612C46B;
	Tue, 30 Apr 2024 10:49:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714474164; cv=none; b=G4WCjls1wj4cgNG7hZWJ0WzOUepCA3kOqDp+HZ4l0klLslSIpx7sT4UG+HK4jqx7E1g/5rLj8Q7KYmZxbT1AJSWzTBQSMU/12QL7bfqfy10tST1i2CUxKaHnnPIzGTq3A8TdwBzczB2/P7FV4Zu8I4ETdQnatmjO7A2bO4WvAWs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714474164; c=relaxed/simple;
	bh=Rj5DZq6P+Ga6d6YXJiw3ra+7J1MdRscVeSWyqd+IyRk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Uk58BMsXk6IsIfldONle9Q/KXfsldFAnqanhcZIjiDFBjDwdKFYJdOWe2veUGrIyT0cilFlT6J58D/+StKi8XpmcyAPN3rcOzuZwQjK9jPcUpcJF4xuqoIAqOxI5w/k0R+x1t5AT1CRydr0ejGltHx+3rLRok5DYBt0HtJySuZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C7YFnHuJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C7YFnHuJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A25F3C4AF19;
	Tue, 30 Apr 2024 10:49:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714474164;
	bh=Rj5DZq6P+Ga6d6YXJiw3ra+7J1MdRscVeSWyqd+IyRk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C7YFnHuJsc2APb9hYz7eLyJGdJ8gBuleTuRgwHkuJFoztOwv74OxqtRQUUaDLtfdn
	 kork/QMrZMRgOVEe8RC8q7ZQifQ+hzgDLEznqOUGI2cn/rNzc4LNTDwixE5gzjjP4l
	 zMx+xppHIhWdE9+2n/LSz4bkiUnEBAHO+GbBmr0E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 058/228] bnxt_en: Fix the PCI-AER routines
Date: Tue, 30 Apr 2024 12:37:16 +0200
Message-ID: <20240430103105.483356814@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103103.806426847@linuxfoundation.org>
References: <20240430103103.806426847@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vikas Gupta <vikas.gupta@broadcom.com>

[ Upstream commit a1acdc226baec331512f815d6ac9dd6f8435cc7f ]

We do not support two simultaneous recoveries so check for reset
flag, BNXT_STATE_IN_FW_RESET, and do not proceed with AER further.
When the pci channel state is pci_channel_io_frozen, the PCIe link
can not be trusted so we disable the traffic immediately and stop
BAR access by calling bnxt_fw_fatal_close().  BAR access after
AER fatal error can cause an NMI.

Fixes: f75d9a0aa967 ("bnxt_en: Re-write PCI BARs after PCI fatal error.")
Signed-off-by: Vikas Gupta <vikas.gupta@broadcom.com>
Signed-off-by: Michael Chan <michael.chan@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 260ffd71e2a89..6bdd8c2607898 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -15045,6 +15045,7 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(netdev);
+	bool abort = false;
 
 	netdev_info(netdev, "PCI I/O error detected\n");
 
@@ -15053,16 +15054,27 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
 
 	bnxt_ulp_stop(bp);
 
-	if (state == pci_channel_io_perm_failure) {
+	if (test_and_set_bit(BNXT_STATE_IN_FW_RESET, &bp->state)) {
+		netdev_err(bp->dev, "Firmware reset already in progress\n");
+		abort = true;
+	}
+
+	if (abort || state == pci_channel_io_perm_failure) {
 		rtnl_unlock();
 		return PCI_ERS_RESULT_DISCONNECT;
 	}
 
-	if (state == pci_channel_io_frozen)
+	/* Link is not reliable anymore if state is pci_channel_io_frozen
+	 * so we disable bus master to prevent any potential bad DMAs before
+	 * freeing kernel memory.
+	 */
+	if (state == pci_channel_io_frozen) {
 		set_bit(BNXT_STATE_PCI_CHANNEL_IO_FROZEN, &bp->state);
+		bnxt_fw_fatal_close(bp);
+	}
 
 	if (netif_running(netdev))
-		bnxt_close(netdev);
+		__bnxt_close_nic(bp, true, true);
 
 	if (pci_is_enabled(pdev))
 		pci_disable_device(pdev);
@@ -15146,6 +15158,7 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 	}
 
 reset_exit:
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 	bnxt_clear_reservations(bp, true);
 	rtnl_unlock();
 
-- 
2.43.0



