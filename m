Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D598416F84F;
	Wed,  2 Oct 2024 13:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875425; cv=none; b=DXegFNrIpt8YGS6Z9I9k/n+Ve+cnBScHudYeJJixhymHn7jLWqauRlT935KDthOBhwL4To8BY0g2oH+YTAufdCyeR02SMu05yGN15PYvwgXVKAHERi9glcPsSUUsrFjjlyM10FFr4NdVjTXC/n84/9MR9ZhDtirrTULC5dWRv6I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875425; c=relaxed/simple;
	bh=l1B0otgO+0F2SsD1TV2+SZRRaNm4E9yaAYcEH3w2/KA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hum82sFaKfkjhVsM1ym1ZDTZyBTy6Z3H3bm2hGZg0gaNpLE4OQUNLnURL19lBPMfPpnLlC8xZnvux/ayajOOb05sP/9ZGSbGRZGIhGz98P9vdJvPi9j+KLnPEWVvuNNj7eQNeFgxIA7qkLT+Lnf4O+jDfttuHLP/P9SNNNbPQ+k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kvG/BTD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kvG/BTD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60439C4CED2;
	Wed,  2 Oct 2024 13:23:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875425;
	bh=l1B0otgO+0F2SsD1TV2+SZRRaNm4E9yaAYcEH3w2/KA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kvG/BTD01q7z+hRJNz8TJ4IIQtxggWYp/3WIJfwmh/RMw/c3mYbygWZq5zhQmg3k2
	 FNTksNFQ7cqAZx2rODNzsIhVH/pS9rq1gge+pmSjVNkSPM4NTKzlqeyLnaAIUUosOL
	 4Rce6a8DIs9KmgM0tl0d23hbfbiuqQI/fP45J1xw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 098/695] af_unix: Move spin_lock() in manage_oob().
Date: Wed,  2 Oct 2024 14:51:36 +0200
Message-ID: <20241002125826.389244976@linuxfoundation.org>
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

[ Upstream commit a0264a9f51fe0d196f22efd7538eb749e3448c2d ]

When OOB skb has been already consumed, manage_oob() returns the next
skb if exists.  In such a case, we need to fall back to the else branch
below.

Then, we want to keep holding spin_lock(&sk->sk_receive_queue.lock).

Let's move it out of if-else branch and add lightweight check before
spin_lock() for major use cases without OOB skb.

Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Link: https://patch.msgid.link/20240905193240.17565-4-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5aa57d9f2d53 ("af_unix: Don't return OOB skb in manage_oob().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/unix/af_unix.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
index 91d7877a10794..159d78fc3d14d 100644
--- a/net/unix/af_unix.c
+++ b/net/unix/af_unix.c
@@ -2657,9 +2657,12 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 	struct sk_buff *read_skb = NULL, *unread_skb = NULL;
 	struct unix_sock *u = unix_sk(sk);
 
-	if (!unix_skb_len(skb)) {
-		spin_lock(&sk->sk_receive_queue.lock);
+	if (likely(unix_skb_len(skb) && skb != READ_ONCE(u->oob_skb)))
+		return skb;
 
+	spin_lock(&sk->sk_receive_queue.lock);
+
+	if (!unix_skb_len(skb)) {
 		if (copied && (!u->oob_skb || skb == u->oob_skb)) {
 			skb = NULL;
 		} else if (flags & MSG_PEEK) {
@@ -2670,14 +2673,9 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 			__skb_unlink(read_skb, &sk->sk_receive_queue);
 		}
 
-		spin_unlock(&sk->sk_receive_queue.lock);
-
-		consume_skb(read_skb);
-		return skb;
+		goto unlock;
 	}
 
-	spin_lock(&sk->sk_receive_queue.lock);
-
 	if (skb != u->oob_skb)
 		goto unlock;
 
@@ -2698,6 +2696,7 @@ static struct sk_buff *manage_oob(struct sk_buff *skb, struct sock *sk,
 unlock:
 	spin_unlock(&sk->sk_receive_queue.lock);
 
+	consume_skb(read_skb);
 	kfree_skb(unread_skb);
 
 	return skb;
-- 
2.43.0



