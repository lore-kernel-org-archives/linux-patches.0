Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38B941D0174;
	Wed,  2 Oct 2024 13:35:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727876133; cv=none; b=mj2iPeC/H9nyJ7Gw8SNlDnAwQLr9i7B3Yz+1CNNIPNrMdw/mWrJ6+LbnDRGiijU4NLk0QbuXJ/qzC2vKmJEvqPgLobf4nPv6WryEe6wio5pY4/XG/N5pkq413hkGBZpKP0GvAwT/J3BlZy0UJUjf8bhyVyWtsORHSvnJMKVHVeI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727876133; c=relaxed/simple;
	bh=QgOugubzsmkyR/8LuE6fx5M4ipSXYViZIVca9Sib3tg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eHHvOby8Nye83/V3nfl++kvVLgw1fCQPQC4KBE3RprzTPHju20hs8eQ5O43oJqPyi7j8BxKvHSPMSsl/nKGiP8fUSkhyL90aWDDr84b1tK4cKVhgNouHvkw1zGQDBGA7/9h6uN00hpZTX54pmZtj3WAYx2tK9YiQT9SbiMKeRlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=prvI655j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="prvI655j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B574BC4CEC5;
	Wed,  2 Oct 2024 13:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727876133;
	bh=QgOugubzsmkyR/8LuE6fx5M4ipSXYViZIVca9Sib3tg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=prvI655jJS4xG3zJiQU6LPOr3OzoBhzAmQpM+5+OY0q0MjuSChTv7VHaZEed7Qzri
	 2qURfdix7n4wEUtGtbrxrf3G5OhMd3o+8SMCWN3Ej9cN6Z41ETQm1l406bxH0X7rBr
	 QBrrs/OjACLUhWhAIP+Tgb3TDbNSvkuS8+xbcsS8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 322/695] bpf: Zero former ARG_PTR_TO_{LONG,INT} args in case of error
Date: Wed,  2 Oct 2024 14:55:20 +0200
Message-ID: <20241002125835.302692009@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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
index b305b116ce125..c9e235807caca 100644
--- a/kernel/bpf/helpers.c
+++ b/kernel/bpf/helpers.c
@@ -522,6 +522,7 @@ BPF_CALL_4(bpf_strtol, const char *, buf, size_t, buf_len, u64, flags,
 	long long _res;
 	int err;
 
+	*res = 0;
 	err = __bpf_strtoll(buf, buf_len, flags, &_res);
 	if (err < 0)
 		return err;
@@ -549,6 +550,7 @@ BPF_CALL_4(bpf_strtoul, const char *, buf, size_t, buf_len, u64, flags,
 	bool is_negative;
 	int err;
 
+	*res = 0;
 	err = __bpf_strtoull(buf, buf_len, flags, &_res, &is_negative);
 	if (err < 0)
 		return err;
diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index efb7ff89fe2e2..d9cae8e259699 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -5932,6 +5932,7 @@ static const struct bpf_func_proto bpf_sys_close_proto = {
 
 BPF_CALL_4(bpf_kallsyms_lookup_name, const char *, name, int, name_sz, int, flags, u64 *, res)
 {
+	*res = 0;
 	if (flags)
 		return -EINVAL;
 
diff --git a/net/core/filter.c b/net/core/filter.c
index 88588dae20267..0e719c7c43bb7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -6262,20 +6262,25 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
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
@@ -6293,15 +6298,12 @@ BPF_CALL_5(bpf_skb_check_mtu, struct sk_buff *, skb,
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
 
@@ -6311,19 +6313,21 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
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
@@ -6333,10 +6337,8 @@ BPF_CALL_5(bpf_xdp_check_mtu, struct xdp_buff *, xdp,
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



