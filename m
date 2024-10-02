Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D6431CF28B;
	Wed,  2 Oct 2024 13:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875420; cv=none; b=YSPxNcZ17exq5J/ZuU6ORtE+ZXW0eTbf62SqWQxpKc7DWG4PBJKBD6Zv9IwbVLWa5NKpGgv/NtYR7vPAzu/bTaG6hdXmzqtLXVH3I/0vQkf+6KEhiBJHd4rlNhu5gcR2L2/Qi7QJ6Erb0jjAaG/s0qWHgcx6O59QacHLIdTK/pk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875420; c=relaxed/simple;
	bh=uMmRUYFuuPtFB1UEmtjbSuj/GR61s7n+3PDf9eEzbww=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJS/1iFKkvSq96SOTbPZzJV5tDKvLjDLk1K9PEw1FEW7KkXw5JfQSYL5B7EiFJX8UnhJCrwWfIo3/wLhIVLX+N+b+cnbp+nVKRZhO+/aljlUXDc1mo7gWNL9JdheLggp1jLPz0mnv/8NJFKub8SNPzOFOnEaQzX68bP68h1dbu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tp37hABc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tp37hABc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D856C4CEC5;
	Wed,  2 Oct 2024 13:23:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875420;
	bh=uMmRUYFuuPtFB1UEmtjbSuj/GR61s7n+3PDf9eEzbww=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tp37hABcFPnyMSfeetFInYJKpNHyFzr/xF0SmlyMGJtHYytTiO8ZZaVEKK2PCOI32
	 cRMsjtcCYEQJYptLMW7XW5TOPCDNeMyLtMPjNLNnGX76kLAOROvb2WHVtIJFSsR4LG
	 t3cssZkFtB4Hvv0uoRhxIjRZLV2RdfWcayEX5ysU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 096/695] af_unix: Remove single nest in manage_oob().
Date: Wed,  2 Oct 2024 14:51:34 +0200
Message-ID: <20241002125826.309784696@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 579770dd89855915096db8364261543c37ed34ef ]

This is a prep for the later fix.

No functional change intended.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240905193240.17565-2-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5aa57d9f2d53 ("af_unix: Don't return OOB skb in manage_oob().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 45 +++++++++++++++++++++++----------------------
 1 file changed, 23 insertions(+), 22 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index a1894019ebd56..03820454bc723 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2654,11 +2654,10 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 				  int flags, int copied)
 {
+	struct sk_buff *unlinked_skb = NULL;
 	struct unix_sock *u = unix_sk(sk);
 
 	if (!unix_skb_len(skb)) {
-		struct sk_buff *unlinked_skb = NULL;
-
 		spin_lock(&sk->sk_receive_queue.lock);
 
 		if (copied && (!u->oob_skb || skb == u->oob_skb)) {
@@ -2674,31 +2673,33 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 		spin_unlock(&sk->sk_receive_queue.lock);
 
 		consume_skb(unlinked_skb);
-	} else {
-		struct sk_buff *unlinked_skb = NULL;
+		return skb;
+	}
 
-		spin_lock(&sk->sk_receive_queue.lock);
+	spin_lock(&sk->sk_receive_queue.lock);
 
-		if (skb == u->oob_skb) {
-			if (copied) {
-				skb = NULL;
-			} else if (!(flags & MSG_PEEK)) {
-				WRITE_ONCE(u->oob_skb, NULL);
-
-				if (!sock_flag(sk, SOCK_URGINLINE)) {
-					__skb_unlink(skb, &sk->sk_receive_queue);
-					unlinked_skb = skb;
-					skb = skb_peek(&sk->sk_receive_queue);
-				}
-			} else if (!sock_flag(sk, SOCK_URGINLINE)) {
-				skb = skb_peek_next(skb, &sk->sk_receive_queue);
-			}
-		}
+	if (skb != u->oob_skb)
+		goto unlock;
 
-		spin_unlock(&sk->sk_receive_queue.lock);
+	if (copied) {
+		skb = NULL;
+	} else if (!(flags & MSG_PEEK)) {
+		WRITE_ONCE(u->oob_skb, NULL);
 
-		kfree_skb(unlinked_skb);
+		if (!sock_flag(sk, SOCK_URGINLINE)) {
+			__skb_unlink(skb, &sk->sk_receive_queue);
+			unlinked_skb = skb;
+			skb = skb_peek(&sk->sk_receive_queue);
+		}
+	} else if (!sock_flag(sk, SOCK_URGINLINE)) {
+		skb = skb_peek_next(skb, &sk->sk_receive_queue);
 	}
+
+unlock:
+	spin_unlock(&sk->sk_receive_queue.lock);
+
+	kfree_skb(unlinked_skb);
+
 	return skb;
 }
 #endif
-- 
2.43.0



