Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 465B22DCC13;
	Thu, 25 Jun 2026 13:12:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782393141; cv=none; b=rYIJ55X6sY9aTl7wdrx6IrpUV/8HBD9rnKJQympRHgykoGUG21s8eQniK6P3y4SBBj3QNLVfrecy6k4saofYxG45BMH+eCoFOl/uyYePFf5wybQZcB/BZdm5Axkv47+uaQ7TuaJbreWSKgvZJWJv1mEH0OB2eP2pabx6YWaiOi8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782393141; c=relaxed/simple;
	bh=b++CI4q41pVMLiVrajZzwd18WUYuOI1dz3/9FNEGjeM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZnVmcCwrVF4vhwe9A5Pz1dioXBWMhU2N2bIoqbzMUBS0Ykb8h1lbMmr507UsanRsA9ILEC6A2tHm++kvQ8UIrxR/iXIc4dAg1n+1jcmZ5aF9nnqTaaM49sXSiRKNz4xajJU4Oqx3gdl2RN3a1c5ZXTpx6aRAAJB1Rii1WTF4Ww=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rBZoqxCz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rBZoqxCz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 887AF1F000E9;
	Thu, 25 Jun 2026 13:12:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1782393140;
	bh=RTSr4TX5friC0i00IRQBzpYjr0pgarrEYS+1KqbbNw4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rBZoqxCzLWvwj1c4ztnRgbcT70oNn7VqKUvKa9PMLHnJpz+gWiXouOKIYQNczbR+Q
	 xlvNzMzKjsaWUBJMLLgWWorkzByto0h0/0pePAAp/dp93Um3/2tEpXL9QdBVCWjzir
	 QFDU+Fn+bGXaybm/0nphwreGbegqq0PGsUlPNdxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>
Subject: [PATCH 7.1 08/21] Input: rmi4 - refactor register descriptor parsing
Date: Thu, 25 Jun 2026 14:04:00 +0100
Message-ID: <20260625125614.406492194@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260625125613.243729608@linuxfoundation.org>
References: <20260625125613.243729608@linuxfoundation.org>
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

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

commit 0adb483fbf2dc43c875cd7550a58b41e92efc52d upstream.

Factor out parsing a register descriptor item from
rmi_read_register_desc() and ensure there are no out-of-bounds accesses.

Use get_unaligned_le16() and get_unaligned_le32() for reading multi-byte
values.

Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Fixes: 2b6a321da9a2 ("Input: synaptics-rmi4 - add support for Synaptics RMI4 devices")
Cc: stable@vger.kernel.org
Assisted-by: Gemini:gemini-3.1-pro
Link: https://patch.msgid.link/20260505045952.1570713-2-dmitry.torokhov@gmail.com
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/input/rmi4/rmi_driver.c |  124 ++++++++++++++++++++++++----------------
 1 file changed, 76 insertions(+), 48 deletions(-)

--- a/drivers/input/rmi4/rmi_driver.c
+++ b/drivers/input/rmi4/rmi_driver.c
@@ -22,6 +22,7 @@
 #include <uapi/linux/input.h>
 #include <linux/rmi.h>
 #include <linux/export.h>
+#include <linux/unaligned.h>
 #include "rmi_bus.h"
 #include "rmi_driver.h"
 
@@ -558,30 +559,74 @@ int rmi_scan_pdt(struct rmi_device *rmi_
 	return retval < 0 ? retval : 0;
 }
 
+static int rmi_parse_register_desc_item(struct rmi_register_desc_item *item,
+					const u8 *buf, size_t size)
+{
+	unsigned int offset = 0;
+	unsigned int map_offset = 0;
+	int b;
+
+	if (offset >= size)
+		return -EIO;
+
+	item->reg_size = buf[offset++];
+	if (item->reg_size == 0) {
+		if (size - offset < 2)
+			return -EIO;
+		item->reg_size = get_unaligned_le16(&buf[offset]);
+		offset += 2;
+	}
+
+	if (item->reg_size == 0) {
+		if (size - offset < 4)
+			return -EIO;
+		item->reg_size = get_unaligned_le32(&buf[offset]);
+		offset += 4;
+	}
+
+	do {
+		if (offset >= size)
+			return -EIO;
+
+		for (b = 0; b < 7; b++) {
+			if (buf[offset] & BIT(b)) {
+				if (map_offset >= RMI_REG_DESC_SUBPACKET_BITS)
+					return -EIO;
+				__set_bit(map_offset, item->subpacket_map);
+			}
+			++map_offset;
+		}
+	} while (buf[offset++] & BIT(7));
+
+	item->num_subpackets = bitmap_weight(item->subpacket_map,
+					     RMI_REG_DESC_SUBPACKET_BITS);
+
+	return offset;
+}
+
 int rmi_read_register_desc(struct rmi_device *d, u16 addr,
-				struct rmi_register_descriptor *rdesc)
+			   struct rmi_register_descriptor *rdesc)
 {
 	int ret;
 	u8 size_presence_reg;
 	u8 buf[35];
-	int presense_offset = 1;
-	u8 *struct_buf;
-	int reg;
-	int offset = 0;
-	int map_offset = 0;
+	unsigned int presence_offset;
+	unsigned int map_offset;
+	unsigned int offset;
+	unsigned int reg;
 	int i;
 	int b;
 
 	/*
 	 * The first register of the register descriptor is the size of
-	 * the register descriptor's presense register.
+	 * the register descriptor's presence register.
 	 */
 	ret = rmi_read(d, addr, &size_presence_reg);
 	if (ret)
 		return ret;
 	++addr;
 
-	if (size_presence_reg < 0 || size_presence_reg > 35)
+	if (size_presence_reg < 1 || size_presence_reg > 35)
 		return -EIO;
 
 	memset(buf, 0, sizeof(buf));
@@ -597,16 +642,23 @@ int rmi_read_register_desc(struct rmi_de
 	addr += size_presence_reg;
 
 	if (buf[0] == 0) {
-		presense_offset = 3;
-		rdesc->struct_size = buf[1] | (buf[2] << 8);
+		if (size_presence_reg < 3)
+			return -EIO;
+		presence_offset = 3;
+		rdesc->struct_size = get_unaligned_le16(&buf[1]);
 	} else {
+		presence_offset = 1;
 		rdesc->struct_size = buf[0];
 	}
 
-	for (i = presense_offset; i < size_presence_reg; i++) {
+	map_offset = 0;
+	for (i = presence_offset; i < size_presence_reg; i++) {
 		for (b = 0; b < 8; b++) {
-			if (buf[i] & (0x1 << b))
+			if (buf[i] & BIT(b)) {
+				if (map_offset >= RMI_REG_DESC_PRESENSE_BITS)
+					return -EIO;
 				bitmap_set(rdesc->presense_map, map_offset, 1);
+			}
 			++map_offset;
 		}
 	}
@@ -626,7 +678,7 @@ int rmi_read_register_desc(struct rmi_de
 	 * I'm not using devm_kzalloc here since it will not be retained
 	 * after exiting this function
 	 */
-	struct_buf = kzalloc(rdesc->struct_size, GFP_KERNEL);
+	u8 *struct_buf __free(kfree) = kzalloc(rdesc->struct_size, GFP_KERNEL);
 	if (!struct_buf)
 		return -ENOMEM;
 
@@ -638,56 +690,32 @@ int rmi_read_register_desc(struct rmi_de
 	 */
 	ret = rmi_read_block(d, addr, struct_buf, rdesc->struct_size);
 	if (ret)
-		goto free_struct_buff;
+		return ret;
 
 	reg = find_first_bit(rdesc->presense_map, RMI_REG_DESC_PRESENSE_BITS);
+	offset = 0;
 	for (i = 0; i < rdesc->num_registers; i++) {
 		struct rmi_register_desc_item *item = &rdesc->registers[i];
-		int reg_size = struct_buf[offset];
+		int item_size;
 
-		++offset;
-		if (reg_size == 0) {
-			reg_size = struct_buf[offset] |
-					(struct_buf[offset + 1] << 8);
-			offset += 2;
-		}
-
-		if (reg_size == 0) {
-			reg_size = struct_buf[offset] |
-					(struct_buf[offset + 1] << 8) |
-					(struct_buf[offset + 2] << 16) |
-					(struct_buf[offset + 3] << 24);
-			offset += 4;
-		}
+		item_size = rmi_parse_register_desc_item(item,
+							 &struct_buf[offset],
+							 rdesc->struct_size - offset);
+		if (item_size < 0)
+			return item_size;
 
 		item->reg = reg;
-		item->reg_size = reg_size;
-
-		map_offset = 0;
-
-		do {
-			for (b = 0; b < 7; b++) {
-				if (struct_buf[offset] & (0x1 << b))
-					bitmap_set(item->subpacket_map,
-						map_offset, 1);
-				++map_offset;
-			}
-		} while (struct_buf[offset++] & 0x80);
-
-		item->num_subpackets = bitmap_weight(item->subpacket_map,
-						RMI_REG_DESC_SUBPACKET_BITS);
+		offset += item_size;
 
 		rmi_dbg(RMI_DEBUG_CORE, &d->dev,
 			"%s: reg: %d reg size: %ld subpackets: %d\n", __func__,
 			item->reg, item->reg_size, item->num_subpackets);
 
 		reg = find_next_bit(rdesc->presense_map,
-				RMI_REG_DESC_PRESENSE_BITS, reg + 1);
+				    RMI_REG_DESC_PRESENSE_BITS, reg + 1);
 	}
 
-free_struct_buff:
-	kfree(struct_buf);
-	return ret;
+	return 0;
 }
 
 const struct rmi_register_desc_item *rmi_get_register_desc_item(


