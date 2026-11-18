Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022311;
	b=449ySCYVEPAWA+09MoNGx38018apNL5KCWJnFCLZyr6JI/RKsjeLoPNg3HqeYoCA2gA8
	 ObYSCIiH6P4Ah7mIqduldU4jPvNzWlLKYZMmnnIeVbYAKszbzqjOGuABqnfG1DR/c7GQx
	 buAkqvnU728DrxggLZfoRTdA9hI5AwIxFcprpvSxwlRvwKQDHAgknUGb2P8/jvwZ6fz9S
	 Uhu87ikNzCSppCBqfmRceSdAdTli4njKkqayJtGFzKmHQDKgKrtErUQyBd+5Wwekki0pD
	 BsFJ6JCg9SdpSyje/xRp7v/IZhEnLsZp6tsufRyjzDX5v/HF7gRAiPwmVBanL6y7CDw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022311;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=OxVmfxbfJ2LCDQI/4hlkafSkaEhyKUpnxQtLPif1vlg=;
	b=xvpSG8l6plH2KRXynWiJsgOvHwuibRhc4JwST3tVkCi9KktKVjdAM20Vdw23j/r5x46R
	 vMnmV2ofOw1iXK0Nj3ZTpMeWqofiShisUdzCRPmBhU0TUfyDj9RJ9nwSf0L5tpBabp2QL
	 0OmU1u+tObsvogFDhjD9OpUSOlzPjsY4Z79BQ86wNhEk+ERvtlunESQ7eqe88OlvdQIbs
	 eKRU61QH6oeJ2zTa3uir007IMJZ/va5vvkq9bgS3AkqjEZIMyEMhGdGpaRqaWeq+PfKZz
	 /DpKOfJ4fDZe5RS1wSXYs37OTIRNXOmrPrCwoNqWJnKWN8KA302efeM6Oj3/9su5n9Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XUoDwFC+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C884606A32C;
	Wed, 18 Nov 2026 17:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=XUoDwFC+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D22411F000C8;
	Wed, 18 Nov 2026 17:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022311;
	bh=OxVmfxbfJ2LCDQI/4hlkafSkaEhyKUpnxQtLPif1vlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XUoDwFC+NVxrsQ4tl84iX8kviMUUq7Hl8ia+QmzFMnwuM44qR6HelEwFvIFY6WCJ/
	 DQshC7k6YqzPM4Tn/r1Zpnn9uRlSl+c31pC0Gvv5H/Rr8Da0HmgZ1mWalY6DI1gat1
	 CbVhIZK2KBKzcQguvpcahVK7ELMJSUtrk4K+aKZk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2616/2651] eth: bnxt: dont leak buffers when XDP agg buffer allocation fails
Date: Wed, 18 Nov 2026 16:04:16 +0100
Message-ID: <20261118150418.412232047@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 1b2f02fb4ba92d01603c8261c94be8d348de65b0 ]

If a replacement agg buffer can't be allocated for a packet received
with XDP attached, bnxt_rx_pkt() drops the packet without returning
its head buffer to the ring. The head buffer leaks, and since rx_prod
still advances, the device gets a BD with a stale DMA address which
points at a buffer the driver no longer owns. When that BD completes
the driver finds no buffer in the slot.

The agg buffers consumed before the failing one have already been
replaced on the agg ring, they are referenced only by the frags of
the xdp_buff, which nobody frees. bnxt_xdp_buff_frags_free() would
skip them since the frags flag is set only on success, so set it
upfront.

Pointed out in LLM review of the first patch of the series.
Tested on a BCM57504 at MTU 9000 with a frags-capable XDP_PASS
program, receiving 8000B ICMPv6 echo requests (a head and two agg
buffers each) while page_pool_alloc_netmems() called from
bnxt_rx_agg_netmems_xdp() failed half of the time (bpftrace
override()). 44.7k packets were dropped, the page pools' inflight
count stayed flat and there were no KASAN or DEBUG_PAGEALLOC splats.

Fixes: 4c6c123c9af9 ("bnxt: adding bnxt_rx_agg_pages_xdp for aggregated xdp")
Reviewed-by: Michael Chan <michael.chan@broadcom.com>
Link: https://patch.msgid.link/20261027234940.1267225-4-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 4f7d2e98adaaf..4c97610a93fc5 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1427,16 +1427,19 @@ static u32 bnxt_rx_agg_netmems_xdp(struct bnxt *bp,
 	struct skb_shared_info *shinfo = xdp_get_shared_info_from_buff(xdp);
 	u32 total_frag_len = 0;
 
-	if (!xdp_buff_has_frags(xdp))
+	if (!xdp_buff_has_frags(xdp)) {
+		xdp_buff_set_frags_flag(xdp);
 		shinfo->nr_frags = 0;
+	}
 
 	total_frag_len = __bnxt_rx_agg_netmems(bp, cpr, idx, agg_bufs, tpa,
 					       NULL, xdp);
-	if (total_frag_len) {
-		xdp_buff_set_frags_flag(xdp);
-		shinfo->nr_frags = agg_bufs;
-		shinfo->xdp_frags_size = total_frag_len;
+	if (!total_frag_len) {
+		bnxt_xdp_buff_frags_free(cpr->bnapi->rx_ring, xdp);
+		return 0;
 	}
+	shinfo->nr_frags = agg_bufs;
+	shinfo->xdp_frags_size = total_frag_len;
 	return total_frag_len;
 }
 
@@ -2293,8 +2296,10 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 							       cp_cons,
 							       agg_bufs,
 							       false);
-			if (!frag_len)
+			if (!frag_len) {
+				bnxt_reuse_rx_data(rxr, cons, data);
 				goto oom_next_rx;
+			}
 
 		}
 		xdp_active = true;
-- 
2.53.0



