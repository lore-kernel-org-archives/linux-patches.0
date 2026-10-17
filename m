Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C233B3C81BE;
	Sat, 17 Oct 2026 18:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260482; cv=none; b=W0w7jx2lgng5N+Xe7TJC0H5ATT0aMVH+k4tDVFXfB6T8WtDiAFaAcqvECL2xgy+Ln3bFobbJW6W3NXRgVJJd6Miselt+dqcKc/nj0aF7BMzpsASosrRB4u8xaN14EjkExtkSez8kyxRetc4R4ejzuDsnji7OAcbSvo7mVKqh/j0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260482; c=relaxed/simple;
	bh=OMrhXNyRFHcTfL41ygP9Oa/ZZczg2oMQx40TFz2LZ9M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gALK35MPTs94dj1zSWyqSKe2DlJax76ZEzWelP5rNtlvrxy2hcUqNFvMKFYx+2l5cw6LMPIA+i97iks5dadPiZ+OufCU82/uM5h5KTfgP7nui9NkF6fsctZ9xxQJjid9OfSffNcwa+FluP7Drld+FkmL6wCJBxHK8wP+DmWbW2M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZzGOUxzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZzGOUxzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 253911F000C5;
	Sat, 17 Oct 2026 18:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260481;
	bh=Qd4IJ0Th2vKfS+pxH+onHaD30+49tmSBaFk6FL7MU2U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ZzGOUxzz3TviD+3TyH8nYikVIgGYzYmWKx0SjublAnnSu3kZAqomf3b4/VSucqYsu
	 A5MTDbdQqxEnYXGWfX5Xsm63dU5nG3GfVfpLFkYNVHhR+xwCF4Cfv8ny2f0TaL1Vk2
	 Uw+U6MS8C6sfSomoXdCepFs+ONZRnJJZeLEUlZYY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sebastian Fricke <sebastian.fricke@collabora.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1559/1674] media: hantro: Disable multicore support
Date: Sat, 17 Oct 2026 18:03:51 +0200
Message-ID: <20261017160511.118728295@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

[ Upstream commit ccdeb8d57f7fb3e5c05d72cb7dfb9bc78f09f542 ]

Avoid exposing equal Hantro video codecs to userspace. Equal video
codecs allow scheduling work between the cores. For that kernel support
is required, which does not yet exist. Until that is implemented avoid
exposing each core separately to userspace so that multicore can be
added in the future without breaking userspace ABI.

This was written with Rockchip RK3588 in mind (which has 4 Hantro H1
cores), but applies to all SoCs.

Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sebastian Fricke <sebastian.fricke@collabora.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Stable-dep-of: e0203ddf9af7 ("media: verisilicon: Avoid G2 bus error while decoding H.264 and HEVC")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../media/platform/verisilicon/hantro_drv.c   | 47 +++++++++++++++++++
 1 file changed, 47 insertions(+)

diff --git a/drivers/media/platform/verisilicon/hantro_drv.c b/drivers/media/platform/verisilicon/hantro_drv.c
index 35833ee8beb51..7892b9f34599a 100644
--- a/drivers/media/platform/verisilicon/hantro_drv.c
+++ b/drivers/media/platform/verisilicon/hantro_drv.c
@@ -987,6 +987,49 @@ static const struct media_device_ops hantro_m2m_media_ops = {
 	.req_queue = v4l2_m2m_request_queue,
 };
 
+/*
+ * Some SoCs, like RK3588 have multiple identical Hantro cores, but the
+ * kernel is currently missing support for multi-core handling. Exposing
+ * separate devices for each core to userspace is bad, since that does
+ * not allow scheduling tasks properly (and creates ABI). With this workaround
+ * the driver will only probe for the first core and early exit for the other
+ * cores. Once the driver gains multi-core support, the same technique
+ * for detecting the main core can be used to cluster all cores together.
+ */
+static int hantro_disable_multicore(struct hantro_dev *vpu)
+{
+	struct device_node *node = NULL;
+	const char *compatible;
+	bool is_main_core;
+	int ret;
+
+	/* Intentionally ignores the fallback strings */
+	ret = of_property_read_string(vpu->dev->of_node, "compatible", &compatible);
+	if (ret)
+		return ret;
+
+	/* The first compatible and available node found is considered the main core */
+	do {
+		node = of_find_compatible_node(node, NULL, compatible);
+		if (of_device_is_available(node))
+			break;
+	} while (node);
+
+	if (!node)
+		return -EINVAL;
+
+	is_main_core = (vpu->dev->of_node == node);
+
+	of_node_put(node);
+
+	if (!is_main_core) {
+		dev_info(vpu->dev, "missing multi-core support, ignoring this instance\n");
+		return -ENODEV;
+	}
+
+	return 0;
+}
+
 static int hantro_probe(struct platform_device *pdev)
 {
 	const struct of_device_id *match;
@@ -1006,6 +1049,10 @@ static int hantro_probe(struct platform_device *pdev)
 	match = of_match_node(of_hantro_match, pdev->dev.of_node);
 	vpu->variant = match->data;
 
+	ret = hantro_disable_multicore(vpu);
+	if (ret)
+		return ret;
+
 	/*
 	 * Support for nxp,imx8mq-vpu is kept for backwards compatibility
 	 * but it's deprecated. Please update your DTS file to use
-- 
2.53.0



