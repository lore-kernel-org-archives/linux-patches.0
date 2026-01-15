Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D34396B7D;
	Thu, 15 Jan 2026 17:04:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496685; cv=none; b=qYGHxlEW5geN18ISwSy+YnGPiXk5EtFT8JwNQN7+7UU3cCveNHv964GKP2xQVlAq4ptX/KXQl/admmLoWTANkJ6J3wcxC14jsIvNbGkMwLI2+8DcRnnTyBqdFKNqXYNMdHluAALmQiQYQpagGseFhi38e3Puf3m1Y2Kr9EQsXIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496685; c=relaxed/simple;
	bh=6304m6usle0uJoivSqNSJg2YRsR3ulcvOjjM1ARVDng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hSlUFPEcaci3UTEsheGTPyxqUlX/yOjhjtPOWrXDsdkRQOSZtFDTvDVIDeF1c4YnUezACIchsLPc8M8+83/1VSj97S9l6cilyfLzDsla+nnHRCmiu6VQM1PG3puW3EgSNYERSCvpWTksrFLbf4VaW1rvAieITlik5wmHyUZaeL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BVg9R8Dw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BVg9R8Dw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D670C116D0;
	Thu, 15 Jan 2026 17:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496685;
	bh=6304m6usle0uJoivSqNSJg2YRsR3ulcvOjjM1ARVDng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVg9R8DwzzwNdqE8jSkTX+CyHeAYRRFHwYzIq5Ga+b6AwLqZUp1YHkjcD+6ey7KAt
	 PfLA5R0Z5vYkdkO1/7RqKAsVOBZHZ9iqvwTduyrL67lvVhztbahzThabUx6Fnu1I7F
	 HpAMw6Hq4TcMuvXQbKGImKPlerYuj41IFHm+PY3E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 098/119] bpf: Make variables in bpf_prog_test_run_xdp less confusing
Date: Thu, 15 Jan 2026 17:48:33 +0100
Message-ID: <20260115164155.491181318@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 6418846d6bc65..c8b8ac6ecbc20 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -1200,9 +1200,9 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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
@@ -1239,7 +1239,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	if (ctx) {
 		/* There can't be user provided data before the meta data */
-		if (ctx->data_meta || ctx->data_end != size ||
+		if (ctx->data_meta || ctx->data_end != kattr->test.data_size_in ||
 		    ctx->data > ctx->data_end ||
 		    unlikely(xdp_metalen_invalid(ctx->data)) ||
 		    (do_live && (kattr->test.data_out || kattr->test.ctx_out)))
@@ -1248,30 +1248,30 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
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



