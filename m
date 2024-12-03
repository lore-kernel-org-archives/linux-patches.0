Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82E22646;
	Tue,  3 Dec 2024 15:27:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239666; cv=none; b=aVirKdzXCthoGhVnJ7zrP/+KjF7wuhc6T0ywXdYBgoP2CAegV2dCyh8afiIbV/nyexLueMNSRO3nC69CWhGiX05IPkULtcMPHfyM3XKzbpgiBjSr1NTny/7EdnoehxXYJ4h1U27BVTvBJjNP635LQxg02RCoiyAILkhyX7YrDc0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239666; c=relaxed/simple;
	bh=Rsf/fGHwKCbF79M7MOFEwvFAMKYZQEh2ien2sj4efYw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VhTyaSACuo1B1vdkD13gJAWC+HQlvM80EOeq5T+TkHBtyPnE/THq0S8M1udTHvBXHOuEMbGmH+H34s3JFnanBJO6vAyLC/foxJwwIekCap5bGjhencffb5FtkCjqadJVMjDlGTOrRJkeG3oIAHL0fC3cqWpL2OedQTnaKQYqi90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HuobRWIs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HuobRWIs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BC93C4CECF;
	Tue,  3 Dec 2024 15:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239666;
	bh=Rsf/fGHwKCbF79M7MOFEwvFAMKYZQEh2ien2sj4efYw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HuobRWIsHwSNkrG1utLJuQx5YrMKjfyJJ8FOqfQvRzUOO/z6neJBS6Qdr+Jfa1Z8F
	 pX3DEFMx71ydWV4tIucG8PAyjmglWrZCZBJMh/QRPJ/xkj7XbM9cVNDf1+lcyfLMhe
	 YO7Wy6txcdbxyAjYN30a0s3PIZABBcftmw41yRD4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.11 693/817] io_uring: fix corner case forgetting to vunmap
Date: Tue,  3 Dec 2024 15:44:25 +0100
Message-ID: <20241203144023.027006556@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pavel Begunkov <asml.silence@gmail.com>

commit 43eef70e7e2ac74e7767731dd806720c7fb5e010 upstream.

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
 io_uring/memmap.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/io_uring/memmap.c
+++ b/io_uring/memmap.c
@@ -72,6 +72,8 @@ void *io_pages_map(struct page ***out_pa
 	ret = io_mem_alloc_compound(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret))
 		goto done;
+	if (nr_pages == 1)
+		goto fail;
 
 	ret = io_mem_alloc_single(pages, nr_pages, size, gfp);
 	if (!IS_ERR(ret)) {
@@ -80,7 +82,7 @@ done:
 		*npages = nr_pages;
 		return ret;
 	}
-
+fail:
 	kvfree(pages);
 	*out_pages = NULL;
 	*npages = 0;


