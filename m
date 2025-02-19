Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 202201C3BF1;
	Wed, 19 Feb 2025 08:31:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739953889; cv=none; b=VFL+fPTfk8lvzbHd8nN7nA8hc3KS1w7mxnK67T5CKZY2dzsMOTBfzEEuMu5/A9Tma/+R7TIa7T/VEvfO26nAGK4xu+dfem22LoxOvnoGAJv5R+Gl9MnjYt+isB/2nlOWU6CzWeipGa75NaoP0Us1vEfDzMgFAza46KGEeHSwSm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739953889; c=relaxed/simple;
	bh=1/YIz8RTvk/6EWaPuU70+++OhBF8sOuE4D9RuOEZZiw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZxpB8hqqsCC+KQt09jNdbFo3tjPaOaYN3DFMmm6FXM3qrjVnm5hQXUYXJa4JvTvpeCaAgZVJI8VFrhRLzvgL+FAVKP4+19RV9FlzeaT+5PATKRnfAtN+9zztQTsSMhefYnfAYfBwGCHVo3JG2GiN7BMw4VCWIMkW2i8Szcsl13E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y9oAnIF/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y9oAnIF/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C620C4CED1;
	Wed, 19 Feb 2025 08:31:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739953888;
	bh=1/YIz8RTvk/6EWaPuU70+++OhBF8sOuE4D9RuOEZZiw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y9oAnIF/SHjLqyoa/VLatXRxBrqdut2gmnrjG+xIOiZDmkJCAS+GFi2KQjbx87Y+/
	 2zR0e0Nh+8fZ/B4Grho3lvSPPYAwYdL3aol/MAwEmJ/ckT/8qAnWMYvTZ3JGYBNHbt
	 DUepo/PM11vXlEqSqgXtFh+s/D1IMAj9iYTSLKhM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zdenek Bouska <zdenek.bouska@siemens.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Simon Horman <horms@kernel.org>,
	Florian Bezdeka <florian.bezdeka@siemens.com>,
	Song Yoong Siang <yoong.siang.song@intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 028/274] igc: Fix HW RX timestamp when passed by ZC XDP
Date: Wed, 19 Feb 2025 09:24:42 +0100
Message-ID: <20250219082610.637331972@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082609.533585153@linuxfoundation.org>
References: <20250219082609.533585153@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zdenek Bouska <zdenek.bouska@siemens.com>

[ Upstream commit 7822dd4d6d4bebca5045a395e1784ef09cae2d43 ]

Fixes HW RX timestamp in the following scenario:
- AF_PACKET socket with enabled HW RX timestamps is created
- AF_XDP socket with enabled zero copy is created
- frame is forwarded to the BPF program, where the timestamp should
  still be readable (extracted by igc_xdp_rx_timestamp(), kfunc
  behind bpf_xdp_metadata_rx_timestamp())
- the frame got XDP_PASS from BPF program, redirecting to the stack
- AF_PACKET socket receives the frame with HW RX timestamp

Moves the skb timestamp setting from igc_dispatch_skb_zc() to
igc_construct_skb_zc() so that igc_construct_skb_zc() is similar to
igc_construct_skb().

This issue can also be reproduced by running:
 # tools/testing/selftests/bpf/xdp_hw_metadata enp1s0
When a frame with the wrong port 9092 (instead of 9091) is used:
 # echo -n xdp | nc -u -q1 192.168.10.9 9092
then the RX timestamp is missing and xdp_hw_metadata prints:
 skb hwtstamp is not found!

With this fix or when copy mode is used:
 # tools/testing/selftests/bpf/xdp_hw_metadata -c enp1s0
then RX timestamp is found and xdp_hw_metadata prints:
 found skb hwtstamp = 1736509937.852786132

Fixes: 069b142f5819 ("igc: Add support for PTP .getcyclesx64()")
Signed-off-by: Zdenek Bouska <zdenek.bouska@siemens.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Reviewed-by: Florian Bezdeka <florian.bezdeka@siemens.com>
Reviewed-by: Song Yoong Siang <yoong.siang.song@intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_main.c | 21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_main.c b/drivers/net/ethernet/intel/igc/igc_main.c
index 27872bdea9bd1..d6c3147725b7e 100644
--- a/drivers/net/ethernet/intel/igc/igc_main.c
+++ b/drivers/net/ethernet/intel/igc/igc_main.c
@@ -2707,8 +2707,9 @@ static int igc_clean_rx_irq(struct igc_q_vector *q_vector, const int budget)
 }
 
 static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
-					    struct xdp_buff *xdp)
+					    struct igc_xdp_buff *ctx)
 {
+	struct xdp_buff *xdp = &ctx->xdp;
 	unsigned int totalsize = xdp->data_end - xdp->data_meta;
 	unsigned int metasize = xdp->data - xdp->data_meta;
 	struct sk_buff *skb;
@@ -2727,27 +2728,28 @@ static struct sk_buff *igc_construct_skb_zc(struct igc_ring *ring,
 		__skb_pull(skb, metasize);
 	}
 
+	if (ctx->rx_ts) {
+		skb_shinfo(skb)->tx_flags |= SKBTX_HW_TSTAMP_NETDEV;
+		skb_hwtstamps(skb)->netdev_data = ctx->rx_ts;
+	}
+
 	return skb;
 }
 
 static void igc_dispatch_skb_zc(struct igc_q_vector *q_vector,
 				union igc_adv_rx_desc *desc,
-				struct xdp_buff *xdp,
-				ktime_t timestamp)
+				struct igc_xdp_buff *ctx)
 {
 	struct igc_ring *ring = q_vector->rx.ring;
 	struct sk_buff *skb;
 
-	skb = igc_construct_skb_zc(ring, xdp);
+	skb = igc_construct_skb_zc(ring, ctx);
 	if (!skb) {
 		ring->rx_stats.alloc_failed++;
 		set_bit(IGC_RING_FLAG_RX_ALLOC_FAILED, &ring->flags);
 		return;
 	}
 
-	if (timestamp)
-		skb_hwtstamps(skb)->hwtstamp = timestamp;
-
 	if (igc_cleanup_headers(ring, desc, skb))
 		return;
 
@@ -2783,7 +2785,6 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 		union igc_adv_rx_desc *desc;
 		struct igc_rx_buffer *bi;
 		struct igc_xdp_buff *ctx;
-		ktime_t timestamp = 0;
 		unsigned int size;
 		int res;
 
@@ -2813,6 +2814,8 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 			 */
 			bi->xdp->data_meta += IGC_TS_HDR_LEN;
 			size -= IGC_TS_HDR_LEN;
+		} else {
+			ctx->rx_ts = NULL;
 		}
 
 		bi->xdp->data_end = bi->xdp->data + size;
@@ -2821,7 +2824,7 @@ static int igc_clean_rx_irq_zc(struct igc_q_vector *q_vector, const int budget)
 		res = __igc_xdp_run_prog(adapter, prog, bi->xdp);
 		switch (res) {
 		case IGC_XDP_PASS:
-			igc_dispatch_skb_zc(q_vector, desc, bi->xdp, timestamp);
+			igc_dispatch_skb_zc(q_vector, desc, ctx);
 			fallthrough;
 		case IGC_XDP_CONSUMED:
 			xsk_buff_free(bi->xdp);
-- 
2.39.5



