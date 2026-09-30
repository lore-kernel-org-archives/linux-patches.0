Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368D250254F;
	Wed, 30 Sep 2026 16:38:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790786306; cv=none; b=FgPaKMMUKvIC0eHlaEoBD6ePglSsl60Cm3cuYx0xvWvNDA3Cm2IkVwLYgPRnuDf47aHrhCaKOPNeraJuY8lVr/TFtv22ICcVWLLklumtBdMmC79HyOUt8B+uSb0Athdq9jF16p4E5M6X/JMgA/tez+41U+dhFeu9TXNFcsjMhQg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790786306; c=relaxed/simple;
	bh=nGqmleeX1D7l5sfSXQA4VoAoot/g3V++VjI5MphixD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jXvMQ6rqpXfEeI6eVWzzkX/l5E45lyTJZpkWpbm/jwrRsmBNR2SePgKpkeiwDKIDCLdq9u+o0LJbDmVDuqXzy0HST7UWJ1iqVa4nMNBRGeT/nH4gic9wsqOLNq2nzlTUy/S51tMh0Af9y53o/RrHj3+JvzLUUi9RTzHTq7/4O5Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0RxfVC94; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0RxfVC94"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E0B81F000FF;
	Wed, 30 Sep 2026 16:38:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790786305;
	bh=xSzkoRgD+rIDpMsEt7i9oHHf5UPkcMZUxJ/jy3ELl+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0RxfVC94oh0qo3pYhiBodJLmigM2Vk5lpWFCqEBDpOjH7/SMspSz208hAL7UpKaYD
	 Sdza+a0kTaPFTcsiMbi+KfpxpOjK9iggsaYZ5nFQuNkJbPTdD5TJcOeIYiDYy58g7v
	 Qm1WKdAx48/kWEXXCo+7DYfVorhyNgnQltPJl8ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 814/982] bpf: Fix out-of-bounds read of rtt_min in sock_ops
Date: Wed, 30 Sep 2026 17:25:50 +0200
Message-ID: <20260930152434.243282495@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bb86d9db3731d..12caa1ac346cf 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10593,18 +10593,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
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



