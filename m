Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10091329E49;
	Mon, 29 Dec 2025 16:24:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025492; cv=none; b=YATZ7YOh9ZvnzjcQ2z3c1OAj5Ec1Gp5GLHOj+RE2zKGptdhvE/e637K4YEeCFiEuyioxw9BvhDHl6fE8honFELnkTC9z3MM67myUD3WIR6fqNOqGhauf5QyUAIJhQhjxZ5Ns6WEpGVVXzn8TxBdB6kYF3XgD2I0Owd6QPrOC24o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025492; c=relaxed/simple;
	bh=Q7RcDElNCkdQdoHDHk0MUifjBvfDYopT1skSTTMF9ck=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L2MEiinqNkQQ9F4Z+TT20shUnGQyJ4d+vj90ChI2IgskWAjE3y+hUzQhfiqXndm98lQhqWNEtw+GBWWA9sFsDLbBcctG2Q813DIemOM3cvYw7LhqcWRhEFxcMs+NRrkGe+jlIRAHIGyuivRz8BhrgKqI1pOQVUtD3oUaLAdTyc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=w2UhEx6W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="w2UhEx6W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8701BC4CEF7;
	Mon, 29 Dec 2025 16:24:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025491;
	bh=Q7RcDElNCkdQdoHDHk0MUifjBvfDYopT1skSTTMF9ck=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w2UhEx6WpGz4Y2RAhuTF80dYywbPPtAq0ZLbc0rS5e9Bu/F6L+8syzxdt1AE1qDnq
	 XK1EyVeuQvQ6XSKoYqxKOtFDeCNEmrTubYzg8uHjK81K+8OTwyECoOFEDNGYARLSLx
	 KP446tXBKTKXL6gOnYTVdD894NI9/ls6qV8eavYU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com,
	Prithvi Tambewagh <activprithvi@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 231/430] io_uring: fix filename leak in __io_openat_prep()
Date: Mon, 29 Dec 2025 17:10:33 +0100
Message-ID: <20251229160732.855330119@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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

From: Prithvi Tambewagh <activprithvi@gmail.com>

commit b14fad555302a2104948feaff70503b64c80ac01 upstream.

 __io_openat_prep() allocates a struct filename using getname(). However,
for the condition of the file being installed in the fixed file table as
well as having O_CLOEXEC flag set, the function returns early. At that
point, the request doesn't have REQ_F_NEED_CLEANUP flag set. Due to this,
the memory for the newly allocated struct filename is not cleaned up,
causing a memory leak.

Fix this by setting the REQ_F_NEED_CLEANUP for the request just after the
successful getname() call, so that when the request is torn down, the
filename will be cleaned up, along with other resources needing cleanup.

Reported-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=00e61c43eb5e4740438f
Tested-by: syzbot+00e61c43eb5e4740438f@syzkaller.appspotmail.com
Cc: stable@vger.kernel.org
Signed-off-by: Prithvi Tambewagh <activprithvi@gmail.com>
Fixes: b9445598d8c6 ("io_uring: openat directly into fixed fd table")
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/openclose.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/io_uring/openclose.c
+++ b/io_uring/openclose.c
@@ -73,13 +73,13 @@ static int __io_openat_prep(struct io_ki
 		open->filename = NULL;
 		return ret;
 	}
+	req->flags |= REQ_F_NEED_CLEANUP;
 
 	open->file_slot = READ_ONCE(sqe->file_index);
 	if (open->file_slot && (open->how.flags & O_CLOEXEC))
 		return -EINVAL;
 
 	open->nofile = rlimit(RLIMIT_NOFILE);
-	req->flags |= REQ_F_NEED_CLEANUP;
 	if (io_openat_force_async(open))
 		req->flags |= REQ_F_FORCE_ASYNC;
 	return 0;


