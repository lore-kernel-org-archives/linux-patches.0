Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 51FB3360ECA;
	Wed, 30 Sep 2026 18:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790794283; cv=none; b=dLyoo+9NFNY01kIh6HBJad/EZk9ulJeuxBOJX3LtBH61VZqCQaa1YhoGRSUm6yTBNSeNmVyhPIMUswnVd1BZ9Dvtv9priF89wQoDb2W2vfw/ZvWTykWrvn+3rXi0sprhaZKWMMnOwcbyf+oo25Fl/PhaiXldk0qRIw1KNRoS1zQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790794283; c=relaxed/simple;
	bh=qsEt80eVDsEuCLHSvzH+MAKEWhRQe1gpAP6Ij/H7wmE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mGud4viFXPd/5iwgTxCFu867O4OH+bD+c4LWs/v9SKSTfx354ap1fcc6M2WyMv4LI0sFDA7losSf5d0doS56l9daklM94siciIdj+HOb6Uie6Fn+5WMYBCElM9Msbo5jCR4Ade76+ejvkndxh6yl4mO9exVWKqoWvsQfL6TeJRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d5yKi75a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d5yKi75a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADFA91F000FF;
	Wed, 30 Sep 2026 18:51:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790794282;
	bh=vUWxNjYsRfZ9yUmr2qHlKHkXn9fFV97qf9ELcUWVy6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=d5yKi75ajMLYzG40YBzXosFS3JIM1B2CySXwYQASQu5TueIBsl9fZvcUkZzzfZOcc
	 ngvZbdBYyrk0Er+4DU/ffSU4DVTx3bQcu+M09T4An/Di4NuJFkynyrvh+Obo2t8Syp
	 j/ohSv+0hLxEHJOIKvhT6zsDYW4gAFCTbI2fVcxs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dian-Syuan Yang <dian_syuan0116@realtek.com>,
	Ping-Ke Shih <pkshih@realtek.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0101/1193] wifi: rtw89: pci: enable LTR based on pcie control register
Date: Wed, 30 Sep 2026 17:13:05 +0200
Message-ID: <20260930152436.478317466@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dian-Syuan Yang <dian_syuan0116@realtek.com>

[ Upstream commit 779bbe1902f29d0ef131249ddd42a8dfbe21d0fb ]

Originally, driver always transmits LTR (Latency Tolerance Reporting) to
pcie host, but it may cause pcie link down on some platforms because
LTR is not supported. As a result, driver will check the control
register of LTR setting to decide whether to enable LTR feature.

This applies to Wi-Fi 6 chips only. For Wi-Fi 7 chips, although the
driver still issues LTR, the hardware has its own internal logic
to determine whether to actually transmit it to pcie host.

Signed-off-by: Dian-Syuan Yang <dian_syuan0116@realtek.com>
Signed-off-by: Ping-Ke Shih <pkshih@realtek.com>
Link: https://patch.msgid.link/20260515014433.16168-5-pkshih@realtek.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtw89/pci.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtw89/pci.c b/drivers/net/wireless/realtek/rtw89/pci.c
index 1ac5d021893d3..1a1027dd01d3e 100644
--- a/drivers/net/wireless/realtek/rtw89/pci.c
+++ b/drivers/net/wireless/realtek/rtw89/pci.c
@@ -2543,6 +2543,17 @@ static int rtw89_pci_mode_op(struct rtw89_dev *rtwdev)
 	return 0;
 }
 
+static bool rtw89_pci_dev_ltr_enabled(struct rtw89_dev *rtwdev)
+{
+	struct rtw89_pci *rtwpci = (struct rtw89_pci *)rtwdev->priv;
+	struct pci_dev *pdev = rtwpci->pdev;
+	u16 cap;
+
+	pcie_capability_read_word(pdev, PCI_EXP_DEVCTL2, &cap);
+
+	return !!(cap & PCI_EXP_DEVCTL2_LTR_EN);
+}
+
 static int rtw89_pci_ops_deinit(struct rtw89_dev *rtwdev)
 {
 	const struct rtw89_pci_info *info = rtwdev->pci_info;
@@ -2646,7 +2657,7 @@ int rtw89_pci_ltr_set(struct rtw89_dev *rtwdev, bool en)
 {
 	u32 val;
 
-	if (!en)
+	if (!en || !rtw89_pci_dev_ltr_enabled(rtwdev))
 		return 0;
 
 	val = rtw89_read32(rtwdev, R_AX_LTR_CTRL_0);
@@ -2682,6 +2693,9 @@ int rtw89_pci_ltr_set_v1(struct rtw89_dev *rtwdev, bool en)
 	u32 dec_ctrl;
 	u32 val32;
 
+	if (!rtw89_pci_dev_ltr_enabled(rtwdev))
+		return 0;
+
 	val32 = rtw89_read32(rtwdev, R_AX_LTR_CTRL_0);
 	if (rtw89_pci_ltr_is_err_reg_val(val32))
 		return -EINVAL;
-- 
2.53.0



