Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625533;
	b=ZM/Y3KWxOVD7eI1qct4SYwF5JrDFSl1Kgn2NNPtrVgfUCw5mPA923fg8x09UcmH55Wjz
	 o4bp8iAu0ZoAG6yK9VKYCypxkJ/jcTfvt5pkyGQ/LzmigHFp34fB+4nVKrtZlAcgO3GMD
	 vv0j5HDNqAT7kPe9eiqxLShnYbTYD5UXyxzT6tQAxuW8u3iiLrOzVDv9+s1a/Z3VpSnY+
	 ZXP8LsH3/EcOcKEtkt5GH2wRe/15p8Bj6K+tU6If3XzH4umPXsDJK4ruVvsTumExXVYsb
	 wSpXn3RQxsJAbZk+IOwQRP1FyB8d6N7vvcXkVRhjsqiBpfAOce1qmu2Rom/gCHA+JUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625533;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v0ySe8rQVFZjfVMjBKYJeZfPyutTO9aCsZvq51mpp4A=;
	b=5Vwzuf8oSsWEFEVLwVPrKYEKJIC90u5kIQ+HP2lwrZAc3cgZ7ao5g7aCNnHqzHitGG1e
	 wIPExONl7eeT/fU1AsZ0rcXqve3wnbzXNX3hHswTC7MBA9f8xa/Bear/mEycyqKw9Fe9u
	 FNRHVBnfKiZ1drEmwfblYBvyxETvNLHQeg/oL2m4wafYouJmZpyu2AIRTNkf9wT6/K8VB
	 +Gp8CALYYBoVCQ628xMUocMTDvQvcQqiSAmSRYKvd57pYb8ytOsjZgEzbg2woCyoNE1yD
	 pjKapGU4RG6XR+8PKBt5d+d7FoiKb/0+DZAyDFDdQX/1UEUZiTq+JDAVLlLPZk46d/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5BlH8n7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC3B7606A31E;
	Wed, 25 Nov 2026 16:52:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5BlH8n7
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0C2901F000C4;
	Wed, 25 Nov 2026 16:52:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625532;
	bh=v0ySe8rQVFZjfVMjBKYJeZfPyutTO9aCsZvq51mpp4A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5BlH8n7JYBtyqFx2nXkiRxAir2Ur6mSlwPnnutzZwkvgwtg5LqyB7W6VdGxEEQnN
	 yAq6PXlxF9YrOib/sgIqtScSCx2mVSRE1xCJqjIvEVQoFA9BQlMpFWq8DfYoXM4Qwd
	 8sQDKzncAMtNzREYtso+gwrkmWLdyznWTDrsJQwE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Chan <michael.chan@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 547/816] eth: bnxt: dont leak buffers when XDP agg buffer allocation fails
Date: Wed, 25 Nov 2026 15:34:55 +0100
Message-ID: <20261125143901.847435346@linuxfoundation.org>
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
[ sashal: Replaced netmem-based helper names and &bnxt_xdp.xdp with the page-based __bnxt_rx_agg_pages()/bnxt_rx_agg_pages_xdp() calls and the local &xdp variable. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.c b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
index 5d6f24044fb63..51272fb72dca6 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.c
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.c
@@ -1297,16 +1297,19 @@ static u32 bnxt_rx_agg_pages_xdp(struct bnxt *bp,
 	struct skb_shared_info *shinfo = xdp_get_shared_info_from_buff(xdp);
 	u32 total_frag_len = 0;
 
-	if (!xdp_buff_has_frags(xdp))
+	if (!xdp_buff_has_frags(xdp)) {
+		xdp_buff_set_frags_flag(xdp);
 		shinfo->nr_frags = 0;
+	}
 
 	total_frag_len = __bnxt_rx_agg_pages(bp, cpr, shinfo,
 					     idx, agg_bufs, tpa, xdp);
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
 
@@ -2179,8 +2182,10 @@ static int bnxt_rx_pkt(struct bnxt *bp, struct bnxt_cp_ring_info *cpr,
 			u32 frag_len = bnxt_rx_agg_pages_xdp(bp, cpr, &xdp,
 							     cp_cons, agg_bufs,
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



