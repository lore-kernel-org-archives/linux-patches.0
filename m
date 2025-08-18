Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41F1E31E0FB;
	Mon, 18 Aug 2025 12:52:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755521548; cv=none; b=Y77uQyjR0hRdoA41qS04VPU3+4jxfI2fyvXl9tG9ZfU7xya91hZegcqCClcvq366msYuov2ugDi7rQhhZzgRNuZnOwfzC1wcaztpmk+Z7TiILM3uIzz2eTs6zZuEUxvtAFqkdZrrY+Ad5J9AZcBx7cSlXA5KTEg7P00TOGfVVks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755521548; c=relaxed/simple;
	bh=8HhEStNzJEjtjH7uN+bzAJNE372uU4CtVlhJoMTijH8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ify47OYt7pT/VCWjgdNeZ/ht0tJbSLoHA/Lkn/D+xeeIrDWpWSeYoYfuKzs4HSLYXhGeNGOQvn6eOP1IZARpOSO/AdimvxB0sgI4ITC9FN5iRrw3kA8RCQEBCsjBqtYkTVnmdZDYeVoU026lOJk5veZZyZKzbW0cb44+/qlQc9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gqEi45BO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gqEi45BO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D6F4C4CEEB;
	Mon, 18 Aug 2025 12:52:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755521548;
	bh=8HhEStNzJEjtjH7uN+bzAJNE372uU4CtVlhJoMTijH8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gqEi45BO9dfSF/96sd10KWc/KgCy4rCtoGzVQm3YV1HTNq3iG17lCzTOetttduSzC
	 1WUwW+CTaJJjJc/jQErL2a3Td7kEVPeUPEWPZMRWfbKHBAkOtup+UjPhhfSq9aWT44
	 evgBrArqotsx+Jo/3iufbVYK7fKOXbn151U+QKl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 054/444] udp: also consider secpath when evaluating ipsec use for checksumming
Date: Mon, 18 Aug 2025 14:41:20 +0200
Message-ID: <20250818124450.955922796@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sabrina Dubroca <sd@queasysnail.net>

[ Upstream commit 1118aaa3b35157777890fffab91d8c1da841b20b ]

Commit b40c5f4fde22 ("udp: disable inner UDP checksum offloads in
IPsec case") tried to fix checksumming in UFO when the packets are
going through IPsec, so that we can't rely on offloads because the UDP
header and payload will be encrypted.

But when doing a TCP test over VXLAN going through IPsec transport
mode with GSO enabled (esp4_offload module loaded), I'm seeing broken
UDP checksums on the encap after successful decryption.

The skbs get to udp4_ufo_fragment/__skb_udp_tunnel_segment via
__dev_queue_xmit -> validate_xmit_skb -> skb_gso_segment and at this
point we've already dropped the dst (unless the device sets
IFF_XMIT_DST_RELEASE, which is not common), so need_ipsec is false and
we proceed with checksum offload.

Make need_ipsec also check the secpath, which is not dropped on this
callpath.

Fixes: b40c5f4fde22 ("udp: disable inner UDP checksum offloads in IPsec case")
Signed-off-by: Sabrina Dubroca <sd@queasysnail.net>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/udp_offload.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/ipv4/udp_offload.c b/net/ipv4/udp_offload.c
index 5de47dd5e909..12ba1a8db93a 100644
--- a/net/ipv4/udp_offload.c
+++ b/net/ipv4/udp_offload.c
@@ -61,7 +61,7 @@ static struct sk_buff *__skb_udp_tunnel_segment(struct sk_buff *skb,
 	remcsum = !!(skb_shinfo(skb)->gso_type & SKB_GSO_TUNNEL_REMCSUM);
 	skb->remcsum_offload = remcsum;
 
-	need_ipsec = skb_dst(skb) && dst_xfrm(skb_dst(skb));
+	need_ipsec = (skb_dst(skb) && dst_xfrm(skb_dst(skb))) || skb_sec_path(skb);
 	/* Try to offload checksum if possible */
 	offload_csum = !!(need_csum &&
 			  !need_ipsec &&
-- 
2.50.1



