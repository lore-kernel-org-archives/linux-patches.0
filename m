Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1008F3EB7F8;
	Mon, 17 Aug 2026 13:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974889; cv=none; b=AJTVKw8hWgmmYwuA/yVKPB2HXAFhuUw0nXPdGN0S2iwu+PA2S5xFRbYvZ8Wq8wysJx+SUZhboh7XdmkYfhh2ERWNI/S0GHpRamU7LZvnZa3d6OyXHtGklFR57HEeFa6qNhdgijUAP1eA8F9nyrWN4ZF3426zkQMHljbIM6hU7YI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974889; c=relaxed/simple;
	bh=kFwp5XxuZ3n+B1J98iGK5gIMqu4dNClIJmXHgtG7oEs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D+6QnH/dkSgzML7UXIOks8h3hC+Z2NEI6CnsHCLl2HbgxMVtQuleh4CZKH+oFdAjV2zy2VhCkhytZlhB8vXOTvreWXb8NbC6qe+TV1A+cgqwcM6uMzOoMLDaStK0q9bV5zzEGAVPY+l7V5ont3WFBM12cWEAFXy1BaLdonR1w7A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e42dUVr8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e42dUVr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40C71F00A3D;
	Mon, 17 Aug 2026 13:54:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974885;
	bh=2TKcXLfbtj3xlhld36LMpJD3lOo2UpokBp3g/KQc/fs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e42dUVr8XSFENkAmCTcMffTkrfE0uMvCkzG8pEIIKZ8B2rhocId8BfIsxjVLdaXhP
	 9zzzcX5r9A7fS7XYhw5di4oyXgG2EFlKGvRSuvhdaQdwAk9y74TCbfr10qLuQtNGFP
	 vROmV8SOnRcdeR0PBotN5YUgwPZJTf+Y2rdfmf6c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xuanqiang Luo <luoxuanqiang@kylinos.cn>,
	Antoine Tenart <atenart@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 071/250] udp: fix potential use-after-free in tunnel segmentation
Date: Mon, 17 Aug 2026 15:30:32 +0200
Message-ID: <20260817132539.350899370@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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
index 589456bd8b5f1..4f7ae02df8d3a 100644
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



