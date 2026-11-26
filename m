Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704187;
	b=q6XG2LnSIYBBOTwWhq0P9P2bZswb4x+lZkmcR4lSZzRCekZU2TKrv+9TCVXE2qR2mwOR
	 L9COQ4ghjAhWGA2e25pRPGDYJ13xxLMdqlKTbRtNmhdKZK/6YBESalpRTg4WQ9/OJedZW
	 ML7EornzEIor/yzNMjzzK3tz3e4ZNx+AP6Dgyc63eo4a8zO/pjnsi5Mu33a1EHbHYuHqv
	 opLgU8GLOWX9Zf/TMhp8HHIHjNa7j5v0ggn0MXERe9cki+XcarNFuap+0ehcqEiB6gHa2
	 cmCuWyb8eJMO6Jshd375LMqFZ5ZHDaulN49IwWTAqetOCXoolAo6sBO32eiVt+pYszQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704187;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PIG7zJENGJcnogFsDtLx6rQeFxmqPv434XHCRSxMDSs=;
	b=mqqWi0yPOuE9VM2B4VRvlbBML7aPSQqb4MeJ3ldqhidItcTwC6f7gMfueWghN5JQbpY8
	 ZzHYeF2dLnzZXqIJR9o4/Qo+zaMcV6O4hZdmVPW85FA6vhYadmICNg2Eb0nox8yK3M4o3
	 /ICujG4CvXYL3HRuWj8ICoYcTirD9k5IkRxOf/ls4a072QgQgrRJCH2XTqHTqMT8+Xp2S
	 KYSJ5Pwq2jUjToG+AkDY2Uh7ArIthg4ou0Kro21NUL3zcxtDneD0F/dLj6zRTkApAv29M
	 vW0r0iZZIZr4f6U19hmgiTKzt66nXaHQz5FQ82izh+1qmopY1uewsRIB5C2WoPo9yHg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylCOZeYH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B930606A327;
	Thu, 26 Nov 2026 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ylCOZeYH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98D3D1F000CA;
	Thu, 26 Nov 2026 14:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704187;
	bh=PIG7zJENGJcnogFsDtLx6rQeFxmqPv434XHCRSxMDSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ylCOZeYH5BkslSbqaM3C/eDlBZq/QXewe/R4InKHNhLtEb3+vAprP2Num1qKS4ASZ
	 g7xf489x5Zb85UIrtS0ll8vsDDrJgez9T+yXJw5ObsITCIwgDDpyONLfnCVCj7sp8+
	 dYsQpLwjcQb47DlQKHgfcScIpgAYaV0boLbv4rtw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/265] bpf: Dont let bpf_skb_adjust_room() raise gso_size to GSO_BY_FRAGS
Date: Thu, 26 Nov 2026 15:36:05 +0100
Message-ID: <20261126143607.585476566@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126143605.076581697@linuxfoundation.org>
References: <20261126143605.076581697@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 6d8118937ba477e03fa2e94e9bd9abac7291a2a2 ]

When bpf_skb_adjust_room() shrinks a TCP GSO skb, it adds the number of
removed bytes to gso_size. gso_size has 16 bits, and nothing checks the
sum. Thus gso_size can wrap to 0 or to a small size, or it can be
GSO_BY_FRAGS. GSO_BY_FRAGS is not a size. It tells skb_segment() to read
the length of each segment from the frag_list. If the TCP GSO skb has no
frag_list, skb_segment() dereferences a NULL pointer.

Return -ENOTSUPP and do not change the skb if the sum is GSO_BY_FRAGS or
larger. With BPF_F_ADJ_ROOM_FIXED_GSO the helper does not change gso_size,
so it shrinks the skb as before.

Fixes: 2be7e212d541 ("bpf: add bpf_skb_adjust_room helper")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-16-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index a7897c1c5e388..da6cf7ef22976 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3648,6 +3648,14 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
 			return -ENOTSUPP;
 	}
 
+	/*
+	 * The MSS is raised by len_diff. It has 16 bits, and GSO_BY_FRAGS is
+	 * not a size.
+	 */
+	if (skb_is_gso(skb) && !(flags & BPF_F_ADJ_ROOM_FIXED_GSO) &&
+	    skb_shinfo(skb)->gso_size + len_diff >= GSO_BY_FRAGS)
+		return -ENOTSUPP;
+
 	ret = skb_unclone(skb, GFP_ATOMIC);
 	if (unlikely(ret < 0))
 		return ret;
-- 
2.53.0



