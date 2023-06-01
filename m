Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17513FBE8
	for <patches@lists.linux.dev>; Thu,  1 Jun 2023 13:25:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98448C433EF;
	Thu,  1 Jun 2023 13:25:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685625945;
	bh=cEhoQ4B3ZTPZ5GFTmov+YtP5xJBvDYhwxNbn5V3EcB4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GLLD+21Z4B29Zkzabi0poVjqXgZUXYB+E5qRN9wR6vg9DkCmvyJgKGSSGO1uO8dxI
	 jq/vj5TykyjmgTneKko52kzDHk+EW+fWZ0LtW6u9nrFR5+Dp7GiFQbW4H0899k4hAN
	 IJlxPzhx9gW5qYYo13U1FTtKvlxdBwA97xVIzZPM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shai Amiram <samiram@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 14/45] tls: rx: strp: force mixed decrypted records into copy mode
Date: Thu,  1 Jun 2023 14:21:10 +0100
Message-Id: <20230601131939.362102447@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230601131938.702671708@linuxfoundation.org>
References: <20230601131938.702671708@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 14c4be92ebb3e36e392aa9dd8f314038a9f96f3c ]

If a record is partially decrypted we'll have to CoW it, anyway,
so go into copy mode and allocate a writable skb right away.

This will make subsequent fix simpler because we won't have to
teach tls_strp_msg_make_copy() how to copy skbs while preserving
decrypt status.

Tested-by: Shai Amiram <samiram@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: eca9bfafee3a ("tls: rx: strp: preserve decryption status of skbs when needed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 10 ++++++++++
 net/tls/tls_strp.c     | 16 +++++++++++-----
 2 files changed, 21 insertions(+), 5 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index dbcaac8b69665..4a882f9ba1f1f 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -1577,6 +1577,16 @@ static inline void skb_copy_hash(struct sk_buff *to, const struct sk_buff *from)
 	to->l4_hash = from->l4_hash;
 };
 
+static inline int skb_cmp_decrypted(const struct sk_buff *skb1,
+				    const struct sk_buff *skb2)
+{
+#ifdef CONFIG_TLS_DEVICE
+	return skb2->decrypted - skb1->decrypted;
+#else
+	return 0;
+#endif
+}
+
 static inline void skb_copy_decrypted(struct sk_buff *to,
 				      const struct sk_buff *from)
 {
diff --git a/net/tls/tls_strp.c b/net/tls/tls_strp.c
index 9889df5ce0660..e2e48217e7ac9 100644
--- a/net/tls/tls_strp.c
+++ b/net/tls/tls_strp.c
@@ -326,15 +326,19 @@ static int tls_strp_read_copy(struct tls_strparser *strp, bool qshort)
 	return 0;
 }
 
-static bool tls_strp_check_no_dup(struct tls_strparser *strp)
+static bool tls_strp_check_queue_ok(struct tls_strparser *strp)
 {
 	unsigned int len = strp->stm.offset + strp->stm.full_len;
-	struct sk_buff *skb;
+	struct sk_buff *first, *skb;
 	u32 seq;
 
-	skb = skb_shinfo(strp->anchor)->frag_list;
-	seq = TCP_SKB_CB(skb)->seq;
+	first = skb_shinfo(strp->anchor)->frag_list;
+	skb = first;
+	seq = TCP_SKB_CB(first)->seq;
 
+	/* Make sure there's no duplicate data in the queue,
+	 * and the decrypted status matches.
+	 */
 	while (skb->len < len) {
 		seq += skb->len;
 		len -= skb->len;
@@ -342,6 +346,8 @@ static bool tls_strp_check_no_dup(struct tls_strparser *strp)
 
 		if (TCP_SKB_CB(skb)->seq != seq)
 			return false;
+		if (skb_cmp_decrypted(first, skb))
+			return false;
 	}
 
 	return true;
@@ -422,7 +428,7 @@ static int tls_strp_read_sock(struct tls_strparser *strp)
 			return tls_strp_read_copy(strp, true);
 	}
 
-	if (!tls_strp_check_no_dup(strp))
+	if (!tls_strp_check_queue_ok(strp))
 		return tls_strp_read_copy(strp, false);
 
 	strp->msg_ready = 1;
-- 
2.39.2



