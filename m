Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 195542EE99E;
	Thu,  3 Jul 2025 14:53:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554427; cv=none; b=L6Ifp6fOnSGlo08z6kgqJzBJrh9eWthU0B4TjzWSL8zyhS2qZVCHRk9ZkZt6LZNBUZWgLqvkP6DZhzflf80BPy+ifpXT61GSBM2giTTzTkcgqd1AW526sUt/mXj0tkHcbq7u4MUqF0DurmnLF/yyWf10DrqIEK/P5LZO3Omo/Pg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554427; c=relaxed/simple;
	bh=7YA0v9yF3uJP9tfCmuhe2gcxtkEyuLILk7ZOP7rELwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FetITPKL6TN5uzxOWcwq+9Rq682VuRgPj3+6ZWKXni6pjj6gj6zuFiBrgK5s+1VIHXPD6iOEkU1IBdh6K0WxBCUbBSlHMvtublcH9vNeJp+cAd3zDYfaE7fGJsWKQ1et5uLBONgmaW+USZvQhESXRNAGk5FCJZXMAsjaTethu6I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHmgAA4x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHmgAA4x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34731C4CEE3;
	Thu,  3 Jul 2025 14:53:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554424;
	bh=7YA0v9yF3uJP9tfCmuhe2gcxtkEyuLILk7ZOP7rELwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHmgAA4xq7aGUrbpA8fHUpzm3iU3D4i7emlxMkXz0r9F8PBlMRL71t8CEDbbRPp9P
	 U8PwXzpRh0Kgr/+qX1QMNnlzE+pHvCAsbtCpm8qdAaB2j9TXsuFEEaETg7mV1Q4lOM
	 lr962jfzcFX3tLvTdlt8cwH1KamOTr1EkQigMoXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 183/218] io_uring/rsrc: dont rely on user vaddr alignment
Date: Thu,  3 Jul 2025 16:42:11 +0200
Message-ID: <20250703144003.500771300@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

Commit 3a3c6d61577dbb23c09df3e21f6f9eda1ecd634b upstream.

There is no guaranteed alignment for user pointers, however the
calculation of an offset of the first page into a folio after coalescing
uses some weird bit mask logic, get rid of it.

Cc: stable@vger.kernel.org
Reported-by: David Hildenbrand <david@redhat.com>
Fixes: a8edbb424b139 ("io_uring/rsrc: enable multi-hugepage buffer coalescing")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/io-uring/e387b4c78b33f231105a601d84eefd8301f57954.1750771718.git.asml.silence@gmail.com/
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rsrc.c |    5 ++++-
 io_uring/rsrc.h |    1 +
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/io_uring/rsrc.c
+++ b/io_uring/rsrc.c
@@ -918,6 +918,7 @@ static bool io_try_coalesce_buffer(struc
 		return false;
 
 	data->folio_shift = folio_shift(folio);
+	data->first_folio_page_idx = folio_page_idx(folio, page_array[0]);
 	/*
 	 * Check if pages are contiguous inside a folio, and all folios have
 	 * the same page count except for the head and tail.
@@ -998,7 +999,9 @@ static int io_sqe_buffer_register(struct
 	if (coalesced)
 		imu->folio_shift = data.folio_shift;
 	refcount_set(&imu->refs, 1);
-	off = (unsigned long) iov->iov_base & ((1UL << imu->folio_shift) - 1);
+	off = (unsigned long)iov->iov_base & ~PAGE_MASK;
+	if (coalesced)
+		off += data.first_folio_page_idx << PAGE_SHIFT;
 	*pimu = imu;
 	ret = 0;
 
--- a/io_uring/rsrc.h
+++ b/io_uring/rsrc.h
@@ -56,6 +56,7 @@ struct io_imu_folio_data {
 	/* For non-head/tail folios, has to be fully included */
 	unsigned int	nr_pages_mid;
 	unsigned int	folio_shift;
+	unsigned long	first_folio_page_idx;
 };
 
 void io_rsrc_node_ref_zero(struct io_rsrc_node *node);


