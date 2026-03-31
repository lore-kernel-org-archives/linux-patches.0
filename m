Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE5BA41C30C;
	Tue, 31 Mar 2026 16:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974682; cv=none; b=UeMS0eWvPlqhLhQ0bgvtGn0t/sTeLuUwUGobsFGFvZ7GEbWvypPBQO5Rs84HU0R6a2CWKBPLGTnfofv3fya5J1rYrM/QuCtyAdTmg/E4X80r68EmziMzIkEOL2S/0rvspM1G5wSj5obAQxftwhPf/TqU7IFzDIYClcaFMa1Cu+I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974682; c=relaxed/simple;
	bh=fsc3siuiIXW//9+MzhWv/5max0tjwTva1qTA8Encaiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jq7ugdo8qxY5TupIsdkYILNnfM3amat1cuiD3DBPkwR1yuOvtzOax7F4R6SDGuHBETL+32BMFqII9S7aXJ7C6nQd/TxU8pjB8Bnvi2FaZhW36XZv02Kzf4X0ikiTDtQCKLRwhecUUHfrsJOJZbp3AQbOaPRF7Rvc/WUYms6Q0aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sXSqP9zm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sXSqP9zm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66C48C19424;
	Tue, 31 Mar 2026 16:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974682;
	bh=fsc3siuiIXW//9+MzhWv/5max0tjwTva1qTA8Encaiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sXSqP9zmsUD/hHYOBgYxzvQdCAN3LUZMJ1o6UBBPI0geABhR0LzEMIoJccp4QXwZV
	 2VKArzRv7vuR73e2OEj2D1qUcQMHJvZcWwuhAF0LHHSbaWBNi/1Qg1dhwpkcdDP429
	 IDd6VpCpg/ZLktWsUae3a1aLqaoGjxATS/mRBquY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <p.yadav@ti.com>,
	Michael Walle <michael@walle.cc>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Liyin Zhang <liyin.zhang.cn@windriver.com>
Subject: [PATCH 6.6 150/175] mtd: spi-nor: core: avoid odd length/address reads on 8D-8D-8D mode
Date: Tue, 31 Mar 2026 18:22:14 +0200
Message-ID: <20260331161735.302050711@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Pratyush Yadav <p.yadav@ti.com>

[ Upstream commit f156b23df6a84efb2f6686156be94d4988568954 ]

On Octal DTR capable flashes like Micron Xcella reads cannot start or
end at an odd address in Octal DTR mode. Extra bytes need to be read at
the start or end to make sure both the start address and length remain
even.

To avoid allocating too much extra memory, thereby putting unnecessary
memory pressure on the system, the temporary buffer containing the extra
padding bytes is capped at PAGE_SIZE bytes. The rest of the 2-byte
aligned part should be read directly in the main buffer.

Signed-off-by: Pratyush Yadav <p.yadav@ti.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Signed-off-by: Luke Wang <ziniu.wang_1@nxp.com>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Link: https://lore.kernel.org/r/20250708091646.292-1-ziniu.wang_1@nxp.com
[ Resolve conflict in drivers/mtd/spi-nor/core.c.
  In spi_nor_read(), 6.6.y contains a spi_nor_convert_addr() call
  before spi_nor_read_data(), introduced by 364995962803 ("mtd:
  spi-nor: Add a ->convert_addr() method"), which does not exist in
  mainline. This call is specific to Xilinx S3AN flashes, which use a
  non-standard address format. In mainline, S3AN flash support was
  removed entirely, and the corresponding spi_nor_convert_addr() call
  was dropped by 9539d12d9f52 ("mtd: spi-nor: get rid of non-power-of-2
  page size handling"). Keep the existing spi_nor_convert_addr() call
  and insert the new spi_nor_octal_dtr_read() branch after it. ]
Signed-off-by: Liyin Zhang <liyin.zhang.cn@windriver.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |   76 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2082,6 +2082,76 @@ static const struct flash_info *spi_nor_
 	return info;
 }
 
+/*
+ * On Octal DTR capable flashes, reads cannot start or end at an odd
+ * address in Octal DTR mode. Extra bytes need to be read at the start
+ * or end to make sure both the start address and length remain even.
+ */
+static int spi_nor_octal_dtr_read(struct spi_nor *nor, loff_t from, size_t len,
+				  u_char *buf)
+{
+	u_char *tmp_buf;
+	size_t tmp_len;
+	loff_t start, end;
+	int ret, bytes_read;
+
+	if (IS_ALIGNED(from, 2) && IS_ALIGNED(len, 2))
+		return spi_nor_read_data(nor, from, len, buf);
+	else if (IS_ALIGNED(from, 2) && len > PAGE_SIZE)
+		return spi_nor_read_data(nor, from, round_down(len, PAGE_SIZE),
+					 buf);
+
+	tmp_buf = kmalloc(PAGE_SIZE, GFP_KERNEL);
+	if (!tmp_buf)
+		return -ENOMEM;
+
+	start = round_down(from, 2);
+	end = round_up(from + len, 2);
+
+	/*
+	 * Avoid allocating too much memory. The requested read length might be
+	 * quite large. Allocating a buffer just as large (slightly bigger, in
+	 * fact) would put unnecessary memory pressure on the system.
+	 *
+	 * For example if the read is from 3 to 1M, then this will read from 2
+	 * to 4098. The reads from 4098 to 1M will then not need a temporary
+	 * buffer so they can proceed as normal.
+	 */
+	tmp_len = min_t(size_t, end - start, PAGE_SIZE);
+
+	ret = spi_nor_read_data(nor, start, tmp_len, tmp_buf);
+	if (ret == 0) {
+		ret = -EIO;
+		goto out;
+	}
+	if (ret < 0)
+		goto out;
+
+	/*
+	 * More bytes are read than actually requested, but that number can't be
+	 * reported to the calling function or it will confuse its calculations.
+	 * Calculate how many of the _requested_ bytes were read.
+	 */
+	bytes_read = ret;
+
+	if (from != start)
+		ret -= from - start;
+
+	/*
+	 * Only account for extra bytes at the end if they were actually read.
+	 * For example, if the total length was truncated because of temporary
+	 * buffer size limit then the adjustment for the extra bytes at the end
+	 * is not needed.
+	 */
+	if (start + bytes_read == end)
+		ret -= end - (from + len);
+
+	memcpy(buf, tmp_buf + (from - start), ret);
+out:
+	kfree(tmp_buf);
+	return ret;
+}
+
 static int spi_nor_read(struct mtd_info *mtd, loff_t from, size_t len,
 			size_t *retlen, u_char *buf)
 {
@@ -2101,7 +2171,11 @@ static int spi_nor_read(struct mtd_info
 
 		addr = spi_nor_convert_addr(nor, addr);
 
-		ret = spi_nor_read_data(nor, addr, len, buf);
+		if (nor->read_proto == SNOR_PROTO_8_8_8_DTR)
+			ret = spi_nor_octal_dtr_read(nor, addr, len, buf);
+		else
+			ret = spi_nor_read_data(nor, addr, len, buf);
+
 		if (ret == 0) {
 			/* We shouldn't see 0-length reads */
 			ret = -EIO;


