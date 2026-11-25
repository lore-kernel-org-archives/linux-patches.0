Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621115;
	b=oPDImzWV3iAkBi1oww+QP237PNdi/Snb30CDdlBITx7JAzq24MHbp5AAduKUpjc6qlG4
	 DHDj8HQVeoAaOvEJHjFDCl+ej9/Wnk57DZmOFy80jOT8M+mUXbergyz4M6oZwOcQfmaJg
	 SxKexaTH7P2W8tJ7L16ECPPVCL1rNYUfdWUIE0ArfxbnVLVZU00kgsQziQg6Z6iNhWoZY
	 bJzVSLpAtAfQEjy+pYh2gOALOiGc7vhD7freURpJcD5PR4FM1HS3Q9MqM9jdrH00oGmDO
	 ubs57X30FaONFAhvjOHBXjqL1zK4eWLeaIYv07y9XljZn7O2PP3k9/xzQFICYx7zSEA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621115;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=O9BharIbfPGgpPbaEedqlC2stTFn1sU2zghyyre4AzU=;
	b=YaUbpr9ZAMa4d6iaB5GtBKeV0dp9eCbm2bGlS9kQAAkTvZUy+iIE8B5uDizfcJ8Aaymc
	 k/z8cWixgvlf7Fe1PmsPruWAZ+2TP7Y4GWKu1g3AMVldmVrTBBe+wbGWu31Uo2+xn+s+P
	 B1V3/20j7RBZTBGoCWsVP9dsr1iZDiU/P/A1hdels8X4PNQmO9j/ttSTFNAppRffPkYeK
	 i4KkQpiUU/8TMMmiBBWFrR39dk7qwXw4VNbWwTsCZaao1FhmHmtofHMy+BgBb2WA4sMm+
	 R7UUJWnDh2w+gXSrL5FFLhr8jEHeFRCrrguweGflIbHXICFIf4x+ZBQPz1q3Ri/NZ1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="qgJb/8qE";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 168DA606A31E;
	Wed, 25 Nov 2026 15:38:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgJb/8qE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D3401F000C0;
	Wed, 25 Nov 2026 15:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621114;
	bh=O9BharIbfPGgpPbaEedqlC2stTFn1sU2zghyyre4AzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgJb/8qEc2iWbvSMcdtYnbCMLgV3QVqKHioZdHyY4WwiwWiyYJOVLIqfkvKXP2Y/6
	 7eubNI1950uOEbzrWGgM/7BC/Fxc7FdEECnyK/2Vi260CMPyVtO9Cpuu3EakSWJjpL
	 olMMd0JHFi3bC5wOOy4hWT6Jb342ZYbeqOA5e2zs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 127/990] bpf: Check the offset in bpf_skb_generic_{push,pop}()
Date: Wed, 25 Nov 2026 15:24:54 +0100
Message-ID: <20261125143825.062688174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit ee36c9aa44ef300cd651074bd97552b229337f85 ]

To make room for len bytes at offset off, bpf_skb_generic_push() moves the
first off bytes and clears len bytes after them. It assumes that the first
off bytes are in the linear part. But in bpf_skb_adjust_room() off can be
the end of the IP header, and this header can be in a frag. Then the
function reads and writes after skb->tail, and can damage skb_shared_info.

bpf_skb_generic_pop() checks off + len, but this u32 sum can wrap to a
small value. bpf_skb_adjust_room() and bpf_skb_change_proto() calculate off
from skb_mac_header_len(). This length is a very large u32 when
network_header < mac_header. Then the check can pass, and memmove() reads
and writes far outside the skb.

Return -ENOMEM from both functions, like the present check, when
off > skb->len. Thus the sum cannot wrap. In bpf_skb_generic_push() also
pull the first off bytes into the linear part. Now bpf_skb_adjust_room()
fails when a prog grows an skb that ends before off. network_header stays
wrong.

Fixes: 6578171a7ff0 ("bpf: add bpf_skb_change_proto helper")
Fixes: 2be7e212d541 ("bpf: add bpf_skb_adjust_room helper")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-28-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 503ca33402840..c6677657656c9 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3330,6 +3330,10 @@ static void bpf_skb_change_protocol(struct sk_buff *skb, u16 proto)
 
 static int bpf_skb_generic_push(struct sk_buff *skb, u32 off, u32 len)
 {
+	/* The bytes in front of @off are moved with skb->data. */
+	if (unlikely(off > skb->len || !pskb_may_pull(skb, off)))
+		return -ENOMEM;
+
 	/* Caller already did skb_cow() with meta_len+len as headroom,
 	 * so no need to do it here.
 	 */
@@ -3350,9 +3354,10 @@ static int bpf_skb_generic_pop(struct sk_buff *skb, u32 off, u32 len)
 	void *old_data;
 
 	/* skb_ensure_writable() is not needed here, as we're
-	 * already working on an uncloned skb.
+	 * already working on an uncloned skb. The first test
+	 * keeps off + len from wrapping.
 	 */
-	if (unlikely(!pskb_may_pull(skb, off + len)))
+	if (unlikely(off > skb->len || !pskb_may_pull(skb, off + len)))
 		return -ENOMEM;
 
 	old_data = skb->data;
-- 
2.53.0



