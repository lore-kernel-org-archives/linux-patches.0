Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050744;
	b=DaRCafXxa28+tx9orXd75y5xI5Clmx6i5rE66rRV1aCt2ZdqFInmDFW1/4j4IXc2cJDh
	 xo1qujwO9rFS92UnLpMP1mR4ExL3khgslBjh10CB85+ZjDyTfX+nCJ7eQMqq47uFdsHUI
	 sO7fL2TfPiNpLF0yIhZIi9yGZs4Q8XXDfx1vCR1vcNLKIRo86nCu8QGnt2FWlok86FJva
	 eRPpLYLI7dfR9J4YYWorFNuRBCymssmBGZPf0RkCxOCj9wJtcc18It//yDSoz5bZ/mX2t
	 k15iuYCrgsCx4dp+F5CW3RD5FA9vTN0jRSg1Llli0zF87nlq8rx18nBaAIOWe7IT2hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050744;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=sBiIgbcOkL/6ccX0/M5NRtbug6Jr3/Gh4dY9pF8SwzI=;
	b=l1UGznHNde1CBlKOX1JmcPgJ0reyBhv1weF1PZClDA6KP/ceokh3OF9ypFqxXOpI8/AX
	 rb7VytKQVX/qvh55klxtlexjRgP6yv8/m3OjER607APiSZj8GomNW1OP1Z0C2ipiOfbmq
	 jz6TQa+LPlC0Z2EM/UnzJdHcgcJqer0HcuDRLO7981C/cLDUoSzpol0tmwcakgBC0ZdSN
	 fJ2ADFVq+J1jPpcXlpXYDLGGOxxTOlLwl0ydve/c/i+036qWJy9BqOqmoS3xz4U6Q3Mtd
	 bL7HNr4vi62octsqK9Vj3F2ThsIG86EiFe1PQwTTpE6TVdgSp7yjCdqiTfBRkqxuGHA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgoicUEL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9F6B606A330;
	Thu, 19 Nov 2026 01:12:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qgoicUEL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA4D01F000C7;
	Thu, 19 Nov 2026 01:12:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050744;
	bh=sBiIgbcOkL/6ccX0/M5NRtbug6Jr3/Gh4dY9pF8SwzI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qgoicUELE4GQO1t0/LMxdTtKrqOARFH3Cu+vmoehdTdVZeN1Jw/4SatatSLKVsK4t
	 5fZYw8K0eTxH0fNpE5T8jlAm+nQotOMkhMAA4XgTZCeE+EotFD1Y03RcamTVeBmgsh
	 21T8eI1QQVpbOnWW7DIgcFJBmWvd/ivVezmuQYLU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2817/2857] eth: bnxt: hand XDP frags over to the copybreak skb
Date: Wed, 18 Nov 2026 16:04:11 +0100
Message-ID: <20261118150343.027584140@linuxfoundation.org>
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
index bbb7b77a6b753..3519dd4c3d911 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1304,6 +1304,14 @@ static struct sk_buff *bnxt_copy_xdp(struct bnxt_napi *bnapi,
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



