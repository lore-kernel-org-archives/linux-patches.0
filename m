Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A74BC37F01B;
	Wed,  8 Apr 2026 18:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775672439; cv=none; b=XxyUDze7xjsHbBxFkAeDUZCkIPrt4sGJ1MtKkenQwBptlV4XBBDUh78Q/J/HqyD5Ht9m3q1hnaqzJ4X0D6Kz9yPBBYFTvlzyx7hAlKX6nAH5zYktyFtyXv1ps1vIUL0Wul3I5s+Kfrlny7ggqfCL+WPVt4nbMoJgbuV7GjmO8N8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775672439; c=relaxed/simple;
	bh=v0fxr9OK2qVunBcI8BJilk3bFuyQJ0+59FXYkTgrfC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e+fVhDsARh200IcMP2oLx1gsW1K4U38e2xoUDgeFhYs7Lb41o20t7Go48WYFoWW+MY9OJM6+p2FQ8GpQMO4dfnyy575p43LfRf4E59MNM40mnqubfReVm9hNhAWdaM6h7g3eyIhQ3qijv3XpAy7akRGwtfYrgWtWPLkTIrTfPkY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CV6QG8Nm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CV6QG8Nm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1ACC19421;
	Wed,  8 Apr 2026 18:20:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775672439;
	bh=v0fxr9OK2qVunBcI8BJilk3bFuyQJ0+59FXYkTgrfC4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CV6QG8Nm4TZaeSVpd+LxhHHRhjgosnj9s9NQEgFoUWKvT8M5C/c0CMKjgjG/qjmVA
	 VeOWnluUsP01fhmZRxaCDYAsXZXHDmGHIvdb08h35UyatXSoB5cWfXMSt2y+4NUs+F
	 3QoAtwv0YcTb/mjNdKBU1z5gouAvPWPh1V9Xz4Xc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <p.yadav@ti.com>,
	Michael Walle <michael@walle.cc>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Liyin Zhang <liyin.zhang.cn@windriver.com>
Subject: [PATCH 6.1 296/312] mtd: spi-nor: core: avoid odd length/address writes in 8D-8D-8D mode
Date: Wed,  8 Apr 2026 20:03:33 +0200
Message-ID: <20260408175944.822170418@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175933.715315542@linuxfoundation.org>
References: <20260408175933.715315542@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <p.yadav@ti.com>

[ Upstream commit 17926cd770ec837ed27d9856cf07f2da8dda4131 ]

On Octal DTR capable flashes like Micron Xcella the writes cannot start
or end at an odd address in Octal DTR mode. Extra 0xff bytes need to be
appended or prepended to make sure the start address and end address are
even. 0xff is used because on NOR flashes a program operation can only
flip bits from 1 to 0, not the other way round. 0 to 1 flip needs to
happen via erases.

Signed-off-by: Pratyush Yadav <p.yadav@ti.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Link: https://lore.kernel.org/r/20250708091646.292-2-ziniu.wang_1@nxp.com
[ Resolve conflict in drivers/mtd/spi-nor/core.c.
  In spi_nor_write(), the spi_nor_lock_device() and
  spi_nor_unlock_device() mechanism was not yet introduced in 6.1.y.
  Drop the spi_nor_unlock_device() call from the patch. ]
Signed-off-by: Liyin Zhang <liyin.zhang.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |   69 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 68 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -1791,6 +1791,68 @@ read_err:
 }
 
 /*
+ * On Octal DTR capable flashes, writes cannot start or end at an odd address
+ * in Octal DTR mode. Extra 0xff bytes need to be appended or prepended to
+ * make sure the start address and end address are even. 0xff is used because
+ * on NOR flashes a program operation can only flip bits from 1 to 0, not the
+ * other way round. 0 to 1 flip needs to happen via erases.
+ */
+static int spi_nor_octal_dtr_write(struct spi_nor *nor, loff_t to, size_t len,
+				   const u8 *buf)
+{
+	u8 *tmp_buf;
+	size_t bytes_written;
+	loff_t start, end;
+	int ret;
+
+	if (IS_ALIGNED(to, 2) && IS_ALIGNED(len, 2))
+		return spi_nor_write_data(nor, to, len, buf);
+
+	tmp_buf = kmalloc(nor->params->page_size, GFP_KERNEL);
+	if (!tmp_buf)
+		return -ENOMEM;
+
+	memset(tmp_buf, 0xff, nor->params->page_size);
+
+	start = round_down(to, 2);
+	end = round_up(to + len, 2);
+
+	memcpy(tmp_buf + (to - start), buf, len);
+
+	ret = spi_nor_write_data(nor, start, end - start, tmp_buf);
+	if (ret == 0) {
+		ret = -EIO;
+		goto out;
+	}
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * More bytes are written than actually requested, but that number can't
+	 * be reported to the calling function or it will confuse its
+	 * calculations. Calculate how many of the _requested_ bytes were
+	 * written.
+	 */
+	bytes_written = ret;
+
+	if (to != start)
+		ret -= to - start;
+
+	/*
+	 * Only account for extra bytes at the end if they were actually
+	 * written. For example, if for some reason the controller could only
+	 * complete a partial write then the adjustment for the extra bytes at
+	 * the end is not needed.
+	 */
+	if (start + bytes_written == end)
+		ret -= end - (to + len);
+
+out:
+	kfree(tmp_buf);
+	return ret;
+}
+
+/*
  * Write an address range to the nor chip.  Data must be written in
  * FLASH_PAGESIZE chunks.  The address range may be any size provided
  * it is within the physical boundaries.
@@ -1834,7 +1896,12 @@ static int spi_nor_write(struct mtd_info
 		if (ret)
 			goto write_err;
 
-		ret = spi_nor_write_data(nor, addr, page_remain, buf + i);
+		if (nor->write_proto == SNOR_PROTO_8_8_8_DTR)
+			ret = spi_nor_octal_dtr_write(nor, addr, page_remain,
+						      buf + i);
+		else
+			ret = spi_nor_write_data(nor, addr, page_remain,
+						 buf + i);
 		if (ret < 0)
 			goto write_err;
 		written = ret;


