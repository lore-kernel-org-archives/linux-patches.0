Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58EE734D38E;
	Tue, 11 Nov 2025 01:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762825412; cv=none; b=QUvJ7L5Yu3e0NzUJt3WKChAqO6DYkqGcjBGcWp2uJ1Fh59vM6olsWt+JwDhsPB/TP1eCqjlslfNXVRosGqq/clwyiW+mYRj0SwM5m+rS57YtYHQWFtCTzMpI4/l911y51CJ6CPbNdH7uPherXl0SPd0GfZJs3lJZLOIITI7lzhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762825412; c=relaxed/simple;
	bh=6UPWC9luoZCtA+sgGphMBNsllFkSajpTQGbSxJjM3bo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O1qriB0s6baYvB9YVu/D3H4eZS01KTl/7Ke36gJ/hQZAu8OFh0xBnRh0z458/vFczmQeGKPvZq9zc7HO7lyZBc7DTHul2TdaCQqgorXIgdLECZmIaG6rn1WuhiA1ko0+cTf0jpPwQbVahwCDjtSS0l3y81jCxX74yDlud6yr31U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iCnj8b1K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iCnj8b1K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E76E0C116B1;
	Tue, 11 Nov 2025 01:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762825412;
	bh=6UPWC9luoZCtA+sgGphMBNsllFkSajpTQGbSxJjM3bo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iCnj8b1KN3wnhqk3ob9SpbptR6EAQobfUiUJjiXw1TL1wdKUh21wO2+fs5uR43mt1
	 mNto46xyEOIUr/bQpY+QSMpu1CBUrZLZLZJ+BlBnYuAO25h+3G5crLzm4VKJh8zE3/
	 WMx6ID69tI85Xxga5Z81vRMblurM2ZSnoDJBeE/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Meghana Malladi <m-malladi@ti.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 790/849] net: ti: icssg-prueth: Fix fdb hash size configuration
Date: Tue, 11 Nov 2025 09:46:00 +0900
Message-ID: <20251111004555.532676580@linuxfoundation.org>
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

From: Meghana Malladi <m-malladi@ti.com>

[ Upstream commit ae4789affd1e181ae46e72e2b5fbe2d6d7b6616a ]

The ICSSG driver does the initial FDB configuration which
includes setting the control registers. Other run time
management like learning is managed by the PRU's. The default
FDB hash size used by the firmware is 512 slots, which is
currently missing in the current driver. Update the driver
FDB config to include FDB hash size as well.

Please refer trm [1] 6.4.14.12.17 section on how the FDB config
register gets configured. From the table 6-1404, there is a reset
field for FDB_HAS_SIZE which is 4, meaning 1024 slots. Currently
the driver is not updating this reset value from 4(1024 slots) to
3(512 slots). This patch fixes this by updating the reset value
to 512 slots.

[1]: https://www.ti.com/lit/pdf/spruim2
Fixes: abd5576b9c57f ("net: ti: icssg-prueth: Add support for ICSSG switch firmware")
Signed-off-by: Meghana Malladi <m-malladi@ti.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20251104104415.3110537-1-m-malladi@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_config.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_config.c b/drivers/net/ethernet/ti/icssg/icssg_config.c
index da53eb04b0a43..3f8237c17d099 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_config.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_config.c
@@ -66,6 +66,9 @@
 #define FDB_GEN_CFG1		0x60
 #define SMEM_VLAN_OFFSET	8
 #define SMEM_VLAN_OFFSET_MASK	GENMASK(25, 8)
+#define FDB_HASH_SIZE_MASK	GENMASK(6, 3)
+#define FDB_HASH_SIZE_SHIFT	3
+#define FDB_HASH_SIZE		3
 
 #define FDB_GEN_CFG2		0x64
 #define FDB_VLAN_EN		BIT(6)
@@ -463,6 +466,8 @@ void icssg_init_emac_mode(struct prueth *prueth)
 	/* Set VLAN TABLE address base */
 	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, SMEM_VLAN_OFFSET_MASK,
 			   addr <<  SMEM_VLAN_OFFSET);
+	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, FDB_HASH_SIZE_MASK,
+			   FDB_HASH_SIZE << FDB_HASH_SIZE_SHIFT);
 	/* Set enable VLAN aware mode, and FDBs for all PRUs */
 	regmap_write(prueth->miig_rt, FDB_GEN_CFG2, (FDB_PRU0_EN | FDB_PRU1_EN | FDB_HOST_EN));
 	prueth->vlan_tbl = (struct prueth_vlan_tbl __force *)(prueth->shram.va +
@@ -484,6 +489,8 @@ void icssg_init_fw_offload_mode(struct prueth *prueth)
 	/* Set VLAN TABLE address base */
 	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, SMEM_VLAN_OFFSET_MASK,
 			   addr <<  SMEM_VLAN_OFFSET);
+	regmap_update_bits(prueth->miig_rt, FDB_GEN_CFG1, FDB_HASH_SIZE_MASK,
+			   FDB_HASH_SIZE << FDB_HASH_SIZE_SHIFT);
 	/* Set enable VLAN aware mode, and FDBs for all PRUs */
 	regmap_write(prueth->miig_rt, FDB_GEN_CFG2, FDB_EN_ALL);
 	prueth->vlan_tbl = (struct prueth_vlan_tbl __force *)(prueth->shram.va +
-- 
2.51.0



