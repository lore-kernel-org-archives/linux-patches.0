Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E6EA19B3ED;
	Thu,  6 Jun 2024 14:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683386; cv=none; b=cUdLvhblW0xrcROlhEL0PQnQ7gvboRfm6jO9G4d2kqY6J6LeU3O+8SiPjGxpk/LerKuz+83Gr245+8LiNPvGvGSSfeN9XEIkfRHgUNfas1ffSjKltDi1DY+QGrjJ7tuWOwlt4JnZAY9G944MX8V7Usyw0ZvtDbFLlGA7RKZ8pBw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683386; c=relaxed/simple;
	bh=l6/4FXJWsOiE+gTPjW6itEkuZyQoqnbwrD5UfkQX6E0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxKRTsjAmmVeqX2RC49dMaPqktdBEnlq9KFVtMYFtxJ0woHPYwrOSSiaQIZq/UTRkfjHy3BdjGR0J9yiq8lKfM9+00VFKuPM/lMhDHqi/CamZAoEcL5YdoRs8mm91XhN1RemeJjBwvKy0z21Ofjb/6xsngORcfaPr0AGfiPOJ8g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2YXrin13; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2YXrin13"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FAC1C2BD10;
	Thu,  6 Jun 2024 14:16:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683386;
	bh=l6/4FXJWsOiE+gTPjW6itEkuZyQoqnbwrD5UfkQX6E0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2YXrin13W0WXaWkF8DxM5MbVVGo7+ToXK7EMoweNpV/IzDEeoWPjq238HbO+ayJob
	 YhId84woheR51vtoO9+Y/2CD+mWsVkvHXvZLLs/1B2+te/xu0gjOW9QpmtJmPOVSXT
	 A89Fvglpu6eylZtF291Oa1XC2qoshFuaJlkm8hkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	David Ahern <dsahern@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 269/473] net: add pskb_may_pull_reason() helper
Date: Thu,  6 Jun 2024 16:03:18 +0200
Message-ID: <20240606131708.832299745@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131659.786180261@linuxfoundation.org>
References: <20240606131659.786180261@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 1fb2d41501f38192d8a19da585cd441cf8845697 ]

pskb_may_pull() can fail for two different reasons.

Provide pskb_may_pull_reason() helper to distinguish
between these reasons.

It returns:

SKB_NOT_DROPPED_YET           : Success
SKB_DROP_REASON_PKT_TOO_SMALL : packet too small
SKB_DROP_REASON_NOMEM         : skb->head could not be resized

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 8bd67ebb50c0 ("net: bridge: xmit: make sure we have at least eth header len bytes")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/skbuff.h | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/include/linux/skbuff.h b/include/linux/skbuff.h
index cecd3b6bebb8b..2b54662048882 100644
--- a/include/linux/skbuff.h
+++ b/include/linux/skbuff.h
@@ -2636,15 +2636,26 @@ void *skb_pull_data(struct sk_buff *skb, size_t len);
 
 void *__pskb_pull_tail(struct sk_buff *skb, int delta);
 
-static inline bool pskb_may_pull(struct sk_buff *skb, unsigned int len)
+static inline enum skb_drop_reason
+pskb_may_pull_reason(struct sk_buff *skb, unsigned int len)
 {
 	DEBUG_NET_WARN_ON_ONCE(len > INT_MAX);
 
 	if (likely(len <= skb_headlen(skb)))
-		return true;
+		return SKB_NOT_DROPPED_YET;
+
 	if (unlikely(len > skb->len))
-		return false;
-	return __pskb_pull_tail(skb, len - skb_headlen(skb)) != NULL;
+		return SKB_DROP_REASON_PKT_TOO_SMALL;
+
+	if (unlikely(!__pskb_pull_tail(skb, len - skb_headlen(skb))))
+		return SKB_DROP_REASON_NOMEM;
+
+	return SKB_NOT_DROPPED_YET;
+}
+
+static inline bool pskb_may_pull(struct sk_buff *skb, unsigned int len)
+{
+	return pskb_may_pull_reason(skb, len) == SKB_NOT_DROPPED_YET;
 }
 
 static inline void *pskb_pull(struct sk_buff *skb, unsigned int len)
-- 
2.43.0



