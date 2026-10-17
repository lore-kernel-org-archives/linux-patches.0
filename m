Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9548417BED0;
	Sat, 17 Oct 2026 17:37:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258677; cv=none; b=tO0ADad94Cp7J3ObdQbZxprUeMjjJxdb34NAC/+zTTBxcKXpVZ2duDKHmq7Wfs8UTZUUTMwb3BPOruuTqLKBZeIylfCO+9465MRT99Ja6zSgOaw8SusBjfPy8oBt3hoWuH7Tvuti6EidWGVl5EOdwPl31WB1VSaf9xpY7jW4Mbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258677; c=relaxed/simple;
	bh=XT7lz9dJewerP78HEuVOL6w6ymH8ZmP+uWgUt17uE4s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L63GgoPIsNDIt17nKSTuWDyoOqvCl+GuT4cVS1v98nVPTdm7e1+sv2J8+kefZ8Mjv8B7wnf3E6yh+L4+jhzGeAYzOJeRIeNaLNBTt1+OlzjYrxlKXAJel6Ubg9M0wpKSRi+hku81qcuHGCgixDAX5JUEIuPurCTjCorCVS97EIE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WA0ifFRX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WA0ifFRX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECC411F000C4;
	Sat, 17 Oct 2026 17:37:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258676;
	bh=+Vmnw5mmWIhOJeQvvqZtez48IuvGEUcs7RwH87bztAw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WA0ifFRXFIvHFY8xDQY0eAuf6xZ0mM4IyvuA+ZowziD5FjKKzzbcHMUfVA4YTvxt8
	 JJkrdGoq5rWq2nnFOf3t+Bmkx3X/OP7BMKHMCVBBb32fYynoPn8ApQeGejvnxZV3pq
	 rgF+uCfjWFIvixR6uTviHrBRhb1+DzWnE9AgJ5bc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@kernel.org>,
	Mikulas Patocka <mpatocka@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0962/1674] dm-verity-fec: fix reading parity bytes split across blocks (take 3)
Date: Sat, 17 Oct 2026 17:53:54 +0200
Message-ID: <20261017160455.817328368@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: Eric Biggers <ebiggers@kernel.org>

[ Upstream commit 430a05cb926f6bdf53e81460a2c3a553257f3f61 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/md/dm-verity-fec.c | 97 +++++++++++++++++---------------------
 1 file changed, 43 insertions(+), 54 deletions(-)

diff --git a/drivers/md/dm-verity-fec.c b/drivers/md/dm-verity-fec.c
index 5f646c4bb98a6..5073c93cf962c 100644
--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -55,36 +55,6 @@ static int fec_decode_rs8(struct dm_verity *v, struct dm_verity_fec_io *fio,
 			  fio->erasures, 0, NULL);
 }
 
-/*
- * Read error-correcting codes for the requested RS block. Returns a pointer
- * to the data block. Caller is responsible for releasing buf.
- */
-static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
-			   unsigned int *offset, unsigned int par_buf_offset,
-			  struct dm_buffer **buf)
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
-	res = dm_bufio_read(v->fec->bufio, block, buf);
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
 /* Loop over each preallocated buffer slot. */
 #define fec_for_each_prealloc_buffer(__i) \
 	for (__i = 0; __i < DM_VERITY_FEC_BUF_PREALLOC; __i++)
@@ -132,13 +102,27 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
-	unsigned int n, i, offset, par_buf_offset = 0;
+	unsigned int n, i, parity_pos, to_copy;
 	u8 *par, *block, par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
+	u64 parity_block;
 
-	par = fec_read_parity(v, rsb, block_offset, &offset,
-			      par_buf_offset, &buf);
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
+	par = dm_bufio_read(v->fec->bufio, parity_block, &buf);
+	if (IS_ERR(par)) {
+		DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+		      v->data_dev->name, (unsigned long long)rsb,
+		      (unsigned long long)parity_block, PTR_ERR(par));
 		return PTR_ERR(par);
+	}
 
 	/*
 	 * Decode the RS blocks we have in bufs. Each RS block results in
@@ -146,7 +130,31 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 	 */
 	fec_for_each_buffer_rs_block(fio, n, i) {
 		block = fec_buffer_rs_block(v, fio, n, i);
-		memcpy(&par_buf[par_buf_offset], &par[offset], v->fec->roots - par_buf_offset);
+
+		/*
+		 * Copy the next 'roots' parity bytes to 'par_buf', reading
+		 * another parity block if needed.
+		 */
+		to_copy = min(v->fec->io_size - parity_pos, v->fec->roots);
+		memcpy(par_buf, &par[parity_pos], to_copy);
+		parity_pos += to_copy;
+		if (to_copy < v->fec->roots) {
+			parity_block++;
+			parity_pos = 0;
+
+			dm_bufio_release(buf);
+			par = dm_bufio_read(v->fec->bufio, parity_block, &buf);
+			if (IS_ERR(par)) {
+				DMERR("%s: FEC %llu: parity read failed (block %llu): %ld",
+				      v->data_dev->name, (unsigned long long)rsb,
+				      (unsigned long long)parity_block,
+				      PTR_ERR(par));
+				return PTR_ERR(par);
+			}
+			memcpy(&par_buf[to_copy], par, v->fec->roots - to_copy);
+			parity_pos = v->fec->roots - to_copy;
+		}
+
 		res = fec_decode_rs8(v, fio, block, par_buf, neras);
 		if (res < 0) {
 			r = res;
@@ -159,25 +167,6 @@ static int fec_decode_bufs(struct dm_verity *v, struct dm_verity_fec_io *fio,
 		block_offset++;
 		if (block_offset >= 1 << v->data_dev_block_bits)
 			goto done;
-
-		/* Read the next block when we run out of parity bytes */
-		offset += (v->fec->roots - par_buf_offset);
-		/* Check if parity bytes are split between blocks */
-		if (offset < v->fec->io_size && (offset + v->fec->roots) > v->fec->io_size) {
-			par_buf_offset = v->fec->io_size - offset;
-			memcpy(par_buf, &par[offset], par_buf_offset);
-			offset += par_buf_offset;
-		} else
-			par_buf_offset = 0;
-
-		if (offset >= v->fec->io_size) {
-			dm_bufio_release(buf);
-
-			par = fec_read_parity(v, rsb, block_offset, &offset,
-					      par_buf_offset, &buf);
-			if (IS_ERR(par))
-				return PTR_ERR(par);
-		}
 	}
 done:
 	r = corrected;
-- 
2.53.0



