Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06E12346789;
	Tue, 11 Nov 2025 01:22:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824172; cv=none; b=Us7SBzOjmAF1WSH/xPka0Nywde7CSbaoeQdlVTDZ0m7feQOKqxSDfatjfNm/eOSbWQ/FM3ruoUX2WQK2yud5BG5HrLKdgrcHY43gwCZs6hSbGrDraStWoVeGqH6xmc3Y5MHagwnEuvvwWrRUgsq4cnjSoHNmZiX+WfCDVF51YIs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824172; c=relaxed/simple;
	bh=9OlPzqvsJikKzsxfW//CRJyxcDs/vKbHzsdRpjVeU2o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFru8fJ60uOt0m62K57ERDZdRLvzFJn02dcPuDwN+9JPbAfNvFM2lXCkgq+XBaYJfi/xNTBh7ktWbEscWyHe0o0+7eRap7pWXvSU+JF4DN5xyiOfnPghRp1JmarwUc+YaNZjWxv1kFeQD/P+D17xPUz1vC2WnacfpyrCeCQIMNE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlhHOf8A; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlhHOf8A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4370EC116B1;
	Tue, 11 Nov 2025 01:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824171;
	bh=9OlPzqvsJikKzsxfW//CRJyxcDs/vKbHzsdRpjVeU2o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlhHOf8AZgARfPHIg04vv29zaPez6gSl6CHqC+u0DrrYyfsJx+Qu8IuAqIaOJ9WXJ
	 +BR2RIFBBmP9/2hbpJcCrS9aNO+/my+HIt8CcNBX++1YTGFjbWYOCsb2XdreG+xtDg
	 HJn0E7OiEuC8TyjTMftNsOWgHLsGP/5+yTHgDUGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nimesh Sati <nimesh.sati@samsung.com>,
	Bharat Uppal <bharat.uppal@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 407/849] scsi: ufs: exynos: fsd: Gate ref_clk and put UFS device in reset on suspend
Date: Tue, 11 Nov 2025 09:39:37 +0900
Message-ID: <20251111004546.280693374@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bharat Uppal <bharat.uppal@samsung.com>

[ Upstream commit 6d55af0f0740bf3d77943425fdafb77dc0fa6bb9 ]

On FSD platform, gating the reference clock (ref_clk) and putting the
UFS device in reset by asserting the reset signal during UFS suspend,
improves the power savings and ensures the PHY is fully turned off.

These operations are added as FSD specific suspend hook to avoid
unintended side effects on other SoCs supported by this driver.

Co-developed-by: Nimesh Sati <nimesh.sati@samsung.com>
Signed-off-by: Nimesh Sati <nimesh.sati@samsung.com>
Signed-off-by: Bharat Uppal <bharat.uppal@samsung.com>
Link: https://lore.kernel.org/r/20250821053923.69411-1-bharat.uppal@samsung.com
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index f0adcd9dd553d..513cbcfa10acd 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1896,6 +1896,13 @@ static int fsd_ufs_pre_pwr_change(struct exynos_ufs *ufs,
 	return 0;
 }
 
+static int fsd_ufs_suspend(struct exynos_ufs *ufs)
+{
+	exynos_ufs_gate_clks(ufs);
+	hci_writel(ufs, 0, HCI_GPIO_OUT);
+	return 0;
+}
+
 static inline u32 get_mclk_period_unipro_18(struct exynos_ufs *ufs)
 {
 	return (16 * 1000 * 1000000UL / ufs->mclk_rate);
@@ -2162,6 +2169,7 @@ static const struct exynos_ufs_drv_data fsd_ufs_drvs = {
 	.pre_link               = fsd_ufs_pre_link,
 	.post_link              = fsd_ufs_post_link,
 	.pre_pwr_change         = fsd_ufs_pre_pwr_change,
+	.suspend                = fsd_ufs_suspend,
 };
 
 static const struct exynos_ufs_drv_data gs101_ufs_drvs = {
-- 
2.51.0



