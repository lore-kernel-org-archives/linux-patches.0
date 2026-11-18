Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027420;
	b=AEzYs38MOX0igCyro/OiKxFy2oRxweOmHbiH011Nx/34wR+Oc2jkGF7LTX7dY3SLAvAw
	 bdTUmxf5IAG7Qk5zBFIcvNNfKDyTfqgf4iC5KXadPSuZZhngb4GBOO3FzSJFBGowvTehd
	 QqYhlm05zRGsAEwdrIkKMJjY/TPZE0MBiZ1nderfU053YlmeCA5uCPMr4/RarBOGswoEd
	 FOen0h5BTbDZIUAlJ07LlD2t9/NyCI9oFtGk0wkHG5ICQyrYSkOrUcCXWDXPTYOQWlIL8
	 o/MtesqsTCnwM7aaWD92TO9kUuZAabX58UJpp47hglTNJGWJNlHE2jRkMnKr9pBCYCQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027420;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=v23mUDdChsfUdRd19QYxhxB7EKwKsYgYdFUrDeCBwec=;
	b=jU+79BIVQxVAtQ1a377/q1RdZUXL/sYOmgbPEd29hADPOp7H5M5gALulrxrau1wLHG1j
	 Pkiq2sTkYPkmRDOkUvGESSgS8smjuDNeVwvLI27Y6bPIJ+wzoUPu6/1lsxJ6egOBjdrWk
	 lD8FddbwtNvjCNRkunQI9+0v/xk6LR4og9iUmi4FBGlu9FclgAUZoCwQaGLlUcfLNtlOS
	 tY5FefZZ8zVoJTnPqHVq/tFptBea1Ou+ZYk3/0+46pZ27IbqjFbwuDa22VEjt6dH75ac7
	 9pquLHUFcqwWw85E1z0AIk8tH9kxDGSG5R3imNHMduUx6fnbepG3A1RNRU5P2L0++Kw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="mNCJ1xW/";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2099960A2618;
	Wed, 18 Nov 2026 18:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mNCJ1xW/
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6DBE61F000C4;
	Wed, 18 Nov 2026 18:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027420;
	bh=v23mUDdChsfUdRd19QYxhxB7EKwKsYgYdFUrDeCBwec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mNCJ1xW/1mCvn7hF1357WB3x8RHpbiZQeA1yQR2CErn2FDGc4F9dM90GUoszNaqRm
	 5858Sx8w13m+6Vy1oFTsTTtJAp0SI4qbj6Ae8fpYGmf6k96u2Fgm9art//Q6kcz8Hs
	 onUQygfhLRcs+jziYRp+7mSYzCMUdc4Bo8GpeSu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	syzbot@syzkaller.appspotmail.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1741/2151] bpf: Craft non-linear skbs in BPF_PROG_TEST_RUN
Date: Wed, 18 Nov 2026 15:57:56 +0100
Message-ID: <20261118150225.280561468@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 838baa351cee86526973fb3ef49c0f4c1b2f3b0c ]

This patch adds support for crafting non-linear skbs in BPF test runs
for tc programs. The size of the linear area is given by ctx->data_end,
with a minimum of ETH_HLEN always pulled in the linear area. If ctx or
ctx->data_end are null, a linear skb is used.

This is particularly useful to test support for non-linear skbs in large
codebases such as Cilium. We've had multiple bugs in the past few years
where we were missing calls to bpf_skb_pull_data(). This support in
BPF_PROG_TEST_RUN would allow us to automatically cover this case in our
BPF tests.

LWT program types are currently excluded in this patch. Allowing
non-linear skbs for these programs would require a bit more care because
they are able to call helpers (ex., bpf_clone_redirect, bpf_redirect)
that themselves call eth_type_trans(). eth_type_trans() assumes there
are at least ETH_HLEN bytes in the linear area. That may not be true
for LWT programs as we already pulled the L2 header via the
eth_type_trans() call in bpf_prog_test_run_skb().

In addition to the selftests introduced later in the series, this patch
was tested by enabling non-linear skbs for all tc selftests programs
and checking test failures were expected.

Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Tested-by: syzbot@syzkaller.appspotmail.com
Link: https://patch.msgid.link/5694d4d1af31bddf974afcb1bbb1e28b8998dcd0.1760037899.git.paul.chaignon@gmail.com
Stable-dep-of: 6aff0129f327 ("bpf: Use the socket of a sk_lookup test run under RCU")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bpf/test_run.c | 103 ++++++++++++++++++++++++++++++++++++---------
 1 file changed, 82 insertions(+), 21 deletions(-)

diff --git a/net/bpf/test_run.c b/net/bpf/test_run.c
index 41fbf4b0a36ab..ebec805711279 100644
--- a/net/bpf/test_run.c
+++ b/net/bpf/test_run.c
@@ -436,7 +436,7 @@ static int bpf_test_run(struct bpf_prog *prog, void *ctx, u32 repeat,
 
 static int bpf_test_finish(const union bpf_attr *kattr,
 			   union bpf_attr __user *uattr, const void *data,
-			   struct skb_shared_info *sinfo, u32 size,
+			   struct skb_shared_info *sinfo, u32 size, u32 frag_size,
 			   u32 retval, u32 duration)
 {
 	void __user *data_out = u64_to_user_ptr(kattr->test.data_out);
@@ -453,7 +453,7 @@ static int bpf_test_finish(const union bpf_attr *kattr,
 	}
 
 	if (data_out) {
-		int len = sinfo ? copy_size - sinfo->xdp_frags_size : copy_size;
+		int len = sinfo ? copy_size - frag_size : copy_size;
 
 		if (len < 0) {
 			err = -ENOSPC;
@@ -899,6 +899,12 @@ static int convert___skb_to_skb(struct sk_buff *skb, struct __sk_buff *__skb)
 	/* cb is allowed */
 
 	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, cb),
+			   offsetof(struct __sk_buff, data_end)))
+		return -EINVAL;
+
+	/* data_end is allowed, but not copied to skb */
+
+	if (!range_is_zero(__skb, offsetofend(struct __sk_buff, data_end),
 			   offsetof(struct __sk_buff, tstamp)))
 		return -EINVAL;
 
@@ -978,34 +984,39 @@ static struct proto bpf_dummy_proto = {
 int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 			  union bpf_attr __user *uattr)
 {
-	bool is_l2 = false, is_direct_pkt_access = false;
+	bool is_l2 = false, is_direct_pkt_access = false, is_lwt = false;
+	u32 tailroom = SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
 	struct net *net = current->nsproxy->net_ns;
 	struct net_device *dev = net->loopback_dev;
-	u32 size = kattr->test.data_size_in;
+	u32 headroom = NET_SKB_PAD + NET_IP_ALIGN;
+	u32 linear_sz = kattr->test.data_size_in;
 	u32 repeat = kattr->test.repeat;
 	struct __sk_buff *ctx = NULL;
 	struct sk_buff *skb = NULL;
 	struct sock *sk = NULL;
 	u32 retval, duration;
 	int hh_len = ETH_HLEN;
-	void *data;
+	void *data = NULL;
 	int ret;
 
 	if ((kattr->test.flags & ~BPF_F_TEST_SKB_CHECKSUM_COMPLETE) ||
 	    kattr->test.cpu || kattr->test.batch_size)
 		return -EINVAL;
 
-	if (size < ETH_HLEN)
+	if (kattr->test.data_size_in < ETH_HLEN)
 		return -EINVAL;
 
 	switch (prog->type) {
 	case BPF_PROG_TYPE_SCHED_CLS:
 	case BPF_PROG_TYPE_SCHED_ACT:
+		is_direct_pkt_access = true;
 		is_l2 = true;
-		fallthrough;
+		break;
 	case BPF_PROG_TYPE_LWT_IN:
 	case BPF_PROG_TYPE_LWT_OUT:
 	case BPF_PROG_TYPE_LWT_XMIT:
+		is_lwt = true;
+		fallthrough;
 	case BPF_PROG_TYPE_CGROUP_SKB:
 		is_direct_pkt_access = true;
 		break;
@@ -1017,9 +1028,24 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	if (IS_ERR(ctx))
 		return PTR_ERR(ctx);
 
-	data = bpf_test_init(kattr, kattr->test.data_size_in,
-			     size, NET_SKB_PAD + NET_IP_ALIGN,
-			     SKB_DATA_ALIGN(sizeof(struct skb_shared_info)));
+	if (ctx) {
+		if (ctx->data_end > kattr->test.data_size_in || ctx->data || ctx->data_meta) {
+			ret = -EINVAL;
+			goto out;
+		}
+		if (ctx->data_end) {
+			/* Non-linear LWT test_run is unsupported for now. */
+			if (is_lwt) {
+				ret = -EINVAL;
+				goto out;
+			}
+			linear_sz = max(ETH_HLEN, ctx->data_end);
+		}
+	}
+
+	linear_sz = min_t(u32, linear_sz, PAGE_SIZE - headroom - tailroom);
+
+	data = bpf_test_init(kattr, linear_sz, linear_sz, headroom, tailroom);
 	if (IS_ERR(data)) {
 		ret = PTR_ERR(data);
 		data = NULL;
@@ -1043,7 +1069,43 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 	data = NULL; /* data released via kfree_skb */
 
 	skb_reserve(skb, NET_SKB_PAD + NET_IP_ALIGN);
-	__skb_put(skb, size);
+	__skb_put(skb, linear_sz);
+
+	if (unlikely(kattr->test.data_size_in > linear_sz)) {
+		void __user *data_in = u64_to_user_ptr(kattr->test.data_in);
+		struct skb_shared_info *sinfo = skb_shinfo(skb);
+		u32 copied = linear_sz;
+
+		while (copied < kattr->test.data_size_in) {
+			struct page *page;
+			u32 data_len;
+
+			if (sinfo->nr_frags == MAX_SKB_FRAGS) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			page = alloc_page(GFP_KERNEL);
+			if (!page) {
+				ret = -ENOMEM;
+				goto out;
+			}
+
+			data_len = min_t(u32, kattr->test.data_size_in - copied,
+					 PAGE_SIZE);
+			skb_fill_page_desc(skb, sinfo->nr_frags, page, 0, data_len);
+
+			if (copy_from_user(page_address(page), data_in + copied,
+					   data_len)) {
+				ret = -EFAULT;
+				goto out;
+			}
+			skb->data_len += data_len;
+			skb->truesize += PAGE_SIZE;
+			skb->len += data_len;
+			copied += data_len;
+		}
+	}
 
 	if (ctx && ctx->ifindex > 1) {
 		dev = dev_get_by_index(net, ctx->ifindex);
@@ -1148,12 +1210,11 @@ int bpf_prog_test_run_skb(struct bpf_prog *prog, const union bpf_attr *kattr,
 
 	convert_skb_to___skb(skb, ctx);
 
-	size = skb->len;
-	/* bpf program can never convert linear skb to non-linear */
-	if (WARN_ON_ONCE(skb_is_nonlinear(skb)))
-		size = skb_headlen(skb);
-	ret = bpf_test_finish(kattr, uattr, skb->data, NULL, size, retval,
-			      duration);
+	if (skb_is_nonlinear(skb))
+		/* bpf program can never convert linear skb to non-linear */
+		WARN_ON_ONCE(linear_sz == kattr->test.data_size_in);
+	ret = bpf_test_finish(kattr, uattr, skb->data, skb_shinfo(skb), skb->len,
+			      skb->data_len, retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, ctx,
 				     sizeof(struct __sk_buff));
@@ -1370,7 +1431,7 @@ int bpf_prog_test_run_xdp(struct bpf_prog *prog, const union bpf_attr *kattr,
 		goto out;
 
 	size = xdp.data_end - xdp.data_meta + sinfo->xdp_frags_size;
-	ret = bpf_test_finish(kattr, uattr, xdp.data_meta, sinfo, size,
+	ret = bpf_test_finish(kattr, uattr, xdp.data_meta, sinfo, size, sinfo->xdp_frags_size,
 			      retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, ctx,
@@ -1461,7 +1522,7 @@ int bpf_prog_test_run_flow_dissector(struct bpf_prog *prog,
 		goto out;
 
 	ret = bpf_test_finish(kattr, uattr, &flow_keys, NULL,
-			      sizeof(flow_keys), retval, duration);
+			      sizeof(flow_keys), 0, retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, user_ctx,
 				     sizeof(struct bpf_flow_keys));
@@ -1562,7 +1623,7 @@ int bpf_prog_test_run_sk_lookup(struct bpf_prog *prog, const union bpf_attr *kat
 		user_ctx->cookie = sock_gen_cookie(ctx.selected_sk);
 	}
 
-	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, retval, duration);
+	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, 0, retval, duration);
 	if (!ret)
 		ret = bpf_ctx_finish(kattr, uattr, user_ctx, sizeof(*user_ctx));
 
@@ -1762,7 +1823,7 @@ int bpf_prog_test_run_nf(struct bpf_prog *prog,
 	if (ret)
 		goto out;
 
-	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, retval, duration);
+	ret = bpf_test_finish(kattr, uattr, NULL, NULL, 0, 0, retval, duration);
 
 out:
 	kfree(user_ctx);
-- 
2.53.0



