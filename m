Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 860CA342509;
	Tue, 12 May 2026 18:10:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609419; cv=none; b=fcY/fL+84LrAQqOii9RvA0cxaYNhdSBpuG8qiPJVAABr5NNyh+rldIgGaRgudVqDdpHU+fAXvffdZs7dZwQtQC4jUFkJQJ7A2eZ9bDveJ0MR+31JmIa0rxwNZZ11TtGvA7OVZ3S7lkG2JfM/te4iajXEHz2KltzK79hzICKevxQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609419; c=relaxed/simple;
	bh=EcFwoyVEaIPKdlTpi/xGKJ6PUDpBCtpIrt7TdhBZLfI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H1GeA7p4qY9ITu9gjCkAM7g35Xpi88wj2NbpVBi/LZmvrnaBkqMX06WTTgOZ/CGO8YEk7rC2gV/fLmYvhtU2YHC1Ky9TfrszXyrJDByzW+XZmeXWDb9hsvgljUUhHxxjuo96zl4BqCpPa5YAXnR0oJyP9RemUXLwPVWZ3V4v9Sw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iMN+NqTz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iMN+NqTz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC44C2BCB0;
	Tue, 12 May 2026 18:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609419;
	bh=EcFwoyVEaIPKdlTpi/xGKJ6PUDpBCtpIrt7TdhBZLfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iMN+NqTztjqxxgWE0QAUfLMhLK/lIMQMyoefyBiiXvjDRee+dGwd6H//azfNwWTp/
	 WxGC0g97AXxhrG5imsGlwKW5ZHx8hC8IrRYBetsIhDYOMN+KgXPyx8FUWkKu+tGyAz
	 nWuN8Isj8aor6kDBifzy8h0I35p2R2V9MyiNZ/gE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 7.0 187/307] dm-verity-fec: fix reading parity bytes split across blocks (take 3)
Date: Tue, 12 May 2026 19:39:42 +0200
Message-ID: <20260512173944.062186282@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Biggers <ebiggers@kernel.org>

commit 430a05cb926f6bdf53e81460a2c3a553257f3f61 upstream.

fec_decode_bufs() assumes that the parity bytes of the first RS codeword
it decodes are never split across parity blocks.

This assumption is false.  Consider v->fec->block_size == 4096 &&
v->fec->roots == 17 && fio->nbufs == 1, for example.  In that case, each
call to fec_decode_bufs() consumes v->fec->roots * (fio->nbufs <<
DM_VERITY_FEC_BUF_RS_BITS) = 272 parity bytes.

Considering that the parity data for each message block starts on a
block boundary, the byte alignment in the parity data will iterate
through 272*i mod 4096 until the 3 parity blocks have been consumed.  On
the 16th call (i=15), the alignment will be 4080 bytes into the first
block.  Only 16 bytes remain in that block, but 17 parity bytes will be
needed.  The code reads out-of-bounds from the parity block buffer.

Fortunately this doesn't normally happen, since it can occur only for
certain non-default values of fec_roots *and* when the maximum number of
buffers couldn't be allocated due to low memory.  For example with
block_size=4096 only the following cases are affected:

    fec_roots=17: nbufs in [1, 3, 5, 15]
    fec_roots=19: nbufs in [1, 229]
    fec_roots=21: nbufs in [1, 3, 5, 13, 15, 39, 65, 195]
    fec_roots=23: nbufs in [1, 89]

Regardless, fix it by refactoring how the parity blocks are read.

Fixes: 6df90c02bae4 ("dm-verity FEC: Fix RS FEC repair for roots unaligned to block size (take 2)")
Cc: stable@vger.kernel.org
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |  100 +++++++++++++++++++--------------------------
 1 file changed, 44 insertions(+), 56 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -33,36 +33,6 @@ static inline u64 fec_interleave(struct
 	return offset + mod * (v->fec->rounds << v->data_dev_block_bits);
 }
 
-/*
- * Read error-correcting codes for the requested RS block. Returns a pointer
- * to the data block. Caller is responsible for releasing buf.
- */
-static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
-			   unsigned int *offset, unsigned int par_buf_offset,
-			   struct dm_buffer **buf, unsigned short ioprio)
-{
-	u64 position, block, rem;
-	u8 *res;
-
-	/* We have already part of parity bytes read, skip to the next block */
-	if (par_buf_offset)
-		index++;
-
-	position = (index + rsb) * v->fec->roots;
-	block = div64_u64_rem(position, v->fec->io_size, &rem);
-	*offset = par_buf_offset ? 0 : (unsigned int)rem;
-
-	res = dm_bufio_read_with_ioprio(v->fec->bufio, block, buf, ioprio);
-	if (IS_ERR(res)) {
-		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
-		      v->data_dev->name, (unsigned long long)rsb,
-		      (unsigned long long)block, PTR_ERR(res));
-		*buf = NULL;
-	}
-
-	return res;
-}
-
 /* Loop over each allocated buffer. */
 #define fec_for_each_buffer(io, __i) \
 	for (__i = 0; __i < (io)->nbufs; __i++)
@@ -102,15 +72,29 @@ static int fec_decode_bufs(struct dm_ver
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
-	unsigned int n, i, j, offset, par_buf_offset = 0;
+	unsigned int n, i, j, parity_pos, to_copy;
 	uint16_t par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
 	u8 *par, *block;
+	u64 parity_block;
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
-	par = fec_read_parity(v, rsb, block_offset, &offset,
-			      par_buf_offset, &buf, bio->bi_ioprio);
-	if (IS_ERR(par))
+	/*
+	 * Compute the index of the first parity block that will be needed and
+	 * the starting position in that block.  Then read that block.
+	 *
+	 * io_size is always a power of 2, but roots might not be.  Note that
+	 * when it's not, a codeword's parity bytes can span a block boundary.
+	 */
+	parity_block = (rsb + block_offset) * v->fec->roots;
+	parity_pos = parity_block & (v->fec->io_size - 1);
+	parity_block >>= v->data_dev_block_bits;
+	par = dm_bufio_read_with_ioprio(v->fec->bufio, parity_block, &buf,
+					bio->bi_ioprio);
+	if (IS_ERR(par)) {
+		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+		      v->data_dev->name, rsb, parity_block, PTR_ERR(par));
 		return PTR_ERR(par);
+	}
 
 	/*
 	 * Decode the RS blocks we have in bufs. Each RS block results in
@@ -118,8 +102,32 @@ static int fec_decode_bufs(struct dm_ver
 	 */
 	fec_for_each_buffer_rs_block(fio, n, i) {
 		block = fec_buffer_rs_block(v, fio, n, i);
-		for (j = 0; j < v->fec->roots - par_buf_offset; j++)
-			par_buf[par_buf_offset + j] = par[offset + j];
+
+		/*
+		 * Copy the next 'roots' parity bytes to 'par_buf', reading
+		 * another parity block if needed.
+		 */
+		to_copy = min(v->fec->io_size - parity_pos, v->fec->roots);
+		for (j = 0; j < to_copy; j++)
+			par_buf[j] = par[parity_pos++];
+		if (to_copy < v->fec->roots) {
+			parity_block++;
+			parity_pos = 0;
+
+			dm_bufio_release(buf);
+			par = dm_bufio_read_with_ioprio(v->fec->bufio,
+							parity_block, &buf,
+							bio->bi_ioprio);
+			if (IS_ERR(par)) {
+				DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+				      v->data_dev->name, rsb, parity_block,
+				      PTR_ERR(par));
+				return PTR_ERR(par);
+			}
+			for (; j < v->fec->roots; j++)
+				par_buf[j] = par[parity_pos++];
+		}
+
 		/* Decode an RS block using Reed-Solomon */
 		res = decode_rs8(fio->rs, block, par_buf, v->fec->rsn,
 				 NULL, neras, fio->erasures, 0, NULL);
@@ -134,26 +142,6 @@ static int fec_decode_bufs(struct dm_ver
 		block_offset++;
 		if (block_offset >= 1 << v->data_dev_block_bits)
 			goto done;
-
-		/* Read the next block when we run out of parity bytes */
-		offset += (v->fec->roots - par_buf_offset);
-		/* Check if parity bytes are split between blocks */
-		if (offset < v->fec->io_size && (offset + v->fec->roots) > v->fec->io_size) {
-			par_buf_offset = v->fec->io_size - offset;
-			for (j = 0; j < par_buf_offset; j++)
-				par_buf[j] = par[offset + j];
-			offset += par_buf_offset;
-		} else
-			par_buf_offset = 0;
-
-		if (offset >= v->fec->io_size) {
-			dm_bufio_release(buf);
-
-			par = fec_read_parity(v, rsb, block_offset, &offset,
-					      par_buf_offset, &buf, bio->bi_ioprio);
-			if (IS_ERR(par))
-				return PTR_ERR(par);
-		}
 	}
 done:
 	r = corrected;


