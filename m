Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C965446BEF;
	Thu, 30 Jul 2026 15:23:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425006; cv=none; b=AGfuxt6ckzWq2DzOuWeID2DkIQV+X5MmZU0eqMTcmmJEfXZxMPilGE7Oaw51bbEM0TmfAharF5cYZpryGs75XoZITXfRIXSzRsCiPuVrmntejxK15gM0xLpFseYzsw0JIqGywCG/jQ2RjHY33309aqC3rC+uSQGUn5O6Kp0epIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425006; c=relaxed/simple;
	bh=pDtQOXsIYMK3hgUllbKwLjVynGQPFz4sUJemNM6QBe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TgwtQfBIzJbcR93PDq+VBZehmx+Y44hGlgshxFIUN5V/2xBYa7Fvifm0hzD6FXIISCz7AU7UeJtBDPf2ecxtxfg+/NIQaZsi/TN3wkSTQZgvhcylhe+E7CGn3mZd3I17PGVVIJyCYrcHrITf1JYLEvA7wHb2d50ckNo0sq5r3A0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GiTnSvXN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GiTnSvXN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93F691F000E9;
	Thu, 30 Jul 2026 15:23:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425005;
	bh=eL+uiZqHNchoSaKjfEESQACnwrqyd45j+5H2Kidfixs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GiTnSvXNJCoYh1G+yBSNB8CxBBvNCBn4GHZPRx7Pfe+J+b1PKOrtHl1Sn9mu3XPe1
	 GuJ49HtFHKj46FbJMVE2p2BShg87X6tGhFNInCP2Ajry8i8GEzXG4Jytx6TzLH5F7U
	 ieU6SM5Ze/hJe9LR0rYjqNywfNrwYUU7alE+le8Y=
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
	Sasha Levin <sashal@kernel.org>,
	Jay Wang <wanjay@amazon.com>
Subject: [PATCH 6.18 591/675] bpf: Fix same-register dst/src OOB read and pointer leak in sock_ops
Date: Thu, 30 Jul 2026 16:15:21 +0200
Message-ID: <20260730141457.683400728@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141445.110192266@linuxfoundation.org>
References: <20260730141445.110192266@linuxfoundation.org>
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
Signed-off-by: Jay Wang <wanjay@amazon.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/filter.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 42385e79043131..332f4986376f11 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -10539,10 +10539,11 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
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
 
@@ -10576,10 +10577,11 @@ static u32 sock_ops_convert_ctx_access(enum bpf_access_type type,
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



