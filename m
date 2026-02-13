Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AFE854723;
	Fri, 13 Feb 2026 13:51:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770990688; cv=none; b=FPlBLdnU+XKSeVi2yZXMv2lh7yOB/AO0NEoMDbzVBMlPvBle5eAFxOX7F6j72tuITCPdZz3bFolCe4TzTzfK5zmMpXqDqCp1Mc9tvb8I3pqdn202FflWHHqZ265tQ6ze+eCFg4qsNEjlKK+DVupxoIevXRecN8iLFWJWq/VoIPc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770990688; c=relaxed/simple;
	bh=3ejgLdABCLhI/8K8/nbEefFMJNXDYf8RHok/S3yLS/c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c/GPhAh5t9/vciD78RAExt35WSlhU3IrXekJsGg4inZNnEru2SB/7/Y3WUb8xkUewKskXiita56XvAyoxcdURZ3M7KiXPx2Mw879bxKLeKAsx+u8+Ut8UWOcMVUmrvxL6wD7f/5jIBSbavPocXoj7g04+5UGA+KOEhpI4NFXOmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OjCLDjqO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OjCLDjqO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A974AC116C6;
	Fri, 13 Feb 2026 13:51:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770990688;
	bh=3ejgLdABCLhI/8K8/nbEefFMJNXDYf8RHok/S3yLS/c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OjCLDjqOg0APjKU+rST7g4OiMIS1Lf77hsWX9SHKcK/t212dsFzetrDlojprHBEkE
	 m5OiQizJq3gEvDGLoRPrxOgh+wTuTxb3me39sXyiQ5YC6rJTrUlA7c+e6jVoJceUjn
	 VhW23+0KZf3h+O/7TGCcTM+GQjxvNT7XuBGMCLVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Chao Yu <chao@kernel.org>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.19 45/49] erofs: fix UAF issue for file-backed mounts w/ directio option
Date: Fri, 13 Feb 2026 14:48:04 +0100
Message-ID: <20260213134710.363083324@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260213134708.713126210@linuxfoundation.org>
References: <20260213134708.713126210@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Yu <chao@kernel.org>

commit 1caf50ce4af096d0280d59a31abdd85703cd995c upstream.

[    9.269940][ T3222] Call trace:
[    9.269948][ T3222]  ext4_file_read_iter+0xac/0x108
[    9.269979][ T3222]  vfs_iocb_iter_read+0xac/0x198
[    9.269993][ T3222]  erofs_fileio_rq_submit+0x12c/0x180
[    9.270008][ T3222]  erofs_fileio_submit_bio+0x14/0x24
[    9.270030][ T3222]  z_erofs_runqueue+0x834/0x8ac
[    9.270054][ T3222]  z_erofs_read_folio+0x120/0x220
[    9.270083][ T3222]  filemap_read_folio+0x60/0x120
[    9.270102][ T3222]  filemap_fault+0xcac/0x1060
[    9.270119][ T3222]  do_pte_missing+0x2d8/0x1554
[    9.270131][ T3222]  handle_mm_fault+0x5ec/0x70c
[    9.270142][ T3222]  do_page_fault+0x178/0x88c
[    9.270167][ T3222]  do_translation_fault+0x38/0x54
[    9.270183][ T3222]  do_mem_abort+0x54/0xac
[    9.270208][ T3222]  el0_da+0x44/0x7c
[    9.270227][ T3222]  el0t_64_sync_handler+0x5c/0xf4
[    9.270253][ T3222]  el0t_64_sync+0x1bc/0x1c0

EROFS may encounter above panic when enabling file-backed mount w/
directio mount option, the root cause is it may suffer UAF in below
race condition:

- z_erofs_read_folio                          wq s_dio_done_wq
 - z_erofs_runqueue
  - erofs_fileio_submit_bio
   - erofs_fileio_rq_submit
    - vfs_iocb_iter_read
     - ext4_file_read_iter
      - ext4_dio_read_iter
       - iomap_dio_rw
       : bio was submitted and return -EIOCBQUEUED
                                              - dio_aio_complete_work
                                               - dio_complete
                                                - dio->iocb->ki_complete (erofs_fileio_ki_complete())
                                                 - kfree(rq)
                                                 : it frees iocb, iocb.ki_filp can be UAF in file_accessed().
       - file_accessed
       : access NULL file point

Introduce a reference count in struct erofs_fileio_rq, and initialize it
as two, both erofs_fileio_ki_complete() and erofs_fileio_rq_submit() will
decrease reference count, the last one decreasing the reference count
to zero will free rq.

Cc: stable@kernel.org
Fixes: fb176750266a ("erofs: add file-backed mount support")
Fixes: 6422cde1b0d5 ("erofs: use buffered I/O for file-backed mounts by default")
Signed-off-by: Chao Yu <chao@kernel.org>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/fileio.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/fs/erofs/fileio.c
+++ b/fs/erofs/fileio.c
@@ -10,6 +10,7 @@ struct erofs_fileio_rq {
 	struct bio bio;
 	struct kiocb iocb;
 	struct super_block *sb;
+	refcount_t ref;
 };
 
 struct erofs_fileio {
@@ -42,7 +43,8 @@ static void erofs_fileio_ki_complete(str
 	}
 	bio_endio(&rq->bio);
 	bio_uninit(&rq->bio);
-	kfree(rq);
+	if (refcount_dec_and_test(&rq->ref))
+		kfree(rq);
 }
 
 static void erofs_fileio_rq_submit(struct erofs_fileio_rq *rq)
@@ -64,6 +66,8 @@ static void erofs_fileio_rq_submit(struc
 		ret = vfs_iocb_iter_read(rq->iocb.ki_filp, &rq->iocb, &iter);
 	if (ret != -EIOCBQUEUED)
 		erofs_fileio_ki_complete(&rq->iocb, ret);
+	if (refcount_dec_and_test(&rq->ref))
+		kfree(rq);
 }
 
 static struct erofs_fileio_rq *erofs_fileio_rq_alloc(struct erofs_map_dev *mdev)
@@ -74,6 +78,7 @@ static struct erofs_fileio_rq *erofs_fil
 	bio_init(&rq->bio, NULL, rq->bvecs, ARRAY_SIZE(rq->bvecs), REQ_OP_READ);
 	rq->iocb.ki_filp = mdev->m_dif->file;
 	rq->sb = mdev->m_sb;
+	refcount_set(&rq->ref, 2);
 	return rq;
 }
 


