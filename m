Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AEB649659;
	Mon, 14 Oct 2024 14:58:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917938; cv=none; b=Art+rGVJNsMHjosddXOu0tEICmfBx8c6LjN6LzuZlRGeac2+ByZxxWL1b4dnVe8r3klgyEcebJoETX4mVwRXLNdfsWmcuoSGnQfDEW8SHwMcncjvdwgvwYVbUNWkVk68Dx3OZJQXez6C3oW1CgBzbAs4SFQpVa7WGj9Xq0JSGu0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917938; c=relaxed/simple;
	bh=8ZfecOQw1VCxTQ47bkR4TvynUat/eRg9oV0QVJgkdmc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pSn5qRzMg202MbbzJOqOuKDtkJGmMQJEIuyhHkq3VHNDr2CrOg4sh9tN8S7NWgWeidBPocmhW4Zm5bzOCT+OMC9qrektJf51IdJZfqOoYpp7r1TSzd+Nwdr2l7fjzRb6mxsfo41osg4jDUELxSAr81A5DudRLvtfcISbseOIslw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C76eGpDn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C76eGpDn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5E72C4CEC3;
	Mon, 14 Oct 2024 14:58:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917938;
	bh=8ZfecOQw1VCxTQ47bkR4TvynUat/eRg9oV0QVJgkdmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C76eGpDnif7NI/mlQttFAR4qda8+tjEITxCsuHc9s84B7MSZNlC1eyiHN8R+VGCMe
	 uOSCMweI2kHAIKVwOygnBwSEs/DMmzmvpjOfGUx0AnuWLdcQ3a/WDiH/xx0JDiO7du
	 8tm5RQfIEU5chgcteVQ8ZL2UDJnwAbx1CM1Mp8mU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 176/798] bpf: Zero former ARG_PTR_TO_{LONG,INT} args in case of error
Date: Mon, 14 Oct 2024 16:12:10 +0200
Message-ID: <20241014141224.841519920@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141217.941104064@linuxfoundation.org>
References: <20241014141217.941104064@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit 4b3786a6c5397dc220b1483d8e2f4867743e966f ]

For all non-tracing helpers which formerly had ARG_PTR_TO_{LONG,INT} as input
arguments, zero the value for the case of an error as otherwise it could leak
memory. For tracing, it is not needed given CAP_PERFMON can already read all
kernel memory anyway hence bpf_get_func_arg() and bpf_get_func_ret() is skipped
in here.

Also, the MTU helpers mtu_len pointer value is being written but also read.
Technically, the MEM_UNINIT should not be there in order to always force init.
Removing MEM_UNINIT needs more verifier rework though: MEM_UNINIT right now
implies two things actually: i) write into memory, ii) memory does not have
to be initialized. If we lift MEM_UNINIT, it then becomes: i) read into memory,
ii) memory must be initialized. This means that for bpf_*_check_mtu() we're
readding the issue we're trying to fix, that is, it would then be able to
write back into things like .rodata BPF maps. Follow-up work will rework the
MEM_UNINIT semantics such that the intent can be better expressed. For now
just clear the *mtu_len on error path which can be lifted later again.

Fixes: 8a67f2de9b1d ("bpf: expose bpf_strtol and bpf_strtoul to all program types")
Fixes: d7a4cb9b6705 ("bpf: Introduce bpf_strtol and bpf_strtoul helpers")
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/e5edd241-59e7-5e39-0ee5-a51e31b6840a@iogearbox.net
Link: https://lore.kernel.org/r/20240913191754.13290-5-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/helpers.c |  2 ++
 kernel/bpf/syscall.c |  1 +
 net/core/filter.c    | 44 +++++++++++++++++++++++---------------------
 3 files changed, 26 insertions(+), 21 deletions(-)

diff --git a/kernel/bpf/helpers.c b/kernel/bpf/helpers.c
index d12e696fac74f..a3fc4e2e8256a 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -514,6 +514,7 @@ BPF_CALL_4(bpf_strtol, const char *, buf, size_t, buf_len, u64, flags,
 	long long _res;
 	int err;
 
+	*res = 0;
 	err = __bpf_strtoll(buf, buf_len, flags, &_res);
 	if (err < 0)
 		return err;
@@ -540,6 +541,7 @@ BPF_CALL_4(bpf_strtoul, const char *, buf, size_t, buf_len, u64, flags,
 	bool is_negative;
 	int err;
 
+	*res = 0;
 	err = __bpf_strtoull(buf, buf_len, flags, &_res, &is_negative);
 	if (err < 0)
 		return err;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index d77597daa0022..42f5b37a74c6f 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5239,6 +5239,7 @@ static const struct bpf_func_proto bpf_sys_close_proto = {
 
 BPF_CALL_4(bpf_kallsyms_lookup_name, const char *, name, int, name_sz, int, flags, u64 *, res)
 {
+	*res = 0;
 	if (flags)
 		return -EINVAL;
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 1cd5f146cafe4..6f65c6eb0d90d 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6131,20 +6131,25 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
 	int ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
 	struct net_device *dev = skb->dev;
 	int skb_len, dev_len;
-	int mtu;
+	int mtu = 0;
 
-	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS)))
-		return -EINVAL;
+	if (unlikely(flags & ~(BPF_MTU_CHK_SEGS))) {
+		ret = -EINVAL;
+		goto out;
+	}
 
-	if (unlikely(flags & BPF_MTU_CHK_SEGS && (len_diff || *mtu_len)))
-		return -EINVAL;
+	if (unlikely(flags & BPF_MTU_CHK_SEGS && (len_diff || *mtu_len))) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	dev = __dev_via_ifindex(dev, ifindex);
-	if (unlikely(!dev))
-		return -ENODEV;
+	if (unlikely(!dev)) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	mtu = READ_ONCE(dev->mtu);
-
 	dev_len = mtu + dev->hard_header_len;
 
 	/* If set use *mtu_len as input, L3 as iph->tot_len (like fib_lookup) */
@@ -6162,15 +6167,12 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
 	 */
 	if (skb_is_gso(skb)) {
 		ret = BPF_MTU_CHK_RET_SUCCESS;
-
 		if (flags & BPF_MTU_CHK_SEGS &&
 		    !skb_gso_validate_network_len(skb, mtu))
 			ret = BPF_MTU_CHK_RET_SEGS_TOOBIG;
 	}
 out:
-	/* BPF verifier guarantees valid pointer */
 	*mtu_len = mtu;
-
 	return ret;
 }
 
@@ -6180,19 +6182,21 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
 	struct net_device *dev = xdp->rxq->dev;
 	int xdp_len = xdp->data_end - xdp->data;
 	int ret = BPF_MTU_CHK_RET_SUCCESS;
-	int mtu, dev_len;
+	int mtu = 0, dev_len;
 
 	/* XDP variant doesn't support multi-buffer segment check (yet) */
-	if (unlikely(flags))
-		return -EINVAL;
+	if (unlikely(flags)) {
+		ret = -EINVAL;
+		goto out;
+	}
 
 	dev = __dev_via_ifindex(dev, ifindex);
-	if (unlikely(!dev))
-		return -ENODEV;
+	if (unlikely(!dev)) {
+		ret = -ENODEV;
+		goto out;
+	}
 
 	mtu = READ_ONCE(dev->mtu);
-
-	/* Add L2-header as dev MTU is L3 size */
 	dev_len = mtu + dev->hard_header_len;
 
 	/* Use *mtu_len as input, L3 as iph->tot_len (like fib_lookup) */
@@ -6202,10 +6206,8 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
 	xdp_len += len_diff; /* minus result pass check */
 	if (xdp_len > dev_len)
 		ret = BPF_MTU_CHK_RET_FRAG_NEEDED;
-
-	/* BPF verifier guarantees valid pointer */
+out:
 	*mtu_len = mtu;
-
 	return ret;
 }
 
-- 
2.43.0



