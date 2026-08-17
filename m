Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E0064B04A7;
	Mon, 17 Aug 2026 14:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976205; cv=none; b=YL6gVpqjqfZGfA/mzYMKfDasTo8j9PfkhwlYXIB3Uajk8I9U77X3/N18Tri0m/zwZaXv2Ys+PZ1nZO7p8UaSPylwWC2Rv11p2kWjH3ut46mK9wxM9vo5OV/fBgkOSNJNgaYMrN0JZxvesyAZp0EM8+q8AN7Gsy2LCOoUgdtlYao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976205; c=relaxed/simple;
	bh=MxYdijT2jbV82x0gQBAZhaE/yhoqcbuw/C+BsHpPleo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S7TbiuoCHVvdU9AJ8A7UbgYvD1PXXkA7arcu27uqBSYWK3M3zv1Inav4AQuLp3i9q6dErD1C+VGqJsEyEX5yDAvU8vevztBgxaiDdkhK3Xm6u/ECRJxmZ6bokf+5uLhD482T0maNa1Szr8zx8S56MJX80AXiifkmyIFyo533V6w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bm9rixOF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bm9rixOF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3AFC1F000E9;
	Mon, 17 Aug 2026 14:16:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976204;
	bh=OKgo1nL608iZekbT0FWF5na9pVJ5PAVJHbHQA+XmQF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bm9rixOFr8IjM1TpDaXl7YvAyMv8iD8uJc80miXcnOp/Npc1U1TAO2yB1FSiou9HB
	 05+jDtc6gkoO6pF7nf6Gant9EromJ4Xzo00pcJIPNvtstm7EbhaZ46IMSESPpYUF7o
	 hJ9Zt95EJ0PGP0HDOSs5DPiK138jF58maKIP0o4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengpeng Hou <pengpeng@iscas.ac.cn>,
	stable@kernel.org,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 5.10 294/389] can: softing: fw_parse(): validate firmware record spans
Date: Mon, 17 Aug 2026 15:32:13 +0200
Message-ID: <20260817132550.540473770@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

From: Pengpeng Hou <pengpeng@iscas.ac.cn>

commit 856d6cb04e5407523566b075841dcd6423757d1c upstream.

fw_parse() reads a fixed record header, a firmware-provided payload,
and a trailing checksum without knowing the end of the firmware blob. A
truncated record can therefore make those reads exceed the blob.

The same record also supplies addresses and lengths for writes into
DPRAM. The generic loader uses wrap-prone mixed signed arithmetic for its
bounds check, while the application loader does not bound the staging
copy at all.

Pass the firmware end to the parser and validate the full source record.
Use a signed wide offset for generic DPRAM records and validate the
application staging span against the mapped DPRAM before copying.

Fixes: 03fd3cf5a179 ("can: add driver for Softing card")
Signed-off-by: Pengpeng Hou <pengpeng@iscas.ac.cn>
Link: https://patch.msgid.link/20260722044347.2708-1-pengpeng@iscas.ac.cn
Cc: stable@kernel.org
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/softing/softing_fw.c |   46 ++++++++++++++++++++++++-----------
 1 file changed, 32 insertions(+), 14 deletions(-)

--- a/drivers/net/can/softing/softing_fw.c
+++ b/drivers/net/can/softing/softing_fw.c
@@ -91,12 +91,12 @@ int softing_bootloader_command(struct so
 	return ret;
 }
 
-static int fw_parse(const uint8_t **pmem, uint16_t *ptype, uint32_t *paddr,
-		uint16_t *plen, const uint8_t **pdat)
+static int fw_parse(const u8 **pmem, const u8 *limit, u16 *ptype,
+		    u32 *paddr, u16 *plen, const u8 **pdat)
 {
 	uint16_t checksum[2];
-	const uint8_t *mem;
-	const uint8_t *end;
+	const u8 *mem;
+	const u8 *record_end;
 
 	/*
 	 * firmware records are a binary, unaligned stream composed of:
@@ -114,14 +114,21 @@ static int fw_parse(const uint8_t **pmem
 	 * endianness & alignment.
 	 */
 	mem = *pmem;
+	/* A record needs an 8-byte prefix and a 2-byte checksum. */
+	if (mem > limit || limit - mem < 10)
+		return -EINVAL;
+
 	*ptype = le16_to_cpup((void *)&mem[0]);
 	*paddr = le32_to_cpup((void *)&mem[2]);
 	*plen = le16_to_cpup((void *)&mem[6]);
+	if (*plen > limit - mem - 10)
+		return -EINVAL;
+
 	*pdat = &mem[8];
 	/* verify checksum */
-	end = &mem[8 + *plen];
-	checksum[0] = le16_to_cpup((void *)end);
-	for (checksum[1] = 0; mem < end; ++mem)
+	record_end = &mem[8 + *plen];
+	checksum[0] = le16_to_cpup((void *)record_end);
+	for (checksum[1] = 0; mem < record_end; ++mem)
 		checksum[1] += *mem;
 	if (checksum[0] != checksum[1])
 		return -EINVAL;
@@ -139,6 +146,7 @@ int softing_load_fw(const char *file, st
 	uint16_t type, len;
 	uint32_t addr;
 	uint8_t *buf = NULL, *new_buf;
+	s64 dpram_offset;
 	int buflen = 0;
 	int8_t type_end = 0;
 
@@ -153,7 +161,7 @@ int softing_load_fw(const char *file, st
 	mem = fw->data;
 	end = &mem[fw->size];
 	/* look for header record */
-	ret = fw_parse(&mem, &type, &addr, &len, &dat);
+	ret = fw_parse(&mem, end, &type, &addr, &len, &dat);
 	if (ret < 0)
 		goto failed;
 	if (type != 0xffff)
@@ -164,7 +172,7 @@ int softing_load_fw(const char *file, st
 	}
 	/* ok, we had a header */
 	while (mem < end) {
-		ret = fw_parse(&mem, &type, &addr, &len, &dat);
+		ret = fw_parse(&mem, end, &type, &addr, &len, &dat);
 		if (ret < 0)
 			goto failed;
 		if (type == 3) {
@@ -179,9 +187,13 @@ int softing_load_fw(const char *file, st
 			goto failed;
 		}
 
-		if ((addr + len + offset) > size)
+		dpram_offset = (s64)addr + offset;
+		if (dpram_offset < 0 || dpram_offset > size ||
+		    len > size - dpram_offset) {
+			ret = -EINVAL;
 			goto failed;
-		memcpy_toio(&dpram[addr + offset], dat, len);
+		}
+		memcpy_toio(&dpram[dpram_offset], dat, len);
 		/* be sure to flush caches from IO space */
 		mb();
 		if (len > buflen) {
@@ -195,7 +207,7 @@ int softing_load_fw(const char *file, st
 			buf = new_buf;
 		}
 		/* verify record data */
-		memcpy_fromio(buf, &dpram[addr + offset], len);
+		memcpy_fromio(buf, &dpram[dpram_offset], len);
 		if (memcmp(buf, dat, len)) {
 			/* is not ok */
 			dev_alert(&card->pdev->dev, "DPRAM readback failed\n");
@@ -237,7 +249,7 @@ int softing_load_app_fw(const char *file
 	mem = fw->data;
 	end = &mem[fw->size];
 	/* look for header record */
-	ret = fw_parse(&mem, &type, &addr, &len, &dat);
+	ret = fw_parse(&mem, end, &type, &addr, &len, &dat);
 	if (ret)
 		goto failed;
 	ret = -EINVAL;
@@ -253,7 +265,7 @@ int softing_load_app_fw(const char *file
 	}
 	/* ok, we had a header */
 	while (mem < end) {
-		ret = fw_parse(&mem, &type, &addr, &len, &dat);
+		ret = fw_parse(&mem, end, &type, &addr, &len, &dat);
 		if (ret)
 			goto failed;
 
@@ -279,6 +291,12 @@ int softing_load_app_fw(const char *file
 		/* work in 16bit (target) */
 		sum &= 0xffff;
 
+		if (card->pdat->app.offs > card->dpram_size ||
+		    len > card->dpram_size - card->pdat->app.offs) {
+			ret = -EINVAL;
+			goto failed;
+		}
+
 		memcpy_toio(&card->dpram[card->pdat->app.offs], dat, len);
 		iowrite32(card->pdat->app.offs + card->pdat->app.addr,
 				&card->dpram[DPRAM_COMMAND + 2]);


