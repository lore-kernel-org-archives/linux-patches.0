Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6895125745F;
	Tue, 25 Mar 2025 12:28:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742905684; cv=none; b=aPUw8v6TgSeH0GeRPllk7LmrmiPhj5CoDyzeNXUXjtlQ7tSRGswhnHhtQIxRhMl+50D/iS7oj6EqcBsXF2iO98UCaGsBlpaNDx7LqqkNhDUsY7wOxN7yUIiz5CXgLNChRo/H3qqStD6aqeoSqBydmBlY6FbIsohVm3mxibwc4U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742905684; c=relaxed/simple;
	bh=iJmD/jg+QmK6CecdCfuoakJlDVHekYDvLSzfSSyFLZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwpaTXtAbevZtWN9+0kr2eQg2lb9kflpgugR6TbC/Z6KhJUYIrDUeGBlikmPp+aZjxME3yRc7qn4ag2nR6eAETaJlPkXT2CBxwOTF6WPQwQkw9lrW1oP/0y4x4gEvMD7SQY8BCh2uYVnuM8OqCufLiGF9J7U9zEp73GC/OfZyZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1XV68m3i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1XV68m3i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C345C4CEE4;
	Tue, 25 Mar 2025 12:28:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742905684;
	bh=iJmD/jg+QmK6CecdCfuoakJlDVHekYDvLSzfSSyFLZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1XV68m3iNyb5yo8eREx/VpSlDZWdcohgXB6XVGXfJybfhKc4NCQCJAlYGLIs1w86e
	 aJL3zp8ODqYdPt+lQCZ5aUZRCjSDLxtKOka7h1diEeBQw+1m5jGQPVqleoBYtA16KS
	 V319Zr9SQx7He40jZrG/cdD7MC0NCkmtZXQFCjEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.1 077/198] io_uring: fix corner case forgetting to vunmap
Date: Tue, 25 Mar 2025 08:20:39 -0400
Message-ID: <20250325122158.657362595@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250325122156.633329074@linuxfoundation.org>
References: <20250325122156.633329074@linuxfoundation.org>
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

From: Pavel Begunkov <asml.silence@gmail.com>

Commit 43eef70e7e2ac74e7767731dd806720c7fb5e010 upstream.

io_pages_unmap() is a bit tricky in trying to figure whether the pages
were previously vmap'ed or not. In particular If there is juts one page
it belives there is no need to vunmap. Paired io_pages_map(), however,
could've failed io_mem_alloc_compound() and attempted to
io_mem_alloc_single(), which does vmap, and that leads to unpaired vmap.

The solution is to fail if io_mem_alloc_compound() can't allocate a
single page. That's the easiest way to deal with it, and those two
functions are getting removed soon, so no need to overcomplicate it.

Cc: stable@vger.kernel.org
Fixes: 3ab1db3c6039e ("io_uring: get rid of remap_pfn_range() for mapping rings/sqes")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/477e75a3907a2fe83249e49c0a92cd480b2c60e0.1732569842.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io_uring.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -2611,6 +2611,8 @@ static void *io_pages_map(struct page **
 	ret = io_mem_alloc_compound(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret))
 		goto done;
+	if (nr_pages == 1)
+		goto fail;
 
 	ret = io_mem_alloc_single(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret)) {
@@ -2619,7 +2621,7 @@ done:
 		*npages = nr_pages;
 		return ret;
 	}
-
+fail:
 	kvfree(pages);
 	*out_pages = NULL;
 	*npages = 0;


