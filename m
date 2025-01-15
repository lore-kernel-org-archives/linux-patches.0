Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D78F248BA6;
	Wed, 15 Jan 2025 10:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938133; cv=none; b=KPUSXZRby6pNN/bXtzhBvCHTPoD++SUZRlZZ+Rhij9anB1MMAIHOPJxlNaMupl690OMMlvO2mN9jFFE96BqDSGtyGw8pNqXPacI34hBjpeJetW/Tl4xVHyM56v9zn2c8rjSc9zYCQP2r+pqr+hOlYpvn6pCUHJqUwubV9uEltOk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938133; c=relaxed/simple;
	bh=uvOpDJJrNToa+xn93Z91wbd6Uc3pgFVZu4oPUq/bipo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O29jHQesZ0iPo/Uacp20LBSlHEQ3+uqylg2VB8ejsHdlvKGHmUhL5vKofoXO8eKTH6C5Ob++Ud3N5r0fi5GS4IOLjndjCWnRgKEga3+aTkNj0/5nNmtfcyG7AG73S1JaSAi6sbKprnkKV7uhUIQv2mTpx8laszgTLopeTC1tm6E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YWrQjYjB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YWrQjYjB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32862C4CEE4;
	Wed, 15 Jan 2025 10:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938132;
	bh=uvOpDJJrNToa+xn93Z91wbd6Uc3pgFVZu4oPUq/bipo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YWrQjYjBYrFFbhtzXdXw0NnDdkeEYsoheeW6xw7EWXEReQOtDFJ0EmANHYgUg/ekx
	 nlu8WtezmWka5HIG0nnE0KYJ6Ipx4YgAZJ4ebKI3JwshIxtqFfwNp54x2J0MYvruVy
	 F8Fa9+ZXQhOaan3wY8yzS033FVJ+ZcblQvicUGaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.12 091/189] dm-verity FEC: Fix RS FEC repair for roots unaligned to block size (take 2)
Date: Wed, 15 Jan 2025 11:36:27 +0100
Message-ID: <20250115103609.960089035@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Milan Broz <gmazyland@gmail.com>

commit 6df90c02bae468a3a6110bafbc659884d0c4966c upstream.

This patch fixes an issue that was fixed in the commit
  df7b59ba9245 ("dm verity: fix FEC for RS roots unaligned to block size")
but later broken again in the commit
  8ca7cab82bda ("dm verity fec: fix misaligned RS roots IO")

If the Reed-Solomon roots setting spans multiple blocks, the code does not
use proper parity bytes and randomly fails to repair even trivial errors.

This bug cannot happen if the sector size is multiple of RS roots
setting (Android case with roots 2).

The previous solution was to find a dm-bufio block size that is multiple
of the device sector size and roots size. Unfortunately, the optimization
in commit 8ca7cab82bda ("dm verity fec: fix misaligned RS roots IO")
is incorrect and uses data block size for some roots (for example, it uses
4096 block size for roots = 20).

This patch uses a different approach:

 - It always uses a configured data block size for dm-bufio to avoid
 possible misaligned IOs.

 - and it caches the processed parity bytes, so it can join it
 if it spans two blocks.

As the RS calculation is called only if an error is detected and
the process is computationally intensive, copying a few more bytes
should not introduce performance issues.

The issue was reported to cryptsetup with trivial reproducer
  https://gitlab.com/cryptsetup/cryptsetup/-/issues/923

Reproducer (with roots=20):

 # create verity device with RS FEC
 dd if=/dev/urandom of=data.img bs=4096 count=8 status=none
 veritysetup format data.img hash.img --fec-device=fec.img --fec-roots=20 | \
 awk '/^Root hash/{ print $3 }' >roothash

 # create an erasure that should always be repairable with this roots setting
 dd if=/dev/zero of=data.img conv=notrunc bs=1 count=4 seek=4 status=none

 # try to read it through dm-verity
 veritysetup open data.img test hash.img --fec-device=fec.img --fec-roots=20 $(cat roothash)
 dd if=/dev/mapper/test of=/dev/null bs=4096 status=noxfer

 Even now the log says it cannot repair it:
   : verity-fec: 7:1: FEC 0: failed to correct: -74
   : device-mapper: verity: 7:1: data block 0 is corrupted
   ...

With this fix, errors are properly repaired.
   : verity-fec: 7:1: FEC 0: corrected 4 errors

Signed-off-by: Milan Broz <gmazyland@gmail.com>
Fixes: 8ca7cab82bda ("dm verity fec: fix misaligned RS roots IO")
Cc: stable@vger.kernel.org
Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |   40 ++++++++++++++++++++++++++--------------
 1 file changed, 26 insertions(+), 14 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -60,15 +60,19 @@ static int fec_decode_rs8(struct dm_veri
  * to the data block. Caller is responsible for releasing buf.
  */
 static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
-			   unsigned int *offset, struct dm_buffer **buf,
-			   unsigned short ioprio)
+			   unsigned int *offset, unsigned int par_buf_offset,
+			   struct dm_buffer **buf, unsigned short ioprio)
 {
 	u64 position, block, rem;
 	u8 *res;
 
+	/* We have already part of parity bytes read, skip to the next block */
+	if (par_buf_offset)
+		index++;
+
 	position = (index + rsb) * v->fec->roots;
 	block = div64_u64_rem(position, v->fec->io_size, &rem);
-	*offset = (unsigned int)rem;
+	*offset = par_buf_offset ? 0 : (unsigned int)rem;
 
 	res = dm_bufio_read_with_ioprio(v->fec->bufio, block, buf, ioprio);
 	if (IS_ERR(res)) {
@@ -128,11 +132,12 @@ static int fec_decode_bufs(struct dm_ver
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
-	unsigned int n, i, offset;
-	u8 *par, *block;
+	unsigned int n, i, offset, par_buf_offset = 0;
+	u8 *par, *block, par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
 	struct bio *bio = dm_bio_from_per_bio_data(io, v->ti->per_io_data_size);
 
-	par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio_prio(bio));
+	par = fec_read_parity(v, rsb, block_offset, &offset,
+			      par_buf_offset, &buf, bio_prio(bio));
 	if (IS_ERR(par))
 		return PTR_ERR(par);
 
@@ -142,7 +147,8 @@ static int fec_decode_bufs(struct dm_ver
 	 */
 	fec_for_each_buffer_rs_block(fio, n, i) {
 		block = fec_buffer_rs_block(v, fio, n, i);
-		res = fec_decode_rs8(v, fio, block, &par[offset], neras);
+		memcpy(&par_buf[par_buf_offset], &par[offset], v->fec->roots - par_buf_offset);
+		res = fec_decode_rs8(v, fio, block, par_buf, neras);
 		if (res < 0) {
 			r = res;
 			goto error;
@@ -155,12 +161,21 @@ static int fec_decode_bufs(struct dm_ver
 		if (block_offset >= 1 << v->data_dev_block_bits)
 			goto done;
 
-		/* read the next block when we run out of parity bytes */
-		offset += v->fec->roots;
+		/* Read the next block when we run out of parity bytes */
+		offset += (v->fec->roots - par_buf_offset);
+		/* Check if parity bytes are split between blocks */
+		if (offset < v->fec->io_size && (offset + v->fec->roots) > v->fec->io_size) {
+			par_buf_offset = v->fec->io_size - offset;
+			memcpy(par_buf, &par[offset], par_buf_offset);
+			offset += par_buf_offset;
+		} else
+			par_buf_offset = 0;
+
 		if (offset >= v->fec->io_size) {
 			dm_bufio_release(buf);
 
-			par = fec_read_parity(v, rsb, block_offset, &offset, &buf, bio_prio(bio));
+			par = fec_read_parity(v, rsb, block_offset, &offset,
+					      par_buf_offset, &buf, bio_prio(bio));
 			if (IS_ERR(par))
 				return PTR_ERR(par);
 		}
@@ -724,10 +739,7 @@ int verity_fec_ctr(struct dm_verity *v)
 		return -E2BIG;
 	}
 
-	if ((f->roots << SECTOR_SHIFT) & ((1 << v->data_dev_block_bits) - 1))
-		f->io_size = 1 << v->data_dev_block_bits;
-	else
-		f->io_size = v->fec->roots << SECTOR_SHIFT;
+	f->io_size = 1 << v->data_dev_block_bits;
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
 					  f->io_size,


