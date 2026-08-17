Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC7D421259;
	Mon, 17 Aug 2026 15:24:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786980258; cv=none; b=fifJdxScsPqePXjGmwABCVogrp/hA29CdmrJFbQTCD2T70bzckBzrINYKd7WbWGVBD2+rB2+VKYZIEGp4blYm6fr5B+Q5jHxl+ZtMn9X5FY+gnc4u1l15YzDDThcv8JL3LiF3ZCw17X1K6xmhywN1xdhVDHsW7L/PZuVKG1Mv/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786980258; c=relaxed/simple;
	bh=W4OamJtx4VaixNYLBDcey3jt3Xr+ZoqtbQqves7oQ3g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EqOef2TetB/W9hhEe/jzai65txSc036+mnmgK0VCjSEJdPZ86vao58lLOvJQ3hA+x4fsuBjW4qkk4ElqJ4muL+O4Lfgax9z6OAB3MAqFdasRzNHNmMMtr2WRiL+UK2TnBhtM01IGYEq0eR+X8I4K2nk919K8Vy+m/4Lbi5LvtEU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sRMmfsRa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sRMmfsRa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50D011F000E9;
	Mon, 17 Aug 2026 15:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786980256;
	bh=rSUdyr0PpqNyMg+FSYJhh2w6jdP8cdemp+7ap4dqoGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sRMmfsRar6vZyiW2N/l29Z9QXGaiqbdG1B3tYJOpxWtHsEwEQj/JSmkBBGQvHlMXd
	 3aVVt+Z3oV6Z1VMWtUwDwMmabr7r6KYoWR9gJLxpGLNAOeMH9zq7g1SJBCTXfqCw+c
	 MtPDlwTPabgVZro3TOo386d6Ren1BxPRachx8yQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 510/609] udp: fix potential use-after-free in tunnel segmentation
Date: Mon, 17 Aug 2026 15:33:26 +0200
Message-ID: <20260817132600.913824170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132543.039278408@linuxfoundation.org>
References: <20260817132543.039278408@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 35c014e10f24b..60fbb4ca34e00 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -21,17 +21,19 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
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



