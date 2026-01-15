Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F44B2D781B;
	Thu, 15 Jan 2026 17:09:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496975; cv=none; b=Sr1I4cWQLDpMusuJmQsApo3IGir+wZ6UyhD/dgDBWRUNvYlv5xcVobhmOw5vghfn9KZo4WBsFIdj3NGdOVPOMLaVae9H7bqngId2ICIsPoUDjQUnNiCKFKliKxgZUnwkcmSySsHIbLZ4ZW3X8+4ezQwc9RrEz1aPveFp21LMSLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496975; c=relaxed/simple;
	bh=kM1TTMMRt1ghz9jQrfGxC/5mt+5BzLn/HdtkfaSbxTE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r+3yhn4l9ZSlFPQoM0OkemG2Wn/4MzsdBcHs/qVitDG7PK4D/VRFIRfx0xeo7lODyt8PH2HV5kv2EbVgTaceNfh15HlPKFYjmaFnmtqYdBcFBIvSUw239tJ8LJ4usuh2bMGeYxQMxQrq9crdqXK3PAWuiGfJPPp22uXLO+25G+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NxUQvNo1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NxUQvNo1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE6ACC116D0;
	Thu, 15 Jan 2026 17:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496975;
	bh=kM1TTMMRt1ghz9jQrfGxC/5mt+5BzLn/HdtkfaSbxTE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NxUQvNo1oueTH+J2dXv0u84Y5HjWuD/B5dbusugoKodGQ8JFImR6FBaB7RdqJXTBR
	 9l32hEjhu8r8Sp5mtWoMa2haM9LBVADfxARYEA2KVjr2gOGSnn/2I0b49yimUEAWvs
	 ZRvet/sUIglgWjRx7fiS3ArxxQrabZvvd6nQepbo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 74/88] bpf: Make variables in bpf_prog_test_run_xdp less confusing
Date: Thu, 15 Jan 2026 17:48:57 +0100
Message-ID: <20260115164148.997758425@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164146.312481509@linuxfoundation.org>
References: <20260115164146.312481509@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Amery Hung <ameryhung@gmail.com>

[ Upstream commit 7eb83bff02ad5e82e8c456c58717ef181c220870 ]

Change the variable naming in bpf_prog_test_run_xdp() to make the
overall logic less confusing. As different modes were added to the
function over the time, some variables got overloaded, making
it hard to understand and changing the code becomes error-prone.

Replace "size" with "linear_sz" where it refers to the size of metadata
and data. If "size" refers to input data size, use test.data_size_in
directly.

Replace "max_data_sz" with "max_linear_sz" to better reflect the fact
that it is the maximum size of metadata and data (i.e., linear_sz). Also,
xdp_rxq.frags_size is always PAGE_SIZE, so just set it directly instead
of subtracting headroom and tailroom and adding them back.

Signed-off-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20250922233356.3356453-6-ameryhung@gmail.com
Stable-dep-of: e558cca21779 ("bpf, test_run: Subtract size of xdp_frame from allowed metadata size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 26 +++++++++++++-------------
 1 file changed, 13 insertions(+), 13 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 373ccb243545f..1e598c858a145 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1144,9 +1144,9 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 {
 	bool do_live = (kattr->test.flags & BPF_F_TEST_XDP_LIVE_FRAMES);
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	u32 retval = 0, duration, max_linear_sz, size;
+	u32 linear_sz = kattr->test.data_size_in;
 	u32 batch_size = kattr->test.batch_size;
-	u32 retval = 0, duration, max_data_sz;
-	u32 size = kattr->test.data_size_in;
 	u32 headroom = XDP_PACKET_HEADROOM;
 	u32 repeat = kattr->test.repeat;
 	struct netdev_rx_queue *rxqueue;
@@ -1183,7 +1183,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	if (ctx) {
 		/* There can't be user provided data before the meta data */
-		if (ctx->data_meta || ctx->data_end != size ||
+		if (ctx->data_meta || ctx->data_end != kattr->test.data_size_in ||
 		    ctx->data > ctx->data_end ||
 		    unlikely(xdp_metalen_invalid(ctx->data)) ||
 		    (do_live && (kattr->test.data_out || kattr->test.ctx_out)))
@@ -1192,30 +1192,30 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		headroom -= ctx->data;
 	}
 
-	max_data_sz = PAGE_SIZE - headroom - tailroom;
-	if (size > max_data_sz) {
-		/* disallow live data mode for jumbo frames */
-		if (do_live)
-			goto free_ctx;
-		size = max_data_sz;
-	}
+	max_linear_sz = PAGE_SIZE - headroom - tailroom;
+	linear_sz = min_t(u32, linear_sz, max_linear_sz);
+
+	/* disallow live data mode for jumbo frames */
+	if (do_live && kattr->test.data_size_in > linear_sz)
+		goto free_ctx;
 
-	data = bpf_test_init(kattr, size, max_data_sz, headroom, tailroom);
+	data = bpf_test_init(kattr, linear_sz, max_linear_sz, headroom, tailroom);
 	if (IS_ERR(data)) {
 		ret = PTR_ERR(data);
 		goto free_ctx;
 	}
 
 	rxqueue = __netif_get_rx_queue(current->nsproxy->net_ns->loopback_dev, 0);
-	rxqueue->xdp_rxq.frag_size = headroom + max_data_sz + tailroom;
+	rxqueue->xdp_rxq.frag_size = PAGE_SIZE;
 	xdp_init_buff(&xdp, rxqueue->xdp_rxq.frag_size, &rxqueue->xdp_rxq);
-	xdp_prepare_buff(&xdp, data, headroom, size, true);
+	xdp_prepare_buff(&xdp, data, headroom, linear_sz, true);
 	sinfo = xdp_get_shared_info_from_buff(&xdp);
 
 	ret = xdp_convert_md_to_buff(ctx, &xdp);
 	if (ret)
 		goto free_data;
 
+	size = linear_sz;
 	if (unlikely(kattr->test.data_size_in > size)) {
 		void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
 
-- 
2.51.0



