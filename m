Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BE2D36B055
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772300960; cv=none; b=G2MKPLsZkdm+3KUsS/7Vpb3p0+sIWTUakvDLz+VNRRMwHKN40WypwYBlduK3J0e6NYz7ZL4ZxJcbD2M+tYgMB1CI3bWFWXaxPpydE7hlwm9ItKKV3CrtlrRCUySMZcN4Xq0AvrPgUD2j8aYIjImFE9WNbHe0mpByAOZeY8kiWNU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772300960; c=relaxed/simple;
	bh=szvlFF3i0wh8Y38w8LClFAbcm0MHnZBIOdlx2IhOYH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvvAJWSlRRibQnyc+4zvPgVvxNtS4ODPmT2C9Z/fDMOWnBrhRdianfqJkTMkEFCqh7aYvoR8HIt2s/VXVF1ZeepB4A/ElTwFK1MyeED4wlr7JIqJu3ogSEAtO9cyp1HqNQCGHZYv4z8xPTLlIJJT4YazevyGXxcWRvFPH/75ARM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ksrv+2Wg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ksrv+2Wg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09808C19424;
	Sat, 28 Feb 2026 17:49:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772300960;
	bh=szvlFF3i0wh8Y38w8LClFAbcm0MHnZBIOdlx2IhOYH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ksrv+2WgnRE9072bmnWkg6LhX0oi1l91EJWHJd5xDKhOHKjomxeJGyCBIlmwywwYm
	 mlp6clEj0y3it1P5aQPBjoi9JFlfl6Vn9u7ygsp2UMuPze1PFh6wYmxTcXxfjnm4Uj
	 D1wD210WlrOvmVk6tb4hgLdJBCDoRSNk806BbSbZ4l4uujjbx/8vQuWdMigu3yPn9z
	 MzwwkXLjMWdISYmR6toBqqkORsr6fcB+fNdrwnlalzQs583m65CkbOU2p8wuBoOO/8
	 0krb14joxnNqSErTOLM6PeQMuDJKmEWFhzP3ECTwiIs1LHy7B5GHsVN1T/949iArFQ
	 SEH6RAuowTvSw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Anton Protopopov <a.s.protopopov@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 085/752] bpf: Properly mark live registers for indirect jumps
Date: Sat, 28 Feb 2026 12:36:36 -0500
Message-ID: <20260228174750.1542406-85-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Anton Protopopov <a.s.protopopov@gmail.com>

[ Upstream commit d1aab1ca576c90192ba961094d51b0be6355a4d6 ]

For a `gotox rX` instruction the rX register should be marked as used
in the compute_insn_live_regs() function. Fix this.

Signed-off-by: Anton Protopopov <a.s.protopopov@gmail.com>
Link: https://lore.kernel.org/r/20260114162544.83253-2-a.s.protopopov@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index e94a02ae3e1cd..dcbf21f61d2e6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -24292,6 +24292,12 @@ static void compute_insn_live_regs(struct bpf_verifier_env *env,
 	case BPF_JMP32:
 		switch (code) {
 		case BPF_JA:
+			def = 0;
+			if (BPF_SRC(insn->code) == BPF_X)
+				use = dst;
+			else
+				use = 0;
+			break;
 		case BPF_JCOND:
 			def = 0;
 			use = 0;
-- 
2.51.0

