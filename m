Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 090CA46AA80;
	Tue, 21 Jul 2026 15:36:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648176; cv=none; b=WnGsu6oa5vpsqT1HyGNcj5REIGaUuCawpSls9YcPn/K57HivNTYHqhT7LhliCr1wHFZPPBASdXA7CAi5Lvs6HNf76A8mZNtmzL4eAEJLmXxs9YIQicz56a7BTwLatr02R30kos7v/O8Px8b9BqI/N4h5IRO+oOoQdXnDjXFVMxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648176; c=relaxed/simple;
	bh=k8BJK5PVGc/lqs0Qi5VuUk1ayRY2ZSsWJxaopKBffWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SVwbzQhth8+I0ldtXXvboZNC2HrtfGKPmE9zLGJCRqNzSV0dFU2nwwFCAb4Ztp//mX1Z4mvKW/aIEMehKzAHgjj3SazXlmRC76lrVQEV3GliE9MiNsQS79cgTwKij5g8mN79rMedqtIIHqVTpb4veJ1uwGRom5bhEoNsUW9NMs8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tVBvyRlm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tVBvyRlm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 220191F000E9;
	Tue, 21 Jul 2026 15:36:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648174;
	bh=7tSOA2UOp4D973yoRpRIeQ5JIdKRWm7yoVSPAxEDqxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tVBvyRlm0Lz4Wmy0R7X7mTyKWwaf40qeIokUBe0m9PPH9VQ2WeOJudZmUAkBmjl54
	 3FdSNmDeP1W5qMblbK5plPMuwwz9u79jrhhurAO0Zetr57OZW0IG1sfmrJxmIGfjPs
	 vhHKXqXopKyvSwxKJ8nI1enEs8DrNoIe5+8Q0H+M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chin-Yen Lee <timlee@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0101/2077] wifi: rtw88: fix wrong pci_get_drvdata type in AER handlers
Date: Tue, 21 Jul 2026 16:56:14 +0200
Message-ID: <20260721152555.074459273@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chin-Yen Lee <timlee@realtek.com>

[ Upstream commit 706183dbef4a79d120d4e928f693bea50df496f8 ]

rtw88 stores an ieee80211_hw pointer via pci_set_drvdata() at probe
time, but io_error_detected() and io_resume() retrieve it as a
net_device pointer.  This causes netif_device_detach/attach to
operate on an ieee80211_hw struct, reading and writing at wrong
offsets.

Use ieee80211_stop_queues/wake_queues instead, consistent with
every other queue stop/start path in the driver.

Fixes: cdb82c80b934 ("wifi: rtw88: pci: add PCI Express error handling")
Signed-off-by: Chin-Yen Lee <timlee@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260413065926.17027-1-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw88/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw88/pci.c b/drivers/net/wireless/realtek/rtw88/pci.c
index bba370ad510cf7..c56beacbb1b03f 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1711,9 +1711,9 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
 static pci_ers_result_t rtw_pci_io_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 
-	netif_device_detach(netdev);
+	ieee80211_stop_queues(hw);
 
 	return PCI_ERS_RESULT_NEED_RESET;
 }
@@ -1730,12 +1730,12 @@ static pci_ers_result_t rtw_pci_io_slot_reset(struct pci_dev *pdev)
 
 static void rtw_pci_io_resume(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 
 	/* ack any pending wake events, disable PME */
 	pci_enable_wake(pdev, PCI_D0, 0);
 
-	netif_device_attach(netdev);
+	ieee80211_wake_queues(hw);
 }
 
 const struct pci_error_handlers rtw_pci_err_handler = {
-- 
2.53.0



