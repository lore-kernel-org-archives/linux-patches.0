Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9ED7B34886F;
	Tue, 11 Nov 2025 01:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762823763; cv=none; b=uZ9OYtwMqAMBYvp04oAJtX1WsJsNQhgBCeH9kY0n/zCJgnsFHZKenlWfqTY1wrVL5aCTs51QjlZteEO7luQxATLzO51QDa06U0hxS9M6krGDrfRN4D2WMvPQhIjck/hT2Yuxxh8sEj4B+uepUj081qiPt2Rfxdw/1g7jrvbMUN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762823763; c=relaxed/simple;
	bh=79smmCPBx/zQi56gtC0cUGf1+EsUry+Tm7TEMwptic0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTlqdJeM88HEOUsLJG8ub7sJ5AG7JZabcxcedUc5c85/uxIcKdf8kSrIkduRyYHSlazbuqdRQn3DOLCzz2g/ytZOmINGehIgus6ibxkwY0TFiL6Rky/uPDYnTYd3mMKi2NyyA7gv8xKe11Kws4Mk1Mb1Ns3OMDVSFLIKMXKNUrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DO/RL8cW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DO/RL8cW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37065C4CEF5;
	Tue, 11 Nov 2025 01:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762823763;
	bh=79smmCPBx/zQi56gtC0cUGf1+EsUry+Tm7TEMwptic0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DO/RL8cW1s8DbBaUYuhDuJcwsHzqsHutbtjcLaw8JU5Fy7HnojSZgCDVk5hri9rS7
	 zDAleRyAdf7inHbwqJHiNxMaxw+oH1I0cn2urwnoMp0L9heiHJOjN6AY5dJOqIqrU1
	 H0wvB9d1tZW9F9wGPMnKmn2nNxkfwDIl/atQR9sQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nimesh Sati <nimesh.sati@samsung.com>,
	Bharat Uppal <bharat.uppal@samsung.com>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 279/565] scsi: ufs: exynos: fsd: Gate ref_clk and put UFS device in reset on suspend
Date: Tue, 11 Nov 2025 09:42:15 +0900
Message-ID: <20251111004533.157248878@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 6bd1532bfd1d6..6a337e058e5c4 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -1882,6 +1882,13 @@ static int fsd_ufs_pre_pwr_change(struct exynos_ufs *ufs,
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



