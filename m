Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36B9255F2C;
	Tue, 17 Mar 2026 17:24:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773768240; cv=none; b=Qy1f072FYKKQTP0h50BBiEmvkgG68K52820p+V4EGNXmntaAyYA+ZNbkysyTMavFKEtCnR/VzYbmjx3C7Xlm2asNBvEENwLlWTM0XssDruvr/o0nY6C95I3cElF1biQqJ8/9aRnrDkuOMQWsVDBChDz0nVtWV1Nh227sx6/OfsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773768240; c=relaxed/simple;
	bh=rCQo9IxDQqx9KjYn3mhqYfUZDNg46er1KXAgZ7OpIZg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q9WaEgw9kCy3UJWnn4Yf/04UyujqHBfnyOlBPRbYSIL82p4liL+NqiFgJQ2+zlFhEJEohXhzwwAtVmuTJ0Lr5/uICkYaah0aR5tTkztVIN25GsYRSz71/R+/ov+58ZqTQAaOKB6yLXUBo/3l2cYSKQbgaEM6Z5QVLwigPZzvTDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kA1dHjUs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kA1dHjUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 357BBC2BCAF;
	Tue, 17 Mar 2026 17:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773768240;
	bh=rCQo9IxDQqx9KjYn3mhqYfUZDNg46er1KXAgZ7OpIZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kA1dHjUsjjE2dPdFcP2woz5MhcWsbW0I0zBjG0Ff7tMeurLVwqgqVKAijyMPzd90S
	 fITYLHnGpuXaFjZIB6pNMfL1DQ4uqF+eCOS7gmdK51+VzDZOTejlZBz8yBy7jopnEN
	 3NjFxuqtH6wJHVbpt0SYxmzlLhtvDfbDpWerORT4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Keenan Dong <keenanat2000@gmail.com>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.18 265/333] io_uring/kbuf: check if target buffer list is still legacy on recycle
Date: Tue, 17 Mar 2026 17:34:54 +0100
Message-ID: <20260317163009.196640874@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Jens Axboe <axboe@kernel.dk>

commit c2c185be5c85d37215397c8e8781abf0a69bec1f upstream.

There's a gap between when the buffer was grabbed and when it
potentially gets recycled, where if the list is empty, someone could've
upgraded it to a ring provided type. This can happen if the request
is forced via io-wq. The legacy recycling is missing checking if the
buffer_list still exists, and if it's of the correct type. Add those
checks.

Cc: stable@vger.kernel.org
Fixes: c7fb19428d67 ("io_uring: add support for ring mapped supplied buffers")
Reported-by: Keenan Dong <keenanat2000@gmail.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/kbuf.c |   13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

--- a/io_uring/kbuf.c
+++ b/io_uring/kbuf.c
@@ -111,9 +111,18 @@ bool io_kbuf_recycle_legacy(struct io_ki
 
 	buf = req->kbuf;
 	bl = io_buffer_get_list(ctx, buf->bgid);
-	list_add(&buf->list, &bl->buf_list);
-	bl->nbufs++;
+	/*
+	 * If the buffer list was upgraded to a ring-based one, or removed,
+	 * while the request was in-flight in io-wq, drop it.
+	 */
+	if (bl && !(bl->flags & IOBL_BUF_RING)) {
+		list_add(&buf->list, &bl->buf_list);
+		bl->nbufs++;
+	} else {
+		kfree(buf);
+	}
 	req->flags &= ~REQ_F_BUFFER_SELECTED;
+	req->kbuf = NULL;
 
 	io_ring_submit_unlock(ctx, issue_flags);
 	return true;


