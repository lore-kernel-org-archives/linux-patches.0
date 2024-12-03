Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAC6E1F76D2;
	Tue,  3 Dec 2024 15:08:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733238492; cv=none; b=DA4dIPbO85uGZmNa0SMzUzgANd1ZFZTtZEMoAJU03CAYbf1hA26VtyX+2bduX89msbGuyFxxD5tQA37TJ0KFfVopVpE+UiQkXq6zVTIpCj6Azva1b58YynPaUDRAVapoxGp28O+EA5MONs9zfP5nf1vc8csTZsR5ezK6BibCCRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733238492; c=relaxed/simple;
	bh=h8LRl4iv2K/64gTZcybdoBMYjFLi2S9PPAG6EI98LaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EP/elB6sEoqU6qR/Rvs08TxeqWuaUg3aDgKTwfRx6jwiv8h32TlLK0WQFiegfEUnjvutqDy9/RIsvkmhs1JMVKWPFU6VKoge3KNbRUCdOArRo2FX1Ve8Ujx7W5CBrdggURO7ytlYBedmcxCVQsD4XA7/jR0SEojv2PWxshD1Tio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gxpRJ5T/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gxpRJ5T/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AD96C4CECF;
	Tue,  3 Dec 2024 15:08:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733238491;
	bh=h8LRl4iv2K/64gTZcybdoBMYjFLi2S9PPAG6EI98LaM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gxpRJ5T//QrAn1RaL345bd7Yh73aK1ym4FjvpTpTlGbKcyk6poBPYawov12MSvA0I
	 bYHUNxR2fFF7tuh9BDpdwuBoICaTCBEqkOfzLbkV6baRxY+0mD3w2RWP02XWHU6Qm8
	 Jz8O7YjTiKY6tBB5CgZmg8pMQXF3kC/bD6yIDu8M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Kuohai <xukuohai@huawei.com>,
	Puranjay Mohan <puranjay@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 295/817] bpf, arm64: Remove garbage frame for struct_ops trampoline
Date: Tue,  3 Dec 2024 15:37:47 +0100
Message-ID: <20241203144007.333511217@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Kuohai <xukuohai@huawei.com>

[ Upstream commit 87cb58aebdf7005661a07e9fd5a900f924d48c75 ]

The callsite layout for arm64 fentry is:

mov x9, lr
nop

When a bpf prog is attached, the nop instruction is patched to a call
to bpf trampoline:

mov x9, lr
bl <bpf trampoline>

So two return addresses are passed to bpf trampoline: the return address
for the traced function/prog, stored in x9, and the return address for
the bpf trampoline itself, stored in lr. To obtain a full and accurate
call stack, the bpf trampoline constructs two fake function frames using
x9 and lr.

However, struct_ops progs are invoked directly as function callbacks,
meaning that x9 is not set as it is in the fentry callsite. In this case,
the frame constructed using x9 is garbage. The following stack trace for
struct_ops, captured by perf sampling, illustrates this issue, where
tcp_ack+0x404 is a garbage frame:

ffffffc0801a04b4 bpf_prog_50992e55a0f655a9_bpf_cubic_cong_avoid+0x98 (bpf_prog_50992e55a0f655a9_bpf_cubic_cong_avoid)
ffffffc0801a228c [unknown] ([kernel.kallsyms]) // bpf trampoline
ffffffd08d362590 tcp_ack+0x798 ([kernel.kallsyms]) // caller for bpf trampoline
ffffffd08d3621fc tcp_ack+0x404 ([kernel.kallsyms]) // garbage frame
ffffffd08d36452c tcp_rcv_established+0x4ac ([kernel.kallsyms])
ffffffd08d375c58 tcp_v4_do_rcv+0x1f0 ([kernel.kallsyms])
ffffffd08d378630 tcp_v4_rcv+0xeb8 ([kernel.kallsyms])

To fix it, construct only one frame using lr for struct_ops.

The above stack trace also indicates that there is no kernel symbol for
struct_ops bpf trampoline. This will be addressed in a follow-up patch.

Fixes: efc9909fdce0 ("bpf, arm64: Add bpf trampoline for arm64")
Signed-off-by: Xu Kuohai <xukuohai@huawei.com>
Acked-by: Puranjay Mohan <puranjay@kernel.org>
Tested-by: Puranjay Mohan <puranjay@kernel.org>
Link: https://lore.kernel.org/r/20241025085220.533949-1-xukuohai@huaweicloud.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/net/bpf_jit_comp.c | 47 +++++++++++++++++++++++------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/arch/arm64/net/bpf_jit_comp.c b/arch/arm64/net/bpf_jit_comp.c
index 6e5a934ee2f55..984fc63ed0bd9 100644
--- a/arch/arm64/net/bpf_jit_comp.c
+++ b/arch/arm64/net/bpf_jit_comp.c
@@ -2046,6 +2046,12 @@ static void restore_args(struct jit_ctx *ctx, int args_off, int nregs)
 	}
 }
 
+static bool is_struct_ops_tramp(const struct bpf_tramp_links *fentry_links)
+{
+	return fentry_links->nr_links == 1 &&
+		fentry_links->links[0]->link.type == BPF_LINK_TYPE_STRUCT_OPS;
+}
+
 /* Based on the x86's implementation of arch_prepare_bpf_trampoline().
  *
  * bpf prog and function entry before bpf trampoline hooked:
@@ -2075,6 +2081,7 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 	struct bpf_tramp_links *fmod_ret = &tlinks[BPF_TRAMP_MODIFY_RETURN];
 	bool save_ret;
 	__le32 **branches = NULL;
+	bool is_struct_ops = is_struct_ops_tramp(fentry);
 
 	/* trampoline stack layout:
 	 *                  [ parent ip         ]
@@ -2143,11 +2150,14 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 	 */
 	emit_bti(A64_BTI_JC, ctx);
 
-	/* frame for parent function */
-	emit(A64_PUSH(A64_FP, A64_R(9), A64_SP), ctx);
-	emit(A64_MOV(1, A64_FP, A64_SP), ctx);
+	/* x9 is not set for struct_ops */
+	if (!is_struct_ops) {
+		/* frame for parent function */
+		emit(A64_PUSH(A64_FP, A64_R(9), A64_SP), ctx);
+		emit(A64_MOV(1, A64_FP, A64_SP), ctx);
+	}
 
-	/* frame for patched function */
+	/* frame for patched function for tracing, or caller for struct_ops */
 	emit(A64_PUSH(A64_FP, A64_LR, A64_SP), ctx);
 	emit(A64_MOV(1, A64_FP, A64_SP), ctx);
 
@@ -2241,19 +2251,24 @@ static int prepare_trampoline(struct jit_ctx *ctx, struct bpf_tramp_image *im,
 	/* reset SP  */
 	emit(A64_MOV(1, A64_SP, A64_FP), ctx);
 
-	/* pop frames  */
-	emit(A64_POP(A64_FP, A64_LR, A64_SP), ctx);
-	emit(A64_POP(A64_FP, A64_R(9), A64_SP), ctx);
-
-	if (flags & BPF_TRAMP_F_SKIP_FRAME) {
-		/* skip patched function, return to parent */
-		emit(A64_MOV(1, A64_LR, A64_R(9)), ctx);
-		emit(A64_RET(A64_R(9)), ctx);
+	if (is_struct_ops) {
+		emit(A64_POP(A64_FP, A64_LR, A64_SP), ctx);
+		emit(A64_RET(A64_LR), ctx);
 	} else {
-		/* return to patched function */
-		emit(A64_MOV(1, A64_R(10), A64_LR), ctx);
-		emit(A64_MOV(1, A64_LR, A64_R(9)), ctx);
-		emit(A64_RET(A64_R(10)), ctx);
+		/* pop frames */
+		emit(A64_POP(A64_FP, A64_LR, A64_SP), ctx);
+		emit(A64_POP(A64_FP, A64_R(9), A64_SP), ctx);
+
+		if (flags & BPF_TRAMP_F_SKIP_FRAME) {
+			/* skip patched function, return to parent */
+			emit(A64_MOV(1, A64_LR, A64_R(9)), ctx);
+			emit(A64_RET(A64_R(9)), ctx);
+		} else {
+			/* return to patched function */
+			emit(A64_MOV(1, A64_R(10), A64_LR), ctx);
+			emit(A64_MOV(1, A64_LR, A64_R(9)), ctx);
+			emit(A64_RET(A64_R(10)), ctx);
+		}
 	}
 
 	kfree(branches);
-- 
2.43.0



