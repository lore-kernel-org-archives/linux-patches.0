Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA05D6CDC8;
	Tue, 14 May 2024 10:24:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715682246; cv=none; b=PRmf4uVCV7f2DIcPaI5qCxo8pxn9tACcC7Y0RfU/ZOdazbU6RLw/KSTKEWFnykdTkfzVxR5M6tvgo6CfhfA453I5D6b1dyTBrNzJ+kC2gdNsS0N8PwNDuXF9lvBfCLF6c8TXCHoq6cD9gMbkEnPfh0RxYTyetPkFXK8M1MdFqSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715682246; c=relaxed/simple;
	bh=W8qzj4IWabhjkzIq2nzMtWkk12ECyp4dSxZJjoK6oo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA5lhY51MTgo+6/LVmLa3rulGbXVEBFIe7PDXRStBVPHcWCjSjNvYLITl9g8NvMlYNoTNxNuR1kgTwVDAKa4kjPf56LSgieF8Y9jRSst3Q/1O1Mi66ImQRSQ2IIj3uCIwRAS7zO18GQFpTfdbcNEcS5cO/jTDZRUfn6RQlNuEvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xILRIDii; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xILRIDii"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25493C2BD10;
	Tue, 14 May 2024 10:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715682246;
	bh=W8qzj4IWabhjkzIq2nzMtWkk12ECyp4dSxZJjoK6oo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xILRIDiilRWgvHh6164E7NGyymLIsm16QDHNlX1iI8e2ZNiYB/37anCoAsqGclRvU
	 7SXyZu78M0ALpZ9kmeG5PHSfl5GpZEVDIzo9ctfO3GGGVXN45r+8FaJobz3cSjke3d
	 k+mUYctDrer8Z3Dqn4YnvXuYwRKhfTWhF+zteReY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ivan Babrou <ivan@cloudflare.com>,
	Xu Kuohai <xukuohai@huawei.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 034/336] bpf, arm64: Fix incorrect runtime stats
Date: Tue, 14 May 2024 12:13:58 +0200
Message-ID: <20240514101039.897719766@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514101038.595152603@linuxfoundation.org>
References: <20240514101038.595152603@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit dc7d7447b56bcc9cf79a9c22e4edad200a298e4c ]

When __bpf_prog_enter() returns zero, the arm64 register x20 that stores
prog start time is not assigned to zero, causing incorrect runtime stats.

To fix it, assign the return value of bpf_prog_enter() to x20 register
immediately upon its return.

Fixes: efc9909fdce0 ("bpf, arm64: Add bpf trampoline for arm64")
Reported-by: Ivan Babrou <ivan@cloudflare.com>
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Tested-by: Ivan Babrou <ivan@cloudflare.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20240416064208.2919073-2-xukuohai@huaweicloud.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 00217d8d034b7..ceed77c29fe6b 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -1738,15 +1738,15 @@ static void invoke_bpf_prog(struct jit_ctx *ctx, struct bpf_tramp_link *l,
 
 	emit_call(enter_prog, ctx);
 
+	/* save return value to callee saved register x20 */
+	emit(A64_MOV(1, A64_R(20), A64_R(0)), ctx);
+
 	/* if (__bpf_prog_enter(prog) == 0)
 	 *         goto skip_exec_of_prog;
 	 */
 	branch = ctx->image + ctx->idx;
 	emit(A64_NOP, ctx);
 
-	/* save return value to callee saved register x20 */
-	emit(A64_MOV(1, A64_R(20), A64_R(0)), ctx);
-
 	emit(A64_ADD_I(1, A64_R(0), A64_SP, args_off), ctx);
 	if (!p->jited)
 		emit_addr_mov_i64(A64_R(1), (const u64)p->insnsi, ctx);
-- 
2.43.0



