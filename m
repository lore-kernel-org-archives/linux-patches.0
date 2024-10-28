Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6BEA418F2C3;
	Mon, 28 Oct 2024 06:51:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098301; cv=none; b=EjZmlzuv2qPRbvNtbt9zWfvrwTmvR9GhNYPQbGE0Bxu3CQHgu6AXJboFcEVRWs3EkN6Yg5+ZFOo2ZZjdlydagTAPlkUlt1IUknv+dPhHhKZJthOvnbnb49XyDnsAPxqAtN9J5aO0WJwBmaFN1KL7I1BjP9bnKOJbzg1lL1GgfPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098301; c=relaxed/simple;
	bh=3UeIMF9JVQv7KhXZ7s7O9tw/nvjKldOAYBv9vmZABa8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I18CSkdsAbdksndlw7/TMc0rM3xwSp0Cry5cFYl4jGsGjnP5ucv8ePi7FnZ5TSPzidSgR/lQ2h3CbH8uI31b19jsNfSuIHzKd3apBB+R3+fTP/Oqq66Y1TZ4EFU04lnaJ5UGwqKRiKtSCvoJtWH0ECatmFuA/ZqYC4DK2+iCwYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0djluqxX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0djluqxX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF154C4CEC3;
	Mon, 28 Oct 2024 06:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098301;
	bh=3UeIMF9JVQv7KhXZ7s7O9tw/nvjKldOAYBv9vmZABa8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0djluqxXfVD+jsAOQrYOC6btU8BTZ3l+JMR9YlNG5Fki896BVLPGiRP+qynRZN42m
	 5KyVVvcFsyQ9CIuXp1XwfQkH25jHASl84f6Sh8nKHa7I9bJIjMisv8sigONKWD72Wz
	 ZgWTo0I+Skcgk0wqzWYQCmm1x8piV/LJWu9d3HiY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 165/261] bpf: Remove MEM_UNINIT from skb/xdp MTU helpers
Date: Mon, 28 Oct 2024 07:25:07 +0100
Message-ID: <20241028062316.136031992@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 14a3d3ef02ba53447d5112a2641aac0d10dc994f ]

We can now undo parts of 4b3786a6c539 ("bpf: Zero former ARG_PTR_TO_{LONG,INT}
args in case of error") as discussed in [0].

Given the BPF helpers now have MEM_WRITE tag, the MEM_UNINIT can be cleared.

The mtu_len is an input as well as output argument, meaning, the BPF program
has to set it to something. It cannot be uninitialized. Therefore, allowing
uninitialized memory and zeroing it on error would be odd. It was done as
an interim step in 4b3786a6c539 as the desired behavior could not have been
expressed before the introduction of MEM_WRITE tag.

Fixes: 4b3786a6c539 ("bpf: Zero former ARG_PTR_TO_{LONG,INT} args in case of error")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/a86eb76d-f52f-dee4-e5d2-87e45de3e16f@iogearbox.net [0]
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20241021152809.33343-3-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 42 +++++++++++++++---------------------------
 1 file changed, 15 insertions(+), 27 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ddcf35e91a5e4..b2b551401bc29 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6263,24 +6263,16 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
 {
 	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
 	struct net_device *dev = skb->dev;
-	int skb_len, dev_len;
-	int mtu = 0;
+	int mtu, dev_len, skb_len;
 
-	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS))) {
-		ret = -EINVAL;
-		goto out;
-	}
-
-	if (unlikely(flags & BPF_MTU_CHK_SEGS && (len_diff || *mtu_len))) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
+		return -EINVAL;
+	if (unlikely(flags & BPF_MTU_CHK_SEGS && (len_diff || *mtu_len)))
+		return -EINVAL;
 
 	dev = __dev_via_ifindex(dev, ifindex);
-	if (unlikely(!dev)) {
-		ret = -ENODEV;
-		goto out;
-	}
+	if (unlikely(!dev))
+		return -ENODEV;
 
 	mtu = READ_ONCE(dev->mtu);
 	dev_len = mtu + dev->hard_header_len;
@@ -6315,19 +6307,15 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
 	struct net_device *dev = xdp->rxq->dev;
 	int xdp_len = xdp->data_end - xdp->data;
 	int ret = BPF_MTU_CHK_RET_SUCCESS;
-	int mtu = 0, dev_len;
+	int mtu, dev_len;
 
 	/* XDP variant doesn't support multi-buffer segment check (yet) */
-	if (unlikely(flags)) {
-		ret = -EINVAL;
-		goto out;
-	}
+	if (unlikely(flags))
+		return -EINVAL;
 
 	dev = __dev_via_ifindex(dev, ifindex);
-	if (unlikely(!dev)) {
-		ret = -ENODEV;
-		goto out;
-	}
+	if (unlikely(!dev))
+		return -ENODEV;
 
 	mtu = READ_ONCE(dev->mtu);
 	dev_len = mtu + dev->hard_header_len;
@@ -6339,7 +6327,7 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
 	xdp_len += len_diff; /* minus result pass check */
 	if (xdp_len > dev_len)
 		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
-out:
+
 	*mtu_len = mtu;
 	return ret;
 }
@@ -6350,7 +6338,7 @@ static const struct bpf_func_proto bpf_skb_check_mtu_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_ANYTHING,
-	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
+	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_WRITE | MEM_ALIGNED,
 	.arg3_size	= sizeof(u32),
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6362,7 +6350,7 @@ static const struct bpf_func_proto bpf_xdp_check_mtu_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_ANYTHING,
-	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
+	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_WRITE | MEM_ALIGNED,
 	.arg3_size	= sizeof(u32),
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
-- 
2.43.0



