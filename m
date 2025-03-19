Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969E020297C;
	Wed, 19 Mar 2025 14:40:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395227; cv=none; b=rjdBq1dOYbpApY2tKRns/5exu+YQZ2xAh+Nq+aLgo0OZ9Pn0BD38t0QI3OyHeE82SSQnqFcS5tTSXSH30WJJq/d5cabtcpVnAz2olx//EVs+1AftItjUOLebZcDv6gukc9RZ51Fry6AOfPzTNP+WS5O5HEQsEeBmsgDGVGPx7fE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395227; c=relaxed/simple;
	bh=hr6vypmSLeG4EYuBmY9Ak8zRlGBiSBbVGHiyigrs5vs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJtEZnaLKy3ydv/sETptopeLBSlmMFqM/D3ssjsbtvWKvfZ/0QlqNgq4aE9k4IJF4SHLNyJgYCx4qZs0Q1Ai5Kc8L99q/fHP12nFvuVXWw2yyQOafQProoGiIvpjN5QcpsFIfpcn0KE/Vl1eViaXUDtOSx8CwYV6Hszvawp0cmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mcz9kag3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mcz9kag3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DA6CC4CEE4;
	Wed, 19 Mar 2025 14:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395227;
	bh=hr6vypmSLeG4EYuBmY9Ak8zRlGBiSBbVGHiyigrs5vs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mcz9kag3LBpSP7mCRy5zywXVWIT6ka+JCq7ftfP01liWrS1Q9p0Q1ULFDTA8vPMUb
	 ZeSSlY0vbrloz1h3fWK9anniEDpg7IlAnNLA3HHf9szDYMZRHPbqf6mQwPE5kMQ89J
	 UJEEfyzJxeFb/mZVbJbXpge1hucgrqDcMb2c/anM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 097/166] io_uring: fix corner case forgetting to vunmap
Date: Wed, 19 Mar 2025 07:31:08 -0700
Message-ID: <20250319143022.643571881@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2889,6 +2889,8 @@ static void *io_pages_map(struct page **
 	ret = io_mem_alloc_compound(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret))
 		goto done;
+	if (nr_pages == 1)
+		goto fail;
 
 	ret = io_mem_alloc_single(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret)) {
@@ -2897,7 +2899,7 @@ done:
 		*npages = nr_pages;
 		return ret;
 	}
-
+fail:
 	kvfree(pages);
 	*out_pages = NULL;
 	*npages = 0;


