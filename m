Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624150;
	b=IRkr7MakygtJUDta3PPr7+fCR6nDnQWh1YaRHDDjhu0wJJeC1OGje3FvNO3+oa6wXxq9
	 Nfym72QiR91dzctShhIoZdhAzvF62Y3RIfaL9BGlJuMWwNa7mrDfIkAXNbODZcUNzHqx1
	 /3v654oSgxXqioHyjH4lmEwK4E5K0g2+ivFyB6nkRA4ZbjYhncW3iLoaMzkEgFEkx4GNS
	 XQObAdQMwswH6yFeo1HPV8FxqxojI4tcwzHmQuZ1Ox72cpQTeKEuVciI2ROoYfIfrYMP4
	 f9veLsvIzv4UlQ6LlXSVKdlmKII0B0ZzHglsOGtNRbVZ9aZ5gtY7eOnWyAO9ni3MKOA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624150;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=EtVtyQEMHWJN7///fkUHorwFdYs3VmYkOAW2g+4L27Y=;
	b=TjTt+yUhNfY/Lej5CY+Cb2f0+rj/m0eOa+zSGBBcLwoTgKYhm74RuOCtC28C8724uSkD
	 gndboasrP8tJrr0USP+G3rS1BeztEM4BTsl+6w8roBCWDFyfX1TlwUWXbql9woFNLauKp
	 G+KRXzufo2FOXFzSEuwBkUt6Y34URSckAB5PSnQQKghDdpHr69FQ+GHRm8P/1NWs9uYRw
	 JDjoMnBB6IoPJzLz8W7i3nY+t+lObH7eeuStwRD0K1rLYOvBFTmIt2E/T7ZoJ9O8+LsUz
	 z5iAWjansg8T83QCbbaBNhTUpOEWmlMtA4LjrxvHsx6sqWnA8H+dRP5MZkAw6hlJTww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkpc+Ojr;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35157606A321;
	Wed, 25 Nov 2026 16:29:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qkpc+Ojr
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F5451F000C6;
	Wed, 25 Nov 2026 16:29:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624150;
	bh=EtVtyQEMHWJN7///fkUHorwFdYs3VmYkOAW2g+4L27Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkpc+OjrTL2TAOUBH5/d0ugU0NwpEqWPJHsUdJdj+xNAXOnoQ/BfeQJXv+Bm3jfgn
	 luVyZ9izPwKgmqT3DNc76Gu/+9qU5dyhExaz5hqhzyvOG+XBTeQ+X1FcYadfxuewt7
	 y5kb4FZbYtA7NnYiA5yTmWsnRhVldxLJflL5yUQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 101/816] bpf: Dont let bpf_skb_adjust_room() raise gso_size to GSO_BY_FRAGS
Date: Wed, 25 Nov 2026 15:27:29 +0100
Message-ID: <20261125143851.554426506@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 648e5b22ea58c..0f621e152b09a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3691,6 +3691,14 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
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



