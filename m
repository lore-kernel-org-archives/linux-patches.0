Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793210156;
	b=e5sRaeDraQClB8NQ2g74iqZsKoWAwje3E2S/aft4Eon7TyptHGI0K0xOhdSYylm+9Vog
	 gXnBN7EfQtMpMVJ7w6rczDl+cG1oVvYovqPWqbyd6ha0dT50NutLzcz3HSy4Nifqy+eo2
	 P91c4wqSGqxuxXTXMNyZtxtN6Z5KWEVYCj6jGa4HR5iMUvQB3/fqJMaXhPlrUJTiX0Hsn
	 VeARHisi5a/uUD17qNQ+e0Mseo/yPTl+8d0tY9xVcoeS3lcELmbiMtnKS1QvStlFuCmaJ
	 GrYYOQ5Wl4HdP/J4AbQkuLk2+jlZHd9wQbSv4vDVEkTHhOLrAjwGNMLDY8pVne9cuYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793210156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=HULWuEi9UX8hTDGeGOSvYV61yNUa8GUNWGG9Z+3T9XE=;
	b=DkQ3/zJpwSzZuUlAQ5Lp7zbR1kjeuEqEyNngEfDbYbilqcjuAve2QEXGWWyyB0i5ncuw
	 zTUzPTYXMmYg0bw0GHo4sOUTMtnZLESew8uOZ1iTjLanNHMf9bMUIQU7gng8rQJL7tszQ
	 n7C+U+mqHEoEFyG4y8JdBo1d0d+fnMNm5zygjgWK0bebcqSUXQ5e0AUR4lFqDb2de60gv
	 MNygZ6UceZcXC7yQ58tTYn50qWrjzSTOdd9270qIuu52SM6HTF0thPEQy/w3mhWU9GBfp
	 fXj+kERTdbwl4fLwWyWXqlxlu/ucHrJ+ZhicaMJaoHLewZIvvYpcjZKZapNBxMjTbiw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7tbxUnt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D44860A2624;
	Wed, 28 Oct 2026 17:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Y7tbxUnt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E14C1F031E6;
	Wed, 28 Oct 2026 17:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793210156;
	bh=HULWuEi9UX8hTDGeGOSvYV61yNUa8GUNWGG9Z+3T9XE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Y7tbxUntLVL1dapFI6krqaVgFnTUh9Ddmhf+nWRd0q/+MIjYhng+SXGAJGx/u9/UF
	 ZjTroKYL6licXqXUgjh3Emum5m7x5o6EnEcKayBCmy/0yhm+U1fS4sCRw4h34lzBe/
	 h61bp60/ieGnDsoIcmuG4wZco2DlqbQdCHtX/XHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	K Prateek Nayak <kprateek.nayak@amd.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 094/168] kernel/watch_queue: Use pipe_buf() to retrieve the pipe buffer
Date: Wed, 28 Oct 2026 18:00:30 +0100
Message-ID: <20261028165945.313454680@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165943.089486480@linuxfoundation.org>
References: <20261028165943.089486480@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: K Prateek Nayak <kprateek.nayak@amd.com>

[ Upstream commit 547476063e123e73fc3aea8432104ab092ffea84 ]

Use pipe_buf() helper to retrieve the pipe buffer in
post_one_notification() replacing the open-coded the logic.

Suggested-by: Oleg Nesterov <oleg@redhat.com>
Signed-off-by: K Prateek Nayak <kprateek.nayak@amd.com>
Link: https://lore.kernel.org/r/20250307052919.34542-3-kprateek.nayak@amd.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Stable-dep-of: 5e531d62f1f8 ("watch_queue: Fix note pool publication race in watch_queue_set_size()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/watch_queue.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/kernel/watch_queue.c b/kernel/watch_queue.c
index 17254597accd4..0840603c91e37 100644
--- a/kernel/watch_queue.c
+++ b/kernel/watch_queue.c
@@ -101,12 +101,11 @@ static bool post_one_notification(struct watch_queue *wqueue,
 	struct pipe_inode_info *pipe = wqueue->pipe;
 	struct pipe_buffer *buf;
 	struct page *page;
-	unsigned int head, tail, mask, note, offset, len;
+	unsigned int head, tail, note, offset, len;
 	bool done = false;
 
 	spin_lock_irq(&pipe->rd_wait.lock);
 
-	mask = pipe->ring_size - 1;
 	head = pipe->head;
 	tail = pipe->tail;
 	if (pipe_full(head, tail, pipe->ring_size))
@@ -124,7 +123,7 @@ static bool post_one_notification(struct watch_queue *wqueue,
 	memcpy(p + offset, n, len);
 	kunmap_atomic(p);
 
-	buf = &pipe->bufs[head & mask];
+	buf = pipe_buf(pipe, head);
 	buf->page = page;
 	buf->private = (unsigned long)wqueue;
 	buf->ops = &watch_queue_pipe_buf_ops;
@@ -147,7 +146,7 @@ static bool post_one_notification(struct watch_queue *wqueue,
 	return done;
 
 lost:
-	buf = &pipe->bufs[(head - 1) & mask];
+	buf = pipe_buf(pipe, head - 1);
 	buf->flags |= PIPE_BUF_FLAG_LOSS;
 	goto out;
 }
-- 
2.53.0



