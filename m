Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C64514F55D3;
	Thu, 17 Sep 2026 15:42:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659735; cv=none; b=QNFywCWmWHuVuALVLK5J3i3yX5NW58U9IhekrYOOCmfyR8nrUQptk2tSfTpsublyG7QYM3juzfB5gbByQg6TT7rC0WjZ6/9B6hUVxlnjcHdstLk9Sh8u2r7DEqdl99jDhgrSqhXQXPnguySupvkEMkPqErPUbfzJm71lheC/H+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659735; c=relaxed/simple;
	bh=Ro7T9vfF6RXOj4ZV6f8V0Al+aisdB/4+pZdrW0UlViE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U8hvgjDAm3ap9vxIqew15Oi5L8aRV4/vdEyte9OIKKHiyPfXkvrM710AsxGRW7BTwY8MrkB4r4HisHYrBHKPWJe662t9g20lQf9222D96Co1Fh0pTCGNYWqBKJObO6K51XDW1oixvrCd5Kg710J1eXTZE3ICl0FgJaRbNlp9weE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RQhHEW4H; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RQhHEW4H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8722E1F0089A;
	Thu, 17 Sep 2026 15:42:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659729;
	bh=mGno5CnBAiZZPOHnbiRWHSvF+1/7oSfkrzTSEcKE+ng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RQhHEW4H/Hbk9FqLhF5umKzgPZjLPWISB0C+N/+4KaLo3WV7jMHcwAgWb+58N95R3
	 OR1FaQywSJqloeACSIOYJEMXcc3NZxn62fQPl+RMQl2fv1HNsth3kPKkbYuW21CmFe
	 KwpGC4h60rQ3i/m5X36gTmlD4RurFuuEHkxkgzJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 354/733] af_unix: Update last skb marker in manage_oob().
Date: Thu, 17 Sep 2026 16:11:02 +0100
Message-ID: <20260917151400.405303455@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 94fd4debd2e3a69cf93e766c8b328a810c228119 ]

Fahad Alharbi reported that blocking recv(MSG_PEEK) could hog CPU
due to OOB skb.

In the following cases, manage_oob() skips OOB skb(s) and returns
NULL for the last recv(MSG_PEEK):

  socketpair(AF_UNIX, SOCK_STREAM, 0, sk);

  1) skb -> OOB skb -> NULL
     send(sk[0], "ab", 2, MSG_OOB);
     recv(sk[1], buf, 0, MSG_PEEK);

  2) skb -> consumed OOB skb -> NULL
     send(sk[0], "ab", 2, MSG_OOB);
     recv(sk[1], buf, 1, MSG_OOB);
     recv(sk[1], buf, 0, MSG_PEEK);

  3) consumed OOB skb -> OOB skb -> NULL
     send(sk[0], "a", 1, MSG_OOB);
     recv(sk[1], buf, 0, MSG_OOB);
     send(sk[0], "b", 1, MSG_OOB);
     recv(sk[1], buf, 1, MSG_PEEK);

Then, @copied is 0 in unix_stream_read_generic() (zero-length buffer,
or non-OOB skb is not yet consumed), and unix_stream_data_wait() is
called.

However, it returns immediately because @last is not updated in
unix_stream_read_generic(), and the thread busy-waits for a new skb.

Let's update @last in manage_oob().

For MSG_PEEK, @last is updated with the skipped OOB, and for the
non-peek case, @last matches the returned value (when !copied)
because OOB is unlinked.

Note that manage_oob() is inlined and no stack canary is added.

Fixes: 22dd70eb2c3d ("af_unix: Don't peek OOB data without MSG_OOB.")
Reported-by: Fahad Alharbi <fahad@codepure.com>
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Link: https://patch.msgid.link/20260902202202.892676-2-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 10ed9421e43aa..4eb086992ae5e 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2805,8 +2805,8 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 	return 1;
 }
 
-static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
-				  int flags, int copied)
+static struct sk_buff *manage_oob(struct sk_buff *skb, struct sk_buff **last,
+				  struct sock *sk, int flags, int copied)
 {
 	struct sk_buff *read_skb = NULL, *unread_skb = NULL;
 	struct unix_sock *u = unix_sk(sk);
@@ -2820,11 +2820,13 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 		if (copied && (!u->oob_skb || skb == u->oob_skb)) {
 			skb = NULL;
 		} else if (flags & MSG_PEEK) {
+			*last = skb;
 			skb = skb_peek_next(skb, &sk->sk_receive_queue);
 		} else {
 			read_skb = skb;
 			skb = skb_peek_next(skb, &sk->sk_receive_queue);
 			__skb_unlink(read_skb, &sk->sk_receive_queue);
+			*last = skb;
 		}
 
 		if (!skb)
@@ -2843,8 +2845,10 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 			__skb_unlink(skb, &sk->sk_receive_queue);
 			unread_skb = skb;
 			skb = skb_peek(&sk->sk_receive_queue);
+			*last = skb;
 		}
 	} else if (!sock_flag(sk, SOCK_URGINLINE)) {
+		*last = skb;
 		skb = skb_peek_next(skb, &sk->sk_receive_queue);
 	}
 
@@ -2964,7 +2968,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
 again:
 #if IS_ENABLED(CONFIG_AF_UNIX_OOB)
 		if (skb) {
-			skb = manage_oob(skb, sk, flags, copied);
+			skb = manage_oob(skb, &last, sk, flags, copied);
 			if (!skb && copied) {
 				unix_state_unlock(sk);
 				break;
-- 
2.53.0



