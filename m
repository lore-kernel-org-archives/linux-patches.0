Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6B6126FA77;
	Tue, 12 Aug 2025 19:14:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026055; cv=none; b=G0N9auLuhOAEzzDxS8N6Q7+R1kBCwVwVVjvl7q5+Zc7n59S5zdwWoGfK5bx3EPhGgdSBIbLntRI2KZUeYDar6E5ms8+q7G72YPapgdeMoApIANq6mB9Z2jY17NcCwdUmZaXl1gGg36aNLZvLbNdEDYtMrDyZO8Jngiu03M6k/e8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026055; c=relaxed/simple;
	bh=tE1Ra9sF+Lt73PHl+Iij/n7R9sLMFOqvPvQAEU0hME8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LBCmf4xBbnPBg441MEu5Ec0PvNY+6NJlWSmaM8bIxwaG/BHn7Sl8c8n1O40JjrZ0izAwIwCli5NoI/nBT27m2rh3CiPKz5ko/qikzd2mPeUPZBdTOArvbNWPQ4+CGknQ+newjhyGK28LeqI+9S2sRrmatQbaxyCJb5oQYeEThVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=edNLNzPg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="edNLNzPg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4645CC4CEF0;
	Tue, 12 Aug 2025 19:14:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026055;
	bh=tE1Ra9sF+Lt73PHl+Iij/n7R9sLMFOqvPvQAEU0hME8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=edNLNzPgywrZ89z65C4vUuJ7e1oV8JtFxBPC8SwtaKB25BLyVSdWbPFLxejMlMOuj
	 K0AQcIgrUYXBVj/+4JuyLjJGFyeMBsM7ruvhdbnc9NHo7J/X2hmK3l2mZr5MN7WWeK
	 t+pwxI8vNNf1FERbkHo/akLLpdAIVkgADW5r3ULk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeremy Linton <jeremy.linton@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 190/480] arm64/gcs: task_gcs_el0_enable() should use passed task
Date: Tue, 12 Aug 2025 19:46:38 +0200
Message-ID: <20250812174405.339069187@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeremy Linton <jeremy.linton@arm.com>

[ Upstream commit cbbcfb94c55c02a8c4ce52b5da0770b5591a314c ]

Mark Rutland noticed that the task parameter is ignored and
'current' is being used instead. Since this is usually
what its passed, it hasn't yet been causing problems but likely
will as the code gets more testing.

But, once this is fixed, it creates a new bug in copy_thread_gcs()
since the gcs_el_mode isn't yet set for the task before its being
checked. Move gcs_alloc_thread_stack() after the new task's
gcs_el0_mode initialization to avoid this.

Fixes: fc84bc5378a8 ("arm64/gcs: Context switch GCS state for EL0")
Signed-off-by: Jeremy Linton <jeremy.linton@arm.com>
Reviewed-by: Mark Brown <broonie@kernel.org>
Link: https://lore.kernel.org/r/20250719043740.4548-2-jeremy.linton@arm.com
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/gcs.h | 2 +-
 arch/arm64/kernel/process.c  | 6 +++---
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/arm64/include/asm/gcs.h b/arch/arm64/include/asm/gcs.h
index f50660603ecf..5bc432234d3a 100644
--- a/arch/arm64/include/asm/gcs.h
+++ b/arch/arm64/include/asm/gcs.h
@@ -58,7 +58,7 @@ static inline u64 gcsss2(void)
 
 static inline bool task_gcs_el0_enabled(struct task_struct *task)
 {
-	return current->thread.gcs_el0_mode & PR_SHADOW_STACK_ENABLE;
+	return task->thread.gcs_el0_mode & PR_SHADOW_STACK_ENABLE;
 }
 
 void gcs_set_el0_mode(struct task_struct *task);
diff --git a/arch/arm64/kernel/process.c b/arch/arm64/kernel/process.c
index 4bc70205312e..ce21682fe129 100644
--- a/arch/arm64/kernel/process.c
+++ b/arch/arm64/kernel/process.c
@@ -305,13 +305,13 @@ static int copy_thread_gcs(struct task_struct *p,
 	p->thread.gcs_base = 0;
 	p->thread.gcs_size = 0;
 
+	p->thread.gcs_el0_mode = current->thread.gcs_el0_mode;
+	p->thread.gcs_el0_locked = current->thread.gcs_el0_locked;
+
 	gcs = gcs_alloc_thread_stack(p, args);
 	if (IS_ERR_VALUE(gcs))
 		return PTR_ERR((void *)gcs);
 
-	p->thread.gcs_el0_mode = current->thread.gcs_el0_mode;
-	p->thread.gcs_el0_locked = current->thread.gcs_el0_locked;
-
 	return 0;
 }
 
-- 
2.39.5



