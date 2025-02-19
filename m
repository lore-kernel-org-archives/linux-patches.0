Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E04B1B415A;
	Wed, 19 Feb 2025 09:26:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739957218; cv=none; b=DuHfQXinxnVCaPGUiBmmQ2X7NQtMr2x0g05slyGCjLzxsssa5ISU2wAcWc0DX30drJdmFPAL6IoyGb5P5gkS8joJPpomXZDTPio65aUQru6+iziXiHnDzya5gNuDsmtBXQlBb+20uFcbkKJk9/KtZd005WpTFkcMl7cDOZhJIL4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739957218; c=relaxed/simple;
	bh=bKrFTuoRmZVkgtGKFCmnqi5222hgGyZj222XUBMBtuc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnGQKqymFbxkYMwZEk5+QXxyV8LJRTdeLIpbt2jMf8vZ9AcUqNYMMUuO3dSmPp2DNL+GFSyZUNa9bdqPl/Svoxa1oulXJ6xVfoqAMM9LErE3s0ZaBdYWbAO94bR6OBn32cU5reX1ReEaWXbumx9qx6m0uKWq8a3mXuzu5ab8fTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFoQuVu7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFoQuVu7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C9EBDC4CED1;
	Wed, 19 Feb 2025 09:26:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739957218;
	bh=bKrFTuoRmZVkgtGKFCmnqi5222hgGyZj222XUBMBtuc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFoQuVu7YwCp8ZlQlG8FYEyztxbDvn+n1mi7XWjedItdGXhss9FyRXa7nNluJAi0n
	 YBi4F1ZTYiBujMbXC1NUzAOPQRq26uReBEw+RGMCqQaW7wgGUCWdB4pbBlrdJUPwhj
	 Pzq8C2QzJjfKNGI3UyRpRAkXqDTgZE8qGulaHhHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Muhammad Ramdhan <ramdhan@starlabs.sg>,
	Bing-Jhong Billy Jheng <billy@starlabs.sg>,
	Jacob Soo <jacob.soo@starlabs.sg>,
	Pavel Begunkov <asml.silence@gmail.com>
Subject: [PATCH 6.1 448/578] io_uring/rw: commit provided buffer state on async
Date: Wed, 19 Feb 2025 09:27:32 +0100
Message-ID: <20250219082710.620057185@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
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

When we get -EIOCBQUEUED, we need to ensure that the buffer is consumed
from the provided buffer ring, which can be done with io_kbuf_recycle()
+ REQ_F_PARTIAL_IO.

Reported-by: Muhammad Ramdhan <ramdhan@starlabs.sg>
Reported-by: Bing-Jhong Billy Jheng <billy@starlabs.sg>
Reported-by: Jacob Soo <jacob.soo@starlabs.sg>
Fixes: c7fb19428d67d ("io_uring: add support for ring mapped supplied buffers")
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/rw.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/io_uring/rw.c
+++ b/io_uring/rw.c
@@ -772,6 +772,8 @@ static int __io_read(struct io_kiocb *re
 			goto done;
 		ret = 0;
 	} else if (ret == -EIOCBQUEUED) {
+		req->flags |= REQ_F_PARTIAL_IO;
+		io_kbuf_recycle(req, issue_flags);
 		if (iovec)
 			kfree(iovec);
 		return IOU_ISSUE_SKIP_COMPLETE;
@@ -795,6 +797,9 @@ static int __io_read(struct io_kiocb *re
 		goto done;
 	}
 
+	req->flags |= REQ_F_PARTIAL_IO;
+	io_kbuf_recycle(req, issue_flags);
+
 	io = req->async_data;
 	s = &io->s;
 	/*
@@ -935,6 +940,11 @@ int io_write(struct io_kiocb *req, unsig
 	else
 		ret2 = -EINVAL;
 
+	if (ret2 == -EIOCBQUEUED) {
+		req->flags |= REQ_F_PARTIAL_IO;
+		io_kbuf_recycle(req, issue_flags);
+	}
+
 	if (req->flags & REQ_F_REISSUE) {
 		req->flags &= ~REQ_F_REISSUE;
 		ret2 = -EAGAIN;


