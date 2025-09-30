Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 920881FF1C8;
	Tue, 30 Sep 2025 15:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244663; cv=none; b=tQaR2Fo8L8lv1BPEPVUDC2ZqI1S6SBnddLLjqGl4igeFVT8OyMe8eLaK7omPgabpqtNB8tNRiUpaeOKTxUNwpvseTlLvpow4fyBWGy2nZ2AekyKICEgUC+B3bQXmI6PrlrJHbvlIyI+SFS96nKworbUm8UMRBen+0bIncPLqxpQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244663; c=relaxed/simple;
	bh=RZtL5uB30XBiPRpr1HBMojsPP3CjMqmXX+Xi52TUKGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oY9/AR4VqK7SXuKRiBS9q7zr8lBiztJxB53F5ONxTseM753Lsln32SHKe9d8WpQwA4hw53VyYuqaBR+0tnYaF0T3P0CYJWgW/gNG16rnQSDyCPfG/4SMklJSoX5aLwc5c9n/wS4OIaK//4vcRrz21Vw52UAhxFGXcbpCOmqXpLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k5lF2RnH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k5lF2RnH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F119DC4CEF0;
	Tue, 30 Sep 2025 15:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244663;
	bh=RZtL5uB30XBiPRpr1HBMojsPP3CjMqmXX+Xi52TUKGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k5lF2RnHty+AFjjcGn2DNOs9Lv+nxU4Mycniz4Rcrpz5Df6ufkSAMGTzI/jWBB5Z7
	 /AJ3VijsE+Aup07hGCcgYGLCaGTmNI9J2WWbwTacFTyI2vGE6rN0xrXhPmG58wEFhA
	 X6IvhEJLEhHglHDAIhf+X2NTVj1QQspjVuIEIfAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Baron <jbaron@akamai.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 076/143] net: allow alloc_skb_with_frags() to use MAX_SKB_FRAGS
Date: Tue, 30 Sep 2025 16:46:40 +0200
Message-ID: <20250930143834.269435778@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143831.236060637@linuxfoundation.org>
References: <20250930143831.236060637@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index d6420b74ea9c6..cb77bb84371bd 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6667,7 +6667,7 @@ struct sk_buff *alloc_skb_with_frags(unsigned long header_len,
 		return NULL;
 
 	while (data_len) {
-		if (nr_frags == MAX_SKB_FRAGS - 1)
+		if (nr_frags == MAX_SKB_FRAGS)
 			goto failure;
 		while (order && PAGE_ALIGN(data_len) < (PAGE_SIZE << order))
 			order--;
-- 
2.51.0



