Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB3C3AF66B;
	Mon, 23 Mar 2026 14:50:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774277445; cv=none; b=cVst42A8tqFTIeRr++hz+A0boLLD+jXNif1JBOvSvhPDPxLgCONAXsoELIEK6uvi+lAvI55sd6bmFNjtOcbDfjbPCMrQmPJRUy5HmUhFJD/6frSMZ/EYtUonT1BcxDcpwqAMdGC0z55sC8bIYULwMmMjrC9CagPK8l9DQx7pjVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774277445; c=relaxed/simple;
	bh=7oXm5ZUM1x1SRkDGpf8SFN11vn/UrhvMkbtgDFI4tMk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zd5SG1Qz6c/9pX0qkhl0NZ/Ep28G3bxHbmJi8Gva5J9m1y1o86avYjg1W9aJoUr98CF9epsSSpJdBpEZDjXemMIPScK+q9pe5AT3QzTi47nnfJTlpnja5jdRkJSR69hsDRqRmEOXR1NeuXIcx0L2In/RGjf3eDlPcnv+QDdH7sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=isMsLgHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="isMsLgHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14BC7C4CEF7;
	Mon, 23 Mar 2026 14:50:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774277445;
	bh=7oXm5ZUM1x1SRkDGpf8SFN11vn/UrhvMkbtgDFI4tMk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=isMsLgHeYpaHTFBf0k1Pr4ZPzSWKzFjc+HP7mCMuGMfvmcTHZP3F314Rs0HThuBB0
	 /A8TYC05HTDVX2LRVxkZZCUDtBgqZxqbLEbt7yd08jVLVLM08cBLHXPAt32O1Bbyuo
	 lcfMpvcrY0+vsvpTq/kQVZqUgoChZ55qIVLJkUaY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pratyush Yadav <p.yadav@ti.com>,
	Michael Walle <michael@walle.cc>,
	Luke Wang <ziniu.wang_1@nxp.com>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.12 443/460] mtd: spi-nor: core: avoid odd length/address reads on 8D-8D-8D mode
Date: Mon, 23 Mar 2026 14:47:19 +0100
Message-ID: <20260323134537.468853998@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pratyush Yadav <p.yadav@ti.com>

commit f156b23df6a84efb2f6686156be94d4988568954 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |   76 ++++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 75 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2037,6 +2037,76 @@ static const struct flash_info *spi_nor_
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
@@ -2054,7 +2124,11 @@ static int spi_nor_read(struct mtd_info
 	while (len) {
 		loff_t addr = from;
 
-		ret = spi_nor_read_data(nor, addr, len, buf);
+		if (nor->read_proto == SNOR_PROTO_8_8_8_DTR)
+			ret = spi_nor_octal_dtr_read(nor, addr, len, buf);
+		else
+			ret = spi_nor_read_data(nor, addr, len, buf);
+
 		if (ret == 0) {
 			/* We shouldn't see 0-length reads */
 			ret = -EIO;


