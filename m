Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CBE434389F;
	Sat, 30 May 2026 17:30:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162230; cv=none; b=jxN8EnICFVh6Belo0Motwxukw0hUpZ9TgEEzwu7FG0QA9UiQvQ8oqbSEIntuyEPBRq11uSe+/6YAMonAkyxstCEf8r918M4NVZgZMRzJZRh29QocNDIXy773z9THVCPbDrMLBrSV12TA2zMbMUsyW8ItVeedK1E5kSrjzdkfRRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162230; c=relaxed/simple;
	bh=azm1CQf30HWxmEZntQe/z7S1HtA2aEo+ceB42OsOWRA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ef8x6wFCT9PE23A2gq+iWHYRhKNe4gArHMZFeqB6dDGDN22oFluJFsiwr1OAFUWbLDIpeubI1zHFDtx4iOsg2F0O7F0vHtzz7CXPEgbnr1FM1S/YRpHfKP3CXg8qHEdAJXN6lx62KPuHsd9EDBRKROwxGex3wBUJ9DcWMNAcqEw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=W6OcspnS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="W6OcspnS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 648C71F00898;
	Sat, 30 May 2026 17:30:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162229;
	bh=s09xkT7xhoNk3o8M8rkj4S7wHfS3BihnPZ2Ce3uyiuI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=W6OcspnSXNxe8CofkEN1/jdC2RZi3dbYcB2iN5I4HpVfYFcbhN/LLGgM/m+HVAoEF
	 YjRksO5E5fwIpGG9et3GJKtqQqS/h9J1i6orNLT48cvkyMMGLpgwcleOkX59vpqyzo
	 2WKrERpJk7mqo/HNviweUa/OSRcBL3V7hyJ+t0hU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>
Subject: [PATCH 6.1 830/969] io-wq: check that the predecessor is hashed in io_wq_remove_pending()
Date: Sat, 30 May 2026 18:05:54 +0200
Message-ID: <20260530160323.565337954@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicholas Carlini <nicholas@carlini.com>

io_wq_remove_pending() needs to fix up wq->hash_tail[] if the cancelled
work was the tail of its hash bucket. When doing this, it checks whether
the preceding entry in acct->work_list has the same hash value, but
never checks that the predecessor is hashed at all. io_get_work_hash()
is simply atomic_read(&work->flags) >> IO_WQ_HASH_SHIFT, and the hash
bits are never set for non-hashed work, so it returns 0. Thus, when a
hashed bucket-0 work is cancelled while a non-hashed work is its list
predecessor, the check spuriously passes and a pointer to the non-hashed
io_kiocb is stored in wq->hash_tail[0].

Because non-hashed work is dequeued via the fast path in
io_get_next_work(), which never touches hash_tail[], the stale pointer
is never cleared. Therefore, after the non-hashed io_kiocb completes and
is freed back to req_cachep, wq->hash_tail[0] is a dangling pointer. The
io_wq is per-task (tctx->io_wq) and survives ring open/close, so the
dangling pointer persists for the lifetime of the task; the next hashed
bucket-0 enqueue dereferences it in io_wq_insert_work() and
wq_list_add_after() writes through freed memory.

Add the missing io_wq_is_hashed() check so a non-hashed predecessor
never inherits a hash_tail[] slot.

Cc: stable@vger.kernel.org # 5.7+
Fixes: 204361a77f40 ("io-wq: fix hang after cancelling pending hashed work")
Signed-off-by: Nicholas Carlini <nicholas@carlini.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 io_uring/io-wq.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/io_uring/io-wq.c
+++ b/io_uring/io-wq.c
@@ -1034,7 +1034,8 @@ static inline void io_wqe_remove_pending
 	if (io_wq_is_hashed(work) && work == wqe->hash_tail[hash]) {
 		if (prev)
 			prev_work = container_of(prev, struct io_wq_work, list);
-		if (prev_work && io_get_work_hash(prev_work) == hash)
+		if (prev_work && io_wq_is_hashed(prev_work) &&
+		    io_get_work_hash(prev_work) == hash)
 			wqe->hash_tail[hash] = prev_work;
 		else
 			wqe->hash_tail[hash] = NULL;


