Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8636239B969;
	Wed, 20 May 2026 16:34:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294852; cv=none; b=iIvhIRxutE4iFpZjnx8xLQ0E398upk8BCEgMRXu8GOFdF4YhOG+ngp+FwTXVf6q3GG5m224jdbxkvhTtZA1EXLwmF0/3ddmRTu834Gc2bqr9VR0Jd0HBJyfPo6ldURUAPphUG5szx7vjTFu4BOIOChbKMCvUDTGbv1rFWwjMsyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294852; c=relaxed/simple;
	bh=R/VBoTs+7yc0vEwl27fEubOo20h7UIAohSpIWl1Rtpw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=o1WAuSePZiRYjqSFhDiGu916Ehl6dAlaff+29zPAWnK6fgBSKvtmI6vIhThDbh95rQyeOI8JvX1HEBmW4Ou7iSWbY8fcEXdhyIeusan67q7pw9hdmFuMXyXsFykv18qVOWTdY9pIEB8hcfyeYeXVWGwuLV/edl59f2bw3QCQytQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bwlzc6wn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bwlzc6wn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EAEBC1F000E9;
	Wed, 20 May 2026 16:34:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294850;
	bh=HQR3VVGXi5sRYDG0Jf30u68sjB6JLNIKRLyds/VW4vQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bwlzc6wn0cH+/B3sJZKwEtz9ffb69pgzyhMwkCE9MXpo7tVFd2ZbIr/IGEn7o03wa
	 VLuk1ieh7/hBnGJyjDi35i74O2XSGi+n26QEy3SqGZvpNn8zkef3te7y6KZCa7wUUx
	 7dw+GorkyhvCT3QLFwT0bYqAZMDVQnRVwzt7vtHY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Quan Sun <2022090917019@std.uestc.edu.cn>,
	Yinhao Hu <dddddd@hust.edu.cn>,
	Kaiyan Mei <M202472210@hust.edu.cn>,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0195/1146] bpf: Fix same-register dst/src OOB read and pointer leak in sock_ops
Date: Wed, 20 May 2026 18:07:25 +0200
Message-ID: <20260520162152.689361140@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 10f86a2a5c91fc4c4d001960f1c21abe52545ef6 ]

When a BPF sock_ops program accesses ctx fields with dst_reg == src_reg,
the SOCK_OPS_GET_SK() and SOCK_OPS_GET_FIELD() macros fail to zero the
destination register in the !fullsock / !locked_tcp_sock path.

Both macros borrow a temporary register to check is_fullsock /
is_locked_tcp_sock when dst_reg == src_reg, because dst_reg holds the
ctx pointer. When the check is false (e.g., TCP_NEW_SYN_RECV state with
a request_sock), dst_reg should be zeroed but is not, leaving the stale
ctx pointer:

 - SOCK_OPS_GET_SK: dst_reg retains the ctx pointer, passes NULL checks
   as PTR_TO_SOCKET_OR_NULL, and can be used as a bogus socket pointer,
   leading to stack-out-of-bounds access in helpers like
   bpf_skc_to_tcp6_sock().

 - SOCK_OPS_GET_FIELD: dst_reg retains the ctx pointer which the
   verifier believes is a SCALAR_VALUE, leaking a kernel pointer.

Fix both macros by:
 - Changing JMP_A(1) to JMP_A(2) in the fullsock path to skip the
   added instruction.
 - Adding BPF_MOV64_IMM(si->dst_reg, 0) after the temp register
   restore in the !fullsock path, placed after the restore because
   dst_reg == src_reg means we need src_reg intact to read ctx->temp.

Fixes: fd09af010788 ("bpf: sock_ops ctx access may stomp registers in corner case")
Fixes: 84f44df664e9 ("bpf: sock_ops sk access may stomp registers when dst_reg = src_reg")
Reported-by: Quan Sun <2022090917019@std.uestc.edu.cn>
Reported-by: Yinhao Hu <dddddd@hust.edu.cn>
Reported-by: Kaiyan Mei <M202472210@hust.edu.cn>
Reported-by: Dongliang Mu <dzm91@hust.edu.cn>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Closes: https://lore.kernel.org/bpf/6fe1243e-149b-4d3b-99c7-fcc9e2f75787@std.uestc.edu.cn/T/#u
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://patch.msgid.link/20260407022720.162151-2-jiayuan.chen@linux.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 78b548158fb05..53ce06ed4a88e 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10581,10 +10581,11 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 				      si->dst_reg, si->dst_reg,		      \
 				      offsetof(OBJ, OBJ_FIELD));	      \
 		if (si->dst_reg == si->src_reg)	{			      \
-			*insn++ = BPF_JMP_A(1);				      \
+			*insn++ = BPF_JMP_A(2);				      \
 			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
 				      offsetof(struct bpf_sock_ops_kern,      \
 				      temp));				      \
+			*insn++ = BPF_MOV64_IMM(si->dst_reg, 0);	      \
 		}							      \
 	} while (0)
 
@@ -10618,10 +10619,11 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
 				      si->dst_reg, si->src_reg,		      \
 				      offsetof(struct bpf_sock_ops_kern, sk));\
 		if (si->dst_reg == si->src_reg)	{			      \
-			*insn++ = BPF_JMP_A(1);				      \
+			*insn++ = BPF_JMP_A(2);				      \
 			*insn++ = BPF_LDX_MEM(BPF_DW, reg, si->src_reg,	      \
 				      offsetof(struct bpf_sock_ops_kern,      \
 				      temp));				      \
+			*insn++ = BPF_MOV64_IMM(si->dst_reg, 0);	      \
 		}							      \
 	} while (0)
 
-- 
2.53.0



