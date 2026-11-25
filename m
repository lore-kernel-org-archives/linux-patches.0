Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795618956;
	b=ZCkYskG3sMx7D/+Ir/0etxQRs2kNrJrwBEOGl3Xld52WE1AJLXYoUYI4UhOmd0wf262W
	 YzhkQ7QulQRs3GTEn/KnyB4lbR48QQZdpsXEcdzCWwkz0JOQv23jBN+/FT5W9ZE7dTzR3
	 HoO3R8GgXfwtQeQYnjWncjtXRazILaxi0XOPdT9oSFrfTUr9hVdcvA4pId1bbSI3+fRmp
	 AaWs3+n9BmaAo0W9k8RAQukdTX/q/DLG1zbyz/Sjrj3El9H62DeyAEgHoRepTHBZsdPDd
	 zrgqFNvxjKFp4vv5Civ7GNFQ4N9ON/Ow2yyKj0ikF9qfCxGS5I9TTWsflHryhqhvQjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795618956;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lPuPiqKKR+3ORb/671lW3ChfEp/JAOchvz4KmzUBK4E=;
	b=D31VoNxyAVoNt00av0pPDT9TYUFdKN7/jasm4pjFqlPIpqjZ930n/x8zk6Qy9AcDxkDz
	 bZZ0VMpMxT39NH2kE2ybf5t1Q6XO4Xw75XXDLIJYWJH3WNikEL8jC0dqDYZIy6/uqsphr
	 ok96O6fOfVr9pLLhWsCVRp4YoCRnQ7c6ySMKGXFqShZo6XZusVsZiC1QsGxpxLgAO1/6l
	 fA0KYZ3Kixa22Y/jGo6qy7qGMsconX2joVvEA8R4o1i83QaX+dvm7PV8KM135X6B2z+83
	 bSYHbrh4QE4H+7U5zrTQu5IYBAXmxOPXAVWaCLmy+Rpv+kLG00vvWfBkVWiTz5dnxjg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VULoBIrw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E12B0606A326;
	Wed, 25 Nov 2026 15:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VULoBIrw
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47BA91F000CA;
	Wed, 25 Nov 2026 15:02:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795618954;
	bh=lPuPiqKKR+3ORb/671lW3ChfEp/JAOchvz4KmzUBK4E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VULoBIrwea8fM9l75h0qdpVvkPDDHOdTvsEdW/qQhNp4+Wp18dwzS+bIdtw8tjFqe
	 lkomNWMBzonSfSTUF1FXnkbncBmbUFnXpzaaDP4IzXxCNrWMzUysMPOEyTHUPQjkvd
	 QNKh0FLvJt4p8fT2W28WDjx3rajH6TNOzyPt+y1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Zeng <kylebot@openai.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0441/1005] net: skbuff: preserve fclone lifetime when freeing stolen heads
Date: Wed, 25 Nov 2026 15:29:39 +0100
Message-ID: <20261125143832.080811841@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kyle Zeng <kylebot@openai.com>

[ Upstream commit 86706ffa990ecd46a4326f8eecbccbbd60a6cb8d ]

skb_morph() can give an skb from skbuff_fclone_cache a page-fragment
head without changing its fclone tag. IPv4 reassembly can produce such
an skb, which can subsequently reach the GRO stolen-head path.

napi_skb_free_stolen_head() puts the shell into the ordinary NAPI skb
cache without dropping its fclone_ref. If the embedded companion is
still live, KASAN poisons it along with the original, and later cache
reuse or eviction can overwrite or free the allocation underneath it.
A mirrored batman-adv DAT packet retained in a plug qdisc reproduces a
KASAN use-after-free in plug_dequeue().

Use kfree_skbmem() for fclones in napi_skb_free_stolen_head(), retaining
NAPI caching for ordinary skb heads. Also use kfree_skbmem() in
kfree_skb_partial(), whose stolen-head branch has the same assumption
about the allocation cache. This releases the shell according to its
allocation kind and preserves any live companion without freeing the
data that has been transferred to the receiving skb.

Fixes: f450d539c05a ("skbuff: introduce {,__}napi_build_skb() which reuses NAPI cache heads")
Signed-off-by: Kyle Zeng <kylebot@openai.com>
Link: https://patch.msgid.link/20261030042329.74461-1-kylebot@openai.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index 0cd5f30ff9bbf..ac78f28daea31 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -1504,6 +1504,10 @@ void napi_skb_free_stolen_head(struct sk_buff *skb)
 		skb_orphan(skb);
 		skb->slow_gro = 0;
 	}
+	if (skb->fclone != SKB_FCLONE_UNAVAILABLE) {
+		kfree_skbmem(skb);
+		return;
+	}
 	napi_skb_cache_put(skb);
 }
 
@@ -6192,7 +6196,7 @@ void kfree_skb_partial(struct sk_buff *skb, bool head_stolen)
 {
 	if (head_stolen) {
 		skb_release_head_state(skb);
-		kmem_cache_free(net_hotdata.skbuff_cache, skb);
+		kfree_skbmem(skb);
 	} else {
 		__kfree_skb(skb);
 	}
-- 
2.53.0



