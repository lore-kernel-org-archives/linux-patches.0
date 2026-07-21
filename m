Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1762A326D44;
	Tue, 21 Jul 2026 17:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784655648; cv=none; b=ecGD7fePYMZcEe7w16g12Gu8UrnQF7Ti4uwEqrMcqdnzUExt31aUkcK+yyrixeIgGO548WJxFVgMyMAeAcK/SNzSJUJ3LLOatATLYPFlL7BZz8OJ9DXVds+BTDf/ICoCkGp5MM2SQ/bj4l1+fxOm561sNbFvS2zx1yOUXJEHyQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784655648; c=relaxed/simple;
	bh=CGDBzj80k92sMyUQAewOqRz7skPKNDztPpsmGGm2Nn4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=inNo1FxBKBDm2fDrrDM3DQ+vFy/nUo1YUB+ADEF9KcsVoOgBsptLSEnawyJBAZTmVmYh8uw5XQFC4ZHIK90ScKRdme7LmjfrrLTBCTjWaRaVSUOQnssA+YWAMjVCedgQDyh4QEZpLlwgYdoJQinGsbuwMaZHB1YZxNLDk13YXW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IRdkrGYZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IRdkrGYZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7EB951F000E9;
	Tue, 21 Jul 2026 17:40:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784655647;
	bh=emEzfANhXYz1/nIoRLZz8cOm4PS9KltzcTR095j82Mw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IRdkrGYZFbnF7CNCmYFCP3rAUDW7aIQ4199rZ/67nh5P5t8cYVjwqY3+UNOv5e9Fm
	 NtRDgjYUq8pdnqtyLmWMTbgDnN+uRE94oKL1ECpf29nkNUucR9V6pxCcxgAh+X0Xjp
	 IhHashRSQbALlC3BKxIfxMAnrF41zGaiVFhuqjnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chin-Yen Lee <timlee@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0087/1611] wifi: rtw88: fix wrong pci_get_drvdata type in AER handlers
Date: Tue, 21 Jul 2026 17:03:23 +0200
Message-ID: <20260721152516.801751979@linuxfoundation.org>
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
index ec0a45bfb670eb..d6d8386f930a9a 100644
--- a/drivers/net/wireless/realtek/rtw88/pci.c
+++ b/drivers/net/wireless/realtek/rtw88/pci.c
@@ -1710,9 +1710,9 @@ static void rtw_pci_napi_deinit(struct rtw_dev *rtwdev)
 static pci_ers_result_t rtw_pci_io_err_detected(struct pci_dev *pdev,
 						pci_channel_state_t state)
 {
-	struct net_device *netdev = pci_get_drvdata(pdev);
+	struct ieee80211_hw *hw = pci_get_drvdata(pdev);
 
-	netif_device_detach(netdev);
+	ieee80211_stop_queues(hw);
 
 	return PCI_ERS_RESULT_NEED_RESET;
 }
@@ -1729,12 +1729,12 @@ static pci_ers_result_t rtw_pci_io_slot_reset(struct pci_dev *pdev)
 
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



