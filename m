Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042735;
	b=DwMWI0ToPpiYm1TF9LC/nFw8+jfHM4SdP3OOAOWbdMS+wvu5LmIk/pMY2Uw9DHWFM1i6
	 ty28b5/tMphmpfc5cXdMV2yEnjygxquAUNZgHHb6D5LEZnnZYvixQzw4he/0jTTOeY+a1
	 uHO5vamqAuqcg5buMWX7xhxsFi7o+vx4j4Tq0oJp6T8es5vSEcerXwQ25gqgD/NlRcYwy
	 pYYnPYR67vosPBLj6fiTcGbhOkZ1bVAkRCiqT81y61d1WaQF7DSfpIoDOhBYrDRobEv7e
	 vBsDnkV6swEQAU1A92lrw+fmXQScn+xbXAKfa2W5G8QomHjrE+1IdcjpevqYHy2Jkvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042735;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+VYH5JRWjkPFKS8fktJqsGSzAx+VLMsUWQpvd+g9tuA=;
	b=5FJYPijrcn+wWW/51Ci/EJupEQ+gdGHzifLTSKXDKX+O/llB1DzsJ/B7cet93JVguU6Q
	 2YZyO0UkufdYDafKTVaW+VOprdxGzv3poa/Gh8hYzx3c8E3wyekUOExPrXQag+B7VJAx1
	 2WJzyUWxEj6rbk+VaC0/6gvkWAe5Z4rx7NksGiWek87NLEhwzRhIrLArvAoOjGbSFq35q
	 FrKQHHCeI6oE9rEbAHYqiIHYAt/LFV58Asi6f2RYH+UZfP6+IYtZxLd+zfkIxQILhwBlq
	 8YCDRmvCaFiicFlbf9lG6Pz3b+ofM25z92lTPtEo2VCOcenscTa34WZhNMNjcJ4ia1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eofab60f;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3061E606A320;
	Wed, 18 Nov 2026 22:58:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=eofab60f
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 819831F000C4;
	Wed, 18 Nov 2026 22:58:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042735;
	bh=+VYH5JRWjkPFKS8fktJqsGSzAx+VLMsUWQpvd+g9tuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eofab60fjCrMbWtQhXKjnYsr3Z2xD/YlPDhiy3THXRoM2GrjeKr8J5ubXlrLC/dIf
	 59s2yuZziyJ5N1p0YnjxRpJUuplDYnnss2ss5vu+/ltQx1AsFrf7+rpObmIEMloKRU
	 HAeI8wS2j2a5PRu0RaW+fUeR1AwBgGJ16Io1tf4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3275/3318] eth: bnxt: free XDP frags when xdp_do_redirect() fails
Date: Wed, 18 Nov 2026 16:04:57 +0100
Message-ID: <20261118150457.864221638@linuxfoundation.org>
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

[ Upstream commit c10f3420d59859df107838aa97b49357616d9b47 ]

When xdp_do_redirect() fails bnxt_rx_xdp() recycles the head page but
not the frags of a multi-buffer frame. Their agg ring slots have
already been refilled, so the pages leak, and the page pool can't be
destroyed until they are returned, which will never happen. Redirect
to an AF_XDP socket in copy mode fails this way with -ENOMEM whenever
the socket's fill ring runs out of buffers.
A socket bound without XDP_USE_SG also fails with -ENOSPC for every
frame that doesn't fit in a single chunk.

All the other drop paths in this function free the frags.

Pointed out in LLM review of the first patch of the series.
Tested on a BCM57504 at MTU 9000 by redirecting 60k 8000B ICMPv6
echo requests (a head and two agg buffers each) to lo, which can't
transmit XDP frames. The page pools' inflight count stayed flat
rather than growing by two pages per frame.

Fixes: a7559bc8c17c ("bnxt: support transmit and free of aggregation buffers")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261027234940.1267225-5-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
index 8a098b5884b9b..cc80e48477acb 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt_xdp.c
@@ -308,6 +308,7 @@ bool bnxt_rx_xdp(struct bnxt *bp, struct bnxt_rx_ring_info *rxr, u16 cons,
 
 		if (xdp_do_redirect(bp->dev, xdp, xdp_prog)) {
 			trace_xdp_exception(bp->dev, xdp_prog, act);
+			bnxt_xdp_buff_frags_free(rxr, xdp);
 			page_pool_recycle_direct(rxr->page_pool, page);
 			return true;
 		}
-- 
2.53.0



