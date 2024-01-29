Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABE2A76051;
	Mon, 29 Jan 2024 17:17:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548631; cv=none; b=r/ddzw5mMBVPgkwbnmbhrM3IdW9KDlXMpLSsM5bgUutcKmVyoKlqhDWRDRy293GZbVRxp8HG9dXF108TMs2DGRVvJuSe1bogq/SfJgZuX+O275qkTqevJQN5nDOgktErwi5VYXLinP8tLF5lIWUdjpO+yWXB3fGmsgKm/jd83ag=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548631; c=relaxed/simple;
	bh=kxVlRXH695/kWNjoA6YV4SmZLVpC6IELHiVp8GF2WMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fC40j/5frPbPfhzgKHAEZVSwukroANdbYzcOzWcRLyrSRmmna7k7Qjyvxw1cZO+LX6FfFxU/j1H4GpqzVMTy69P/Xb4S8NL2bljPWLXSPB70JmSxRtt05GSpmkN1JItLFQQ4yu9NSQYm74+xm6OUUppAx1cKR5cstRNtF3yOAa8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CXCTYOXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CXCTYOXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FE89C43390;
	Mon, 29 Jan 2024 17:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548631;
	bh=kxVlRXH695/kWNjoA6YV4SmZLVpC6IELHiVp8GF2WMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CXCTYOXhbBt0qjf0249YX+jU6KT17E+MnpJiNbJurC5jG8kCjg443J+73k+hiD2eH
	 EC1JoPAIfs0sXwHrSWe2OoC965mm4PQEGS/815yYOvPi5sN4U5F/SDYkM8TygTHRSL
	 MgZtw6HofkCnMeA8H/mqrPFaQkGLBD8MNZpH/wds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Hans de Goede <hdegoede@redhat.com>,
	Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 281/331] media: v4l2-cci: Add support for little-endian encoded registers
Date: Mon, 29 Jan 2024 09:05:45 -0800
Message-ID: <20240129170023.084693224@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit d92e7a013ff33f4e0b31bbf768d0c85a8acefebf ]

Some sensors, e.g. Sony IMX290, are using little-endian registers. Add
support for those by encoding the endianness into Bit 20 of the register
address.

Fixes: af73323b9770 ("media: imx290: Convert to new CCI register access helpers")
Cc: stable@vger.kernel.org
Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
[Sakari Ailus: Fixed commit message.]
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/v4l2-core/v4l2-cci.c | 44 ++++++++++++++++++++++++------
 include/media/v4l2-cci.h           |  5 ++++
 2 files changed, 41 insertions(+), 8 deletions(-)

diff --git a/drivers/media/v4l2-core/v4l2-cci.c b/drivers/media/v4l2-core/v4l2-cci.c
index 3179160abde3..10005c80f43b 100644
--- a/drivers/media/v4l2-core/v4l2-cci.c
+++ b/drivers/media/v4l2-core/v4l2-cci.c
@@ -18,6 +18,7 @@
 
 int cci_read(struct regmap *map, u32 reg, u64 *val, int *err)
 {
+	bool little_endian;
 	unsigned int len;
 	u8 buf[8];
 	int ret;
@@ -25,6 +26,7 @@ int cci_read(struct regmap *map, u32 reg, u64 *val, int *err)
 	if (err && *err)
 		return *err;
 
+	little_endian = reg & CCI_REG_LE;
 	len = CCI_REG_WIDTH_BYTES(reg);
 	reg = CCI_REG_ADDR(reg);
 
@@ -40,16 +42,28 @@ int cci_read(struct regmap *map, u32 reg, u64 *val, int *err)
 		*val = buf[0];
 		break;
 	case 2:
-		*val = get_unaligned_be16(buf);
+		if (little_endian)
+			*val = get_unaligned_le16(buf);
+		else
+			*val = get_unaligned_be16(buf);
 		break;
 	case 3:
-		*val = get_unaligned_be24(buf);
+		if (little_endian)
+			*val = get_unaligned_le24(buf);
+		else
+			*val = get_unaligned_be24(buf);
 		break;
 	case 4:
-		*val = get_unaligned_be32(buf);
+		if (little_endian)
+			*val = get_unaligned_le32(buf);
+		else
+			*val = get_unaligned_be32(buf);
 		break;
 	case 8:
-		*val = get_unaligned_be64(buf);
+		if (little_endian)
+			*val = get_unaligned_le64(buf);
+		else
+			*val = get_unaligned_be64(buf);
 		break;
 	default:
 		dev_err(regmap_get_device(map), "Error invalid reg-width %u for reg 0x%04x\n",
@@ -68,6 +82,7 @@ EXPORT_SYMBOL_GPL(cci_read);
 
 int cci_write(struct regmap *map, u32 reg, u64 val, int *err)
 {
+	bool little_endian;
 	unsigned int len;
 	u8 buf[8];
 	int ret;
@@ -75,6 +90,7 @@ int cci_write(struct regmap *map, u32 reg, u64 val, int *err)
 	if (err && *err)
 		return *err;
 
+	little_endian = reg & CCI_REG_LE;
 	len = CCI_REG_WIDTH_BYTES(reg);
 	reg = CCI_REG_ADDR(reg);
 
@@ -83,16 +99,28 @@ int cci_write(struct regmap *map, u32 reg, u64 val, int *err)
 		buf[0] = val;
 		break;
 	case 2:
-		put_unaligned_be16(val, buf);
+		if (little_endian)
+			put_unaligned_le16(val, buf);
+		else
+			put_unaligned_be16(val, buf);
 		break;
 	case 3:
-		put_unaligned_be24(val, buf);
+		if (little_endian)
+			put_unaligned_le24(val, buf);
+		else
+			put_unaligned_be24(val, buf);
 		break;
 	case 4:
-		put_unaligned_be32(val, buf);
+		if (little_endian)
+			put_unaligned_le32(val, buf);
+		else
+			put_unaligned_be32(val, buf);
 		break;
 	case 8:
-		put_unaligned_be64(val, buf);
+		if (little_endian)
+			put_unaligned_le64(val, buf);
+		else
+			put_unaligned_be64(val, buf);
 		break;
 	default:
 		dev_err(regmap_get_device(map), "Error invalid reg-width %u for reg 0x%04x\n",
diff --git a/include/media/v4l2-cci.h b/include/media/v4l2-cci.h
index a2835a663df5..8b0b361b464c 100644
--- a/include/media/v4l2-cci.h
+++ b/include/media/v4l2-cci.h
@@ -38,12 +38,17 @@ struct cci_reg_sequence {
 #define CCI_REG_WIDTH_BYTES(x)		FIELD_GET(CCI_REG_WIDTH_MASK, x)
 #define CCI_REG_WIDTH(x)		(CCI_REG_WIDTH_BYTES(x) << 3)
 #define CCI_REG_ADDR(x)			FIELD_GET(CCI_REG_ADDR_MASK, x)
+#define CCI_REG_LE			BIT(20)
 
 #define CCI_REG8(x)			((1 << CCI_REG_WIDTH_SHIFT) | (x))
 #define CCI_REG16(x)			((2 << CCI_REG_WIDTH_SHIFT) | (x))
 #define CCI_REG24(x)			((3 << CCI_REG_WIDTH_SHIFT) | (x))
 #define CCI_REG32(x)			((4 << CCI_REG_WIDTH_SHIFT) | (x))
 #define CCI_REG64(x)			((8 << CCI_REG_WIDTH_SHIFT) | (x))
+#define CCI_REG16_LE(x)			(CCI_REG_LE | (2U << CCI_REG_WIDTH_SHIFT) | (x))
+#define CCI_REG24_LE(x)			(CCI_REG_LE | (3U << CCI_REG_WIDTH_SHIFT) | (x))
+#define CCI_REG32_LE(x)			(CCI_REG_LE | (4U << CCI_REG_WIDTH_SHIFT) | (x))
+#define CCI_REG64_LE(x)			(CCI_REG_LE | (8U << CCI_REG_WIDTH_SHIFT) | (x))
 
 /**
  * cci_read() - Read a value from a single CCI register
-- 
2.43.0



