Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91E9D1E9B18;
	Thu, 30 Jan 2025 14:19:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738246785; cv=none; b=Zxa/Utfem2hypWFQKPQcD9WcvX/WatiK1NlrVFCmS4LPXIf8JQoeThiptwbpWqOKJT7E2mYRhBRtSeeJCJ5gkjGDJOTJegDZvEkFgjaFrrsZQgxwbFUZQKIOGrXcgRVa4ba1cZIFijG7At24warLUl8kqqBsKaoiFfvY5FgnsBc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738246785; c=relaxed/simple;
	bh=Ua7HeK733dA2Nh5OZxzJaZz/sqAGRXzCVO+YovMV76g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q5Vw4wF4I42SSBluYp7mF1Cex88MhoZ5JENXORfI2H7/G1vGK2KGxNhRTnYmzucjJ8Bf4Ben8Xq52hbwj9Vu/MWCa0bBhtJ2Bbp2K/WPXwLhRlyUvsocoBYapxeAVcuR5u8Xeh+0TxGzYZomLRA9ku3itlRRj22rNQRma918Gmw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gxe5sUSx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gxe5sUSx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F44BC4CED2;
	Thu, 30 Jan 2025 14:19:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738246785;
	bh=Ua7HeK733dA2Nh5OZxzJaZz/sqAGRXzCVO+YovMV76g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gxe5sUSxS7idtfIeutK7BZwWxK2F9APkKK0DkFmG7vw8Y+Xzdx3q6aJUUuyEiEPvG
	 qOjZQCGTs4PU55bOPeiBhJ8F1LIg/1D2aIaD9OgL1cgINjK6iQ3wGJ5WljZXOBmYkH
	 dnemhr3LqxC8CEDMK93fiH127M98+HGGCJnuXiKc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleg Nesterov <oleg@redhat.com>,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 66/91] poll_wait: add mb() to fix theoretical race between waitqueue_active() and .poll()
Date: Thu, 30 Jan 2025 15:01:25 +0100
Message-ID: <20250130140136.329604530@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140133.662535583@linuxfoundation.org>
References: <20250130140133.662535583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Oleg Nesterov <oleg@redhat.com>

[ Upstream commit cacd9ae4bf801ff4125d8961bb9a3ba955e51680 ]

As the comment above waitqueue_active() explains, it can only be used
if both waker and waiter have mb()'s that pair with each other. However
__pollwait() is broken in this respect.

This is not pipe-specific, but let's look at pipe_poll() for example:

	poll_wait(...); // -> __pollwait() -> add_wait_queue()

	LOAD(pipe->head);
	LOAD(pipe->head);

In theory these LOAD()'s can leak into the critical section inside
add_wait_queue() and can happen before list_add(entry, wq_head), in this
case pipe_poll() can race with wakeup_pipe_readers/writers which do

	smp_mb();
	if (waitqueue_active(wq_head))
		wake_up_interruptible(wq_head);

There are more __pollwait()-like functions (grep init_poll_funcptr), and
it seems that at least ep_ptable_queue_proc() has the same problem, so the
patch adds smp_mb() into poll_wait().

Link: https://lore.kernel.org/all/20250102163320.GA17691@redhat.com/
Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20250107162717.GA18922@redhat.com
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/poll.h | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/include/linux/poll.h b/include/linux/poll.h
index 7e0fdcf905d2e..a4af5e14dffed 100644
--- a/include/linux/poll.h
+++ b/include/linux/poll.h
@@ -43,8 +43,16 @@ typedef struct poll_table_struct {
 
 static inline void poll_wait(struct file * filp, wait_queue_head_t * wait_address, poll_table *p)
 {
-	if (p && p->_qproc && wait_address)
+	if (p && p->_qproc && wait_address) {
 		p->_qproc(filp, wait_address, p);
+		/*
+		 * This memory barrier is paired in the wq_has_sleeper().
+		 * See the comment above prepare_to_wait(), we need to
+		 * ensure that subsequent tests in this thread can't be
+		 * reordered with __add_wait_queue() in _qproc() paths.
+		 */
+		smp_mb();
+	}
 }
 
 /*
-- 
2.39.5



