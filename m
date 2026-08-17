Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E69FA3F7882;
	Mon, 17 Aug 2026 13:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974214; cv=none; b=nV9F9bEVoTCkF20yxbMgimlCxuRIiqljmKbCYM41cVnj9siBsMVAeSZM8WyXwBFe2TKIG8yW9oD6jUD4eR462VlUZWq1+/llp5k7fYHLXI9xscBHMrQHBtwZwj3M5910e9LwWTWZc985ZC7CNO+FiY1IzCcf83k4lD2zWgEQWeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974214; c=relaxed/simple;
	bh=SqzxQifuk/VtoTtKC7/NxBqJQxt8jD3+gdweG44rnQs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DqBNwsUUbFiNAdFpjF2u8S4iJmY3D3x818fDJA8D9FKbwco5qr7FPW31KTIgzrp8aeqBBif3OfdKYFQVH0e3XRcr45bz4/cdBcqDNa7DMotYjAoL+CTtvjDbCeDnUwRO96R4R8NUM/zU9KgbjNrv8W9Sa/EYJRuSGi2Jvh1HrJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R4HiUbMM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R4HiUbMM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48DC01F000E9;
	Mon, 17 Aug 2026 13:43:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974212;
	bh=47KkBsGUN/qxiPSft7LSxDAhp9tZa0JqcCY0iPnf78E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=R4HiUbMMhUIzaLHsm6pWrpcp6Ha2TK0yGE+36dAHZVAOwNPSO/yPzngQpLPIKRT/b
	 65p7IvSooHn+o634evLkikUFAsk7abqzT1hsg00jlFipVevvyjNpcN4QlQtHc3UefK
	 4nyfzOV9An6w2Ykzsau7+ViQISqXKBUFFvbzVRQQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 079/271] udp: fix potential use-after-free in tunnel segmentation
Date: Mon, 17 Aug 2026 15:30:04 +0200
Message-ID: <20260817132539.987175106@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xuanqiang Luo <luoxuanqiang@kylinos.cn>

[ Upstream commit d0f86fb36eb260abd10007b62c9dcc1028e03e61 ]

__skb_udp_tunnel_segment() gets the UDP header before ensuring the
tunnel header is in the skb head. If the pull reallocates skb->head,
the saved UDP header pointer is no longer valid.

Get the UDP header after the pull to avoid a potential use-after-free.

Fixes: dbef491ebe7f ("udp: Use uh->len instead of skb->len to compute checksum in segmentation")
Signed-off-by: Xuanqiang Luo <luoxuanqiang@kylinos.cn>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Link: https://patch.msgid.link/20260730093554.68127-1-xuanqiang.luo@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 29651b1a0bc70..abcd3cc2d9a38 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -178,17 +178,19 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	int tnl_hlen = skb_inner_mac_header(skb) - skb_transport_header(skb);
 	bool remcsum, need_csum, offload_csum, gso_partial;
 	struct sk_buff *segs = ERR_PTR(-EINVAL);
-	struct udphdr *uh = udp_hdr(skb);
 	u16 mac_offset = skb->mac_header;
 	__be16 protocol = skb->protocol;
 	u16 mac_len = skb->mac_len;
 	int udp_offset, outer_hlen;
+	struct udphdr *uh;
 	__wsum partial;
 	bool need_ipsec;
 
 	if (unlikely(!pskb_may_pull(skb, tnl_hlen)))
 		goto out;
 
+	uh = udp_hdr(skb);
+
 	/* Adjust partial header checksum to negate old length.
 	 * We cannot rely on the value contained in uh->len as it is
 	 * possible that the actual value exceeds the boundaries of the
-- 
2.53.0



