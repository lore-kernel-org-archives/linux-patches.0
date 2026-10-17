Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E33B3909BC;
	Sat, 17 Oct 2026 18:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260657; cv=none; b=MTAuTS5p1kLRSVIOjrr9CGzEtlCPHG/Zc826VvhO8OJvtQOkD4ZX17FugTg8mMy6YLKBPe9iHwBhLtp1UCfUbdE8mSLaj81tlUAfhPdLszzZiMLjr+gHKYCwhVbV1Cn7ZHnWLrBCkAAXN69WPjpCT9suK3qdsIA5Rhg/Tasxm9Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260657; c=relaxed/simple;
	bh=ZFFnd/OJ1GOjx0qyDCtfRngMgnItPND/OG2ZlGaDp8s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VSo5CJbXJK1ObU6rSzKBsgyTQq+2rJ9RmykB+78aHc2i0m1zC2c3KexwjjEK6+cUAuFjPfBc1Bo1VOk99uCswJLT7OrLfgmgYSC8xQhxAa+abM3lcbpPeJMUOnpDS+FeiPlkRFQdyLchE6zSH1Gs6Oi4DvItg8zqITMor9EQnVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lrC8t2k2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lrC8t2k2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69F6C1F000C4;
	Sat, 17 Oct 2026 18:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260656;
	bh=O12roAVWfkFwix3o902yZu1apNe6HkU1pt6BCg598HM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lrC8t2k2A1mmET7uE8NzgqNG0RkQCzTRnE9XqV1wbuHJGRwiwN45Ufs+Sy9nPu4Hy
	 Y6bDd1ZVnE/1oNn2wNCrCGU/b/uKBCN9lLejxxeKmTWAPDxxsnOxMpSGULy3kA/pbm
	 SfK671hB3IA3xi2f+sTLUeGjny5D4AUKwjP5ac/Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fahad Alharbi <fahad@codepure.com>,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1616/1674] af_unix: Update last skb marker in manage_oob().
Date: Sat, 17 Oct 2026 18:04:48 +0200
Message-ID: <20261017160512.566084459@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
 net/unix/af_unix.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index e1f798af1a8af..8aa73ccdf67ae 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2641,8 +2641,8 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 	return 1;
 }
 
-static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
-				  int flags, int copied)
+static struct sk_buff *manage_oob(struct sk_buff *skb, struct sk_buff **last,
+				  struct sock *sk, int flags, int copied)
 {
 	struct unix_sock *u = unix_sk(sk);
 
@@ -2665,8 +2665,10 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 					__skb_unlink(skb, &sk->sk_receive_queue);
 					unlinked_skb = skb;
 					skb = skb_peek(&sk->sk_receive_queue);
+					*last = skb;
 				}
 			} else if (!sock_flag(sk, SOCK_URGINLINE)) {
+				*last = skb;
 				skb = skb_peek_next(skb, &sk->sk_receive_queue);
 			}
 		}
@@ -2792,7 +2794,7 @@ static int unix_stream_read_generic(struct unix_stream_read_state *state,
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



