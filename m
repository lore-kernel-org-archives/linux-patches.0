Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2132C46AA81;
	Tue, 21 Jul 2026 15:36:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784648173; cv=none; b=q3+nwhnGjq/0BrAA7juDJVZke3zEDPxG4KCXc7XF8qvotaWq7/TV6Gb4iX0mJsW3WpaUctU0DIQ+VNY5GM8EiwirirCqO0Z6WD9YIktNSTAZk72b7ML7WnjlykwDB72OVLsB3Jnx7Nmi1AYC9hzxUy4KsAO5KbBuewcbDbGkK9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784648173; c=relaxed/simple;
	bh=Nbf4aw8PDL7xmn4VOuZ7MDZwx8S5Gf3PKCWwcTisioA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CC658yQt8KyNtOFZ/caYO8eCN64sU3ZFn2UabDmd2WUKhGIEdALvj7a1fnwj1zsRFFEKeXJBpSlPuF3UaqTVFsdW52pdsuqrBX97CbqUMtgeEhYJVgYoV1zGgdSZuWzOyumx3dmZ7kEQw4JJbJcVbvvOtP+Line3D6xrRTdQNIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hiaydf/M; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hiaydf/M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7CAC21F000E9;
	Tue, 21 Jul 2026 15:36:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784648172;
	bh=B7PxxhiW+B7hieJbcaCIj3LegcieNa/2F6gW6e0s5ak=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hiaydf/MqYu5MXC2XfB/BDLNtPJy2iwkzpkAO+xnmY7ML24o6xnsbjWFJeMobXFwQ
	 nZ+xw1CpFicFqKW7piNLBDId6mKfolNxJYszQxpx+knHFd7mbDHFfHTN53u5rGW44y
	 mE0C8QjLPgGZNZizyCRWUNj48gGS52HbCWL1w1ys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christos Longros <chris.longros@gmail.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0100/2077] wifi: rtw89: fix wrong pci_get_drvdata type in AER handlers
Date: Tue, 21 Jul 2026 16:56:13 +0200
Message-ID: <20260721152555.051472744@linuxfoundation.org>
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
index 43c61b3dc969f2..64554eb35a72cf 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -4624,9 +4624,9 @@ EXPORT_SYMBOL(rtw89_pm_ops);
 static pci_ers_result_t rtw89_pci_io_error_detected(struct pci_dev *pdev,
 						    pci_channel_state_t state)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 
-	netif_device_detach(netdev);
+	ieee80211_stop_queues(hw);
 
 	return PCI_ERS_RESULT_NEED_RESET;
 }
@@ -4643,12 +4643,12 @@ static pci_ers_result_t rtw89_pci_io_slot_reset(struct pci_dev *pdev)
 
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



