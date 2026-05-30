Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B12612F39CE;
	Sat, 30 May 2026 20:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780171303; cv=none; b=hc1hg7cX3YX8XrkhEdQFSxg+q69wl3AmucUz6NkQeUOwkS2a+bMmvjmnDRpnf/r107AYpJ7k26QeSO4jdBhYSM387FhJ8eUTtA2a2R11i0w6itd/TI0e0WdDm6xIrUJHcvfpcTOkG0cgEGkDbbvLyowlyka90rP+HN7eSB06STc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780171303; c=relaxed/simple;
	bh=HIEvJ2qJpV+v3lmH+po/ztUdbX+ryxZj6uRZAqZ2bYM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=CBVxnttBP4c5ttTas0fUqaO18UfrK9JviyFY1RfzFlSNkdpZmbuFQypNZ7aO1g7TZJeEufwBzbgYsNc/ENrl4ymYLmaAVVUg0W/SkSW+TyOhKrTCGpg/Do/9G6OBYiwF4prZjJTExTZ3smdKo0k3seSwSFa+yw/7FEXXRVCgd6Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zkiAJqHZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zkiAJqHZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C7DDF1F00893;
	Sat, 30 May 2026 20:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780171301;
	bh=feobJL59YA0cT6xnoIJFcL/ZwU5Y1toxOQs8vWxYEuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zkiAJqHZliV4OjF4eLox64yfBjcr8j19Mv+Xftj1a2E+kZgQx5vPcDQeinC7/MSLe
	 F6s9EBLvYLQOH8v7k0hTXXuRjXYnBvOaZ3nUp1wJoQ4uIncClIl0kfT0n35Yh05Hem
	 vQiXusVa2xcM8nw/3+CfBc1OfBjYkwu+jg6jqRWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=20Bence?= <csokas.bence@prolan.hu>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.1 423/969] mtd: spi-nor: sst: Factor out common write operation to `sst_nor_write_data()`
Date: Sat, 30 May 2026 17:59:07 +0200
Message-ID: <20260530160311.944332517@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bence Csókás <csokas.bence@prolan.hu>

commit 18bcb4aa54eab75dce41e5c176a1c2bff94f0f79 upstream.

Writing to the Flash in `sst_nor_write()` is a 3-step process:
first an optional one-byte write to get 2-byte-aligned, then the
bulk of the data is written out in vendor-specific 2-byte writes.
Finally, if there's a byte left over, another one-byte write.
This was implemented 3 times in the body of `sst_nor_write()`.
To reduce code duplication, factor out these sub-steps to their
own function.

Signed-off-by: Csókás, Bence <csokas.bence@prolan.hu>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
[pratyush@kernel.org: fixup whitespace, use %zu instead of %i in WARN()]
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Link: https://lore.kernel.org/r/20240710091401.1282824-1-csokas.bence@prolan.hu
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/sst.c |   39 +++++++++++++++++++--------------------
 1 file changed, 19 insertions(+), 20 deletions(-)

--- a/drivers/mtd/spi-nor/sst.c
+++ b/drivers/mtd/spi-nor/sst.c
@@ -117,6 +117,21 @@ static const struct flash_info sst_nor_p
 		.fixups = &sst26vf_nor_fixups },
 };
 
+static int sst_nor_write_data(struct spi_nor *nor, loff_t to, size_t len,
+			      const u_char *buf)
+{
+	u8 op = (len == 1) ? SPINOR_OP_BP : SPINOR_OP_AAI_WP;
+	int ret;
+
+	nor->program_opcode = op;
+	ret = spi_nor_write_data(nor, to, 1, buf);
+	if (ret < 0)
+		return ret;
+	WARN(ret != len, "While writing %zu byte written %i bytes\n", len, ret);
+
+	return spi_nor_wait_till_ready(nor);
+}
+
 static int sst_nor_write(struct mtd_info *mtd, loff_t to, size_t len,
 			 size_t *retlen, const u_char *buf)
 {
@@ -138,16 +153,10 @@ static int sst_nor_write(struct mtd_info
 
 	/* Start write from odd address. */
 	if (to % 2) {
-		nor->program_opcode = SPINOR_OP_BP;
-
 		/* write one byte. */
-		ret = spi_nor_write_data(nor, to, 1, buf);
+		ret = sst_nor_write_data(nor, to, 1, buf);
 		if (ret < 0)
 			goto out;
-		WARN(ret != 1, "While writing 1 byte written %i bytes\n", ret);
-		ret = spi_nor_wait_till_ready(nor);
-		if (ret)
-			goto out;
 
 		to++;
 		actual++;
@@ -155,16 +164,11 @@ static int sst_nor_write(struct mtd_info
 
 	/* Write out most of the data here. */
 	for (; actual < len - 1; actual += 2) {
-		nor->program_opcode = SPINOR_OP_AAI_WP;
-
 		/* write two bytes. */
-		ret = spi_nor_write_data(nor, to, 2, buf + actual);
+		ret = sst_nor_write_data(nor, to, 2, buf + actual);
 		if (ret < 0)
 			goto out;
-		WARN(ret != 2, "While writing 2 bytes written %i bytes\n", ret);
-		ret = spi_nor_wait_till_ready(nor);
-		if (ret)
-			goto out;
+
 		to += 2;
 		nor->sst_write_second = true;
 	}
@@ -184,14 +188,9 @@ static int sst_nor_write(struct mtd_info
 		if (ret)
 			goto out;
 
-		nor->program_opcode = SPINOR_OP_BP;
-		ret = spi_nor_write_data(nor, to, 1, buf + actual);
+		ret = sst_nor_write_data(nor, to, 1, buf + actual);
 		if (ret < 0)
 			goto out;
-		WARN(ret != 1, "While writing 1 byte written %i bytes\n", ret);
-		ret = spi_nor_wait_till_ready(nor);
-		if (ret)
-			goto out;
 
 		actual += 1;
 


