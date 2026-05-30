Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3634223DC6;
	Sat, 30 May 2026 18:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780164811; cv=none; b=Wr8OHJ0z+e9H6z63CCytQQOgKJlLPJMBiXSnuhm/p/b5dKPxaEGYPQf8Tn6o0vlgcmIRB1B2WVYTOaNSQ4PRNmJlKf3ZsS0wXu3UACEJg26FegS1mZxgJIb2p8v1dLSPj5BCLrJvUP50F06kxOWF6UpKDrj+OVPiRrrEHoyFrgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780164811; c=relaxed/simple;
	bh=FmFFIQu0/9yUdygBi5NbwziSw6VzkQznwSHkSOgEImY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YrzmPtB/A5ZWWpkXmaqWtJtaCrABaa0ZXcnkVpEcFbYsDuzDbwV/2tFOW06RZgXUxzxjs7TkHnq20aFk/e/o4mViVU0kCZyKCNgIhJ634O5Dx0wy4w9cPyiVvB8elqHd+qH1kRI9QGHIN94xI4CHFm4g8gwzzRkC3HY4gDJMgjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gDgUmdHG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gDgUmdHG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 218F01F00893;
	Sat, 30 May 2026 18:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780164810;
	bh=TJ+rj6p9ONDa4NmXq2eWvel7Sdkc83vx0UHlcWh23Kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=gDgUmdHGboUS55RLwVfDHm8n4oz72v4XiciW6WhD4jZpRJ4QYgx+/BW/5qnQH6HF1
	 s2HGgLCmOL4ZPggih0l97arUJN5bugJsv5daMAMJ+ss/oe/3FEbqzumPDCBHYdw6My
	 7zMrDR82M7QczGL+JWCbSgM7jvp6zkgEZeAKmTH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <nicholas@carlini.com>
Subject: [PATCH 5.15 667/776] io-wq: check that the predecessor is hashed in io_wq_remove_pending()
Date: Sat, 30 May 2026 18:06:21 +0200
Message-ID: <20260530160257.122952551@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1014,7 +1014,8 @@ static inline void io_wqe_remove_pending
 	if (io_wq_is_hashed(work) && work == wqe->hash_tail[hash]) {
 		if (prev)
 			prev_work = container_of(prev, struct io_wq_work, list);
-		if (prev_work && io_get_work_hash(prev_work) == hash)
+		if (prev_work && io_wq_is_hashed(prev_work) &&
+		    io_get_work_hash(prev_work) == hash)
 			wqe->hash_tail[hash] = prev_work;
 		else
 			wqe->hash_tail[hash] = NULL;


