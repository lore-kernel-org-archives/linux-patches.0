Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F27CE1E534;
	Tue, 27 Feb 2024 13:35:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040942; cv=none; b=OK98xqjXapWtn9ZGDhw3Cmt2uDqRVITlnYD+AXNrHAG2X6HqPvWXpo7Z4OYnHj7q5SyQCLv80VTLlCBs+U/WagNltPqOVn4mH6fCmvdX5Oivz8A9gYSFeJDETWJ5PR5fKRU8ShWbGgOCMByLVjQYLYZFBnOYu2DS69t/8aRoX1k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040942; c=relaxed/simple;
	bh=n0X2MtGyUCx9pDXisxfOh3Co4bTjVBbgCQv1HhH+BFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSXqMZJbP4TYU2Wg2Xh1gkCJhqA1lotvEaKzh+hovk1VPC6m8ZjvbGb1PHnnLV5TwWXF/i5/fdM/MzNrbB+Y1AHKIxCO9F6qwVosB/SsL9rxuc4s0TbptVBhKh0+vNYp7gxOs5n9hJRZc9RgIKX1njAse+a7EikPPpBMIGckDmA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nJZhub3r; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nJZhub3r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D4B1C433C7;
	Tue, 27 Feb 2024 13:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040941;
	bh=n0X2MtGyUCx9pDXisxfOh3Co4bTjVBbgCQv1HhH+BFU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nJZhub3rd+QBogasSyeNQHLr0TkzPq/kdTSuhTEXRORmCUVwDK52qP4HrFCp5XeF8
	 3bW17HE71PKNTKguyd/pmAEj7G0lYfz1cySeHybJU9v9EXuUGxrnbLui1Wz/y0Opfm
	 sX1sBFNjHPWOWiTs7o4oEOkAticqMcfoWJ5Mv9ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mikulas Patocka <mpatocka@redhat.com>,
	Mike Snitzer <snitzer@kernel.org>
Subject: [PATCH 6.7 163/334] dm-verity: recheck the hash after a failure
Date: Tue, 27 Feb 2024 14:20:21 +0100
Message-ID: <20240227131635.754055269@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mikulas Patocka <mpatocka@redhat.com>

commit 9177f3c0dea6143d05cac1bbd28668fd0e216d11 upstream.

If a userspace process reads (with O_DIRECT) multiple blocks into the same
buffer, dm-verity reports an error [1].

This commit fixes dm-verity, so that if hash verification fails, the data
is read again into a kernel buffer (where userspace can't modify it) and
the hash is rechecked. If the recheck succeeds, the content of the kernel
buffer is copied into the user buffer; if the recheck fails, an error is
reported.

[1] https://people.redhat.com/~mpatocka/testcases/blk-auth-modify/read2.c

Signed-off-by: Mikulas Patocka <mpatocka@redhat.com>
Cc: stable@vger.kernel.org
Signed-off-by: Mike Snitzer <snitzer@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/md/dm-verity-target.c |   86 +++++++++++++++++++++++++++++++++++++++---
 drivers/md/dm-verity.h        |    6 ++
 2 files changed, 86 insertions(+), 6 deletions(-)

--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -482,6 +482,63 @@ int verity_for_bv_block(struct dm_verity
 	return 0;
 }
 
+static int verity_recheck_copy(struct dm_verity *v, struct dm_verity_io *io,
+			       u8 *data, size_t len)
+{
+	memcpy(data, io->recheck_buffer, len);
+	io->recheck_buffer += len;
+
+	return 0;
+}
+
+static int verity_recheck(struct dm_verity *v, struct dm_verity_io *io,
+			  struct bvec_iter start, sector_t cur_block)
+{
+	struct page *page;
+	void *buffer;
+	int r;
+	struct dm_io_request io_req;
+	struct dm_io_region io_loc;
+
+	page = mempool_alloc(&v->recheck_pool, GFP_NOIO);
+	buffer = page_to_virt(page);
+
+	io_req.bi_opf = REQ_OP_READ;
+	io_req.mem.type = DM_IO_KMEM;
+	io_req.mem.ptr.addr = buffer;
+	io_req.notify.fn = NULL;
+	io_req.client = v->io;
+	io_loc.bdev = v->data_dev->bdev;
+	io_loc.sector = cur_block << (v->data_dev_block_bits - SECTOR_SHIFT);
+	io_loc.count = 1 << (v->data_dev_block_bits - SECTOR_SHIFT);
+	r = dm_io(&io_req, 1, &io_loc, NULL);
+	if (unlikely(r))
+		goto free_ret;
+
+	r = verity_hash(v, verity_io_hash_req(v, io), buffer,
+			1 << v->data_dev_block_bits,
+			verity_io_real_digest(v, io), true);
+	if (unlikely(r))
+		goto free_ret;
+
+	if (memcmp(verity_io_real_digest(v, io),
+		   verity_io_want_digest(v, io), v->digest_size)) {
+		r = -EIO;
+		goto free_ret;
+	}
+
+	io->recheck_buffer = buffer;
+	r = verity_for_bv_block(v, io, &start, verity_recheck_copy);
+	if (unlikely(r))
+		goto free_ret;
+
+	r = 0;
+free_ret:
+	mempool_free(page, &v->recheck_pool);
+
+	return r;
+}
+
 static int verity_bv_zero(struct dm_verity *v, struct dm_verity_io *io,
 			  u8 *data, size_t len)
 {
@@ -508,9 +565,7 @@ static int verity_verify_io(struct dm_ve
 {
 	bool is_zero;
 	struct dm_verity *v = io->v;
-#if defined(CONFIG_DM_VERITY_FEC)
 	struct bvec_iter start;
-#endif
 	struct bvec_iter iter_copy;
 	struct bvec_iter *iter;
 	struct crypto_wait wait;
@@ -561,10 +616,7 @@ static int verity_verify_io(struct dm_ve
 		if (unlikely(r < 0))
 			return r;
 
-#if defined(CONFIG_DM_VERITY_FEC)
-		if (verity_fec_is_enabled(v))
-			start = *iter;
-#endif
+		start = *iter;
 		r = verity_for_io_block(v, io, iter, &wait);
 		if (unlikely(r < 0))
 			return r;
@@ -586,6 +638,10 @@ static int verity_verify_io(struct dm_ve
 			 * tasklet since it may sleep, so fallback to work-queue.
 			 */
 			return -EAGAIN;
+		} else if (verity_recheck(v, io, start, cur_block) == 0) {
+			if (v->validated_blocks)
+				set_bit(cur_block, v->validated_blocks);
+			continue;
 #if defined(CONFIG_DM_VERITY_FEC)
 		} else if (verity_fec_decode(v, io, DM_VERITY_BLOCK_TYPE_DATA,
 					     cur_block, NULL, &start) == 0) {
@@ -941,6 +997,10 @@ static void verity_dtr(struct dm_target
 	if (v->verify_wq)
 		destroy_workqueue(v->verify_wq);
 
+	mempool_exit(&v->recheck_pool);
+	if (v->io)
+		dm_io_client_destroy(v->io);
+
 	if (v->bufio)
 		dm_bufio_client_destroy(v->bufio);
 
@@ -1379,6 +1439,20 @@ static int verity_ctr(struct dm_target *
 	}
 	v->hash_blocks = hash_position;
 
+	r = mempool_init_page_pool(&v->recheck_pool, 1, 0);
+	if (unlikely(r)) {
+		ti->error = "Cannot allocate mempool";
+		goto bad;
+	}
+
+	v->io = dm_io_client_create();
+	if (IS_ERR(v->io)) {
+		r = PTR_ERR(v->io);
+		v->io = NULL;
+		ti->error = "Cannot allocate dm io";
+		goto bad;
+	}
+
 	v->bufio = dm_bufio_client_create(v->hash_dev->bdev,
 		1 << v->hash_dev_block_bits, 1, sizeof(struct buffer_aux),
 		dm_bufio_alloc_callback, NULL,
--- a/drivers/md/dm-verity.h
+++ b/drivers/md/dm-verity.h
@@ -11,6 +11,7 @@
 #ifndef DM_VERITY_H
 #define DM_VERITY_H
 
+#include <linux/dm-io.h>
 #include <linux/dm-bufio.h>
 #include <linux/device-mapper.h>
 #include <linux/interrupt.h>
@@ -68,6 +69,9 @@ struct dm_verity {
 	unsigned long *validated_blocks; /* bitset blocks validated */
 
 	char *signature_key_desc; /* signature keyring reference */
+
+	struct dm_io_client *io;
+	mempool_t recheck_pool;
 };
 
 struct dm_verity_io {
@@ -84,6 +88,8 @@ struct dm_verity_io {
 
 	struct work_struct work;
 
+	char *recheck_buffer;
+
 	/*
 	 * Three variably-size fields follow this struct:
 	 *


