Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B40D837B025;
	Wed, 30 Sep 2026 15:59:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790783993; cv=none; b=irqxaCT6KNX/pw9W6ICqCjz+BfUVY3YZW82FM4UqDg6D7aQilI8rUh+x39GVcQg8EpBUjBiSRWZtm4lUYjF15fRObYARs6TaDjwjeYarpn2Rt9GnUJ2AWB/qGtunSeJkNqzS1Sbff0tc3etraWfbJoG5BdivMtMv0QUdIeHQH1o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790783993; c=relaxed/simple;
	bh=N+KctXN57rfd+iCY1JaeP5jq/flziaJxEehAXmdPFqM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CfW9DiMauTMz/5JqU7N6mG9uT5xDXWx+nqOoUiQ4bzXcbrZq4LRRx0bRZzV2tOKIdHWhKf2UaJjiv7xaEACezLrGCYdu6aAfEubVblPWvdu/DymLvUoQGQGnRZ1s41BSbgb1GyJ4aV91ufnrMdoYAd32dpATlQ5hit+uELPoVOk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qPYQ4nVJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qPYQ4nVJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819E71F00893;
	Wed, 30 Sep 2026 15:59:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790783989;
	bh=Z4+8u7txAguRGJU0HfPoaX26Udgw9FyqmbWPNWB4SJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qPYQ4nVJ/4xlQdakmYjR9gcBITs3zF5xBQogh0n5lCvxpQijRCwgsW5uZSE/QqB00
	 LT7S4JYxJyDUoHvwdXtLkAGf8VmC9PH/8stunkOxGA5cPG+X96Hun30Mo6I3KygA+d
	 JmeOMUC8ktVstJPw+tp0OS+wCkIEsHqzNZpeoIXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Marco Elver <elver@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	"Miguel Gazquez (Schneider Electric)" <miguel.gazquez@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 548/595] net: add and use skb_unclone_keeptruesize() helper
Date: Wed, 30 Sep 2026 17:27:21 +0200
Message-ID: <20260930152359.501587930@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152347.700140858@linuxfoundation.org>
References: <20260930152347.700140858@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

commit c4777efa751d293e369aec464ce6875e957be255 upstream.

While commit 097b9146c0e2 ("net: fix up truesize of cloned
skb in skb_prepare_for_shift()") fixed immediate issues found
when KFENCE was enabled/tested, there are still similar issues,
when tcp_trim_head() hits KFENCE while the master skb
is cloned.

This happens under heavy networking TX workloads,
when the TX completion might be delayed after incoming ACK.

This patch fixes the WARNING in sk_stream_kill_queues
when sk->sk_mem_queued/sk->sk_forward_alloc are not zero.

Fixes: d3fb45f370d9 ("mm, kfence: insert KFENCE hooks for SLAB")
Signed-off-by: Eric Dumazet <edumazet@google.com>
Acked-by: Marco Elver <elver@google.com>
Link: https://lore.kernel.org/r/20211102004555.1359210-1-eric.dumazet@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Miguel Gazquez (Schneider Electric) <miguel.gazquez@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 16 ++++++++++++++++
 net/core/skbuff.c      | 14 +-------------
 net/ipv4/tcp_output.c  |  6 +++---
 3 files changed, 20 insertions(+), 16 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index 01eb7bc4e84b0..80de69bf9586a 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1645,6 +1645,22 @@ static inline int skb_unclone(struct sk_buff *skb, gfp_t pri)
 	return 0;
 }
 
+/* This variant of skb_unclone() makes sure skb->truesize is not changed */
+static inline int skb_unclone_keeptruesize(struct sk_buff *skb, gfp_t pri)
+{
+	might_sleep_if(gfpflags_allow_blocking(pri));
+
+	if (skb_cloned(skb)) {
+		unsigned int save = skb->truesize;
+		int res;
+
+		res = pskb_expand_head(skb, 0, 0, pri);
+		skb->truesize = save;
+		return res;
+	}
+	return 0;
+}
+
 /**
  *	skb_header_cloned - is the header a clone
  *	@skb: buffer to check
diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 6a8e10db11b77..e20ecc44f7555 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -3388,19 +3388,7 @@ EXPORT_SYMBOL(skb_split);
  */
 static int skb_prepare_for_shift(struct sk_buff *skb)
 {
-	int ret = 0;
-
-	if (skb_cloned(skb)) {
-		/* Save and restore truesize: pskb_expand_head() may reallocate
-		 * memory where ksize(kmalloc(S)) != ksize(kmalloc(S)), but we
-		 * cannot change truesize at this point.
-		 */
-		unsigned int save_truesize = skb->truesize;
-
-		ret = pskb_expand_head(skb, 0, 0, GFP_ATOMIC);
-		skb->truesize = save_truesize;
-	}
-	return ret;
+	return skb_unclone_keeptruesize(skb, GFP_ATOMIC);
 }
 
 /**
diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
index e469f689cd5c9..6bde4c463a893 100644
--- a/net/ipv4/tcp_output.c
+++ b/net/ipv4/tcp_output.c
@@ -1560,7 +1560,7 @@ int tcp_fragment(struct sock *sk, enum tcp_queue tcp_queue,
 		return -ENOMEM;
 	}
 
-	if (skb_unclone(skb, gfp))
+	if (skb_unclone_keeptruesize(skb, gfp))
 		return -ENOMEM;
 
 	/* Get a new skb... force flag on. */
@@ -1669,7 +1669,7 @@ int tcp_trim_head(struct sock *sk, struct sk_buff *skb, u32 len)
 {
 	u32 delta_truesize;
 
-	if (skb_unclone(skb, GFP_ATOMIC))
+	if (skb_unclone_keeptruesize(skb, GFP_ATOMIC))
 		return -ENOMEM;
 
 	delta_truesize = __pskb_trim_head(skb, len);
@@ -3227,7 +3227,7 @@ int __tcp_retransmit_skb(struct sock *sk, struct sk_buff *skb, int segs)
 				 cur_mss, GFP_ATOMIC))
 			return -ENOMEM; /* We'll try again later. */
 	} else {
-		if (skb_unclone(skb, GFP_ATOMIC))
+		if (skb_unclone_keeptruesize(skb, GFP_ATOMIC))
 			return -ENOMEM;
 
 		diff = tcp_skb_pcount(skb);
-- 
2.53.0



