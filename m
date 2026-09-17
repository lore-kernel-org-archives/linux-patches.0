Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 523084ED1A4;
	Thu, 17 Sep 2026 15:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659987; cv=none; b=Vmo/MetPHTHEqx/TOngA6wt8jNSkC86d5KaZZxCU8qETtzP1c0xFZpxI+O0Rz/k41MP9oOgmJiutTg8Rc2Xfu1hsP0FDGNr3vAGANP2jcrXDfXhBpxKIMg+Mg/H1K8tl74FgdQ3Csc+Pfk78+0ift4gJe7UNacBOYfTithWGG1c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659987; c=relaxed/simple;
	bh=TlIOXvOeBYi241uZ3FR4xNLwkx9VkYqy76Kn/75YzNk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kJvS3TQZhfQBtggS3AEzF9mHrHnlnq0Ffbm3KgAhhmC0ZkskpF9+//r29VlTCUGxg8ZmtKmCkQw6zHRuNxG+1H9fB/mOTpacLQixyVdtXii1wN+zdEyF94/Z95tfW/mtQ0iJbzJa9/OflEH8+4QlRUXhgJV6Uxt4lG9RVGic7dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A2/BDOjR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A2/BDOjR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A00B91F00893;
	Thu, 17 Sep 2026 15:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659979;
	bh=MMryOJEP0FNVep7uD0La6r9QjRwt7DCXOLk3GhLMRYY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=A2/BDOjR6bdFZOuKEXhBr21uciD2aytlaKTSa8dCNi8qpa8hid5LMNZy1P1jbJ9Gx
	 ivOFAV8sIbjGRRJ5DAmng2pPTVsMHbutmOC92TJalM2sUdaJ/UcwU4Aiu7T4asFwX9
	 xyS9OPsecFuT6XPMsqxHFwhmfRR5U6B5ZpCuWhrM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@infradead.org>,
	Jens Axboe <axboe@kernel.dk>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-block@vger.kernel.org,
	linux-fsdevel@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 438/733] block: Fix start and length check added to iov_iter_extract_bvecs()
Date: Thu, 17 Sep 2026 16:12:26 +0100
Message-ID: <20260917151402.772497217@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit b0d8d56b7c93ed767eb4f2be9988e7b9dc023566 ]

Commit 14b007e17881 added an address check using iter_iov_addr() and a
length check using iter_iov_len() to iov_iter_extract_bvecs(), but these
cannot be used so and are unsafe in this circumstance as the functions have
hardwired assumptions about the iterator type.  They should only be used
with ITER_UBUF or ITER_IOVEC-type iterators; they shouldn't be used with
ITER_BVEC, ITER_KVEC, ITER_FOLIOQ, ITER_XARRAY or ITER_DISCARD iterators.

This proves to be a problem for cachefiles as an iterator of type
ITER_FOLIOQ is passed and iter_iov_addr() and iter_iov_len() both
malfunction because iter->__iov in iter_iov() is not pointing to an iovec
array.

Fix this by using iov_iter_alignment() instead.

Fixes: 14b007e17881 ("block: validate user space vectors during extraction")
Signed-off-by: David Howells <dhowells@redhat.com>
Reviewed-by: Keith Busch <kbusch@kernel.org>
cc: Hannes Reinecke <hare@kernel.org>
cc: Christoph Hellwig <hch@infradead.org>
cc: Jens Axboe <axboe@kernel.dk>
cc: Alexander Viro <viro@zeniv.linux.org.uk>
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-block@vger.kernel.org
cc: linux-fsdevel@vger.kernel.org
Reviewed-by: Christoph Hellwig <hch@lst.de>
Link: https://patch.msgid.link/1667275.1788941191@warthog.procyon.org.uk
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 lib/iov_iter.c | 18 ++++++++++++++++--
 1 file changed, 16 insertions(+), 2 deletions(-)

diff --git a/lib/iov_iter.c b/lib/iov_iter.c
index 34a52e9ba9e1b..5238731910917 100644
--- a/lib/iov_iter.c
+++ b/lib/iov_iter.c
@@ -1920,15 +1920,29 @@ ssize_t iov_iter_extract_bvecs(struct iov_iter *iter, struct bio_vec *bv,
 		unsigned short max_vecs, unsigned mem_align_mask,
 		iov_iter_extraction_t extraction_flags)
 {
-	unsigned long start = (unsigned long)iter_iov_addr(iter);
 	unsigned short entries_left = max_vecs - *nr_vecs;
 	unsigned short nr_pages, i = 0;
 	size_t left, offset, len;
 	struct page **pages;
 	ssize_t size;
 
-	if ((start | iter_iov_len(iter)) & mem_align_mask)
+	/*
+	 * DMA engines typically have both memory address and length alignment
+	 * requirements, so check these against the alignment mask.  For UBUF,
+	 * IOVEC and KVEC, only the current segment will be extracted from; for
+	 * everything else we might extract from multiple segments, so we need
+	 * to check those too.
+	 */
+	if (likely(iter_is_ubuf(iter) ||
+		   iter_is_iovec(iter) ||
+		   iov_iter_is_kvec(iter))) {
+		unsigned long start = (unsigned long)iter_iov_addr(iter);
+
+		if ((start | iter_iov_len(iter)) & mem_align_mask)
+			return -EINVAL;
+	} else if (iov_iter_alignment(iter) & mem_align_mask) {
 		return -EINVAL;
+	}
 
 	/*
 	 * Move page array up in the allocated memory for the bio vecs as far as
-- 
2.53.0



