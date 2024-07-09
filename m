Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 25FBD155389;
	Tue,  9 Jul 2024 11:12:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523579; cv=none; b=hCFbkNCRVA2cpQ2Wr0cphKStm/1XAtCkF+gpS0PCQV++zV7aEjn8/WXr6HfI9Djn5R1CHLM3GDRXm04KgdTHmxz2wY9VoF8LGdfV1ANLnw17MXgpUrrk/eZ18sVupX6LRDOtg3+rWy3h15UxIfntTdIE0wmU0CycAIH3wdnUlG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523579; c=relaxed/simple;
	bh=5afz7z6AnejZQX3BXGhw2eE7wTQ61Xk9+kzIpvFUVDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q2wpzErLTX9GAWq5diAVgvRfeNs5p7AxrW58kQBScEe4aix3pMG+6ZT9QKRxAoUsdIMFk05VnnMXsAIczfibNdU14ougoESal7xTn3BVUHJULb2zJZwhBEYsS0fYTpA68lpHH8FhwT9rD7OupByl+d96lzUmXiq29fuO80zEIB4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rDG0A2H4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rDG0A2H4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558C8C3277B;
	Tue,  9 Jul 2024 11:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523578;
	bh=5afz7z6AnejZQX3BXGhw2eE7wTQ61Xk9+kzIpvFUVDA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rDG0A2H4FA48xYRq9z9QkWT5oG5zDXLxL7st7MOVzvFmUeHlqQfHJbP+6yKancV/a
	 syZAyjZx5d+iLTbVZlwksupbWc5kq4rSqycdEa/1ufp6tUhtCzWOktnjrV7RguGTIg
	 z/w7l3AmMhFV4lk/03HeToMvR7k0iX933o6oEYWE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Gray <bgray@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 039/139] powerpc/dexcr: Track the DEXCR per-process
Date: Tue,  9 Jul 2024 13:08:59 +0200
Message-ID: <20240709110659.676165008@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

From: Benjamin Gray <bgray@linux.ibm.com>

[ Upstream commit 75171f06c4507c3b6b5a69d793879fb20d108bb1 ]

Add capability to make the DEXCR act as a per-process SPR.

We do not yet have an interface for changing the values per task. We
also expect the kernel to use a single DEXCR value across all tasks
while in privileged state, so there is no need to synchronize after
changing it (the userspace aspects will synchronize upon returning to
userspace).

Signed-off-by: Benjamin Gray <bgray@linux.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20240417112325.728010-3-bgray@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/processor.h     |  1 +
 arch/powerpc/kernel/process.c            | 10 ++++++++++
 arch/powerpc/kernel/ptrace/ptrace-view.c |  7 +------
 3 files changed, 12 insertions(+), 6 deletions(-)

diff --git a/arch/powerpc/include/asm/processor.h b/arch/powerpc/include/asm/processor.h
index b2c51d337e60c..882e31296ea6b 100644
--- a/arch/powerpc/include/asm/processor.h
+++ b/arch/powerpc/include/asm/processor.h
@@ -260,6 +260,7 @@ struct thread_struct {
 	unsigned long   sier2;
 	unsigned long   sier3;
 	unsigned long	hashkeyr;
+	unsigned long	dexcr;
 
 #endif
 };
diff --git a/arch/powerpc/kernel/process.c b/arch/powerpc/kernel/process.c
index 9452a54d356c9..d482c3fd81d7a 100644
--- a/arch/powerpc/kernel/process.c
+++ b/arch/powerpc/kernel/process.c
@@ -1185,6 +1185,9 @@ static inline void save_sprs(struct thread_struct *t)
 
 	if (cpu_has_feature(CPU_FTR_DEXCR_NPHIE))
 		t->hashkeyr = mfspr(SPRN_HASHKEYR);
+
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		t->dexcr = mfspr(SPRN_DEXCR);
 #endif
 }
 
@@ -1267,6 +1270,10 @@ static inline void restore_sprs(struct thread_struct *old_thread,
 	if (cpu_has_feature(CPU_FTR_DEXCR_NPHIE) &&
 	    old_thread->hashkeyr != new_thread->hashkeyr)
 		mtspr(SPRN_HASHKEYR, new_thread->hashkeyr);
+
+	if (cpu_has_feature(CPU_FTR_ARCH_31) &&
+	    old_thread->dexcr != new_thread->dexcr)
+		mtspr(SPRN_DEXCR, new_thread->dexcr);
 #endif
 
 }
@@ -1878,6 +1885,9 @@ int copy_thread(struct task_struct *p, const struct kernel_clone_args *args)
 #ifdef CONFIG_PPC_BOOK3S_64
 	if (cpu_has_feature(CPU_FTR_DEXCR_NPHIE))
 		p->thread.hashkeyr = current->thread.hashkeyr;
+
+	if (cpu_has_feature(CPU_FTR_ARCH_31))
+		p->thread.dexcr = mfspr(SPRN_DEXCR);
 #endif
 	return 0;
 }
diff --git a/arch/powerpc/kernel/ptrace/ptrace-view.c b/arch/powerpc/kernel/ptrace/ptrace-view.c
index 584cf5c3df509..c1819e0a66842 100644
--- a/arch/powerpc/kernel/ptrace/ptrace-view.c
+++ b/arch/powerpc/kernel/ptrace/ptrace-view.c
@@ -469,12 +469,7 @@ static int dexcr_get(struct task_struct *target, const struct user_regset *regse
 	if (!cpu_has_feature(CPU_FTR_ARCH_31))
 		return -ENODEV;
 
-	/*
-	 * The DEXCR is currently static across all CPUs, so we don't
-	 * store the target's value anywhere, but the static value
-	 * will also be correct.
-	 */
-	membuf_store(&to, (u64)lower_32_bits(DEXCR_INIT));
+	membuf_store(&to, (u64)lower_32_bits(target->thread.dexcr));
 
 	/*
 	 * Technically the HDEXCR is per-cpu, but a hypervisor can't reasonably
-- 
2.43.0



