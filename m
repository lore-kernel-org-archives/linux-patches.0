Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050213;
	b=MpTFYGXHoPf8v7a+07+2dRdIqyxgrEJekhFCb5y3ZNm88fW52CzLZg55U8Ew8sL7M9/1
	 R2SvbxgdrE90eIPVrkJxjSNwyBSaGgVFE2w91xRj/aDgO49O4VcJU7sbaHUTWBYiyf6dq
	 zHh5lTRP672GPSdn14usWcedGulsrtpPo9nxHw24aSnBDcj15AGY99hZRZZXbYupUVJia
	 cZEmIspesb9LJl3oiiAe5YTcPUJKKuGdXX6ygq/cVATJ/dK1XWYDMG4q7QM9zFoqPJbQh
	 g87WtKBJyXzeejDCB0MGJ7lHBjS2G0K7pvjP77Moz4e0DVw81PNt4Z13c2GKDL3VKdw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050213;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=vHA4LYShRjPNizIDH/KiZ9Sz5CUXUqKHLL3okQAqNM4=;
	b=X9m6INA1k0zXgFjLwJyrcRGfzEMCtNqEv1MQKurJFYf6LVefzTxfLrI8iK29GqxiB21z
	 KDMiCrC2Ur1lN/CyV32uGC/og0k8FM/zO3zchmLMJfm4TkwzGKs1GqosECHCvRMfCS3It
	 hmcPyJDtvBh32roe6jdnJIxPNG3XLw9Xhvd+nCwEzkmwR53tsgl3c0SmQ4/y1XxU4feKi
	 d60iNODIgtJG48bTtH755aSNBOkhwSYUMpDoVPE0bhdsd0rE2U84kpz4JKowpUl23RMFJ
	 KGNQSf4ijew7fj0z7Z2YYr5ORdyhKjgCz2UKx9ZTHF7QYi+FT8MtDsDYLpGCrPu/TAA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHIm1+Ha;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 957C1606A32C;
	Thu, 19 Nov 2026 01:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=zHIm1+Ha
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDEB71F000C4;
	Thu, 19 Nov 2026 01:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050213;
	bh=vHA4LYShRjPNizIDH/KiZ9Sz5CUXUqKHLL3okQAqNM4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=zHIm1+HaDWxaXcZTMpG4mrzMUVtklpCF5yL7a9dSOaf8zK/Phv8tmRDTSDCSyTjqQ
	 JYL2i7vW7Yfm1W5buUQPhZpbETgB7jt7pe5bioZVgrLYhWd72gJYp5CBEKjTXeKKHP
	 /g2rvHWUrFiTaAUNQjWc+a6HVl/b4VFxrvGy5x1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josef Bacik <josef@toxicpanda.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2587/2857] bpf: Dont let bpf_skb_adjust_room() use up the MSS
Date: Wed, 18 Nov 2026 16:00:21 +0100
Message-ID: <20261118150334.663524404@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit 12d07c38e1b0f79e48a37abd7103194212f2da8c ]

When bpf_skb_adjust_room() grows a TCP GSO packet without
BPF_F_ADJ_ROOM_FIXED_GSO, gso_size is lowered by the number of bytes
added. Nothing looks at how large it is.

gso_size is the size of the segments the peer has sent if the packet
comes out of GRO, and what the sender has written into the virtio header
if it comes from a tun device or a packet socket. If it equals len_diff
the result is 0, and a packet of up to 64 KB is no GSO packet any more. If
it is smaller, the 16 bit value wraps around.

One less than len_diff gives GSO_BY_FRAGS. skb_segment() then takes the
length of each segment from the frag_list. A packet with more than 64 KB
of payload gets that far, and one from a tun device has no frag_list:

  BUG: KASAN: null-ptr-deref in skb_segment+0xcf1/0x1a90
  BUG: kernel NULL pointer dereference, address: 0000000000000070
   tcp_gso_segment+0x1be/0x9f0
   inet_gso_segment+0x288/0x740
   inet_gso_segment+0x288/0x740
   skb_mac_gso_segment+0x179/0x2e0

What is left must not be less than TCP_MIN_GSO_SIZE either. The stack
relies on that for the number of segments to fit into gso_segs, see
commit c27c449d455a ("virtio-net: Ensure that TCP packets don't overflow
gso_segs").

Refuse to grow a packet that would end up with less, with the error that
other packets which cannot be adjusted get.

Fixes: 2be7e212d541 ("bpf: add bpf_skb_adjust_room helper")
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017163745.3341787-9-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/filter.c b/net/core/filter.c
index 6c87f72d15b4d..fda221890bba5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -3532,6 +3532,14 @@ static int bpf_skb_net_grow(struct sk_buff *skb, u32 off, u32 len_diff,
 			return -ENOTSUPP;
 	}
 
+	/*
+	 * The MSS is lowered by len_diff. Leave the least that the stack lets a
+	 * TCP GSO packet have, or gso_segs can overflow.
+	 */
+	if (skb_is_gso(skb) && !(flags & BPF_F_ADJ_ROOM_FIXED_GSO) &&
+	    skb_shinfo(skb)->gso_size < len_diff + TCP_MIN_GSO_SIZE)
+		return -ENOTSUPP;
+
 	ret = skb_cow_head(skb, meta_len + len_diff);
 	if (unlikely(ret < 0))
 		return ret;
-- 
2.53.0



