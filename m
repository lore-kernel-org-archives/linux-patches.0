Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704970;
	b=yjh7oIkQc02YIt15GyfEqUFcRt8QgZZ/dOGz2ECzZaaFBN9geqK4f5s8+D8Y2k3eF3sP
	 kmBzbeIALGH0D/tBLiRrGTZE4Uuk1QVXtTaZnlkrFix5ohN7GRLIdJ8dgj8B4oqYTAm78
	 zTZEkOPbuVON1BAbv0LSutn0KoJGFJmA7a+HzKT+fOatL6kC3CVx/E3N/wZiIVNierJEl
	 bZWQ31Zodui3lozMMpbh7iTL0YPdCA3UIDR5gfEFEgVkM+EASOzuct6BgSrtBOhBFfppZ
	 VUMzIN+WVfOJOSqt/fTy/TQvqbmwpWLMPk0KfvHZ2Imou9wOzVprGPjMn6oxXH75R4A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704970;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=7+ksaa3tcDO6oDi1Qcg0V02WNPK3qrE2qW2zypeAMMs=;
	b=t3PN/9GawshcxuaVUIlWz4NPPx2ykr+U/AV8tG5iUTNrmNY6LubAUnz0mdN6hUITxJL9
	 rLWl+00JmcnJD3vcNQfDZ6ZkeBQYtDWD58FdBSDg3/icaagjjw24GAdKRHAMqyNObm41I
	 +UreLfJC3MBUmA1hsD3oKEcimqOhXD2r7W2Mjfk2AGviC/L24YHJze4bDW0yTE/U5qJxV
	 yFF6xz1P9Hq/R/Upq3vkGRiOAr2omdZdpf9SN7L0C8JGYbUE/tmKnOw9Vd+vwmfvP0mU6
	 o/PBJa4W9pzytttTxckpbt1WHRKcJAOIhXMMX/JMcc8yjz0vj8ehD+SxI/2tQYotKSw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFZeqiWV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3080606A31E;
	Thu, 26 Nov 2026 14:56:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=aFZeqiWV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE7D31F000D8;
	Thu, 26 Nov 2026 14:56:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795704970;
	bh=7+ksaa3tcDO6oDi1Qcg0V02WNPK3qrE2qW2zypeAMMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aFZeqiWVwTzkHmcYNVutCmvgvXNr8bzo1WmEUwBxnaXn4p4EbDSaFoQ1/nVvCDtob
	 o9CB9kXpozi0UsPjQaBZNBle0WbOZUqhCJT0l+EG7vClQZ4KoApV5u9t6BuaXPbU0W
	 3HSmK7V+VoCrzMiQg3sdyzVcpnHSrZtHC8bDa4Uw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 039/319] bpf: Limit the SRH length in bpf_lwt_seg6_adjust_srh()
Date: Thu, 26 Nov 2026 15:36:47 +0100
Message-ID: <20261126144007.620510371@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 0ecd9f8ac2e80..07e60e4d9886a 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6337,6 +6337,9 @@ BPF_CALL_3(bpf_lwt_seg6_adjust_srh, struct sk_buff *, skb, u32, offset,
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



