Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAA2428EA59;
	Wed, 23 Apr 2025 15:07:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420843; cv=none; b=oack2yOZahhnDyPtfgzAJ3LCRpPn0y146noQiiApKW+QDIg5e7hAmQ2/p76gkC75lKWBloHuHZ+Cfva/0WV/JaHop0/HSCJv4sZH4SkDLwYOsK8f9JreWiz3rcjqpeSg6PqTadCtexuOXnLzA7qfprg1OPaU2BOpnIaZM06QVQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420843; c=relaxed/simple;
	bh=TphMF7AkjUGabbO97uaQOWlYgNA3XoFQxsDJp1+Znlo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=fF3fLLZRPa79rrhU78XpShARaWpIpH1uZTFjNIJRddQAcExj+ON3vKGeFUJtYJmBYIrVoo2bx8ldP7v3QVMD4feZyS03XT4GPgdY9lkj3zYGctul+GoQLvoPHcy2dCX7bFqn47tcpgh5oP1AewpiP82OkZHthKnHMM3ULCth3Ps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O616+EMz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O616+EMz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DD5DC4CEE2;
	Wed, 23 Apr 2025 15:07:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420842;
	bh=TphMF7AkjUGabbO97uaQOWlYgNA3XoFQxsDJp1+Znlo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O616+EMzSbRv5fVjVA4785myDqsLBoH/jperaMZfM0uXGwgQdlinURBDNolOrjggv
	 oA2pNk52EPAcpdwuX7L+dbAUay9t79U7t4ZCOlFv8UIpaAQDnUbn2m5Qv2SgUQvRit
	 HvOLad/rfniQAklDgqMPRJGvCmzi9atj+u2b+jnE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matt Moeller <moeller.matt@gmail.com>,
	=?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
	Willem de Bruijn <willemb@google.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 117/393] bpf: support SKF_NET_OFF and SKF_LL_OFF on skb frags
Date: Wed, 23 Apr 2025 16:40:13 +0200
Message-ID: <20250423142648.191165856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Willem de Bruijn <willemb@google.com>

[ Upstream commit d4bac0288a2b444e468e6df9cb4ed69479ddf14a ]

Classic BPF socket filters with SKB_NET_OFF and SKB_LL_OFF fail to
read when these offsets extend into frags.

This has been observed with iwlwifi and reproduced with tun with
IFF_NAPI_FRAGS. The below straightforward socket filter on UDP port,
applied to a RAW socket, will silently miss matching packets.

    const int offset_proto = offsetof(struct ip6_hdr, ip6_nxt);
    const int offset_dport = sizeof(struct ip6_hdr) + offsetof(struct udphdr, dest);
    struct sock_filter filter_code[] = {
            BPF_STMT(BPF_LD  + BPF_B   + BPF_ABS, SKF_AD_OFF + SKF_AD_PKTTYPE),
            BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, PACKET_HOST, 0, 4),
            BPF_STMT(BPF_LD  + BPF_B   + BPF_ABS, SKF_NET_OFF + offset_proto),
            BPF_JUMP(BPF_JMP + BPF_JEQ + BPF_K, IPPROTO_UDP, 0, 2),
            BPF_STMT(BPF_LD  + BPF_H   + BPF_ABS, SKF_NET_OFF + offset_dport),

This is unexpected behavior. Socket filter programs should be
consistent regardless of environment. Silent misses are
particularly concerning as hard to detect.

Use skb_copy_bits for offsets outside linear, same as done for
non-SKF_(LL|NET) offsets.

Offset is always positive after subtracting the reference threshold
SKB_(LL|NET)_OFF, so is always >= skb_(mac|network)_offset. The sum of
the two is an offset against skb->data, and may be negative, but it
cannot point before skb->head, as skb_(mac|network)_offset would too.

This appears to go back to when frag support was introduced to
sk_run_filter in linux-2.4.4, before the introduction of git.

The amount of code change and 8/16/32 bit duplication are unfortunate.
But any attempt I made to be smarter saved very few LoC while
complicating the code.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Link: https://lore.kernel.org/netdev/20250122200402.3461154-1-maze@google.com/
Link: https://elixir.bootlin.com/linux/2.4.4/source/net/core/filter.c#L244
Reported-by: Matt Moeller <moeller.matt@gmail.com>
Co-developed-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Maciej Żenczykowski <maze@google.com>
Signed-off-by: Willem de Bruijn <willemb@google.com>
Acked-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://lore.kernel.org/r/20250408132833.195491-2-willemdebruijn.kernel@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 80 ++++++++++++++++++++++++++---------------------
 1 file changed, 44 insertions(+), 36 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 84992279f4b10..39eef3370d800 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -211,24 +211,36 @@ BPF_CALL_3(bpf_skb_get_nlattr_nest, struct sk_buff *, skb, u32, a, u32, x)
 	return 0;
 }
 
+static int bpf_skb_load_helper_convert_offset(const struct sk_buff *skb, int offset)
+{
+	if (likely(offset >= 0))
+		return offset;
+
+	if (offset >= SKF_NET_OFF)
+		return offset - SKF_NET_OFF + skb_network_offset(skb);
+
+	if (offset >= SKF_LL_OFF && skb_mac_header_was_set(skb))
+		return offset - SKF_LL_OFF + skb_mac_offset(skb);
+
+	return INT_MIN;
+}
+
 BPF_CALL_4(bpf_skb_load_helper_8, const struct sk_buff *, skb, const void *,
 	   data, int, headlen, int, offset)
 {
-	u8 tmp, *ptr;
+	u8 tmp;
 	const int len = sizeof(tmp);
 
-	if (offset >= 0) {
-		if (headlen - offset >= len)
-			return *(u8 *)(data + offset);
-		if (!skb_copy_bits(skb, offset, &tmp, sizeof(tmp)))
-			return tmp;
-	} else {
-		ptr = bpf_internal_load_pointer_neg_helper(skb, offset, len);
-		if (likely(ptr))
-			return *(u8 *)ptr;
-	}
+	offset = bpf_skb_load_helper_convert_offset(skb, offset);
+	if (offset == INT_MIN)
+		return -EFAULT;
 
-	return -EFAULT;
+	if (headlen - offset >= len)
+		return *(u8 *)(data + offset);
+	if (!skb_copy_bits(skb, offset, &tmp, sizeof(tmp)))
+		return tmp;
+	else
+		return -EFAULT;
 }
 
 BPF_CALL_2(bpf_skb_load_helper_8_no_cache, const struct sk_buff *, skb,
@@ -241,21 +253,19 @@ BPF_CALL_2(bpf_skb_load_helper_8_no_cache, const struct sk_buff *, skb,
 BPF_CALL_4(bpf_skb_load_helper_16, const struct sk_buff *, skb, const void *,
 	   data, int, headlen, int, offset)
 {
-	__be16 tmp, *ptr;
+	__be16 tmp;
 	const int len = sizeof(tmp);
 
-	if (offset >= 0) {
-		if (headlen - offset >= len)
-			return get_unaligned_be16(data + offset);
-		if (!skb_copy_bits(skb, offset, &tmp, sizeof(tmp)))
-			return be16_to_cpu(tmp);
-	} else {
-		ptr = bpf_internal_load_pointer_neg_helper(skb, offset, len);
-		if (likely(ptr))
-			return get_unaligned_be16(ptr);
-	}
+	offset = bpf_skb_load_helper_convert_offset(skb, offset);
+	if (offset == INT_MIN)
+		return -EFAULT;
 
-	return -EFAULT;
+	if (headlen - offset >= len)
+		return get_unaligned_be16(data + offset);
+	if (!skb_copy_bits(skb, offset, &tmp, sizeof(tmp)))
+		return be16_to_cpu(tmp);
+	else
+		return -EFAULT;
 }
 
 BPF_CALL_2(bpf_skb_load_helper_16_no_cache, const struct sk_buff *, skb,
@@ -268,21 +278,19 @@ BPF_CALL_2(bpf_skb_load_helper_16_no_cache, const struct sk_buff *, skb,
 BPF_CALL_4(bpf_skb_load_helper_32, const struct sk_buff *, skb, const void *,
 	   data, int, headlen, int, offset)
 {
-	__be32 tmp, *ptr;
+	__be32 tmp;
 	const int len = sizeof(tmp);
 
-	if (likely(offset >= 0)) {
-		if (headlen - offset >= len)
-			return get_unaligned_be32(data + offset);
-		if (!skb_copy_bits(skb, offset, &tmp, sizeof(tmp)))
-			return be32_to_cpu(tmp);
-	} else {
-		ptr = bpf_internal_load_pointer_neg_helper(skb, offset, len);
-		if (likely(ptr))
-			return get_unaligned_be32(ptr);
-	}
+	offset = bpf_skb_load_helper_convert_offset(skb, offset);
+	if (offset == INT_MIN)
+		return -EFAULT;
 
-	return -EFAULT;
+	if (headlen - offset >= len)
+		return get_unaligned_be32(data + offset);
+	if (!skb_copy_bits(skb, offset, &tmp, sizeof(tmp)))
+		return be32_to_cpu(tmp);
+	else
+		return -EFAULT;
 }
 
 BPF_CALL_2(bpf_skb_load_helper_32_no_cache, const struct sk_buff *, skb,
-- 
2.39.5



