Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061289;
	b=aWUHP2PEXfClXpwJh++eh/ZYwrGEfFp3Q+q9/o6fMpmJjNxszm6SFkyoSHlMHJnVxz2W
	 WwgDJICR2fFhyJ/1vICTPkRVqATdKnHuTH6GouoX8rnW/idwaSYEqnFJReVM35cWvPtGj
	 vK7FjQHJ8gbJhwLeyX4CZ34e102yBS2+ToWZvsgGreKebWSO4yeE7IjdhAw7wkkirz3ng
	 X4OWN76WvAWT+K/DwKQA+gZKAPnAOHsozIaSViW4/c6/cnSuwyAsSLi2bStVXXR0sXPKD
	 XPgpyM7hn4SBgoKE6P1YigE0UPNBxQzCAq7nP0IfjegYZYeRKf3pYVBH+yHESS4eWyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061289;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=L0ICxj9JiPDa//Z3bkG/z+EtqBOY/Z9JKYfNLVIhoaw=;
	b=XfgD80OPdSdTrPmEkCzdv7gO3KRg6s8bzLDyBiZee5N9UqZk94C91agboFsSSBunhrn3
	 qb+p9fhJbpiHBwUIvLOglQ9G5/7vqUJ0zPwU5TXBtxdS6/aqqu6wxO0lsBp/0e8Wq4R7M
	 Z8A0dbTa7yuDirLkMz5oskxfRveYve+9HzxzJzfeUgjKiyGi7x9Mzf6fI2cTbIm7brhGO
	 soNPsVV5LGDyYZC7+OsJmL4oIhVUnA3MgPH/AY7RYZLV7MPMxapMMoh9Js6TG8z4zIy9K
	 yNdQeWKe8HU8+6whhAEQvliJ/oqTiM5Iq4liubG/7DHUfPP8LaTDWUzs35QbTn1Knww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbbSdupo;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B7D4606A320;
	Thu, 19 Nov 2026 04:08:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=lbbSdupo
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 702761F000C4;
	Thu, 19 Nov 2026 04:08:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061289;
	bh=L0ICxj9JiPDa//Z3bkG/z+EtqBOY/Z9JKYfNLVIhoaw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lbbSdupoF9a6e+nLhjckZKPDXkY3G68UEEwSqGLLRyBMzrT40jeVX7noJX927WoAP
	 y/0KB62OmmxZScDU6mPzEQOApWthW1y9QB3aVP/HH5Dmb/8ARmyA/GoVBJ6XgD8kbv
	 mCD/Fe3IN5MDbrydX3dt1sOkhuPj19yd0urDiHC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Frank Li <Frank.Li@nxp.com>,
	Linus Walleij <linusw@kernel.org>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1498/1848] dmaengine: ste_dma40: Fix memcpy channel parsing
Date: Wed, 18 Nov 2026 15:58:56 +0100
Message-ID: <20261118150022.061774489@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit f2baf04a695de4f952513cb00ccf0338c6db2e00 ]

d40_of_probe() validates the memcpy-channels property against
D40_MEMCPY_MAX_CHANS, but reads the property directly into a smaller global
array. A long property can therefore overwrite adjacent data. The mutable
global also lets a later DMA40 instance replace the memcpy channel mapping
used for future allocations on an earlier instance.

Store the mapping in the per-device platform data, validate the property
against that storage, and check the property read result. The property is
required and d40_probe() always populates the platform data, so remove the
obsolete global mapping and fallback.

Fixes: a7dacb68b35a ("dmaengine: ste_dma40: Allow memcpy channels to be configured from DT")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/dmaengine/20260819225215.5EA2F1F000E9@smtp.kernel.org/
Assisted-by: LLM
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260927-dma40-fixes-v7-15-89f595e8851d@kernel.org
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/dma/ste_dma40.c | 45 +++++++++++++----------------------------
 1 file changed, 14 insertions(+), 31 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 020804cc03c11..aa268ecb53582 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -28,6 +28,8 @@
 #include "ste_dma40.h"
 #include "ste_dma40_ll.h"
 
+#define D40_MEMCPY_MAX_CHANS	8
+
 /**
  * struct stedma40_platform_data - Configuration struct for the dma device.
  *
@@ -43,6 +45,7 @@
  * to use SoftLLI.
  * @use_esram_lcla: flag for mapping the lcla into esram region
  * @num_of_memcpy_chans: The number of channels reserved for memcpy.
+ * @memcpy_channels: The event lines used for memcpy.
  * @num_of_phy_chans: The number of physical channels implemented in HW.
  * 0 means reading the number of channels from DMA HW but this is only valid
  * for 'multiple of 4' channels, like 8.
@@ -53,6 +56,7 @@ struct stedma40_platform_data {
 	int				 num_of_soft_lli_chans;
 	bool				 use_esram_lcla;
 	int				 num_of_memcpy_chans;
+	u32				 memcpy_channels[D40_MEMCPY_MAX_CHANS];
 	int				 num_of_phy_chans;
 };
 
@@ -88,25 +92,6 @@ struct stedma40_platform_data {
 #define D40_ALLOC_PHY		BIT(30)
 #define D40_ALLOC_LOG_FREE	0
 
-#define D40_MEMCPY_MAX_CHANS	8
-
-/* Reserved event lines for memcpy only. */
-#define DB8500_DMA_MEMCPY_EV_0	51
-#define DB8500_DMA_MEMCPY_EV_1	56
-#define DB8500_DMA_MEMCPY_EV_2	57
-#define DB8500_DMA_MEMCPY_EV_3	58
-#define DB8500_DMA_MEMCPY_EV_4	59
-#define DB8500_DMA_MEMCPY_EV_5	60
-
-static int dma40_memcpy_channels[] = {
-	DB8500_DMA_MEMCPY_EV_0,
-	DB8500_DMA_MEMCPY_EV_1,
-	DB8500_DMA_MEMCPY_EV_2,
-	DB8500_DMA_MEMCPY_EV_3,
-	DB8500_DMA_MEMCPY_EV_4,
-	DB8500_DMA_MEMCPY_EV_5,
-};
-
 /* Default configuration for physical memcpy */
 static const struct stedma40_chan_cfg dma40_memcpy_conf_phy = {
 	.mode = STEDMA40_MODE_PHYSICAL,
@@ -2026,7 +2011,8 @@ static int d40_config_memcpy(struct d40_chan *d40c)
 
 	if (dma_has_cap(DMA_MEMCPY, cap) && !dma_has_cap(DMA_SLAVE, cap)) {
 		d40c->dma_cfg = dma40_memcpy_conf_log;
-		d40c->dma_cfg.dev_type = dma40_memcpy_channels[d40c->chan.chan_id];
+		d40c->dma_cfg.dev_type =
+			d40c->base->plat_data->memcpy_channels[d40c->chan.chan_id];
 
 		d40_log_cfg(&d40c->dma_cfg,
 			    &d40c->log_def.lcsp1, &d40c->log_def.lcsp3);
@@ -3247,12 +3233,7 @@ static struct d40_base * __init d40_hw_detect_init(struct platform_device *pdev)
 	num_phy_chans = min(num_phy_chans, STEDMA40_MAX_PHYS);
 
 	/* The number of channels used for memcpy */
-	if (plat_data->num_of_memcpy_chans)
-		num_memcpy_chans = plat_data->num_of_memcpy_chans;
-	else
-		num_memcpy_chans = ARRAY_SIZE(dma40_memcpy_channels);
-
-	num_memcpy_chans = min(num_memcpy_chans, D40_MEMCPY_MAX_CHANS);
+	num_memcpy_chans = plat_data->num_of_memcpy_chans;
 	num_log_chans = num_phy_chans * D40_MAX_LOG_CHAN_PER_PHY;
 
 	dev_info(dev,
@@ -3499,6 +3480,7 @@ static int __init d40_of_probe(struct device *dev,
 	struct stedma40_platform_data *pdata;
 	int num_phy = 0, num_memcpy = 0, num_disabled = 0;
 	const __be32 *list;
+	int ret;
 
 	pdata = devm_kzalloc(dev, sizeof(*pdata), GFP_KERNEL);
 	if (!pdata)
@@ -3512,18 +3494,19 @@ static int __init d40_of_probe(struct device *dev,
 	list = of_get_property(np, "memcpy-channels", &num_memcpy);
 	num_memcpy /= sizeof(*list);
 
-	if (num_memcpy > D40_MEMCPY_MAX_CHANS || num_memcpy <= 0) {
+	if (num_memcpy > ARRAY_SIZE(pdata->memcpy_channels) ||
+	    num_memcpy <= 0) {
 		d40_err(dev,
 			"Invalid number of memcpy channels specified (%d)\n",
 			num_memcpy);
 		return -EINVAL;
 	}
+	ret = of_property_read_u32_array(np, "memcpy-channels",
+					 pdata->memcpy_channels, num_memcpy);
+	if (ret)
+		return ret;
 	pdata->num_of_memcpy_chans = num_memcpy;
 
-	of_property_read_u32_array(np, "memcpy-channels",
-				   dma40_memcpy_channels,
-				   num_memcpy);
-
 	list = of_get_property(np, "disabled-channels", &num_disabled);
 	num_disabled /= sizeof(*list);
 
-- 
2.53.0



