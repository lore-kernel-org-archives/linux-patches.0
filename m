Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBDB83FBB52;
	Fri, 15 May 2026 16:16:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861767; cv=none; b=OrufMceG6XO1w9allH2vItAHXSuxfG326Q9Ic1jKbNoN0KYBia/ayuqErkeRDbgtz6AtUMJm0R4EPw43xdEKk1MS8ai6jmFlZ+7boU93CvjQgDyvON8dnAcEhr0wwsO5mTk0Vhs9do6gQ8YkjQ4ps0/mK1+q1HLVrh7F0wbEU2o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861767; c=relaxed/simple;
	bh=KYsMZrw7VO82muuQ7/X+YY8LuGZF4+MssERDOAi1XRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=HPOSeNm8ClVUyCB5JsUm2dmRTtEio8Eg5NqYRp73SXxtRmBLvfirYlbGVrJL/Eznbj/Kepm4/S44Zhb7DLPffcmNtckArbOoTgRYn742TuwapmWu24KRUC01vNu6S9MSAvY5OS+wZDiDEYPvaA2WiX4vRDqZmsoXSehdFBWh86c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VBxv+eqC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VBxv+eqC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62018C2BCB0;
	Fri, 15 May 2026 16:16:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861767;
	bh=KYsMZrw7VO82muuQ7/X+YY8LuGZF4+MssERDOAi1XRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VBxv+eqCOj+K6ebZbtD5CEI5Jln/IAqmRADswqwLQC6gOFoYJ3Y9ClUbnKD7wtHnb
	 ZhGO1gh1ST8mM7lRIUQdwMrDVdd4mgcJRUAUxAdGtZy3PSF1Jq7qt+LXTKllC3wV2K
	 8carDEQWGjipQAqKHw1NaB4HGzEpgp1Ml2kXWomo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s,
	=20Bence?= <csokas.bence@prolan.hu>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.6 454/474] mtd: spi-nor: sst: Factor out common write operation to `sst_nor_write_data()`
Date: Fri, 15 May 2026 17:49:23 +0200
Message-ID: <20260515154724.918180107@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -123,6 +123,21 @@ static const struct flash_info sst_nor_p
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
@@ -144,16 +159,10 @@ static int sst_nor_write(struct mtd_info
 
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
@@ -161,16 +170,11 @@ static int sst_nor_write(struct mtd_info
 
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
@@ -190,14 +194,9 @@ static int sst_nor_write(struct mtd_info
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
 


