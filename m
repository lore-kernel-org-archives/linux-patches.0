Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A88D31DFE16;
	Wed, 19 Feb 2025 09:11:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739956277; cv=none; b=rPeYcxtMANc2+QCQpRitKr7Y2pTC/dpC53V7QjuEepnHBZVex65LbwOKBUE5nnF15H6zxUj5gBSvRhbt9T01zi1frT64IILo0/n7tBvvzGN/2dZALNNH+TbgOyrTUl59Hzk81dRbdLiEDzsMx8g6YNyCMd5m+nzjp55pllHfiRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739956277; c=relaxed/simple;
	bh=68e6cAin3XA3iv/KMIQ2bmVmn+2/w8FPIxYOpAAwgzk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mqiCA8YwtVwCHHonE7515782C4bo0OJuzKr7FYfogRRUM91TN+l7A/hNqd1a1rx8DSls45fcswcVAYnABHa5K8sMcy6bfymc8mcsmBj97f5DjaZ/ml0TipYrnslCMyJ+dOyWYFvEi6viPTMsQvO2blGQG4YNmbd5sD72lpfEyeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o7xBLuSH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o7xBLuSH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35008C4CED1;
	Wed, 19 Feb 2025 09:11:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739956277;
	bh=68e6cAin3XA3iv/KMIQ2bmVmn+2/w8FPIxYOpAAwgzk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o7xBLuSH4eeLpeOxoBzhrXR1MvaD+7vSEEfuKrc55F2Y7oC8gOyg4e4iJ391WTgp3
	 RWJnqlpw3byqwp6PkvXVCMz63YFB84nsTOA517pm42sHJrFRrrKxjbmeDEZI7Bw0A4
	 Q/stv/5TkmOxcKcxgu8rZlTCV27MNMVwe7mTEYMo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Daniel Xu <dxu@dxuuu.xyz>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 126/578] bpf: tcp: Mark bpf_load_hdr_opt() arg2 as read-write
Date: Wed, 19 Feb 2025 09:22:10 +0100
Message-ID: <20250219082657.944226918@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250219082652.891560343@linuxfoundation.org>
References: <20250219082652.891560343@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Daniel Xu <dxu@dxuuu.xyz>

[ Upstream commit 8ac412a3361173e3000b16167af3d1f6f90af613 ]

MEM_WRITE attribute is defined as: "Non-presence of MEM_WRITE means that
MEM is only being read". bpf_load_hdr_opt() both reads and writes from
its arg2 - void *search_res.

This matters a lot for the next commit where we more precisely track
stack accesses. Without this annotation, the verifier will make false
assumptions about the contents of memory written to by helpers and
possibly prune valid branches.

Fixes: 6fad274f06f0 ("bpf: Add MEM_WRITE attribute")
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Signed-off-by: Daniel Xu <dxu@dxuuu.xyz>
Link: https://lore.kernel.org/r/730e45f8c39be2a5f3d8c4406cceca9d574cbf14.1736886479.git.dxu@dxuuu.xyz
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index b35615c469e27..370f61f9bf4ba 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -7529,7 +7529,7 @@ static const struct bpf_func_proto bpf_sock_ops_load_hdr_opt_proto = {
 	.gpl_only	= false,
 	.ret_type	= RET_INTEGER,
 	.arg1_type	= ARG_PTR_TO_CTX,
-	.arg2_type	= ARG_PTR_TO_MEM,
+	.arg2_type	= ARG_PTR_TO_MEM | MEM_WRITE,
 	.arg3_type	= ARG_CONST_SIZE,
 	.arg4_type	= ARG_ANYTHING,
 };
-- 
2.39.5



