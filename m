Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D794168C4;
	Mon, 27 May 2024 19:18:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716837519; cv=none; b=RK69f6zbSpuMPsTC5umKqSaNupaszIETpJX5I6kb0Seut3vgoDCy+BYMDTaIQ+NEnTmfN0Vg4UsH1yWGPWtJM0Y2DGgdCYCbucbRodVXu9MRfyg7365KU5C1QG+36l/RCBZzEfzOglig6g3vIsFqab3Qvy9ZHA8ry7ayjTgohng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716837519; c=relaxed/simple;
	bh=iyxKbp0YqbPJLxbH1FV5WnIhrq5kPLzh1qEUsPFmmTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qFmE0+opg7gB3uIpj6q4RCMpsQG8n4FDw3oM1FF+iBlxmwnPpxt/NSvKHdWYfKNpx+D2PyHEQBjurYtdaosJqvKVYFvgTVSv7TBnRDrBH0YpAjzcOSobYEJKNTbN6bVGp1A6lOyAqIsQWBQFWx1eCX0wbcU3YlCaHvKYenyES2o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RTQzdsj9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RTQzdsj9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8848C2BBFC;
	Mon, 27 May 2024 19:18:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716837519;
	bh=iyxKbp0YqbPJLxbH1FV5WnIhrq5kPLzh1qEUsPFmmTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RTQzdsj94Pum3zZpUD5aQRNKH9P32AEn2BEe4zRzsQcTIym70BdE0JHUB3jVfc/Nm
	 HmTy4r8xOZKi+m1y/TpVT/5fAw1gAqYoV5cUG+kh+c0Os0L4ezOcud7QMM6DjTcrqe
	 pThq4aXFOaXjv/vKzg2PnTUmOP3u9F5/CaEKEQsk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johannes Nixdorf <mixi@shadowice.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.8 005/493] Revert "arm64: fpsimd: Implement lazy restore for kernel mode FPSIMD"
Date: Mon, 27 May 2024 20:50:07 +0200
Message-ID: <20240527185627.073283575@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240527185626.546110716@linuxfoundation.org>
References: <20240527185626.546110716@linuxfoundation.org>
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

From: Will Deacon <will@kernel.org>

commit b8995a18417088bb53f87c49d200ec72a9dd4ec1 upstream.

This reverts commit 2632e25217696712681dd1f3ecc0d71624ea3b23.

Johannes (and others) report data corruption with dm-crypt on Apple M1
which has been bisected to this change. Revert the offending commit
while we figure out what's going on.

Cc: stable@vger.kernel.org
Reported-by: Johannes Nixdorf <mixi@shadowice.org>
Link: https://lore.kernel.org/all/D1B7GPIR9K1E.5JFV37G0YTIF@shadowice.org/
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/processor.h |    1 -
 arch/arm64/kernel/fpsimd.c         |   18 ------------------
 2 files changed, 19 deletions(-)

--- a/arch/arm64/include/asm/processor.h
+++ b/arch/arm64/include/asm/processor.h
@@ -169,7 +169,6 @@ struct thread_struct {
 	struct debug_info	debug;		/* debugging */
 
 	struct user_fpsimd_state	kernel_fpsimd_state;
-	unsigned int			kernel_fpsimd_cpu;
 #ifdef CONFIG_ARM64_PTR_AUTH
 	struct ptrauth_keys_user	keys_user;
 #ifdef CONFIG_ARM64_PTR_AUTH_KERNEL
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1492,30 +1492,12 @@ void do_fpsimd_exc(unsigned long esr, st
 
 static void fpsimd_load_kernel_state(struct task_struct *task)
 {
-	struct cpu_fp_state *last = this_cpu_ptr(&fpsimd_last_state);
-
-	/*
-	 * Elide the load if this CPU holds the most recent kernel mode
-	 * FPSIMD context of the current task.
-	 */
-	if (last->st == &task->thread.kernel_fpsimd_state &&
-	    task->thread.kernel_fpsimd_cpu == smp_processor_id())
-		return;
-
 	fpsimd_load_state(&task->thread.kernel_fpsimd_state);
 }
 
 static void fpsimd_save_kernel_state(struct task_struct *task)
 {
-	struct cpu_fp_state cpu_fp_state = {
-		.st		= &task->thread.kernel_fpsimd_state,
-		.to_save	= FP_STATE_FPSIMD,
-	};
-
 	fpsimd_save_state(&task->thread.kernel_fpsimd_state);
-	fpsimd_bind_state_to_cpu(&cpu_fp_state);
-
-	task->thread.kernel_fpsimd_cpu = smp_processor_id();
 }
 
 void fpsimd_thread_switch(struct task_struct *next)


