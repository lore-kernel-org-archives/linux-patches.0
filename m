Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0483248BA8;
	Wed, 15 Jan 2025 10:41:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736937678; cv=none; b=SftfVldYmaZG9SHhpLxH6UD50+TLkzkBsMCeJjClzOjckK0V0LxLhxNVCPte3FftzwydU/a9VVL/veGHhp5QgAnEdeRd+VQspeWBG/M6dmekCr7W7yCVRR13XFgg3RHo/TlnT1zgHkzNoM+aho/7Bdk8S6wdxTS/uA2LggeaD6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736937678; c=relaxed/simple;
	bh=sg36DisQ6/XUOvMPseLcsLqb6vU+HOwIdtAFzNRDbwU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h81+RSIdfmIa3pEFbDL9c9Jllj0hLjDfNO4QDN/2oTs4SZ+ui/0Nl5i2Ih9duu8d6yyeV7Lzve7Mj/XW3Vjvyyc/ns9CTN5W3s0qt34PYmmEmuvPS1pxjaygid4OpSrNdzqcAxS2qUfTFDh9VbOwyzWnUYVE5N3ZQf9Sp6yVlcw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VECKCg6n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VECKCg6n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FF84C4CEE3;
	Wed, 15 Jan 2025 10:41:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736937678;
	bh=sg36DisQ6/XUOvMPseLcsLqb6vU+HOwIdtAFzNRDbwU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VECKCg6nqIPdi0G8xSYy3D3DlFUfZjuTLA8Cdp4aG9rwahN5Du9mGsmhy+zgW/nQH
	 J3mUHXUDPpQzn4MGis8JT383gS0bnVjvXAXrQlzFLh9yQTQ72VWEtzi/rgtlNJzaiF
	 t4cKjN5Xzn2uwQbjKmgGMuZBoGzROpvcqNITtjbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milan Broz <gmazyland@gmail.com>,
	Mikulas Patocka <mpatocka@redhat.com>
Subject: [PATCH 6.1 49/92] dm-verity FEC: Fix RS FEC repair for roots unaligned to block size (take 2)
Date: Wed, 15 Jan 2025 11:37:07 +0100
Message-ID: <20250115103549.492162002@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103547.522503305@linuxfoundation.org>
References: <20250115103547.522503305@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Milan Broz <gmazyland@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-fec.c |   39 ++++++++++++++++++++++++++-------------
 1 file changed, 26 insertions(+), 13 deletions(-)

--- a/drivers/md/dm-verity-fec.c
+++ b/drivers/md/dm-verity-fec.c
@@ -60,14 +60,19 @@ static int fec_decode_rs8(struct dm_veri
  * to the data block. Caller is responsible for releasing buf.
  */
 static u8 *fec_read_parity(struct dm_verity *v, u64 rsb, int index,
-			   unsigned int *offset, struct dm_buffer **buf)
+			   unsigned int *offset, unsigned int par_buf_offset,
+			  struct dm_buffer **buf)
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
 
 	res = dm_bufio_read(v->fec->bufio, block, buf);
 	if (IS_ERR(res)) {
@@ -127,10 +132,11 @@ static int fec_decode_bufs(struct dm_ver
 {
 	int r, corrected = 0, res;
 	struct dm_buffer *buf;
-	unsigned int n, i, offset;
-	u8 *par, *block;
+	unsigned int n, i, offset, par_buf_offset = 0;
+	u8 *par, *block, par_buf[DM_VERITY_FEC_RSM - DM_VERITY_FEC_MIN_RSN];
 
-	par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
+	par = fec_read_parity(v, rsb, block_offset, &offset,
+			      par_buf_offset, &buf);
 	if (IS_ERR(par))
 		return PTR_ERR(par);
 
@@ -140,7 +146,8 @@ static int fec_decode_bufs(struct dm_ver
 	 */
 	fec_for_each_buffer_rs_block(fio, n, i) {
 		block = fec_buffer_rs_block(v, fio, n, i);
-		res = fec_decode_rs8(v, fio, block, &par[offset], neras);
+		memcpy(&par_buf[par_buf_offset], &par[offset], v->fec->roots - par_buf_offset);
+		res = fec_decode_rs8(v, fio, block, par_buf, neras);
 		if (res < 0) {
 			r = res;
 			goto error;
@@ -153,12 +160,21 @@ static int fec_decode_bufs(struct dm_ver
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
 
-			par = fec_read_parity(v, rsb, block_offset, &offset, &buf);
+			par = fec_read_parity(v, rsb, block_offset, &offset,
+					      par_buf_offset, &buf);
 			if (IS_ERR(par))
 				return PTR_ERR(par);
 		}
@@ -743,10 +759,7 @@ int verity_fec_ctr(struct dm_verity *v)
 		return -E2BIG;
 	}
 
-	if ((f->roots << SECTOR_SHIFT) & ((1 << v->data_dev_block_bits) - 1))
-		f->io_size = 1 << v->data_dev_block_bits;
-	else
-		f->io_size = v->fec->roots << SECTOR_SHIFT;
+	f->io_size = 1 << v->data_dev_block_bits;
 
 	f->bufio = dm_bufio_client_create(f->dev->bdev,
 					  f->io_size,


