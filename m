Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74CA5326D44;
	Tue, 21 Jul 2026 17:40:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655645; cv=none; b=kmc+JAsle7tEMd+oi/e9bNyunfwARGXyQBoMBmuzjQfFEt9gaA3d4GwUQOhEP0Hvt8HivISUqnW0ZigBGhcHSaJN+3PdQE9fQgkyMIoRRK0YoMlQ52Wr3zY5OdlX+u5d6v0pNfdSBnXwaE5P2HHA7c/vIPmLb7mqIfRcKX2tPfw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655645; c=relaxed/simple;
	bh=mhdHWaSPLyYSyqAoFTWecKwz6QVAxhgCWc31Ztg6oDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dtAsX1IQrwD4gcjCsos9AMGOBPfEkGzLZ6LjRFOdiVqPCeJCK9kMca8B8zuzILjlPEQQUpBv3wyoNhCGQH73QdDAN3h8CTZ27sOT6u7LyrvF+IrGJPT+xXCO8qDh3STI/5h27gLmQdwbOs7ob9JpB4lwMChFE0D6QP/+97zcIdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKHNtFnZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKHNtFnZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8C11F000E9;
	Tue, 21 Jul 2026 17:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655644;
	bh=fhtZLs9mKYemR5s4rwLDCufiupmcysnyXTriMO302M8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SKHNtFnZbXcGAxjy/kHJR07l5sh7QkCIUQQdOxKPWufToNpJDGXoiO9m8YVdVuLV7
	 VVVFBRZOvPQIoG5QPle7W5lUyS7ZeZsk0jxfKrszK41/O4wy/vPyFmnQEXN3y8/UWq
	 KnU+BR+kDH9uXoBb8ipfsN1vZoT6eXMBvLAWcgZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christos Longros <chris.longros@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0086/1611] wifi: rtw89: fix wrong pci_get_drvdata type in AER handlers
Date: Tue, 21 Jul 2026 17:03:22 +0200
Message-ID: <20260721152516.779106271@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Christos Longros <chris.longros@gmail.com>

[ Upstream commit 7068c379cf9aa8afe4dce4d9d82390187aa9c4d0 ]

rtw89 stores an ieee80211_hw pointer via pci_set_drvdata() at probe
time, but io_error_detected() and io_resume() retrieve it as a
net_device pointer.  This causes netif_device_detach/attach to
operate on an ieee80211_hw struct, reading and writing at wrong
offsets.  The adjacent io_slot_reset() already does it correctly.

Use ieee80211_stop_queues/wake_queues instead, consistent with
every other queue stop/start path in the driver.

Tested on RTL8852CE by calling the handlers from a test module
before and after the fix.

Fixes: 16e3d93c6183 ("wifi: rtw89: pci: add PCI Express error handling")
Signed-off-by: Christos Longros <chris.longros@gmail.com>
Acked-by: Ping-Ke Shih <pkshih@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260329073857.113081-1-chris.longros@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 6be1849b0c4d2f..17a199ee1d4a41 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -4605,9 +4605,9 @@ EXPORT_SYMBOL(rtw89_pm_ops);
 static pci_ers_result_t rtw89_pci_io_error_detected(struct pci_dev *pdev,
 						    pci_channel_state_t state)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 
-	netif_device_detach(netdev);
+	ieee80211_stop_queues(hw);
 
 	return PCI_ERS_RESULT_NEED_RESET;
 }
@@ -4624,12 +4624,12 @@ static pci_ers_result_t rtw89_pci_io_slot_reset(struct pci_dev *pdev)
 
 static void rtw89_pci_io_resume(struct pci_dev *pdev)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 
 	/* ack any pending wake events, disable PME */
 	pci_enable_wake(pdev, PCI_D0, 0);
 
-	netif_device_attach(netdev);
+	ieee80211_wake_queues(hw);
 }
 
 const struct pci_error_handlers rtw89_pci_err_handler = {
-- 
2.53.0



