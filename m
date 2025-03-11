Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDB321CAA8F;
	Tue, 11 Mar 2025 15:35:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707360; cv=none; b=K+WVqNaeqEx6EkV8pJ2WT4tpeOv18rm9TamZlPcD3Mjc7u0J9+yI2uJ+WPcSziavEYBo+z6xitAobsv0QdamH/ZG6F6aF+5/GI+wpPqwsr4MH9yUxeT6h2EgzFoNYsD9hw8BaioLHNG12zKs7OzrqtE6+0US7BNK8aBvYbdV8KI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707360; c=relaxed/simple;
	bh=/JWRTt3HhCBtnsToHfN5wyAgKl1So1ZOZScf9QwX/sA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5+0PQLYAvHrqALMVPmYCsJH4QagaSsU5asKQOIY9O5cfjAlTkUsOZ7nXFGokmTOHPHD7fHm1Rba3gTSdSZS5ZwDEHY+pNXwTXJM125Pq3Y5mVfpZUODe0dPkVDOTyNQonbk4pXYBoyUrsVBrDLt4+WYmeZI9pDEsnuZdXjdct8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vXzXYyJb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vXzXYyJb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 684C1C4CEE9;
	Tue, 11 Mar 2025 15:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707359;
	bh=/JWRTt3HhCBtnsToHfN5wyAgKl1So1ZOZScf9QwX/sA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vXzXYyJbBgiHGXkpwUKXcD3lh16o7gjTOS+nfzjPKlrGuRgQuveZOYl3J/FosiXWx
	 FoDymKi3nE/h3snREFu0jGE0vGjyinrsF3x7/6jbbz0VWpFMTOGb5/mrqyanOQn/BP
	 LGitgV3VPLLirYQov06qT12LZXRtkchabs9g00qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Brian Vazquez <brianvv@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 363/462] net: use indirect call helpers for dst_input
Date: Tue, 11 Mar 2025 16:00:29 +0100
Message-ID: <20250311145812.693390477@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brian Vazquez <brianvv@google.com>

[ Upstream commit e43b21906439ed14dda84f9784d38c03d0464607 ]

This patch avoids the indirect call for the common case:
ip_local_deliver and ip6_input

Signed-off-by: Brian Vazquez <brianvv@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 13e55fbaec17 ("net: ipv6: fix dst ref loop on input in rpl lwt")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/dst.h   | 6 +++++-
 net/ipv4/ip_input.c | 1 +
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/include/net/dst.h b/include/net/dst.h
index 48e613420b952..907b4b5893a67 100644
--- a/include/net/dst.h
+++ b/include/net/dst.h
@@ -18,6 +18,7 @@
 #include <linux/refcount.h>
 #include <net/neighbour.h>
 #include <asm/processor.h>
+#include <linux/indirect_call_wrapper.h>
 
 struct sk_buff;
 
@@ -436,10 +437,13 @@ static inline int dst_output(struct net *net, struct sock *sk, struct sk_buff *s
 	return skb_dst(skb)->output(net, sk, skb);
 }
 
+INDIRECT_CALLABLE_DECLARE(int ip6_input(struct sk_buff *));
+INDIRECT_CALLABLE_DECLARE(int ip_local_deliver(struct sk_buff *));
 /* Input packet from network to transport.  */
 static inline int dst_input(struct sk_buff *skb)
 {
-	return skb_dst(skb)->input(skb);
+	return INDIRECT_CALL_INET(skb_dst(skb)->input,
+				  ip6_input, ip_local_deliver, skb);
 }
 
 static inline struct dst_entry *dst_check(struct dst_entry *dst, u32 cookie)
diff --git a/net/ipv4/ip_input.c b/net/ipv4/ip_input.c
index 372579686162b..3109bf6cdf283 100644
--- a/net/ipv4/ip_input.c
+++ b/net/ipv4/ip_input.c
@@ -253,6 +253,7 @@ int ip_local_deliver(struct sk_buff *skb)
 		       net, NULL, skb, skb->dev, NULL,
 		       ip_local_deliver_finish);
 }
+EXPORT_SYMBOL(ip_local_deliver);
 
 static inline bool ip_rcv_options(struct sk_buff *skb, struct net_device *dev)
 {
-- 
2.39.5



