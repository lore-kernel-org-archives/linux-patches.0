Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9172240611;
	Tue, 29 Apr 2025 18:16:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745950614; cv=none; b=Z951ssSAJA/XW5J9KdEumcowXLwX2Mts1XzyXYmv+gYQBzQf9XsCHs5LYTWFMZpdYf7ILVfyih8Fzph4QKm+y3+zioGt84SrFrMt3p7lHhezdC1hdeCw25rInFAbBtp/B8DZDdeR7gyC8m2t8LOfrKPl0XW8RdXlYfXR8MbFcYA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745950614; c=relaxed/simple;
	bh=J5R48IU8fuxmOAx9EAoUzKk3CfgqSALa4vT8IrBgiis=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U6FcRvBHxTXV4smYWH9O+k+gO9mfTpBXsmCRIYTA0fRVYkKKnYug6qobulLDcDNlcOGvZjoeDYiPtY4NdyNSLqQL8Txqrx0whQw0eCuj/FOci0hn3yveteP19TWAQLlqdtygvXM52184AWn4L5ayV0Boe3vfhCPvr+nHyIHvU54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jjRIxBXv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jjRIxBXv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 542C9C4CEE3;
	Tue, 29 Apr 2025 18:16:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745950614;
	bh=J5R48IU8fuxmOAx9EAoUzKk3CfgqSALa4vT8IrBgiis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jjRIxBXvCpkLUGV6hrMXz89SN/eLQ+Kn5wTk10qZPXQuNVYMKnEfwy2XG6GSn/QCS
	 8B5t8wGzUqfhTTTybzQIJQVJLq5sLDIBH9eX4z3/hjlVUsKOM7H7ZSKoMzYLqyqcOg
	 70kCWi6RkFfpKKLiaPx7eRoKGX9s1VewHIZf5p4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+903a2ad71fb3f1e47cf5@syzkaller.appspotmail.com,
	Pavel Begunkov <asml.silence@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 151/204] io_uring: always do atomic put from iowq
Date: Tue, 29 Apr 2025 18:43:59 +0200
Message-ID: <20250429161105.598450712@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161059.396852607@linuxfoundation.org>
References: <20250429161059.396852607@linuxfoundation.org>
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

[ Upstream commit 390513642ee6763c7ada07f0a1470474986e6c1c ]

io_uring always switches requests to atomic refcounting for iowq
execution before there is any parallilism by setting REQ_F_REFCOUNT,
and the flag is not cleared until the request completes. That should be
fine as long as the compiler doesn't make up a non existing value for
the flags, however KCSAN still complains when the request owner changes
oter flag bits:

BUG: KCSAN: data-race in io_req_task_cancel / io_wq_free_work
...
read to 0xffff888117207448 of 8 bytes by task 3871 on cpu 0:
 req_ref_put_and_test io_uring/refs.h:22 [inline]

Skip REQ_F_REFCOUNT checks for iowq, we know it's set.

Reported-by: syzbot+903a2ad71fb3f1e47cf5@syzkaller.appspotmail.com
Signed-off-by: Pavel Begunkov <asml.silence@gmail.com>
Link: https://lore.kernel.org/r/d880bc27fb8c3209b54641be4ff6ac02b0e5789a.1743679736.git.asml.silence@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 io_uring/io_uring.c | 2 +-
 io_uring/refs.h     | 7 +++++++
 2 files changed, 8 insertions(+), 1 deletion(-)

diff --git a/io_uring/io_uring.c b/io_uring/io_uring.c
index 9883fd16cde44..3ce93418e0151 100644
--- a/io_uring/io_uring.c
+++ b/io_uring/io_uring.c
@@ -1917,7 +1917,7 @@ struct io_wq_work *io_wq_free_work(struct io_wq_work *work)
 	struct io_kiocb *req = container_of(work, struct io_kiocb, work);
 	struct io_kiocb *nxt = NULL;
 
-	if (req_ref_put_and_test(req)) {
+	if (req_ref_put_and_test_atomic(req)) {
 		if (req->flags & IO_REQ_LINK_FLAGS)
 			nxt = io_req_find_next(req);
 		io_free_req(req);
diff --git a/io_uring/refs.h b/io_uring/refs.h
index 1336de3f2a30a..21a379b0f22d6 100644
--- a/io_uring/refs.h
+++ b/io_uring/refs.h
@@ -17,6 +17,13 @@ static inline bool req_ref_inc_not_zero(struct io_kiocb *req)
 	return atomic_inc_not_zero(&req->refs);
 }
 
+static inline bool req_ref_put_and_test_atomic(struct io_kiocb *req)
+{
+	WARN_ON_ONCE(!(data_race(req->flags) & REQ_F_REFCOUNT));
+	WARN_ON_ONCE(req_ref_zero_or_close_to_overflow(req));
+	return atomic_dec_and_test(&req->refs);
+}
+
 static inline bool req_ref_put_and_test(struct io_kiocb *req)
 {
 	if (likely(!(req->flags & REQ_F_REFCOUNT)))
-- 
2.39.5



