Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC221CFECF;
	Wed,  2 Oct 2024 13:23:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875423; cv=none; b=dBKNkdCf4Pzk9b1kWtJ7dYbj+HQvGwtxpyG2EBXVbi69exORZc25XbLy0DRXCvnnU4K6kGK/LDByaatLNhh+Iec2KVOhkeGTZeNQ/BLrvkbabqpH67psZSbsyzqdyziksINTdGNy9XK47QN0meQFMOqY+Tn+x0e/MvZRDjSmVq4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875423; c=relaxed/simple;
	bh=zuyyy26umZNl50eoTDY/9El+TcuR10dISsPbPQHJs9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FiOVW4CeNE4bEnA83Wp5Dc7hHodxDlHaEYKLhtcB4E12aXEdMvgQTyOUYalpnmNWSQazwAhVtjUT5M61skjtEERyEmAtxNAoD1NnmJgyYM2Kh0LVvUL5raX7RLz95wkWJtkDW0x91DoPpuH1CTDhVghxgbPcCk9uDs8QDq5iBpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gY+7fV95; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gY+7fV95"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89FACC4CEC5;
	Wed,  2 Oct 2024 13:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875422;
	bh=zuyyy26umZNl50eoTDY/9El+TcuR10dISsPbPQHJs9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gY+7fV958Q996pa/FKpvHl6ay64ZrwEKUZkNt3NbdA0F4Z5v6vVaAODXs82yAiau4
	 VwDE1k4E7MlMOwKublp9ACV7nElm7TEdeiF4UT8QUMIca75pZekQ/hgal+pCW16FHc
	 fKP5LFyJbV6/3oZm50WZ2brIyY5nkSQkLJfILkCE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 097/695] af_unix: Rename unlinked_skb in manage_oob().
Date: Wed,  2 Oct 2024 14:51:35 +0200
Message-ID: <20241002125826.349056504@linuxfoundation.org>
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

[ Upstream commit beb2c5f19b6ab033b187e770a659c730c3bd05ca ]

When OOB skb has been already consumed, manage_oob() returns the next
skb if exists.  In such a case, we need to fall back to the else branch
below.

Then, we need to keep two skbs and free them later with consume_skb()
and kfree_skb().

Let's rename unlinked_skb accordingly.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240905193240.17565-3-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5aa57d9f2d53 ("af_unix: Don't return OOB skb in manage_oob().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 03820454bc723..91d7877a10794 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2654,7 +2654,7 @@ static int unix_stream_recv_urg(struct unix_stream_read_state *state)
 static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 				  int flags, int copied)
 {
-	struct sk_buff *unlinked_skb = NULL;
+	struct sk_buff *read_skb = NULL, *unread_skb = NULL;
 	struct unix_sock *u = unix_sk(sk);
 
 	if (!unix_skb_len(skb)) {
@@ -2665,14 +2665,14 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 		} else if (flags & MSG_PEEK) {
 			skb = skb_peek_next(skb, &sk->sk_receive_queue);
 		} else {
-			unlinked_skb = skb;
+			read_skb = skb;
 			skb = skb_peek_next(skb, &sk->sk_receive_queue);
-			__skb_unlink(unlinked_skb, &sk->sk_receive_queue);
+			__skb_unlink(read_skb, &sk->sk_receive_queue);
 		}
 
 		spin_unlock(&sk->sk_receive_queue.lock);
 
-		consume_skb(unlinked_skb);
+		consume_skb(read_skb);
 		return skb;
 	}
 
@@ -2688,7 +2688,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 
 		if (!sock_flag(sk, SOCK_URGINLINE)) {
 			__skb_unlink(skb, &sk->sk_receive_queue);
-			unlinked_skb = skb;
+			unread_skb = skb;
 			skb = skb_peek(&sk->sk_receive_queue);
 		}
 	} else if (!sock_flag(sk, SOCK_URGINLINE)) {
@@ -2698,7 +2698,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 unlock:
 	spin_unlock(&sk->sk_receive_queue.lock);
 
-	kfree_skb(unlinked_skb);
+	kfree_skb(unread_skb);
 
 	return skb;
 }
-- 
2.43.0



