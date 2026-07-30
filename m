Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B03B40963F;
	Thu, 30 Jul 2026 14:34:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422079; cv=none; b=sjGhg5tul1zrr54M+bBIRQja+PoCJIOdqYaS1KpjOZTkvwWZnpNSJF7FI96dddJFKrY35cc3vYKMWkiqbPeuKzfHVFibG6BfUlIV4RCI8k6VR3vVWpUP/8OpHtnEmev/EWcroHr0t1LaWskfu30FFoPqmdA9J2guHbO7EGxoR28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422079; c=relaxed/simple;
	bh=5eUrrafFC3BD753qfM4cACJLv7vWam233ZaQRUrHLbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qzdiX+syG2Tlniu4+7dI9xUsoN79xa0J/bS7btYnTlzPgnvzxI+IdopW1/dPBgmA7TvaLdW1RzDMC7w6+Hh+nEhdSfRYKqOBN4+bfVt8+K20GFLjDNwpuYtP0VB17VtwWi+zjkzl4+ZSzjrGChzLgycacgsxkYLNGBYG6J+tHpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ul9WateV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ul9WateV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 599A01F00A3D;
	Thu, 30 Jul 2026 14:34:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422077;
	bh=P171CVuqUA+8lGZJdRN4lgEj1JeH8Ccq4MUrJlx8/vM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ul9WateVMOUdfrV3kv1u5wAc073u8oS7tuJjcOVfQLjJXMOs9IE0bw+XAeVQcxm5O
	 OQaKXoisn38iH67ETyiwhcSXOGupQs4qsn5SlKhYMjrJrBNJBcEEBaloU1rILsgbEN
	 cT74C+H+Unu1htEtzeY6waafSOvhqQPnJNc4185c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tomeu Vizoso <tomeu@tomeuvizoso.net>,
	"Rob Herring (Arm)" <robh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 273/744] accel: ethosu: Handle U85 internal chaining buffer
Date: Thu, 30 Jul 2026 16:09:06 +0200
Message-ID: <20260730141450.094432028@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rob Herring (Arm) <robh@kernel.org>

[ Upstream commit 6b7e0066294d23ad1fd37f4326c32e8090fb8b65 ]

The Ethos-U85 supports an internal chaining buffer as temporary storage
between some operations. When chaining is activated, the IFM/OFM region
setting selects a chaining buffer rather than a region, and the IFM/OFM
base addresses don't matter. In this case, the feature matrix size
calculations should be skipped. Otherwise, the command stream will be
intermittently rejected depending on prior feature matrix base
addresses.

Fixes: 5a5e9c0228e6 ("accel: Add Arm Ethos-U NPU driver")
Acked-by: Tomeu Vizoso <tomeu@tomeuvizoso.net>
Link: https://patch.msgid.link/20260720231450.485221-2-robh@kernel.org
Signed-off-by: Rob Herring (Arm) <robh@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/accel/ethosu/ethosu_gem.c | 35 +++++++++++++++++++++++--------
 1 file changed, 26 insertions(+), 9 deletions(-)

diff --git a/drivers/accel/ethosu/ethosu_gem.c b/drivers/accel/ethosu/ethosu_gem.c
index 1daff32610c71b..d50fed64d4d937 100644
--- a/drivers/accel/ethosu/ethosu_gem.c
+++ b/drivers/accel/ethosu/ethosu_gem.c
@@ -192,7 +192,15 @@ static u64 dma_length(struct ethosu_validated_cmdstream_info *info,
 	return len;
 }
 
-static u64 feat_matrix_length(struct ethosu_validated_cmdstream_info *info,
+static bool feat_matrix_chained(struct ethosu_device *edev, struct feat_matrix *fm)
+{
+	u32 storage = fm->precision >> 14;
+
+	return !ethosu_is_u65(edev) && storage == 2;
+}
+
+static u64 feat_matrix_length(struct ethosu_device *edev,
+			      struct ethosu_validated_cmdstream_info *info,
 			      struct feat_matrix *fm,
 			      u32 x, u32 y, u32 c, bool ofm)
 {
@@ -203,6 +211,9 @@ static u64 feat_matrix_length(struct ethosu_validated_cmdstream_info *info,
 	if (fm->region < 0)
 		return U64_MAX;
 
+	if (feat_matrix_chained(edev, fm))
+		return 0;
+
 	switch (storage) {
 	case 0:
 		if (x >= fm->width0 + 1) {
@@ -223,6 +234,8 @@ static u64 feat_matrix_length(struct ethosu_validated_cmdstream_info *info,
 			tile = 1;
 		}
 		break;
+	default:
+		return U64_MAX;
 	}
 	if (fm->base[tile] == U64_MAX)
 		return U64_MAX;
@@ -251,6 +264,7 @@ static int calc_sizes(struct drm_device *ddev,
 		      u16 op, struct cmd_state *st,
 		      bool ifm, bool ifm2, bool weight, bool scale)
 {
+	struct ethosu_device *edev = to_ethosu_device(ddev);
 	u64 len;
 
 	if (ifm) {
@@ -268,7 +282,7 @@ static int calc_sizes(struct drm_device *ddev,
 		if (ifm_height < 0 || ifm_width < 0)
 			return -EINVAL;
 
-		len = feat_matrix_length(info, &st->ifm, ifm_width,
+		len = feat_matrix_length(edev, info, &st->ifm, ifm_width,
 					 ifm_height, st->ifm.depth, false);
 		dev_dbg(ddev->dev, "op %d: IFM:%d:0x%llx-0x%llx\n",
 			op, st->ifm.region, st->ifm.base[0], len);
@@ -277,7 +291,7 @@ static int calc_sizes(struct drm_device *ddev,
 	}
 
 	if (ifm2) {
-		len = feat_matrix_length(info, &st->ifm2, st->ifm.depth,
+		len = feat_matrix_length(edev, info, &st->ifm2, st->ifm.depth,
 					 0, st->ofm.depth, false);
 		dev_dbg(ddev->dev, "op %d: IFM2:%d:0x%llx-0x%llx\n",
 			op, st->ifm2.region, st->ifm2.base[0], len);
@@ -309,13 +323,14 @@ static int calc_sizes(struct drm_device *ddev,
 			    st->scale[0].base + st->scale[0].length);
 	}
 
-	len = feat_matrix_length(info, &st->ofm, st->ofm.width,
+	len = feat_matrix_length(edev, info, &st->ofm, st->ofm.width,
 				 st->ofm.height[2], st->ofm.depth, true);
 	dev_dbg(ddev->dev, "op %d: OFM:%d:0x%llx-0x%llx\n",
 		op, st->ofm.region, st->ofm.base[0], len);
 	if (len == U64_MAX)
 		return -EINVAL;
-	info->output_region[st->ofm.region] = true;
+	if (!feat_matrix_chained(edev, &st->ofm))
+		info->output_region[st->ofm.region] = true;
 
 	return 0;
 }
@@ -325,6 +340,7 @@ static int calc_sizes_elemwise(struct drm_device *ddev,
 			       u16 op, struct cmd_state *st,
 			       bool ifm, bool ifm2)
 {
+	struct ethosu_device *edev = to_ethosu_device(ddev);
 	u32 height, width, depth;
 	u64 len;
 
@@ -333,7 +349,7 @@ static int calc_sizes_elemwise(struct drm_device *ddev,
 		width = st->ifm.broadcast & 0x2 ? 0 : st->ofm.width;
 		depth = st->ifm.broadcast & 0x4 ? 0 : st->ofm.depth;
 
-		len = feat_matrix_length(info, &st->ifm, width,
+		len = feat_matrix_length(edev, info, &st->ifm, width,
 					 height, depth, false);
 		dev_dbg(ddev->dev, "op %d: IFM:%d:0x%llx-0x%llx\n",
 			op, st->ifm.region, st->ifm.base[0], len);
@@ -346,7 +362,7 @@ static int calc_sizes_elemwise(struct drm_device *ddev,
 		width = st->ifm2.broadcast & 0x2 ? 0 : st->ofm.width;
 		depth = st->ifm2.broadcast & 0x4 ? 0 : st->ofm.depth;
 
-		len = feat_matrix_length(info, &st->ifm2, width,
+		len = feat_matrix_length(edev, info, &st->ifm2, width,
 					 height, depth, false);
 		dev_dbg(ddev->dev, "op %d: IFM2:%d:0x%llx-0x%llx\n",
 			op, st->ifm2.region, st->ifm2.base[0], len);
@@ -354,13 +370,14 @@ static int calc_sizes_elemwise(struct drm_device *ddev,
 			return -EINVAL;
 	}
 
-	len = feat_matrix_length(info, &st->ofm, st->ofm.width,
+	len = feat_matrix_length(edev, info, &st->ofm, st->ofm.width,
 				 st->ofm.height[2], st->ofm.depth, true);
 	dev_dbg(ddev->dev, "op %d: OFM:%d:0x%llx-0x%llx\n",
 		op, st->ofm.region, st->ofm.base[0], len);
 	if (len == U64_MAX)
 		return -EINVAL;
-	info->output_region[st->ofm.region] = true;
+	if (!feat_matrix_chained(edev, &st->ofm))
+		info->output_region[st->ofm.region] = true;
 
 	return 0;
 }
-- 
2.53.0



