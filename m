Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3486F51121D;
	Wed, 30 Sep 2026 18:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790792289; cv=none; b=iPT+ELERFGX1/V5/FL15i/QYjOcewdDdVUNbhDAemIrxg2MvoodrHbNm89Qv2io2Gr+9ktvQ0HkmcjDmF65pOUp9ZTNK40j9eBZENZOUwljGaskuNQSfiurO8kCvRe+Ox4gU1f9P/y6nqBTXClsv4XBkd2NNVPeC1w+ZZ86254o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790792289; c=relaxed/simple;
	bh=GvZZ+qhD2QrhOcWPincr3OjSvt3OFcpQqa8l7hVQ2io=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ma6ZN2PwDYHmbfgFFshfgeVZdaZPeJx7UWwei8kZqdzV3NjYHuQsN91HFAHPZcvjELuxBI2vCsh8jlQhsDlVX20I7t1CNowf1FuHbiZFGNzkHQGHS6j3N4upMhyzEi2xh24xGkyLYZfpLbnzTF19C5oFYqHojIzA3Zvg0Cod+wY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GwCBaCPh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GwCBaCPh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9018E1F000FF;
	Wed, 30 Sep 2026 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790792288;
	bh=+n6lzrRAfmEBOAgSAfekvK3Uue93/cUMn/DOApZAnHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GwCBaCPhn0Wfo+Kqj5brDtAVjQAjXQ9JDvbg638XO6wkOXhfF1zqQM8ZUxWOBxMxq
	 nu6ybIwkMQeC9BTQVn6Uc0EmWnN3pzfTsuUYk6xFucuRyXueZm4xZtEkCIrcwXo6Ur
	 8cTLSbbTy6x9nXXmVtzDWPodmv7GsfkM/o1Z/1nc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	VEGA <vega@nebusec.ai>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 600/752] bpf: Fix out-of-bounds read of rtt_min in sock_ops
Date: Wed, 30 Sep 2026 17:27:50 +0200
Message-ID: <20260930152411.267678438@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152358.131179731@linuxfoundation.org>
References: <20260930152358.131179731@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index a466ac9065361..1ee9432d516ed 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -9972,18 +9972,7 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
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



