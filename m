Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624156;
	b=Gr4UJOQoKIZbH8e3sVGCjZuc+WWUVmE48wIhz8ytrtB02kHlP+MvtRNgAehTiEpQO1nX
	 jg0wgqZ1m1qjJzdqqAUExLrI6XIkqo6tIv9IfOlH/eJTvOGdU/gcExhTBxsrh7m2IRKnz
	 ldWlzAcsKwa7b+nmSci1iLo9wbZf1+ArRwN+nAfwD+fi3NRLJOmKiPjkyZqPuZh+PC3aT
	 pF6d5nJImiN/OGKM8CEUXgHI1UgjI7+xVl//wmfh2Vux4PCPz6CFqclTPCw+oYeiDNhMQ
	 cmSRNExoO9LW03kwf4+s/O2Bq3G5Tq3mpg9Ij3QbiihZN/W7o2GB0u53UNotWdtPMvg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624156;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=FTWf5/80APgUOKrNsNMVTLF71Y89AXwIVxbj5mDTUuo=;
	b=LNOZXWILVWOsQxM/w6qfGlYlQDPejw03XWBsl4rUrE1fK6oEEjuEk5lG+e05ICIcJx0W
	 DEuGfROVdOqiN6ikcIjaa7yn2tVatadOfHMjQmQAogP+VyXY6v0RhT1/CDkyN+8w/kawx
	 wI0VxvuIryLP1SeReAH+WJBp3SLCod4VdOhh5w1TGXhy6HI09Fepg4i2PrCRgI9Ap8ZoC
	 PQx4ah+laX54x9bLQvGfyLndQRkbylY+Mb9mOqqtAxBJf5MM7eI7f1u5fEbqe444H+BDw
	 dlG4CcXo9TmFBfxAc3YVKHBV2wAM9mQlZu0M6rDWPI/J4hwsjOp49fC+d5L0tANiNPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncC3t2aW;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E150606A31E;
	Wed, 25 Nov 2026 16:29:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ncC3t2aW
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA77E1F000C6;
	Wed, 25 Nov 2026 16:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624156;
	bh=FTWf5/80APgUOKrNsNMVTLF71Y89AXwIVxbj5mDTUuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ncC3t2aWfphORbmNCxe6K/UEwhPtAdS6+CNJ2amrTt3lbT6igJXi+BNkPi42Yi6Mn
	 glgdMuz9bDgbTx/Acyh6IArgTF2McbC7x3WTuTMuC09cxwlqzgcYbfde/jfA8sM6+3
	 YK4u0PK5C7opTeNGKKSMch4p6Zp8bh6L5iO6brMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/816] bpf: Limit the SRH length in bpf_lwt_seg6_adjust_srh()
Date: Wed, 25 Nov 2026 15:27:31 +0100
Message-ID: <20261125143851.599053936@linuxfoundation.org>
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

From: Chris Mason <mason@kernel.org>

[ Upstream commit ac159f39b252971141c49b68a27de0b637debfad ]

bpf_lwt_seg6_adjust_srh() lets an End.BPF prog change the size of the TLVs
in the SRH. The helper keeps the SRH length in srh_state->hdrlen, in bytes
and without the first 8 bytes. Later seg6_bpf_has_valid_srh() writes it to
srh->hdrlen, an 8-bit field in units of 8 bytes. But srh_state->hdrlen has
no upper limit, and the cast to u8 can truncate it. After that,
seg6_validate_srh() gets the SRH length from srh->hdrlen, and thus it can
accept the SRH. Then srh->hdrlen is too small, and a parser reads TLVs as
the subsequent header.

Return -EFAULT when the new srh_state->hdrlen is larger than 2040, the
largest length that srh->hdrlen can hold. To replace a TLV in the largest
SRH, a prog can no longer add bytes first. It must remove bytes first.

Fixes: fe94cc290f53 ("bpf: Add IPv6 Segment Routing helpers")
Signed-off-by: Chris Mason <mason@kernel.org>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261101190535.1454146-19-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4dbc3f091513b..e4930cd595350 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6776,6 +6776,9 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
 		return -EFAULT;
 	if (unlikely(len < 0 && (void *)((char *)ptr - len) > srh_end))
 		return -EFAULT;
+	/* The length field of the SRH has 8 bits, in units of 8 bytes. */
+	if (unlikely(len > (U8_MAX << 3) - srh_state->hdrlen))
+		return -EFAULT;
 
 	if (len > 0) {
 		ret = skb_cow_head(skb, len);
-- 
2.53.0



