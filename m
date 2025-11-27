Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA90228135D;
	Thu, 27 Nov 2025 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764255816; cv=none; b=EvNnfs6msykMUai/M5g2A3K43NspZlem+1wBltMQ/WBZ8THyCnN89eOnEYEDRq/i3jpUSYSllRbBsBgrz0VUF7Z7uKBacnzVUNJHwzM1voI5qzYf3BXZFM83WS7+C3WksxVFO9YezCGjVdc9t50IeRu2l6mq0aBthklHXGseelA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764255816; c=relaxed/simple;
	bh=rkmp1dhQJGGR8jWtdL3vS8dezmcF7v+RIfilvy2kTK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HdrrYTQ3MPwMv/NLPpUh4Ysl3O0C6RkfHg4bhFXMYOtBx14QdhmL1ps7Ena8QIPDdqchZEoh1rrD2gJT6cUDwmImIErq6rOwjnLAxZH3TCqII9nZUbngy3BH5Jz5UfI3wImOCoAHWWgPn2f83Sjrqf5ZJ62oTlpvT30ApiuwcfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QWz3c2fk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QWz3c2fk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21C4FC4CEF8;
	Thu, 27 Nov 2025 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764255816;
	bh=rkmp1dhQJGGR8jWtdL3vS8dezmcF7v+RIfilvy2kTK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QWz3c2fkreMmJDgSeYNbOJiXsY0d3kGx8J58x+TbFyELAtnICyDoHMNECkJkeUTKF
	 n7Quj/G2f6ERI0J97NpqNV76h1D8Ps6ZnZ0q06CJubU3rdm6vxi3Sq81VSfcKy3pti
	 PxCmGYDYBVCNwfLo1XuZAW4hRpjk+81NVJb/LiQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miao Wang <shankerwangmiao@gmail.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 124/175] af_unix: Read sk_peek_offset() again after sleeping in unix_stream_read_generic().
Date: Thu, 27 Nov 2025 15:46:17 +0100
Message-ID: <20251127144047.488583287@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251127144042.945669935@linuxfoundation.org>
References: <20251127144042.945669935@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 7bf3a476ce43833c49fceddbe94ff3472e04e9bc ]

Miao Wang reported a bug of SO_PEEK_OFF on AF_UNIX SOCK_STREAM
socket.

The unexpected behaviour is triggered when the peek offset is
larger than the recv queue and the thread is unblocked by new
data.

Let's assume a socket which has "aaaa" in the recv queue and
the peek offset is 4.

First, unix_stream_read_generic() reads the offset 4 and skips
the skb(s) of "aaaa" with the code below:

	skip = max(sk_peek_offset(sk, flags), 0);	/* @skip is 4. */

	do {
	...
		while (skip >= unix_skb_len(skb)) {
			skip -= unix_skb_len(skb);
		...
			skb = skb_peek_next(skb, &sk->sk_receive_queue);
			if (!skb)
				goto again;		/* @skip is 0. */
		}

The thread jumps to the 'again' label and goes to sleep since
new data has not arrived yet.

Later, new data "bbbb" unblocks the thread, and the thread jumps
to the 'redo:' label to restart the entire process from the first
skb in the recv queue.

	do {
		...
redo:
		...
		last = skb = skb_peek(&sk->sk_receive_queue);
		...
again:
		if (skb == NULL) {
			...
			timeo = unix_stream_data_wait(sk, timeo, last,
						      last_len, freezable);
			...
			goto redo;			/* @skip is 0 !! */

However, the peek offset is not reset in the path.

If the buffer size is 8, recv() will return "aaaabbbb" without
skipping any data, and the final offset will be 12 (the original
offset 4 + peeked skbs' length 8).

After sleeping in unix_stream_read_generic(), we have to fetch the
peek offset again.

Let's move the redo label before mutex_lock(&u->iolock).

Fixes: 9f389e35674f ("af_unix: return data from multiple SKBs on recv() with MSG_PEEK flag")
Reported-by: Miao Wang <shankerwangmiao@gmail.com>
Closes: https://lore.kernel.org/netdev/3B969F90-F51F-4B9D-AB1A-994D9A54D460@gmail.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20251117174740.3684604-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 6d7c110814ffa..0f288a80e0acd 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2954,6 +2954,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 
 	u = unix_sk(sk);
 
+redo:
 	/* Lock the socket to prevent queue disordering
 	 * while sleeps in memcpy_tomsg
 	 */
@@ -2965,7 +2966,6 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 		struct sk_buff *skb, *last;
 		int chunk;
 
-redo:
 		unix_state_lock(sk);
 		if (sock_flag(sk, SOCK_DEAD)) {
 			err = -ECONNRESET;
@@ -3015,7 +3015,6 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 				goto out;
 			}
 
-			mutex_lock(&u->iolock);
 			goto redo;
 unlock:
 			unix_state_unlock(sk);
-- 
2.51.0



