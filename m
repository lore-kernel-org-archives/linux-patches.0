Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA8092C0285;
	Thu, 15 Jan 2026 17:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496688; cv=none; b=CEmWzXHmw8JwAfQF91uU+74N6EVd47TU9zI6QZlw8Zd2bajOBmSqjptJvqQmrBEYUAHNEv+8IfdTDBFiURkQ5icoW/bmTi0T5LUNFEso/wrFfcc9txpzXWM/+wmD3L9sQZA3Zda+ppcrnDxfW10eRxuKfiX/97UKKw6xGboBAnA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496688; c=relaxed/simple;
	bh=T0K+lEraQJSHZFNKerw4xjHr3oVqgrNMppsTcJNnjLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ltFTBRs7uaJz/Xa8QuBXLMnSK5+rlAsBHUFto27jMUiXDe4NQRirBSZwXTv0Ofimd5jY2YqWsOaSsE+hHoM5nwXRiM3YZVjMSLBqRkceQMSj38F2TIsDTtLCavi92qLLvIW698pG4LLJkabIbQHDtxY0Moq2nOp/O4S3QCcRlQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGCF2JFS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGCF2JFS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F00EFC116D0;
	Thu, 15 Jan 2026 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496688;
	bh=T0K+lEraQJSHZFNKerw4xjHr3oVqgrNMppsTcJNnjLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lGCF2JFSuzwIcEAgUBx91BBd2HPp3K+5dRbYf5l6IP68vr828Dd8w+SSr79I6eLXB
	 4RhBJz7LvC8YqB50SgotC9gV4ZPof7+K4dXIELxCdzjcJaAcTSOWxohH1+3FSN76Mh
	 g3/18S4bTpmaO5BTdPDdnWgdx/7qb1HVhjzjA1PQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <ameryhung@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 099/119] bpf: Support specifying linear xdp packet data size for BPF_PROG_TEST_RUN
Date: Thu, 15 Jan 2026 17:48:34 +0100
Message-ID: <20260115164155.526773667@linuxfoundation.org>
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

[ Upstream commit fe9544ed1a2e9217b2c5285c3a4ac0dc5a38bd7b ]

To test bpf_xdp_pull_data(), an xdp packet containing fragments as well
as free linear data area after xdp->data_end needs to be created.
However, bpf_prog_test_run_xdp() always fills the linear area with
data_in before creating fragments, leaving no space to pull data. This
patch will allow users to specify the linear data size through
ctx->data_end.

Currently, ctx_in->data_end must match data_size_in and will not be the
final ctx->data_end seen by xdp programs. This is because ctx->data_end
is populated according to the xdp_buff passed to test_run. The linear
data area available in an xdp_buff, max_linear_sz, is alawys filled up
before copying data_in into fragments.

This patch will allow users to specify the size of data that goes into
the linear area. When ctx_in->data_end is different from data_size_in,
only ctx_in->data_end bytes of data will be put into the linear area when
creating the xdp_buff.

While ctx_in->data_end will be allowed to be different from data_size_in,
it cannot be larger than the data_size_in as there will be no data to
copy from user space. If it is larger than the maximum linear data area
size, the layout suggested by the user will not be honored. Data beyond
max_linear_sz bytes will still be copied into fragments.

Finally, since it is possible for a NIC to produce a xdp_buff with empty
linear data area, allow it when calling bpf_test_init() from
bpf_prog_test_run_xdp() so that we can test XDP kfuncs with such
xdp_buff. This is done by moving lower-bound check to callers as most of
them already do except bpf_prog_test_run_skb(). The change also fixes a
bug that allows passing an xdp_buff with data < ETH_HLEN. This can
happen when ctx is used and metadata is at least ETH_HLEN.

Signed-off-by: Amery Hung <ameryhung@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20250922233356.3356453-7-ameryhung@gmail.com
Stable-dep-of: e558cca21779 ("bpf, test_run: Subtract size of xdp_frame from allowed metadata size")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c                                | 15 ++++++++++++---
 .../bpf/prog_tests/xdp_context_test_run.c         |  4 +---
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index c8b8ac6ecbc20..318ffd55cf608 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -660,7 +660,7 @@ static void *bpf_test_init(const union bpf_attr *kattr, u32 user_size,
 	void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
 	void *data;
 
-	if (user_size < ETH_HLEN || user_size > PAGE_SIZE - headroom - tailroom)
+	if (user_size > PAGE_SIZE - headroom - tailroom)
 		return ERR_PTR(-EINVAL);
 
 	size = SKB_DATA_ALIGN(size);
@@ -995,6 +995,9 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	    kattr->test.cpu || kattr->test.batch_size)
 		return -EINVAL;
 
+	if (size < ETH_HLEN)
+		return -EINVAL;
+
 	data = bpf_test_init(kattr, kattr->test.data_size_in,
 			     size, NET_SKB_PAD + NET_IP_ALIGN,
 			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
@@ -1200,7 +1203,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 {
 	bool do_live = (kattr->test.flags & BPF_F_TEST_XDP_LIVE_FRAMES);
 	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
-	u32 retval = 0, duration, max_linear_sz, size;
+	u32 retval = 0, meta_sz = 0, duration, max_linear_sz, size;
 	u32 linear_sz = kattr->test.data_size_in;
 	u32 batch_size = kattr->test.batch_size;
 	u32 headroom = XDP_PACKET_HEADROOM;
@@ -1239,13 +1242,16 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	if (ctx) {
 		/* There can't be user provided data before the meta data */
-		if (ctx->data_meta || ctx->data_end != kattr->test.data_size_in ||
+		if (ctx->data_meta || ctx->data_end > kattr->test.data_size_in ||
 		    ctx->data > ctx->data_end ||
 		    unlikely(xdp_metalen_invalid(ctx->data)) ||
 		    (do_live && (kattr->test.data_out || kattr->test.ctx_out)))
 			goto free_ctx;
 		/* Meta data is allocated from the headroom */
 		headroom -= ctx->data;
+
+		meta_sz = ctx->data;
+		linear_sz = ctx->data_end;
 	}
 
 	max_linear_sz = PAGE_SIZE - headroom - tailroom;
@@ -1255,6 +1261,9 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (do_live && kattr->test.data_size_in > linear_sz)
 		goto free_ctx;
 
+	if (kattr->test.data_size_in - meta_sz < ETH_HLEN)
+		return -EINVAL;
+
 	data = bpf_test_init(kattr, linear_sz, max_linear_sz, headroom, tailroom);
 	if (IS_ERR(data)) {
 		ret = PTR_ERR(data);
diff --git a/tools/testing/selftests/bpf/prog_tests/xdp_context_test_run.c b/tools/testing/selftests/bpf/prog_tests/xdp_context_test_run.c
index e6a783c7f5db9..cd43d6616dd2d 100644
--- a/tools/testing/selftests/bpf/prog_tests/xdp_context_test_run.c
+++ b/tools/testing/selftests/bpf/prog_tests/xdp_context_test_run.c
@@ -80,9 +80,7 @@ void test_xdp_context_test_run(void)
 	/* Meta data must be 255 bytes or smaller */
 	test_xdp_context_error(prog_fd, opts, 0, 256, sizeof(data), 0, 0, 0);
 
-	/* Total size of data must match data_end - data_meta */
-	test_xdp_context_error(prog_fd, opts, 0, sizeof(__u32),
-			       sizeof(data) - 1, 0, 0, 0);
+	/* Total size of data must be data_end - data_meta or larger */
 	test_xdp_context_error(prog_fd, opts, 0, sizeof(__u32),
 			       sizeof(data) + 1, 0, 0, 0);
 
-- 
2.51.0



