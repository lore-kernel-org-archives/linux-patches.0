Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A757242847F;
	Tue, 16 Jun 2026 15:53:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781625211; cv=none; b=IhklCFlrRmNpEtD9A4iKng5wjOy+OOSRIoFyid7Qs3VGVBaCiCZSdkrXiavDf0Pk6PxK9rAhTGPGOzQEeZVRkQbbBZSqmDdQiXw3Jn5tSp/wYJdNVsi5NX5sN1UHq+cLJ2kFDrAAmwdxTaBuE5vNRBsTu1UvR+Hz6nBejmXrUdQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781625211; c=relaxed/simple;
	bh=Uyw6/FMvz7HjiWtOEyHJPwnazw910UYZ1a58arOWJH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JKJO3Span+RiUSULJ4n5BaREOcW2FH1nlmR3DnzCTtqZVQ4HzqZMh1pTD2FfItrO4Qlq6aquWrqEpoRv9Tg+qPNW2iYciW5N7h9iqqAuRa5VdRgseBUd5dXu0ijwXh0kmtbqWIANFV7Ff4j+sT7sx9GKo0qzYKgTNKJ0b3f/EZo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eLbktw9P; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eLbktw9P"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB8291F000E9;
	Tue, 16 Jun 2026 15:53:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781625210;
	bh=k45L2/2AMVuCCN2KN9FwakOPP783OrRV7APKZpmGB3g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eLbktw9PBJw23XpVTafmBhSeNVYt3uebEQ/vNnlE/N+v35CDnrmtAGWoSaohb7jjP
	 ClkyPPAM2JHB0tawU7QzWkhVmp+kLVoL6o+qNwlJsSOJfqC9XAGbSge2krkU8TSfHQ
	 q3u4GHyUBwwfZ75juQDuvVfYMhWesTYyOW01OLYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HanQuan <eilaimemedsnaimel@gmail.com>,
	MingXuan <bwnie0730@outlook.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 098/325] net: add pskb_may_pull() to skb_gro_receive_list()
Date: Tue, 16 Jun 2026 20:28:14 +0530
Message-ID: <20260616145102.567421545@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145057.827196531@linuxfoundation.org>
References: <20260616145057.827196531@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HanQuan <eilaimemedsnaimel@gmail.com>

[ Upstream commit f2bb3434544454099a5b6dec213567267b05d79d ]

skb_gro_receive_list() calls skb_pull(skb, skb_gro_offset(skb)) without
first ensuring the data is in the linear area via pskb_may_pull(). When
the skb arrives via napi_gro_frags(), skb_headlen can be 0 (all data in
page fragments) while skb_gro_offset is non-zero (after IP+TCP header
parsing). The skb_pull() then decrements skb->len by skb_gro_offset
but skb->data_len stays unchanged, hitting BUG_ON(skb->len < skb->data_len)
in __skb_pull().

The UDP fraglist GRO path already contains this guard at
udp_offload.c:749. Adding it to skb_gro_receive_list() itself provides
centralized protection for all callers (TCP, UDP, and any future
protocols), and ensures the precondition of skb_pull() is satisfied
before it is called.

On pskb_may_pull() failure, set NAPI_GRO_CB(skb)->flush = 1 so the
skb is not held as a new GRO head and is instead delivered through the
normal receive path, matching the UDP handling.

Fixes: 8d95dc474f85 ("net: add code for TCP fraglist GRO")
Reported-by: HanQuan <eilaimemedsnaimel@gmail.com>
Reported-by: MingXuan <bwnie0730@outlook.com>
Signed-off-by: HanQuan <eilaimemedsnaimel@gmail.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/gro.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/net/core/gro.c b/net/core/gro.c
index b5f790a643d497..9ec8a46b30bb97 100644
--- a/net/core/gro.c
+++ b/net/core/gro.c
@@ -234,6 +234,11 @@ int skb_gro_receive_list(struct sk_buff *p, struct sk_buff *skb)
 	if (unlikely(p->len + skb->len >= 65536))
 		return -E2BIG;
 
+	if (!pskb_may_pull(skb, skb_gro_offset(skb))) {
+		NAPI_GRO_CB(skb)->flush = 1;
+		return -ENOMEM;
+	}
+
 	if (NAPI_GRO_CB(p)->last == p)
 		skb_shinfo(p)->frag_list = skb;
 	else
-- 
2.53.0



