Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3271D4EDCC0;
	Thu, 17 Sep 2026 17:56:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667779; cv=none; b=EQL39poWQnW9XNP3gijwXusF4rPQusyLsDFtfDojXMJNU/oxu3kD7HU3iOzd4PBxAHyfk9duAZZXCs6njKjXYNw7Mj7klpBRzdhzzlaTs+pQIZiw6UVyKTiNVd0QXg941oLiIKSzA9SmN35XyzSe09r1LhePdVBW7PPMrXfjnuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667779; c=relaxed/simple;
	bh=MzdkDEt8QlIxENo2neZntiOWd8iITMG+CFUGVZoRjhY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=roV7XhRiTEjrQTJ2VmsMfQcCly0tEyfVZndT1Ij/ZGuO/puSYF3On7yaOyVL4K+wQ8u2E92ZyStVl7g8Pvvj5NxOvcoyl9zoOUh597CjS7IsnExRbxrhIDVMfDqwkQEqhE4riJnBWKbKTHk3IuFAsmEzPYtkTacFVxiH/CMioXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=itxxgEf6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="itxxgEf6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87BC91F000FF;
	Thu, 17 Sep 2026 17:56:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667778;
	bh=DGp5TLhxmI7JYgGRKs85Wh8WeWpcabw1msRnSASUOj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=itxxgEf6o0k4akRjjJN7mynkTgdTDELnAl8fEqtAQ8OH+w1UrxlEsT6VRpHKT0F5d
	 nt8sHHyb096Digx4NMctzQzZ9SZ7eS+Ybwk95Ow6CHwfNGAYJATKKeyvNGo+z0sFoj
	 OdrndWkgGiJw2JSGlYXVY0heM53FFLppX4fhBeOI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Xue <xxm@rock-chips.com>,
	=?UTF-8?q?Sven=20P=C3=BCschel?= <s.pueschel@pengutronix.de>,
	Heiko Stuebner <heiko@sntech.de>,
	Joerg Roedel <joerg.roedel@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0205/1102] iommu/rockchip: disable fetch dte time limit
Date: Thu, 17 Sep 2026 16:02:28 +0100
Message-ID: <20260917151544.721717007@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Xue <xxm@rock-chips.com>

[ Upstream commit 8d4346ecd4950ae08cc76a6de327c264e846758c ]

Disable the Bit 31 of the AUTO_GATING iommu register, as it causes
hangups with the RGA3 (Raster Graphics Acceleration 3) peripheral.
The RGA3 register description of the TRM already states that the bit
must be set to 1. The vendor kernel sets the bit unconditionally to
1 to fix VOP (Video Output Processor) screen black issues. This patch
squashes the 2 vendor kernel commits with the following commit messages:

Master fetch data and cpu update page table may work in parallel, may
have the following procedure:

	master                  cpu
	fetch dte               update page tabl
	        |                       |
	(make dte invalid)  <-  zap iotlb entry
	        |                       |
	fetch dte again
	(make dte invalid)  <-  zap iotlb entry
	        |                       |
	fetch dte again
	(make dte invalid)  <-  zap iotlb entry
	        |                       |
	fetch dte again
	(make iommu block)  <-  zap iotlb entry

New iommu version has the above bug, if fetch dte consecutively four
times, then it will be blocked. Fortunately, we can set bit 31 of
register MMU_AUTO_GATING to 1 to make it work as old version which does
not have this issue.

This issue only appears on RV1126 so far, so make a workaround dedicated
to "rockchip,rv1126" machine type.

iommu/rockchip: fix vop blocked and screen black on RK356X and RK3588

RK3568 and RK3588 has the same issue as RV1126/RV1109 that caused by
dte fetch time limit, So we can set BIT(31) of register 0x24 default
to 1 as a workaround.

Signed-off-by: Simon Xue <xxm@rock-chips.com>
Signed-off-by: Sven Püschel <s.pueschel@pengutronix.de>
Acked-by: Heiko Stuebner <heiko@sntech.de>
Signed-off-by: Joerg Roedel <joerg.roedel@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iommu/rockchip-iommu.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/iommu/rockchip-iommu.c b/drivers/iommu/rockchip-iommu.c
index 4c7f470a4752f..7edc913b267c6 100644
--- a/drivers/iommu/rockchip-iommu.c
+++ b/drivers/iommu/rockchip-iommu.c
@@ -75,6 +75,8 @@
 #define SPAGE_ORDER 12
 #define SPAGE_SIZE (1 << SPAGE_ORDER)
 
+#define DISABLE_FETCH_DTE_TIME_LIMIT BIT(31)
+
  /*
   * Support mapping any size that fits in one page table:
   *   4 KiB to 4 MiB
@@ -928,6 +930,7 @@ static int rk_iommu_enable(struct rk_iommu *iommu)
 	struct iommu_domain *domain = iommu->domain;
 	struct rk_iommu_domain *rk_domain = to_rk_domain(domain);
 	int ret, i;
+	u32 auto_gate;
 
 	ret = clk_bulk_enable(iommu->num_clocks, iommu->clocks);
 	if (ret)
@@ -946,6 +949,11 @@ static int rk_iommu_enable(struct rk_iommu *iommu)
 			       rk_ops->mk_dtentries(rk_domain->dt_dma));
 		rk_iommu_base_command(iommu->bases[i], RK_MMU_CMD_ZAP_CACHE);
 		rk_iommu_write(iommu->bases[i], RK_MMU_INT_MASK, RK_MMU_IRQ_MASK);
+
+		/* Workaround for iommu blocked, BIT(31) default to 1 */
+		auto_gate = rk_iommu_read(iommu->bases[i], RK_MMU_AUTO_GATING);
+		auto_gate |= DISABLE_FETCH_DTE_TIME_LIMIT;
+		rk_iommu_write(iommu->bases[i], RK_MMU_AUTO_GATING, auto_gate);
 	}
 
 	ret = rk_iommu_enable_paging(iommu);
-- 
2.53.0



