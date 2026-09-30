Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DF8D52268C;
	Wed, 30 Sep 2026 18:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792773; cv=none; b=JYbe1v++MZujFhSHuRfQA3fmEsG8/wJTnvr2UCSiv551mOu82IbGX2D0mAYE2uDiRuoZcCfsF/hIWZtORzntmIWKN+/mh71usHe12PmR/wKPsWJK0lVsBsW0FboHfpYpURV3C4iHtNmXGTqc5C5T/YnX83pbs7RboQqGTu5+tCI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792773; c=relaxed/simple;
	bh=gueHxh0x0Tl0arMQfW2Xk3VpCUkInVvwvguvt5Z4Il8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TE/GCYtEMNtmeqXxagLkFwK/68iwi3dXH+GLC1pluNkCJHu0z7EnuJUqUvD1y0sMHWonEcc6pkPfBs3VnnhfhtaX0ps7RUSsRd9Ba2QZzPJHyYPSnY32h73jqkNNa3530jkTl6ZUrBz6J3G9mZFmXOKR9K3neIHNvh9bDrDCbrk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hylki0vO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hylki0vO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 991C81F000FF;
	Wed, 30 Sep 2026 18:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792772;
	bh=I1tlAxg5XRL7gW1msagSu5iPuaCNMaw6ekkMOz6B5w4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hylki0vOlCQzVa58t78Qr9n1R4fULgi+d3g8+KG/OD12NwoDTvvEk7q1a26biwx2Z
	 jc2/KFi27/6yBjuTveK/pB0bb012NiHodpaVd06WcY/i8UiKyX1FGltSRLdGVglGyE
	 RavY32WpOzZkrA/uU5Oi/mYtvkqNdehX0xyhCU0k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 020/395] bpf: Fix out-of-bounds read of rtt_min in sock_ops
Date: Wed, 30 Sep 2026 17:24:42 +0200
Message-ID: <20260930152341.055990822@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 75f8cf22463d82bb1fb0239a3d485fc8f4c8ef03 ]

A sockops prog reading skops->rtt_min never checks the sk type: on the
tcp_conn_request() path sock_ops->sk is a request_sock (non-full), and the
ctx rewrite casts it to a tcp_sock (full) and reads rtt_min past the end of
the request_sock, returning dirty adjacent memory.

	SEC("sockops")
	int prog(struct bpf_sock_ops *skops)
	{
		switch (skops->op) {
		case BPF_SOCK_OPS_RWND_INIT:
			leak = skops->rtt_min;   /* reads the request_sock OOB */
		...
		}
	}

For instance one such read returned rtt_min=0xffff8881, the high half of a
leaked kernel pointer.

Guarding that cast is exactly what SOCK_OPS_GET_FIELD() does -- it checks
is_locked_tcp_sock and returns 0 when sock_ops->sk is not a locked full
socket. Every other tcp_sock field in sock_ops goes through it; rtt_min is
the only one open-coded, so it skips the check.

Read rtt_min through SOCK_OPS_GET_FIELD() too. rtt_min is a bit special:
it is a struct minmax and we only want the current min, so pass
rtt_min.s[0].v. That is equivalent to the old hand-computed offset

	offsetof(struct tcp_sock, rtt_min) + sizeof_field(struct minmax_sample, t)

(s[0] sits at rtt_min + 0 and .v at + sizeof(.t), i.e. what minmax_get()
returns), so the loaded field is unchanged and only the full-sock guard is
added. The two BUILD_BUG_ON()s that protected the hand-computed offset
are no longer needed.

Before patch:

	0: r1 = *(u64 *)(r1 +0)      ; r1 = skops->sk
	1: r1 = *(u32 *)(r1 +2324)   ; ((tcp_sock *)sk)->rtt_min.s[0].v

After patch:

	0: *(u64 *)(r1 +56) = r9
	1: r9 = *(u8 *)(r1 +50)      ; is_locked_tcp_sock
	2: if r9 == 0 goto pc+4      ; not a locked full sock -> 0
	3: r9 = *(u64 *)(r1 +56)
	4: r1 = *(u64 *)(r1 +0)      ; r1 = skops->sk
	5: r1 = *(u32 *)(r1 +2324)   ; rtt_min.s[0].v
	6: goto pc+2
	7: r9 = *(u64 *)(r1 +56)
	8: r1 = 0

Fixes: 44f0e43037d3 ("bpf: Add support for reading sk_state and more")
Reported-by: VEGA <vega@nebusec.ai>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/r/20260903100921.113374-1-jiayuan.chen@linux.dev
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 13 +------------
 1 file changed, 1 insertion(+), 12 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 4f0a052d9aed1..dea8dd48d4aa6 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10787,18 +10787,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 		break;
 
 	case offsetof(struct bpf_sock_ops, rtt_min):
-		BUILD_BUG_ON(sizeof_field(struct tcp_sock, rtt_min) !=
-			     sizeof(struct minmax));
-		BUILD_BUG_ON(sizeof(struct minmax) <
-			     sizeof(struct minmax_sample));
-
-		*insn++ = BPF_LDX_MEM(BPF_FIELD_SIZEOF(
-						struct bpf_sock_ops_kern, sk),
-				      si->dst_reg, si->src_reg,
-				      offsetof(struct bpf_sock_ops_kern, sk));
-		*insn++ = BPF_LDX_MEM(BPF_W, si->dst_reg, si->dst_reg,
-				      offsetof(struct tcp_sock, rtt_min) +
-				      sizeof_field(struct minmax_sample, t));
+		SOCK_OPS_GET_FIELD(rtt_min, rtt_min.s[0].v, struct tcp_sock);
 		break;
 
 	case offsetof(struct bpf_sock_ops, bpf_sock_ops_cb_flags):
-- 
2.53.0



