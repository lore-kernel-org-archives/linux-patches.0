Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B1318E354;
	Mon, 28 Oct 2024 06:43:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097797; cv=none; b=lzYbsrmmYHfvzinV02jViOnTjS5tvuoR4mOREVyFgIyo6Knqdt3EWrPKQ5ZPLqxRifV3Y9zyx72xe/GUGwOvCbmMIB6g8Ig4gqiYoxThYFRbbEDcDIrdq2DbXNEgh3H8hZuSzZ6DnV7iO/V5Q+OH+f39rzaIxy7tUHxneIwniBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097797; c=relaxed/simple;
	bh=++RqIgOC//YxDlwdxY+lByvIs5Biw1Bo0pODHYnsqro=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YCnNXWyIzv5Gc5CfByYQkyUAIkmEQPn88h6iZ42q9kuvlLwnb6TgMEMiCrizdiErIoaW7Cb8o3FGH2homIP1+RiXGQWrLsr87NmXLTdaTw4jtw/4X4E0FX7EY4TSeiq2UAsezlI9nfMydLFYYL2F0Q+QfRuzXwDBoYEa/9SbJ4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zFMut9hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zFMut9hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00732C4CEC3;
	Mon, 28 Oct 2024 06:43:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097797;
	bh=++RqIgOC//YxDlwdxY+lByvIs5Biw1Bo0pODHYnsqro=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zFMut9hrrYJWShyxBuajwC2FyIWo4q/yrr6DHOMDuzLKyg2JImVkgOAyl08BJX6KK
	 z3zdM8+ifOH2zollwcyk8ErlxQXlbcyxACo4TUqJsxq81G1YTWzQU8g30cVeDk0k/M
	 zM6NAshGCBiekapXVbWqQMRWPScfO1oYhgpno7oM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 152/208] bpf: Remove MEM_UNINIT from skb/xdp MTU helpers
Date: Mon, 28 Oct 2024 07:25:32 +0100
Message-ID: <20241028062310.370946538@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062306.649733554@linuxfoundation.org>
References: <20241028062306.649733554@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index a7d928345b1f4..a2467a7c01f9e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6223,24 +6223,16 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
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
@@ -6275,19 +6267,15 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
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
@@ -6299,7 +6287,7 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
 	xdp_len += len_diff; /* minus result pass check */
 	if (xdp_len > dev_len)
 		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
-out:
+
 	*mtu_len = mtu;
 	return ret;
 }
@@ -6310,7 +6298,7 @@ static const struct bpf_func_proto bpf_skb_check_mtu_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type      = ARG_PTR_TO_CTX,
 	.arg2_type      = ARG_ANYTHING,
-	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_UNINIT | MEM_WRITE | MEM_ALIGNED,
+	.arg3_type      = ARG_PTR_TO_FIXED_SIZE_MEM | MEM_WRITE | MEM_ALIGNED,
 	.arg3_size	= sizeof(u32),
 	.arg4_type      = ARG_ANYTHING,
 	.arg5_type      = ARG_ANYTHING,
@@ -6322,7 +6310,7 @@ static const struct bpf_func_proto bpf_xdp_check_mtu_proto = {
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



