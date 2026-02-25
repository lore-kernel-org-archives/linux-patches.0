Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82F7A21D596;
	Wed, 25 Feb 2026 01:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771982980; cv=none; b=iFFARWTl/zCxyLwwIVO92gBo1R5MPABDbiuEsAKRI53wZrEjZMop6uoLqI+su2ymg6C3RBWypCuJz1zIbtcZZ3Xq+shsTWoF6Gsw0FadGKte6ekt22uidfsYvy2KZl2ahkSd+6pOegcM3vtFAkCO2oAUD4qmfm3ifsAIq/j6YaI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771982980; c=relaxed/simple;
	bh=9uHy421SvF6o8Px/Nay7WoBQxK0nJXP51+UUYR/DGEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BwutDJKXYeNOoG0XilpAAzGdlQbjjBV9jA7WvU2hHMO9PI6pCfqzqRv3IPCJwZPGs6R8ZLDLot0MYwCni33nsyPS6C0d3HBtt0NF7qfx+hvuvL5P8BjEorIOVm/HDseJVoeDURO0uW6vxQPLxe1t/cU/A/gkWPuC1lR+RdSt7vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dRIJvrUS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dRIJvrUS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029F3C116D0;
	Wed, 25 Feb 2026 01:29:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771982980;
	bh=9uHy421SvF6o8Px/Nay7WoBQxK0nJXP51+UUYR/DGEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dRIJvrUSiQQmBRWb3668eGShAMalouv75plNriPwhpb4+koI4Tdk6EVJSrmJQoFfJ
	 sl8WRo13+uYWoRxU80zfWNGYejh/DYxiJT3vlVspuf0+G34dDZqF4saMEnMwd8S63o
	 XubWiwr2j04P5h8RSMKqjmjcBdC9QIgZkxcdNy/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 116/781] bpf: Fix bpf_xdp_store_bytes proto for read-only arg
Date: Tue, 24 Feb 2026 17:13:45 -0800
Message-ID: <20260225012402.519849202@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index b1f8e2930e1c4..51318cb40f778 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -4137,7 +4137,7 @@ static const struct bpf_func_proto bpf_xdp_store_bytes_proto = {
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
 	.arg2_type	= ARG_ANYTHING,
-	.arg3_type	= ARG_PTR_TO_UNINIT_MEM,
+	.arg3_type	= ARG_PTR_TO_MEM | MEM_RDONLY,
 	.arg4_type	= ARG_CONST_SIZE,
 };
 
-- 
2.51.0



