Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042740;
	b=4rM/j4ZOaToTYtCHGTfIJsmr49IYf37Tw9ryLszaphrCFpywUusFbmMo/pvM01f6GEtx
	 bRP0Usdq1/H2cAFSnZjyGUiUvjtnJLwNvp/F9O+pS7UF338V4qfeXpOYHFGi/20ucSICF
	 whFmBbJHF9UAg9ZSU8WzuugJG58ZktKuABNCo1sU6UjvIailH3bKJaoZ9mDtZDxj9zQDh
	 98Lkdil5yDw52q3i7VNMVhmIJHHhA6d6xcHg71D1OaIXHn/EptqRQMLkV3Zzey7QweeHs
	 tVZhc3XF/nbS8j67+/LdMqW2XU+xguczz7Ognp0kUm2Rs1hBpsDYQNBMjaalpucZnnw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042740;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mmxOICTAMhAQ8DuKfnCdFGg0inRyHMHu3zIas24VDTM=;
	b=gEdncJIadGc1EXe7y+bB0olRNcsP4tVD/T6lRTMcY611Cl0KoIgAzhAzmAud1orRRRRh
	 4yXbdU5vb89PY1TZA0xnO1JoOYp2xDOe3ele9OMQNYyRRZvNg+afPH2f+irwUuGP/Bbdh
	 aL6cHW4J66AMyLM2pkIKWvjjXK2vB4L7Qqb3Bem0FNPiW7JvFjbC/3U6YGD4b4eJYVoJ8
	 yX/gZnx5R9/dftKwfEdGUyaoK1OdXsVkObBLOV1d6RcRHy1JpClHrs8V6sjCjV6PDkUTN
	 F/dyTAP8T4jV3cdh8+KkVR1P85m8K6kUVi0qkddMWsPLA2K+yv8Yr1YNkM21obVUQPg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Byy3lSpV;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CBC2606A31C;
	Wed, 18 Nov 2026 22:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Byy3lSpV
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B911F000C4;
	Wed, 18 Nov 2026 22:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042740;
	bh=mmxOICTAMhAQ8DuKfnCdFGg0inRyHMHu3zIas24VDTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Byy3lSpVK0PMjqlhLHxcfbDDI4Zs9Smhc8KYmHYsVA46meenOZBHhpoPm4/S0fdMY
	 dci7sBE5GOQ0yXVWOAIrkQK7TfpEszOhTUIYlHzp0JhRpTL8OW0s4RcGYTQMBbz6wc
	 91pzU35yJkqCxlCLBnrIZg+fAYtARm71sQhXrcKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3277/3318] eth: bnxt: hand XDP frags over to the copybreak skb
Date: Wed, 18 Nov 2026 16:04:59 +0100
Message-ID: <20261118150457.923071696@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 364b88b54fc260d22ee318bae862c2d7d8c31dc6 ]

With a multi-buffer XDP program attached, a packet only has agg
buffers if it filled its head buffer, which in page mode holds most
of a page. The program can still move the start of the packet forward
with bpf_xdp_adjust_head() and leave at most rx_copybreak bytes in the
head. bnxt_rx_pkt() then copies the head into a new skb, puts the head
page back on the ring, and calls bnxt_xdp_build_skb() on the copy.
bnxt_xdp_build_skb() only sets nr_frags and the skb's length
accounting, because it expects an skb built around the head page,
sharing its shinfo with the xdp_buff. The copy ends up with nr_frags
set but no frag descriptors, and the stack later reads and releases
whatever its frags array happens to contain. The real frags leak.

Copy the frag descriptors to the new skb in bnxt_copy_xdp(), so that
bnxt_xdp_build_skb() finds the frags where it expects them. The frags
now belong to the skb, and the head page goes back on the ring as
before.

Pointed out in LLM review of the first patch of the series.
Confirmed by reading the code, the unfixed kernel was not run with
the reproducer below.
Tested on a BCM57504 at MTU 9000 with rx-copybreak raised to 1024
and a frags-capable XDP program moving the start of multi-buffer
frames 3000B forward with bpf_xdp_adjust_head(), receiving 8000B
ICMPv6 echo requests (a head and two agg buffers each). All 60k
frames took the copybreak path with frags attached, the sampled skbs
reached GRO with len=4998 data_len=4492 nr_frags=2, and were freed by
the stack with the page pools' inflight count staying flat, no KASAN
or DEBUG_PAGEALLOC splats.

Fixes: 1dc4c557bfed ("bnxt: adding bnxt_xdp_build_skb to build skb from multibuffer xdp_buff")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261027234940.1267225-6-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 98ae70fcf8888..9751ddcf416c0 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1266,6 +1266,14 @@ static struct sk_buff *bnxt_copy_xdp(struct bnxt_napi *bnapi,
 		__skb_pull(skb, metasize);
 	}
 
+	if (unlikely(xdp_buff_has_frags(xdp))) {
+		struct skb_shared_info *sinfo;
+
+		sinfo = xdp_get_shared_info_from_buff(xdp);
+		memcpy(skb_shinfo(skb)->frags, sinfo->frags,
+		       sinfo->nr_frags * sizeof(skb_frag_t));
+	}
+
 	return skb;
 }
 
-- 
2.53.0



