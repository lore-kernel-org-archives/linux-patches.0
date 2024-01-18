Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5867B22F06;
	Thu, 18 Jan 2024 10:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575338; cv=none; b=Q+EAlDwws6210PZYqEJNIMkGIjkBnDdHUrCE0EofY12MtrcO3cMMmwdxaG65eMtGXjWRyUmWx+yRdvikX45CgaRsBC5fhgb/Im1YJFCDsoCnmF8Bq3aQM2mNI1L94yAIgWdu3et9E6qFhpKjVdfIVJc8UtrPMGa5MU3mev8IY6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575338; c=relaxed/simple;
	bh=mNpzoaxehkQVZSHukhhnhhMTQkzDzcjgtbYK1lGYrsE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=LWIBzGFe6RCAbBehm64xsrPI/3PCp7jgeLACcl85qDdoCnmV19UX7p+bxiVfc0IBkvCQE8Dbkwp4okK/CSHToTY0qXx8z0LVacQYymaBSRerpCDvhC41zLYwg/znzypDGazAk15oF70L2em9GrqmDYCPDrNEXMlwprSx5Hc7fbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UkVSZ2mb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UkVSZ2mb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EFC2C433F1;
	Thu, 18 Jan 2024 10:55:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575337;
	bh=mNpzoaxehkQVZSHukhhnhhMTQkzDzcjgtbYK1lGYrsE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UkVSZ2mb8jHqUocprMUROLPiB5sX67Yto4ywsf1YOGvV6zIvlPPTGhGPuEYqI7/ie
	 XAw/d5wvraTjP0BG3Ce1vVQhNdUJy3umkHbrumhHQplJ3z8EdcKzsUyucJHAmyPp4S
	 C7FgnYr7TS4aw0vJOsh84ZL9UQwvVN5YoaOu4SV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hengqi Chen <hengqi.chen@gmail.com>,
	Jinyang He <hejinyang@loongson.cn>,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/150] LoongArch: Set unwind stack type to unknown rather than set error flag
Date: Thu, 18 Jan 2024 11:48:09 +0100
Message-ID: <20240118104323.072524552@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinyang He <hejinyang@loongson.cn>

[ Upstream commit 97ceddbc9404a7d1e2c4049435bff29427d762cc ]

During unwinding, unwind_done() is used as an end condition. Normally it
unwind to the user stack and then set the stack type to unknown, which
is a normal exit. When something unexpected happens in unwind process
and we cannot unwind anymore, we should set the error flag, and also set
the stack type to unknown to indicate that the unwind process can not
continue. The error flag emphasizes that the unwind process produce an
unexpected error. There is no unexpected things when we unwind the PT_REGS
in the top of IRQ stack and find out that is an user mode PT_REGS. Thus,
we should not set error flag and just set stack type to unknown.

Reported-by: Hengqi Chen <hengqi.chen@gmail.com>
Acked-by: Hengqi Chen <hengqi.chen@gmail.com>
Signed-off-by: Jinyang He <hejinyang@loongson.cn>
Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/kernel/stacktrace.c      | 2 +-
 arch/loongarch/kernel/unwind.c          | 1 -
 arch/loongarch/kernel/unwind_prologue.c | 2 +-
 3 files changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/loongarch/kernel/stacktrace.c b/arch/loongarch/kernel/stacktrace.c
index 92270f14db94..f623feb2129f 100644
--- a/arch/loongarch/kernel/stacktrace.c
+++ b/arch/loongarch/kernel/stacktrace.c
@@ -32,7 +32,7 @@ void arch_stack_walk(stack_trace_consume_fn consume_entry, void *cookie,
 	}
 
 	for (unwind_start(&state, task, regs);
-	     !unwind_done(&state) && !unwind_error(&state); unwind_next_frame(&state)) {
+	     !unwind_done(&state); unwind_next_frame(&state)) {
 		addr = unwind_get_return_address(&state);
 		if (!addr || !consume_entry(cookie, addr))
 			break;
diff --git a/arch/loongarch/kernel/unwind.c b/arch/loongarch/kernel/unwind.c
index ba324ba76fa1..a463d6961344 100644
--- a/arch/loongarch/kernel/unwind.c
+++ b/arch/loongarch/kernel/unwind.c
@@ -28,6 +28,5 @@ bool default_next_frame(struct unwind_state *state)
 
 	} while (!get_stack_info(state->sp, state->task, info));
 
-	state->error = true;
 	return false;
 }
diff --git a/arch/loongarch/kernel/unwind_prologue.c b/arch/loongarch/kernel/unwind_prologue.c
index 55afc27320e1..929ae240280a 100644
--- a/arch/loongarch/kernel/unwind_prologue.c
+++ b/arch/loongarch/kernel/unwind_prologue.c
@@ -227,7 +227,7 @@ static bool next_frame(struct unwind_state *state)
 	} while (!get_stack_info(state->sp, state->task, info));
 
 out:
-	state->error = true;
+	state->stack_info.type = STACK_TYPE_UNKNOWN;
 	return false;
 }
 
-- 
2.43.0



