Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBAEB346772
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302073; cv=none; b=WLqAGnYIu9zhjNVGeRriD+TVMBGVHbMpNTb8Q8hODUz7vv3gu8D0stPwMGvhoJWymzMHxhaNwx0KmolbVYcO+4VV/fvApw5xgjVIqZ8Zip0REVo0utOFse3rCDSNlVo2Si9oVIQPGkr6WBd1y/FtEVtJN/PvV90md1QmVjn31Vc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302073; c=relaxed/simple;
	bh=hKFKnw75Y62EXR5ctrFzNlwXeqp9gkGDG3II9K9ybfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BtcCz869kAofhv3sYL38D+BOjoAinDw+C44jW8Bq6ELAqAUlDxmDW4m4Vi5OCu76SfD9SkQArOLp/8e1CdCVtMa5WkoKpRe8ELtr+aF+2Mtc0nPtt/OMpA9PoYY/Jo0/2PUWtRTLNqZp0ECBEqSE5sRbqLknn6wg9OFT9QBkLzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CPRGKeCL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CPRGKeCL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1680FC19423;
	Sat, 28 Feb 2026 18:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302072;
	bh=hKFKnw75Y62EXR5ctrFzNlwXeqp9gkGDG3II9K9ybfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CPRGKeCLaBEz4PB1TvfMyP+fFMFNb1uvEKlcG4+YhBP9O3WPE+kQbM0R+NRWZH+Bl
	 AZRC2x9QtAHAOHmx4ZFRlZWG8NYlCuXEl1RQZ5l5im4zj3aHruip3Ub5f5yVpcXJhN
	 9E7sW8oAv/vUqS+9lZU+70W1Qb5INODeJXiAzx+IYkoyYHUuYU9p9Thbmpudo85Ucw
	 JCLgmfFGpAStKxwNG0fm2wpYhUsMS9Smviw962Z5grUzyid0jfXORwCtlW2oFPEGBN
	 QtCCfFrYAKw1eqLdsKWS6wzBqJtuC41rVh9sfMOddWRFhfVxlSBvAWtmH8bYojRgSb
	 LKmxpE6Zi3k2A==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 052/283] bpf: Fix bpf_xdp_store_bytes proto for read-only arg
Date: Sat, 28 Feb 2026 13:03:14 -0500
Message-ID: <20260228180709.1583486-52-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 6557f1565d779851c4db9c488c49c05a47a6e72f ]

While making some maps in Cilium read-only from the BPF side, we noticed
that the bpf_xdp_store_bytes proto is incorrect. In particular, the
verifier was throwing the following error:

  ; ret = ctx_store_bytes(ctx, l3_off + offsetof(struct iphdr, saddr),
                          &nat->address, 4, 0);
  635: (79) r1 = *(u64 *)(r10 -144)     ; R1=ctx() R10=fp0 fp-144=ctx()
  636: (b4) w2 = 26                     ; R2=26
  637: (b4) w4 = 4                      ; R4=4
  638: (b4) w5 = 0                      ; R5=0
  639: (85) call bpf_xdp_store_bytes#190
  write into map forbidden, value_size=6 off=0 size=4

nat comes from a BPF_F_RDONLY_PROG map, so R3 is a PTR_TO_MAP_VALUE.
The verifier checks the helper's memory access to R3 in
check_mem_size_reg, as it reaches ARG_CONST_SIZE argument. The third
argument has expected type ARG_PTR_TO_UNINIT_MEM, which includes the
MEM_WRITE flag. The verifier thus checks for a BPF_WRITE access on R3.
Given R3 points to a read-only map, the check fails.

Conversely, ARG_PTR_TO_UNINIT_MEM can also lead to the helper reading
from uninitialized memory.

This patch simply fixes the expected argument type to match that of
bpf_skb_store_bytes.

Fixes: 3f364222d032 ("net: xdp: introduce bpf_xdp_pointer utility routine")
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/9fa3c9f72d806e82541071c4df88b8cba28ad6a9.1769875479.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index ddb6d3dd34deb..e5dc1f699297b 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4118,7 +4118,7 @@ static const struct bpf_func_proto bpf_xdp_store_bytes_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE,
 };
 
-- 
2.51.0

