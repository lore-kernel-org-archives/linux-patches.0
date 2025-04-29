Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9329922A81D;
	Tue, 29 Apr 2025 17:07:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946451; cv=none; b=KiH+lUZZqmCl/X6VvEcW7rEJrdemGrDofZKCSJ32DiNpUV9HlemKx4aBB2xPIprO6Gy5B0p1oQucwcVlZD/D7wSqzMw7lGskA+lsKthdoiMa/w/WtPzPkYRIl51S8a0Ti0AMphVoCev33f1P/KNxC2fVy1vJeJmhYgsVpuUEyS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946451; c=relaxed/simple;
	bh=abHBS2kT72fE0XOEMVhG4T7Bctp+ry+1c9hY10hg8Qo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+MWp7vbUZM10Uel1aCKgrsUVhVDc10AjM+Nfy7R44PL8HSlX+oDYaKt+7hCs67GHnrhEAYEBlpJijM21NaQ7e/PRkuhlmgAj0g4rcFdWX256jMiJBHjCUV3/C5+QrcY9xrCGDyhQnJ5TLca9C6OpHexsvWJ6awEa1wchXtb6GQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tu1bynPe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tu1bynPe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C69AC4CEE3;
	Tue, 29 Apr 2025 17:07:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946451;
	bh=abHBS2kT72fE0XOEMVhG4T7Bctp+ry+1c9hY10hg8Qo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tu1bynPe9DxrYdgGiHCt7PoJuumg7PLuPOyGwMcX20hRJgwdCnIFuq4YJTunlaLsS
	 4Arsbpp63bgJqXrWT7G/I5GU3cGS8k6pR/CRPJArVrvoxfZj7kdZ57MlqWaCQwJkmh
	 dQuXAVKI6rGvy9MVMP25KH0Cqrb0SH2Ym8mYzerk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Griffin <peter.griffin@linaro.org>,
	Bart Van Assche <bvanassche@acm.org>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 271/311] scsi: ufs: exynos: Enable PRDT pre-fetching with UFSHCD_CAP_CRYPTO
Date: Tue, 29 Apr 2025 18:41:48 +0200
Message-ID: <20250429161132.125237744@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161121.011111832@linuxfoundation.org>
References: <20250429161121.011111832@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Griffin <peter.griffin@linaro.org>

[ Upstream commit deac9ad496ec17e1ec06848964ecc635bdaca703 ]

PRDT_PREFETCH_ENABLE[31] bit should be set when desctype field of
fmpsecurity0 register is type2 (double file encryption) or type3
(support for file and disk encryption). Setting this bit enables PRDT
pre-fetching on both TXPRDT and RXPRDT.

Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
Link: https://lore.kernel.org/r/20250319-exynos-ufs-stability-fixes-v2-5-96722cc2ba1b@linaro.org
Reviewed-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ufs/host/ufs-exynos.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/drivers/ufs/host/ufs-exynos.c b/drivers/ufs/host/ufs-exynos.c
index e77b3c63e6981..ac71b878d872f 100644
--- a/drivers/ufs/host/ufs-exynos.c
+++ b/drivers/ufs/host/ufs-exynos.c
@@ -34,7 +34,7 @@
  * Exynos's Vendor specific registers for UFSHCI
  */
 #define HCI_TXPRDT_ENTRY_SIZE	0x00
-#define PRDT_PREFECT_EN		BIT(31)
+#define PRDT_PREFETCH_EN	BIT(31)
 #define HCI_RXPRDT_ENTRY_SIZE	0x04
 #define HCI_1US_TO_CNT_VAL	0x0C
 #define CNT_VAL_1US_MASK	0x3FF
@@ -1098,12 +1098,17 @@ static int exynos_ufs_post_link(struct ufs_hba *hba)
 	struct exynos_ufs *ufs = ufshcd_get_variant(hba);
 	struct phy *generic_phy = ufs->phy;
 	struct exynos_ufs_uic_attr *attr = ufs->drv_data->uic_attr;
+	u32 val = ilog2(DATA_UNIT_SIZE);
 
 	exynos_ufs_establish_connt(ufs);
 	exynos_ufs_fit_aggr_timeout(ufs);
 
 	hci_writel(ufs, 0xa, HCI_DATA_REORDER);
-	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_TXPRDT_ENTRY_SIZE);
+
+	if (hba->caps & UFSHCD_CAP_CRYPTO)
+		val |= PRDT_PREFETCH_EN;
+	hci_writel(ufs, val, HCI_TXPRDT_ENTRY_SIZE);
+
 	hci_writel(ufs, ilog2(DATA_UNIT_SIZE), HCI_RXPRDT_ENTRY_SIZE);
 	hci_writel(ufs, (1 << hba->nutrs) - 1, HCI_UTRL_NEXUS_TYPE);
 	hci_writel(ufs, (1 << hba->nutmrs) - 1, HCI_UTMRL_NEXUS_TYPE);
-- 
2.39.5



