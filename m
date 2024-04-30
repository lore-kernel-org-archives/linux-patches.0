Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C56BC17592;
	Tue, 30 Apr 2024 11:27:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476435; cv=none; b=tx8M2G8BrutSN+YbvFyTo0OrAi7ji152f2zLHLDbDjdl6cukOfTY4lCiPbF085Ae+aZMfSvOBKD8dEPLG9oKxSF7jIQeizbSOc8/NpdhW69zCSTZVw8ty9k68M7Rvxrpagx6GQDZ71MnCyDIog7hlypl76oweZI3DpiRc4Re1jY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476435; c=relaxed/simple;
	bh=6EQueb564aFHuidKhveuoeASYrC5jGNtTWkBfIiApSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RzZCQ3ADBXsIAh1pmH27dCrkCd3MNuJvj/xPQP84QhpwHsYgww+KgDuvcP+WMcwhO0TYbtJhkyu1V482BtwhG4KLbBgGAq6WxEROl+2lPgy576dL632GsRKCnSYDmjKMFr0mxzIqBDl/HGRYx1OFlPUbRT8nUvhJvqYsrwtS34g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOUSh/ar; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOUSh/ar"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 509E7C2BBFC;
	Tue, 30 Apr 2024 11:27:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476435;
	bh=6EQueb564aFHuidKhveuoeASYrC5jGNtTWkBfIiApSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tOUSh/ar9k7ozyjYPC8Q5UCCyMOWGzDKCGINQ2RZfg/xfa5FPM6egdMqn1dQa3tPx
	 A5muo1gAP+K6BqBvy3XsKRxQ69ZYdLUHo4hVAarp7uKM6F+edlUQS1Kzt/36uvC/2n
	 a35KECbX+XPPnE7iIbjDHf/6y83hX34nPqufbgwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vikas Gupta <vikas.gupta@broadcom.com>,
	Michael Chan <michael.chan@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 031/110] bnxt_en: Fix the PCI-AER routines
Date: Tue, 30 Apr 2024 12:40:00 +0200
Message-ID: <20240430103048.487858647@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index e889017e3a7fb..70021b5eb54a6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -13983,6 +13983,7 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
 {
 	struct net_device *netdev = pci_get_drvdata(pdev);
 	struct bnxt *bp = netdev_priv(netdev);
+	bool abort = false;
 
 	netdev_info(netdev, "PCI I/O error detected\n");
 
@@ -13991,16 +13992,27 @@ static pci_ers_result_t bnxt_io_error_detected(struct pci_dev *pdev,
 
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
@@ -14086,6 +14098,7 @@ static pci_ers_result_t bnxt_io_slot_reset(struct pci_dev *pdev)
 	}
 
 reset_exit:
+	clear_bit(BNXT_STATE_IN_FW_RESET, &bp->state);
 	bnxt_clear_reservations(bp, true);
 	rtnl_unlock();
 
-- 
2.43.0



