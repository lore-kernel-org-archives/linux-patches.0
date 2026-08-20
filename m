Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C979C47F2CE;
	Thu, 20 Aug 2026 16:50:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787244643; cv=none; b=TTrmt3y+s49/42p6v0GfHzp7C0FrYp2b9LEBtNh4D+xBGBwuXJejBUW0NG017ZS0Of/Gi3Thkjo/jA7ckw1JXXy+iTcjpckIUQkb1Tu0zF/e+zbeE6ajzqDoWQaO58CPupFvO0/OGhk06+YtAImk9UR/iWdTA5slbqEsopTZPrk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787244643; c=relaxed/simple;
	bh=HXbDF4MT/6FosGzZZ2w4eEAuMpzep0Ethp400hCI5TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GXWjbtbctJHeYos5IOVGr0FxXPrtRDfHC0QIN4rhGCb7g/ehM/5ZagbiJv29ToZ/LHeWV/hCVGvUamCIFt8gLTlrOJYLDIEO7HxVY1Bfdxac+wvsMTKiWHU8Lp0PjNou0mSgizEmpom+Qf+drE4CNDQU2DhKeaQThzCfiX4awjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PfDweCVz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PfDweCVz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C70B1F000E9;
	Thu, 20 Aug 2026 16:50:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787244642;
	bh=+1cL4WJNQireGl9BDK/utO2KoRWUnJfB/Ho/VqV3sU8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PfDweCVzwWTH19kL43+RUtq2XFYdju3rbJpsMlt5IUn6ffI5A381sJgG1jM8tYzvl
	 0y80Mh4+MkIS6R8EAPVIQji+M7HCA7Nm7/hQI2n4yNds9f0xzjNJl48r4X8lRnFYuL
	 mTZd6fm1szeF3IHkQQJoZYQ7cz36d0s3+FgZQLZ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Grygorii Strashko <grygorii.strashko@ti.com>,
	Jesse Brandeburg <jesse.brandeburg@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 226/235] net: ethernet: ti: am65-cpsw: move free desc queue mode selection in pdata
Date: Thu, 20 Aug 2026 16:57:42 +0200
Message-ID: <20260820145223.467055725@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145216.426568665@linuxfoundation.org>
References: <20260820145216.426568665@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Grygorii Strashko <grygorii.strashko@ti.com>

[ Upstream commit c6275c02a09730b365fffe3372fbe768cef8eb37 ]

In preparation of adding more multi-port K3 CPSW versions move free
descriptor queue mode selection in am65_cpsw_pdata, so it can be selected
basing on DT compatibility property.

Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
Reviewed-by: Jesse Brandeburg <jesse.brandeburg@intel.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 36a05d282007 ("net: ethernet: ti: am65-cpsw-nuss: Fix port_id extraction from SRC TAG")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 4 +++-
 drivers/net/ethernet/ti/am65-cpsw-nuss.h | 2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index d1bf457acba04..0b228205d08c6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -1578,7 +1578,6 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 		};
 		struct k3_ring_cfg fdqring_cfg = {
 			.elm_size = K3_RINGACC_RING_ELSIZE_8,
-			.mode = K3_RINGACC_RING_MODE_MESSAGE,
 			.flags = K3_RINGACC_RING_SHARED,
 		};
 		struct k3_udma_glue_rx_flow_cfg rx_flow_cfg = {
@@ -1592,6 +1591,7 @@ static int am65_cpsw_nuss_init_rx_chns(struct am65_cpsw_common *common)
 		rx_flow_cfg.ring_rxfdq0_id = fdqring_id;
 		rx_flow_cfg.rx_cfg.size = max_desc_num;
 		rx_flow_cfg.rxfdq_cfg.size = max_desc_num;
+		rx_flow_cfg.rxfdq_cfg.mode = common->pdata.fdqring_mode;
 
 		ret = k3_udma_glue_rx_flow_init(rx_chn->rx_chn,
 						i, &rx_flow_cfg);
@@ -1989,11 +1989,13 @@ static const struct soc_device_attribute am65_cpsw_socinfo[] = {
 static const struct am65_cpsw_pdata am65x_sr1_0 = {
 	.quirks = AM65_CPSW_QUIRK_I2027_NO_TX_CSUM,
 	.ale_dev_id = "am65x-cpsw2g",
+	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
 };
 
 static const struct am65_cpsw_pdata j721e_pdata = {
 	.quirks = 0,
 	.ale_dev_id = "am65x-cpsw2g",
+	.fdqring_mode = K3_RINGACC_RING_MODE_MESSAGE,
 };
 
 static const struct of_device_id am65_cpsw_nuss_of_mtable[] = {
diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.h b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
index 9c2186b8eae90..b6f228ddc3a09 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.h
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.h
@@ -11,6 +11,7 @@
 #include <linux/netdevice.h>
 #include <linux/phy.h>
 #include <linux/platform_device.h>
+#include <linux/soc/ti/k3-ringacc.h>
 #include "am65-cpsw-qos.h"
 
 struct am65_cpts;
@@ -77,6 +78,7 @@ struct am65_cpsw_rx_chn {
 
 struct am65_cpsw_pdata {
 	u32	quirks;
+	enum k3_ring_mode fdqring_mode;
 	const char	*ale_dev_id;
 };
 
-- 
2.53.0



