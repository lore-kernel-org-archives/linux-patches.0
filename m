Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617888;
	b=a+MsclU7Jy040viDwotandCJRJ1p6DMBRg+HWNipciQGiAfUaQ8ANiC3M4U4v/1MRlJ3
	 sBFF60etn6F8r2ypr6uJ0ZoHvmvy7SFShMjzmPf5qw3XyV/JTXmwiTir7vSZXiC2Q27QL
	 8FLzM+c4PFI+a6jraOZvcuLEbZu1UcGufLdpOGfFn56GzCiHMy5zeBlGxOcjr8rAudT7q
	 M2RqmNXNEULNtpWz6faEuUIYVQfSDb/qIDKs9/lV++29CUCSp/5ytSj1dPiX8Mwlfg9zL
	 WExloEOa9vcw9uYaVwVcb5KjKWyh0lDRsZ/VSLz5Yg6TSYIJEwMObdUqw1dkhVp+eVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617888;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=jYzWaqs1OnZFE9c9UMYX3cKBzIQkDsM42YKtOxcUg3w=;
	b=RKL2r3Pq4wgUyl2fAMM9CV7Q899YTrExVMy6ULkIJ8jTaxU1EbAVo6o4CkhIoibRNPTG
	 849iLWsju5THfsgi7n0Er57rEosGAmnc22WnJGGFud2LdfTo2G8Uz1PAFaSdxi/B7Z3oI
	 KAeRkiSx093M3tv8KIkK9VBZTMq+d9D3jE5I8LKTOc8nqRoPgx9wkd7HUAeoSgxgur+MX
	 lgG5BTjHm45C3gB8mWLCJEgfDDlXlrkH5n+08ayWsn2RRmdJv3UjySz0G0+st2WodX2bJ
	 sCzNEuj3Yzo/hROBASlGrvlV+DCbgV/v8r9nEkJHIb02Br069IxVR75sPAKBG2voQCg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDN+cpdG;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF939606A32A;
	Wed, 25 Nov 2026 14:44:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BDN+cpdG
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07D11F0093C;
	Wed, 25 Nov 2026 14:44:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795617888;
	bh=jYzWaqs1OnZFE9c9UMYX3cKBzIQkDsM42YKtOxcUg3w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BDN+cpdGZgMgnTBxim1CN11rzuETNQbqnp7TIz/QtTsgTQ8aurALHLzb8sOwjcWrt
	 IX5s7xqxoL/1iiJrIaryV9gi8BJkYhaa7D/u6CKF8WZ2Ivx9KPkdr4tmUirrIjfg7+
	 evV3tyu1NJZFSkm0JcWjC33pD8O9581KbmGk82Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0106/1005] bpf: Dont let bpf_skb_adjust_room() raise gso_size to GSO_BY_FRAGS
Date: Wed, 25 Nov 2026 15:24:04 +0100
Message-ID: <20261125143824.230314074@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143821.729802100@linuxfoundation.org>
References: <20261125143821.729802100@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 0ad1507759ded..3f268e3aac56b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3762,6 +3762,14 @@ static int bpf_skb_net_shrink(struct sk_buff *skb, u32 off, u32 len_diff,
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



