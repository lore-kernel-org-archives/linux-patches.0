Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027246;
	b=PBVnNR9EY3tyxG05F+sGoEPT2PkuD6Cli1d+8tJz2NE8quuwkCPILLzqa0W3I/dYvosZ
	 lEBj9CWXEcWu20n/x6IBvFPVVLrIaGjhJRDilZxprU0XTXsHQF5o5S5FtdmKV9URHd77N
	 OcXeZWEVkYis4DfvpgVRgKtM3eu/g7oKa2AMwlwGXF2wh5xxMQNQsLfXHv4D3iJ3KPZ61
	 yjSvQQadkpFdASjBVRSJzdacKuwZmeqoBmAYAqis9akJR3qcYvOYt9EF/R2pA6IKBSPnt
	 0QwQ3VFQtHwhqE1ojSybPdsZKN6KEfEiJeG0KtrpY7IQs2VLsN2WXQbBnbcsEogXeXw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027246;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Xzt6xp8GELCtUNZaGrZE+/neQTp19ajCZr/4HN/Qau8=;
	b=clRveKGXC/7Y6ELN0nbLqg2jI5Wbr32b0mwim62SJxf3weEl82u1gxEu+nNeEo/EuKVp
	 KywEh0mk+iFYmLmvslRavvGuk7cjagNCbkrH+hsOTSlD5uDtbikcU6ssl4ef2KdIcueFB
	 KejXawuIiO45jKtffJCoa+eHkKAx2nPrmfmIILVRXs55MKV5kIj4362PRsEEfL2teF3uf
	 zolhHB0r0pTHZ0hgSykgGMBDopRLVO/1Eh1E4TVDVMUvfbTc5gZ6BeNWEtImwCX2i/QYF
	 GuYXF4XctSpSvhwZRqaBT48ufCHNbbx6yiNacDfj2Ub/u13T9/nuLBxD8c/zZE+Z7Zg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKkVASCy;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1877606A32C;
	Wed, 18 Nov 2026 18:40:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QKkVASCy
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F98C1F000C4;
	Wed, 18 Nov 2026 18:40:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027245;
	bh=Xzt6xp8GELCtUNZaGrZE+/neQTp19ajCZr/4HN/Qau8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QKkVASCy4LJOqOzeav2z3djiJ6Cc168KUlouLIZ0sZkMVhcPWBK1yI6qVvUr7jgXn
	 H+dZDQkiI551DIau3LT5dkkWVjICNd8NPlYAodwrahNeyOfZZWzGk5tZfgDUklsxva
	 OI2ad879mOIlc8kpWja6yrh1v7dgo4B3oyFj3qSs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Sitnicki <jakub@cloudflare.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1720/2151] bpf: Make bpf_skb_adjust_room metadata-safe
Date: Wed, 18 Nov 2026 15:57:35 +0100
Message-ID: <20261118150224.491049812@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Sitnicki <jakub@cloudflare.com>

[ Upstream commit be83105d38ab99737ac0488600efd59ddd57b74c ]

bpf_skb_adjust_room() may push or pull bytes from skb->data. In both cases,
skb metadata must be moved accordingly to stay accessible.

Replace existing memmove() calls, which only move payload, with a helper
that also handles metadata. Reserve enough space for metadata to fit after
skb_push.

Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20251105-skb-meta-rx-path-v4-7-5ceb08a9b37b@cloudflare.com
Stable-dep-of: 12d07c38e1b0 ("bpf: Don't let bpf_skb_adjust_room() use up the MSS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ab49e7eb9d16b..ce126500a52cc 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3311,11 +3311,11 @@ static void bpf_skb_change_protocol(struct sk_buff *skb, u16 proto)
 
 static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 {
-	/* Caller already did skb_cow() with len as headroom,
+	/* Caller already did skb_cow() with meta_len+len as headroom,
 	 * so no need to do it here.
 	 */
 	skb_push(skb, len);
-	memmove(skb->data, skb->data + len, off);
+	skb_postpush_data_move(skb, len, off);
 	memset(skb->data + off, 0, len);
 
 	/* No skb_postpush_rcsum(skb, skb->data + off, len)
@@ -3339,7 +3339,7 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 	old_data = skb->data;
 	__skb_pull(skb, len);
 	skb_postpull_rcsum(skb, old_data + off, len);
-	memmove(skb->data, old_data, off);
+	skb_postpull_data_move(skb, len, off);
 
 	return 0;
 }
@@ -3549,6 +3549,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 	u8 inner_mac_len = flags >> BPF_ADJ_ROOM_ENCAP_L2_SHIFT;
 	bool encap = flags & BPF_F_ADJ_ROOM_ENCAP_L3_MASK;
 	u16 mac_len = 0, inner_net = 0, inner_trans = 0;
+	const u8 meta_len = skb_metadata_len(skb);
 	unsigned int gso_type = SKB_GSO_DODGY;
 	int ret;
 
@@ -3559,7 +3560,7 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 			return -ENOTSUPP;
 	}
 
-	ret = skb_cow_head(skb, len_diff);
+	ret = skb_cow_head(skb, meta_len + len_diff);
 	if (unlikely(ret < 0))
 		return ret;
 
-- 
2.53.0



