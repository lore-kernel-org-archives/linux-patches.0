Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 564212512C0;
	Wed,  5 Mar 2025 18:14:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198469; cv=none; b=e7pCTX36+czgq6T6XG4zJ+m2R72zU/x514F0NVg726Aqdtr3QI3kX6Q40Ly2FV1u0PnW1euVDKHN3KmBP3enftJi2gOwVwWhbesXIy+aTbmqWlADdqJJG3mPCKC35t+z6teyNo243px8+E/g+w1DnJiIZc+uPisLj2TLnpLdt50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198469; c=relaxed/simple;
	bh=g60T00jl/tFF1Sh4ycb7LqlYAFChdHU/Ihrxhw+TziI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=URfWMoRcJPrANfonCrpQCwIbViJGQkBYI3muasVUFUUYEhZ5XI7oggpX4bIcnsiXXag+F1o0D6REVsZt2rVdFc62c1KPomQu8h1jlTkIZ1rWUs6XfxzjDdkq1+/NaBmloiO6kZcJpp7Se/6J+n7ka7pYMCnK+tdKBMX0Ng0Q4zU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XMjYHReH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XMjYHReH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D05D6C4CED1;
	Wed,  5 Mar 2025 18:14:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198469;
	bh=g60T00jl/tFF1Sh4ycb7LqlYAFChdHU/Ihrxhw+TziI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMjYHReHmeGHFGJoTgFYRWrQi5MNaGSKiWHvgB20EP7gxoUjUksdnrSSKmGKO3WNT
	 Sa50CuWOQJ+QMt3YZ2KV1Oo1awwwr+u0C0lzxGQGALHbM+9AsiK5VlQ+u7wvaevZ2R
	 UiWS/EppHWVfgKewaT4W0KV3ibW4NXWirQgffwvU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philo Lu <lulie@linux.alibaba.com>,
	Julian Anastasov <ja@ssi.bg>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 039/157] ipvs: Always clear ipvs_property flag in skb_scrub_packet()
Date: Wed,  5 Mar 2025 18:47:55 +0100
Message-ID: <20250305174506.868712084@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Philo Lu <lulie@linux.alibaba.com>

[ Upstream commit de2c211868b9424f9aa9b3432c4430825bafb41b ]

We found an issue when using bpf_redirect with ipvs NAT mode after
commit ff70202b2d1a ("dev_forward_skb: do not scrub skb mark within
the same name space"). Particularly, we use bpf_redirect to return
the skb directly back to the netif it comes from, i.e., xnet is
false in skb_scrub_packet(), and then ipvs_property is preserved
and SNAT is skipped in the rx path.

ipvs_property has been already cleared when netns is changed in
commit 2b5ec1a5f973 ("netfilter/ipvs: clear ipvs_property flag when
SKB net namespace changed"). This patch just clears it in spite of
netns.

Fixes: 2b5ec1a5f973 ("netfilter/ipvs: clear ipvs_property flag when SKB net namespace changed")
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Acked-by: Julian Anastasov <ja@ssi.bg>
Link: https://patch.msgid.link/20250222033518.126087-1-lulie@linux.alibaba.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skbuff.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/skbuff.c b/net/core/skbuff.c
index f251a99f8d421..bed75273f8c47 100644
--- a/net/core/skbuff.c
+++ b/net/core/skbuff.c
@@ -6127,11 +6127,11 @@ void skb_scrub_packet(struct sk_buff *skb, bool xnet)
 	skb->offload_fwd_mark = 0;
 	skb->offload_l3_fwd_mark = 0;
 #endif
+	ipvs_reset(skb);
 
 	if (!xnet)
 		return;
 
-	ipvs_reset(skb);
 	skb->mark = 0;
 	skb_clear_tstamp(skb);
 }
-- 
2.39.5



