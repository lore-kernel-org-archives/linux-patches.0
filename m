Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 186253C465;
	Tue, 30 Sep 2025 15:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759246104; cv=none; b=PELYTA+OePjIdBLLjafTaloUcOw+55OiW3oZoSSDjy9+yU1kHRiLSV+GwrbmV/LPY/9DNjv1nIOCGhV93uu3a4oMJEdFgCHXk5KcTxZcxSY5cK7fbNN/sMIDG9nJMs3lMKAcI8A7iciuGzzizfRLDEzFCqi6g13OZVH0JQTmvxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759246104; c=relaxed/simple;
	bh=OTUI0SSo2mBVnAtE3B697C+7dP1p5hkHRxRnTsUGWCQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jd0+iYyOLphH6cpGdYU77XyexcXgL0dV0vDiUbSYpM0fYQr+ONQrbx24T6qkQQtnK0Xslk0wE8MNK5AdaqMYHqvVtcSk+T798HQAQMjxFgQoJgq9CaEUkSdLpxGiZQhJmG9OhbfbuRIzLphhq/Abmn1HyVLXVYctR5BP5KNOUs0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aywQZZZy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aywQZZZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2558EC4CEF0;
	Tue, 30 Sep 2025 15:28:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759246102;
	bh=OTUI0SSo2mBVnAtE3B697C+7dP1p5hkHRxRnTsUGWCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aywQZZZyGjHsrzjiZrB9/oi4lhpN4z5g8eHreJ6Xnm9468rl+BVTMyzb8uN1Cd7zD
	 Id6o0NmENjqU9+TPZnkQ+YsU4AmNjmrePtuut0eOIQSsyk50v/M4UuH+7Py32PC7Xu
	 1yYz2ks9R16LVupaLQc6HZwssXtabjOvDT8SuhHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Baron <jbaron@akamai.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 52/89] net: allow alloc_skb_with_frags() to use MAX_SKB_FRAGS
Date: Tue, 30 Sep 2025 16:48:06 +0200
Message-ID: <20250930143824.074053640@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143821.852512002@linuxfoundation.org>
References: <20250930143821.852512002@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason Baron <jbaron@akamai.com>

[ Upstream commit ca9f9cdc4de97d0221100b11224738416696163c ]

Currently, alloc_skb_with_frags() will only fill (MAX_SKB_FRAGS - 1)
slots. I think it should use all MAX_SKB_FRAGS slots, as callers of
alloc_skb_with_frags() will size their allocation of frags based
on MAX_SKB_FRAGS.

This issue was discovered via a test patch that sets 'order' to 0
in alloc_skb_with_frags(), which effectively tests/simulates high
fragmentation. In this case sendmsg() on unix sockets will fail every
time for large allocations. If the PAGE_SIZE is 4K, then data_len will
request 68K or 17 pages, but alloc_skb_with_frags() can only allocate
64K in this case or 16 pages.

Fixes: 09c2c90705bb ("net: allow alloc_skb_with_frags() to allocate bigger packets")
Signed-off-by: Jason Baron <jbaron@akamai.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250922191957.2855612-1-jbaron@akamai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index cf54593149cce..6a92c03ee6f42 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6603,7 +6603,7 @@ struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
 		return NULL;
 
 	while (data_len) {
-		if (nr_frags == MAX_SKB_FRAGS - 1)
+		if (nr_frags == MAX_SKB_FRAGS)
 			goto failure;
 		while (order && PAGE_ALIGN(data_len) < (PAGE_SIZE << order))
 			order--;
-- 
2.51.0



