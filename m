Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794585351;
	b=Xf9f+SD2izQVtyi5EoEV6O50q3DzPvEQeQwwY8WRXOl1909wlDGonQjHCe/oPzNV99vW
	 b0Hq5qSXiFZdlCxzMHXDXCsYe92fIZYGicOlF/ckZ713mJXNezXgGznO5lLwfEr6bvlWL
	 FL8VXmFtQbhbFOksZWNJgp4kU6MAipJhroKs5PRHKGLSQtR7sHoPk7w6ELyjfBC87NP3C
	 vQs9MEbD/fpno6aBhUWw/TzDSqPcukcCK6s2CsisIVK7/jrjLjVinwt+5+TaZVYWBxY8s
	 CHpHVauUaOgQtI+Kh1Z/i8S1nhCpYlVMctMHtoePiueYCtqg6encTcrRWorWme3nccQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794585351;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AQBdoMlp6HhsrmSerSk0n5s2taouaNscTdohebkP/9Q=;
	b=C+LyDxmnBtbqDm3IkFHZf9WJ8d2m3GHCVzTsfsF94WVoOjxOoDpbjmO5d0hGSN/Vul+6
	 HGDx/a6pq8Gx44l4qZxlfS2VKsBL+HYXOSOrBB3KHjYHq8xzVPr3FFOhhZ6inACQEYlxn
	 l6/Cy7bTivb9VNLZWDwIeXbOVmh2CKVbFQK7ilQF4/jscJN2xE7jXhejZB6cGdquDAVs3
	 TElUFnccaGX7+CRVvqGM9zmixEMng7rA6c+zgh8a0nWoa/mCX8tDUCbtkB9aZznSErbnj
	 HpWk52mEoIxcvRs8erFBjsdYi8fssNRngwhQhyqHINc4SHSJy8WIdwbzSby6bucTiVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anPNJnzT;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D42A60A5BCC;
	Fri, 13 Nov 2026 15:55:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=anPNJnzT
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9B131F00933;
	Fri, 13 Nov 2026 15:55:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794585351;
	bh=AQBdoMlp6HhsrmSerSk0n5s2taouaNscTdohebkP/9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=anPNJnzTHW3Y5pLy6N+uN10T7Ujb9G81BIIkDnidTt20VGHfv2NfzYbyebseWsnMa
	 kIlkfpq6L7yKUlI/Ysrdx6J9i3beAsyCRXusABrmR+YZtpMm+9q+meCjMFBSvIFf4e
	 9FVdinGvrJ4QdaB1k4uKp1n/Wck9/xDpxGncSKTY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Morton <akpm@linux-foundation.org>,
	Haocheng Yu <l1za0.sec@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Tal Zussman <tz2294@columbia.edu>,
	Daehyeon Ko <4ncienth@gmail.com>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Hannes Reinecke <hare@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 032/507] block: restore the iterator when rejecting a misaligned bio
Date: Fri, 13 Nov 2026 10:45:36 -0500
Message-ID: <20261113153754.489549426@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153753.358973689@linuxfoundation.org>
References: <20261113153753.358973689@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrew Morton <akpm@linux-foundation.org>

commit 40d070cbb1906896d6fd65c39722d2411830ed9f upstream.

bio_iov_iter_get_pages() can extract some iovecs before encountering a
misaligned one.  It releases the pages and rejects the entire bio, but
leaves the supplied iterator advanced.

An iomap direct-I/O caller may subsequently reexpand the iterator's
byte count and fall back to buffered I/O.  The reexpanded count then
includes bytes before the iterator's current segment, potentially
causing iterate_iovec() to read beyond the imported iovec array.

In a reproducer using an initial empty iovec followed by 10-byte and
1015-byte segments, writev() returned 1015 instead of 1025 and KASAN
reported an 8-byte read beyond the nine-element iovec allocation.
Saving and restoring the iterator on the rejected-bio path makes
writev() return 1025 and eliminates the KASAN report.

Restore the entire iterator rather than reverting a byte count:
advancing past an empty segment changes its position without consuming
any bytes.

Leave successful and partially accepted bio paths unchanged.

[ Backport to 7.3.y: restore the iterator in the existing inline
  -EINVAL cleanup, as this tree lacks out_release_pages. ]

Fixes: 14b007e17881 ("block: validate user space vectors during extraction")
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Haocheng Yu <l1za0.sec@gmail.com>
Closes: https://lore.kernel.org/20261018081203.2431035-1-l1za0.sec@gmail.com
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Keith Busch <kbusch@kernel.org>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Tal Zussman <tz2294@columbia.edu>
Cc: Daehyeon Ko <4ncienth@gmail.com>
Cc: Al Viro <viro@zeniv.linux.org.uk>
Cc: Hannes Reinecke <hare@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20261020170250.014BD1F000C9@smtp.kernel.org
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Haocheng Yu <l1za0.sec@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/bio.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/block/bio.c b/block/bio.c
index f95b63c0604af..90104e6abbcf2 100644
--- a/block/bio.c
+++ b/block/bio.c
@@ -1285,6 +1285,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 			   unsigned mem_align_mask, unsigned len_align_mask)
 {
 	iov_iter_extraction_t flags = 0;
+	struct iov_iter saved_iter;
 
 	if (WARN_ON_ONCE(bio_flagged(bio, BIO_CLONED)))
 		return -EIO;
@@ -1303,6 +1304,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 	if (bio->bi_bdev && blk_queue_pci_p2pdma(bio->bi_bdev->bd_disk->queue))
 		flags |= ITER_ALLOW_P2PDMA;
 
+	saved_iter = *iter;
 	do {
 		ssize_t ret;
 
@@ -1320,6 +1322,7 @@ int bio_iov_iter_get_pages(struct bio *bio, struct iov_iter *iter,
 				bio_release_pages(bio, false);
 				bio_clear_flag(bio, BIO_PAGE_PINNED);
 				bio->bi_vcnt = 0;
+				*iter = saved_iter;
 			}
 			if (!bio->bi_vcnt)
 				return ret;
-- 
2.53.0



