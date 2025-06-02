Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D6692253E9;
	Mon,  2 Jun 2025 14:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873655; cv=none; b=B33XF6y9S2r8i8lUsjnBJAhOGKLyhwlqq2s9o1oV66LV06O5Stq91/N4ndPemn14nVTMWP9ObGnrq3MvNbLmD+9MRD5bIoSPMIk4ysjbGjZBb1aVHd49rjK+aS565dhGWWIjpAAeQ95YZtCIHifJNGP44st8PFMpRIUSqybXHk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873655; c=relaxed/simple;
	bh=4RNgXCNqe7dn9Wk0SQSsD0nouD6uq61NmT2r3JExgj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TumF4uaM8vOCgTm7LrfKJJTystbsiQuSMhYspk1KafkCqfHLAJz1ULXHyK3ccf3b4nbXv8mioX4Kxshey48xcOmBiTQdWkj8qF8BDiqjAVgw5hg0KvVDTSymorceSnXBgssyEOdb+Sq3kArRKNrnV4YTj+2uNdPpHOaTEWoq0dM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=a1B2SLtM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="a1B2SLtM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B365EC4CEEB;
	Mon,  2 Jun 2025 14:14:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873655;
	bh=4RNgXCNqe7dn9Wk0SQSsD0nouD6uq61NmT2r3JExgj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=a1B2SLtMZoHY+YyBTuPffQtI13yBpvbcWoWBw3wD5KjvQvnAhEVox+YvZrMJI3+Dg
	 YWpSzOfdXlh9S56XqMocA+MB9ZSfrnDPe2k8ElkHb1/m3MBtLdnVKz+N8jSt6wwLuv
	 8PFMud74ZGywGtttMjToka/b0+7ng4/oYiiI1LAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Davis <afd@ti.com>,
	Nishanth Menon <nm@ti.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 180/444] soc: ti: k3-socinfo: Do not use syscon helper to build regmap
Date: Mon,  2 Jun 2025 15:44:04 +0200
Message-ID: <20250602134348.200062694@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Davis <afd@ti.com>

[ Upstream commit a5caf03188e44388e8c618dcbe5fffad1a249385 ]

The syscon helper device_node_to_regmap() is used to fetch a regmap
registered to a device node. It also currently creates this regmap
if the node did not already have a regmap associated with it. This
should only be used on "syscon" nodes. This driver is not such a
device and instead uses device_node_to_regmap() on its own node as
a hacky way to create a regmap for itself.

This will not work going forward and so we should create our regmap
the normal way by defining our regmap_config, fetching our memory
resource, then using the normal regmap_init_mmio() function.

Signed-off-by: Andrew Davis <afd@ti.com>
Link: https://lore.kernel.org/r/20250123181726.597144-1-afd@ti.com
Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/ti/k3-socinfo.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/soc/ti/k3-socinfo.c b/drivers/soc/ti/k3-socinfo.c
index 6ea9b8c7d335c..7a3bdef5a7c0d 100644
--- a/drivers/soc/ti/k3-socinfo.c
+++ b/drivers/soc/ti/k3-socinfo.c
@@ -63,6 +63,12 @@ k3_chipinfo_partno_to_names(unsigned int partno,
 	return -EINVAL;
 }
 
+static const struct regmap_config k3_chipinfo_regmap_cfg = {
+	.reg_bits = 32,
+	.val_bits = 32,
+	.reg_stride = 4,
+};
+
 static int k3_chipinfo_probe(struct platform_device *pdev)
 {
 	struct device_node *node = pdev->dev.of_node;
@@ -70,13 +76,18 @@ static int k3_chipinfo_probe(struct platform_device *pdev)
 	struct device *dev = &pdev->dev;
 	struct soc_device *soc_dev;
 	struct regmap *regmap;
+	void __iomem *base;
 	u32 partno_id;
 	u32 variant;
 	u32 jtag_id;
 	u32 mfg;
 	int ret;
 
-	regmap = device_node_to_regmap(node);
+	base = devm_platform_ioremap_resource(pdev, 0);
+	if (IS_ERR(base))
+		return PTR_ERR(base);
+
+	regmap = regmap_init_mmio(dev, base, &k3_chipinfo_regmap_cfg);
 	if (IS_ERR(regmap))
 		return PTR_ERR(regmap);
 
-- 
2.39.5



