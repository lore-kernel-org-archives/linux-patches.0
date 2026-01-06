Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A51B34DB44;
	Tue,  6 Jan 2026 18:03:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767722604; cv=none; b=EfLz0zUwlL4tGBKrxSu2IuQ3YU3AognkGrH1a0J4qzA4lPCksEgQneQlZAyc/dxHGTLgTSiZfAhxkYh7GUncPsiJFxfBu/f/LnQjVZwQxWTqWG4ZH8LlcOWAafivsFTMR6OV3ssLB2GWCofwgKds9Mhp0xxD5JJoaikGXzwlMho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767722604; c=relaxed/simple;
	bh=Qpv85fCMZi6gRwNIduDE4tvnbMC9jpxRcXK/7d1A9bU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bdzLst2Ince8jFsAGSs6Bj8QyjmnUlhRFq436NkIARpGUX158KA9nYgW9WI5TpAaMkjXPQombWGQHYEEd/6DpSEzIuUd6wWswb2YEgXlleJM6BHnhTwNYvLvQLhJeZ+yLxerG9xVUAmgblUpMCXLBlO83DiJtpgn6eT+nNC+kU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jPHwniYk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jPHwniYk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0983AC116C6;
	Tue,  6 Jan 2026 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767722604;
	bh=Qpv85fCMZi6gRwNIduDE4tvnbMC9jpxRcXK/7d1A9bU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jPHwniYk4Zoy4LGdGMZLZm3mZuoWyX6Ibi1NBFsIO5fY3bXxmiQ05RKXf5IZl9kqk
	 knVm5oxzTzM+gHYTLbIeijaYdA17J3Jbsii/ovyp1N74x/LCjoOAJ9pXxQm21tH6Ig
	 WFtCryj6TDO9Isf9NQ3SXq+8Pzz4+M5FNJumSsys=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaewook Kim <jw5454.kim@samsung.com>,
	Sungjong Seo <sj1557.seo@samsung.com>,
	Junbeom Yeom <junbeom.yeom@samsung.com>,
	Gao Xiang <hsiangkao@linux.alibaba.com>
Subject: [PATCH 6.18 305/312] erofs: fix unexpected EIO under memory pressure
Date: Tue,  6 Jan 2026 18:06:19 +0100
Message-ID: <20260106170558.894721075@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junbeom Yeom <junbeom.yeom@samsung.com>

commit 4012d78562193ef5eb613bad4b0c0fa187637cfe upstream.

erofs readahead could fail with ENOMEM under the memory pressure because
it tries to alloc_page with GFP_NOWAIT | GFP_NORETRY, while GFP_KERNEL
for a regular read. And if readahead fails (with non-uptodate folios),
the original request will then fall back to synchronous read, and
`.read_folio()` should return appropriate errnos.

However, in scenarios where readahead and read operations compete,
read operation could return an unintended EIO because of an incorrect
error propagation.

To resolve this, this patch modifies the behavior so that, when the
PCL is for read(which means pcl.besteffort is true), it attempts actual
decompression instead of propagating the privios error except initial EIO.

- Page size: 4K
- The original size of FileA: 16K
- Compress-ratio per PCL: 50% (Uncompressed 8K -> Compressed 4K)
[page0, page1] [page2, page3]
[PCL0]---------[PCL1]

- functions declaration:
  . pread(fd, buf, count, offset)
  . readahead(fd, offset, count)
- Thread A tries to read the last 4K
- Thread B tries to do readahead 8K from 4K
- RA, besteffort == false
- R, besteffort == true

        <process A>                   <process B>

pread(FileA, buf, 4K, 12K)
  do readahead(page3) // failed with ENOMEM
  wait_lock(page3)
    if (!uptodate(page3))
      goto do_read
                               readahead(FileA, 4K, 8K)
                               // Here create PCL-chain like below:
                               // [null, page1] [page2, null]
                               //   [PCL0:RA]-----[PCL1:RA]
...
  do read(page3)        // found [PCL1:RA] and add page3 into it,
                        // and then, change PCL1 from RA to R
...
                               // Now, PCL-chain is as below:
                               // [null, page1] [page2, page3]
                               //   [PCL0:RA]-----[PCL1:R]

                                 // try to decompress PCL-chain...
                                 z_erofs_decompress_queue
                                   err = 0;

                                   // failed with ENOMEM, so page 1
                                   // only for RA will not be uptodated.
                                   // it's okay.
                                   err = decompress([PCL0:RA], err)

                                   // However, ENOMEM propagated to next
                                   // PCL, even though PCL is not only
                                   // for RA but also for R. As a result,
                                   // it just failed with ENOMEM without
                                   // trying any decompression, so page2
                                   // and page3 will not be uptodated.
                ** BUG HERE ** --> err = decompress([PCL1:R], err)

                                   return err as ENOMEM
...
    wait_lock(page3)
      if (!uptodate(page3))
        return EIO      <-- Return an unexpected EIO!
...

Fixes: 2349d2fa02db ("erofs: sunset unneeded NOFAILs")
Cc: stable@vger.kernel.org
Reviewed-by: Jaewook Kim <jw5454.kim@samsung.com>
Reviewed-by: Sungjong Seo <sj1557.seo@samsung.com>
Signed-off-by: Junbeom Yeom <junbeom.yeom@samsung.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Reviewed-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Gao Xiang <hsiangkao@linux.alibaba.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/erofs/zdata.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

--- a/fs/erofs/zdata.c
+++ b/fs/erofs/zdata.c
@@ -1262,17 +1262,17 @@ static int z_erofs_parse_in_bvecs(struct
 	return err;
 }
 
-static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, int err)
+static int z_erofs_decompress_pcluster(struct z_erofs_backend *be, bool eio)
 {
 	struct erofs_sb_info *const sbi = EROFS_SB(be->sb);
 	struct z_erofs_pcluster *pcl = be->pcl;
 	unsigned int pclusterpages = z_erofs_pclusterpages(pcl);
 	const struct z_erofs_decompressor *decomp =
 				z_erofs_decomp[pcl->algorithmformat];
-	int i, j, jtop, err2;
+	bool try_free = true;
+	int i, j, jtop, err2, err = eio ? -EIO : 0;
 	struct page *page;
 	bool overlapped;
-	bool try_free = true;
 
 	mutex_lock(&pcl->lock);
 	be->nr_pages = PAGE_ALIGN(pcl->length + pcl->pageofs_out) >> PAGE_SHIFT;
@@ -1400,12 +1400,12 @@ static int z_erofs_decompress_queue(cons
 		.pcl = io->head,
 	};
 	struct z_erofs_pcluster *next;
-	int err = io->eio ? -EIO : 0;
+	int err = 0;
 
 	for (; be.pcl != Z_EROFS_PCLUSTER_TAIL; be.pcl = next) {
 		DBG_BUGON(!be.pcl);
 		next = READ_ONCE(be.pcl->next);
-		err = z_erofs_decompress_pcluster(&be, err) ?: err;
+		err = z_erofs_decompress_pcluster(&be, io->eio) ?: err;
 	}
 	return err;
 }


