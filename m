Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B31315B981;
	Mon, 29 Jan 2024 17:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548287; cv=none; b=qA5++qslm68GEJ12wdQpNfTAjckx9b/LhGDQFRvMqN6+JGsM+d8dcIvtHyDY0vSOm2Wb6fEbRXJbHMO3ZxjFMi4ItYFYqhbkAi2N4R8tcDaJjjiieNhN3nB6gPy8U0Q+K4EhzoNHyRdGyytadTvRbgs+UPy5btrTPwwckty25Og=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548287; c=relaxed/simple;
	bh=IFZlv9gnQFw/jgt4DRUtWT5RYnJa0/BZqszU4VlqGnk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hNzQfzgGx14PwJQAr8TmEWPXwXl/lr1RfGldB0tBq4wQPIvVX3I3bl6Rhuy0/aWyqBu/p8hibz9HDucKg3sMjD+9+fg5SkCrH931jeYZYiWW3IosSEwjANCxxNF2Zt7P74NXcVgArEJJ31D/znXwGqZwwq/IAv9gYai+ohSRd3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e7/1hjw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e7/1hjw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E37D2C433F1;
	Mon, 29 Jan 2024 17:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548287;
	bh=IFZlv9gnQFw/jgt4DRUtWT5RYnJa0/BZqszU4VlqGnk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e7/1hjw1kUksnfAjZtTpCJi4TNugezlO9Nsl+8eNixjsTAm8T4sC2v2LA2he8cQcX
	 QC72J/mD+JEmr/gcUCvsqEfl8D5PAWlxQDLy40I0118fqoKhwyzytndpa9aeBFRX4N
	 EmDpB4QszO4WSk/HLsTkyzqiiI509pUh8dYN/AAU=
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
Subject: [PATCH 6.7 285/346] media: v4l2-cci: Add support for little-endian encoded registers
Date: Mon, 29 Jan 2024 09:05:16 -0800
Message-ID: <20240129170024.767133893@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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



