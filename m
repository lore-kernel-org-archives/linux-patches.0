Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 861F011703
	for <patches@lists.linux.dev>; Mon, 21 Aug 2023 19:58:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F20B0C433C9;
	Mon, 21 Aug 2023 19:58:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692647931;
	bh=4c6RfHxoiVXLH7umeRV9xFgCuMrIHXXhTH9bHfcqCao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rkNwh3ZAVYk1Oz0VY5RMX22h8qJ/crHiH6lqXOWDo+jqyJ+JzRckQy5F5RbkgPIcT
	 rfG7j6TOpYh/eDNZGswEvQNG3aSoQZyVVLMPF8lQSYO8AqMPXKEV0t+MShjMbXzk2L
	 M9NtUBucm8su4O6T5wbItVsCVmvMC1P508ISbUa4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Spickett <David.Spickett@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Catalin Marinas <catalin.marinas@arm.com>
Subject: [PATCH 6.1 188/194] arm64/ptrace: Ensure that SME is set up for target when writing SSVE state
Date: Mon, 21 Aug 2023 21:42:47 +0200
Message-ID: <20230821194130.959015509@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230821194122.695845670@linuxfoundation.org>
References: <20230821194122.695845670@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mark Brown <broonie@kernel.org>

commit 5d0a8d2fba50e9c07cde4aad7fba28c008b07a5b upstream.

When we use NT_ARM_SSVE to either enable streaming mode or change the
vector length for a process we do not currently do anything to ensure that
there is storage allocated for the SME specific register state.  If the
task had not previously used SME or we changed the vector length then
the task will not have had TIF_SME set or backing storage for ZA/ZT
allocated, resulting in inconsistent register sizes when saving state
and spurious traps which flush the newly set register state.

We should set TIF_SME to disable traps and ensure that storage is
allocated for ZA and ZT if it is not already allocated.  This requires
modifying sme_alloc() to make the flush of any existing register state
optional so we don't disturb existing state for ZA and ZT.

Fixes: e12310a0d30f ("arm64/sme: Implement ptrace support for streaming mode SVE registers")
Reported-by: David Spickett <David.Spickett@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: <stable@vger.kernel.org> # 5.19.x
Link: https://lore.kernel.org/r/20230810-arm64-fix-ptrace-race-v1-1-a5361fad2bd6@kernel.org
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/fpsimd.h |    4 ++--
 arch/arm64/kernel/fpsimd.c      |    6 +++---
 arch/arm64/kernel/ptrace.c      |    9 ++++++++-
 arch/arm64/kernel/signal.c      |    2 +-
 4 files changed, 14 insertions(+), 7 deletions(-)

--- a/arch/arm64/include/asm/fpsimd.h
+++ b/arch/arm64/include/asm/fpsimd.h
@@ -339,7 +339,7 @@ static inline int sme_max_virtualisable_
 	return vec_max_virtualisable_vl(ARM64_VEC_SME);
 }
 
-extern void sme_alloc(struct task_struct *task);
+extern void sme_alloc(struct task_struct *task, bool flush);
 extern unsigned int sme_get_vl(void);
 extern int sme_set_current_vl(unsigned long arg);
 extern int sme_get_current_vl(void);
@@ -365,7 +365,7 @@ static inline void sme_smstart_sm(void)
 static inline void sme_smstop_sm(void) { }
 static inline void sme_smstop(void) { }
 
-static inline void sme_alloc(struct task_struct *task) { }
+static inline void sme_alloc(struct task_struct *task, bool flush) { }
 static inline void sme_setup(void) { }
 static inline unsigned int sme_get_vl(void) { return 0; }
 static inline int sme_max_vl(void) { return 0; }
--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -1239,9 +1239,9 @@ void fpsimd_release_task(struct task_str
  * the interest of testability and predictability, the architecture
  * guarantees that when ZA is enabled it will be zeroed.
  */
-void sme_alloc(struct task_struct *task)
+void sme_alloc(struct task_struct *task, bool flush)
 {
-	if (task->thread.za_state) {
+	if (task->thread.za_state && flush) {
 		memset(task->thread.za_state, 0, za_state_size(task));
 		return;
 	}
@@ -1460,7 +1460,7 @@ void do_sme_acc(unsigned long esr, struc
 	}
 
 	sve_alloc(current, false);
-	sme_alloc(current);
+	sme_alloc(current, true);
 	if (!current->thread.sve_state || !current->thread.za_state) {
 		force_sig(SIGKILL);
 		return;
--- a/arch/arm64/kernel/ptrace.c
+++ b/arch/arm64/kernel/ptrace.c
@@ -886,6 +886,13 @@ static int sve_set_common(struct task_st
 			break;
 		case ARM64_VEC_SME:
 			target->thread.svcr |= SVCR_SM_MASK;
+
+			/*
+			 * Disable traps and ensure there is SME storage but
+			 * preserve any currently set values in ZA/ZT.
+			 */
+			sme_alloc(target, false);
+			set_tsk_thread_flag(target, TIF_SME);
 			break;
 		default:
 			WARN_ON_ONCE(1);
@@ -1107,7 +1114,7 @@ static int za_set(struct task_struct *ta
 	}
 
 	/* Allocate/reinit ZA storage */
-	sme_alloc(target);
+	sme_alloc(target, true);
 	if (!target->thread.za_state) {
 		ret = -ENOMEM;
 		goto out;
--- a/arch/arm64/kernel/signal.c
+++ b/arch/arm64/kernel/signal.c
@@ -430,7 +430,7 @@ static int restore_za_context(struct use
 	fpsimd_flush_task_state(current);
 	/* From now, fpsimd_thread_switch() won't touch thread.sve_state */
 
-	sme_alloc(current);
+	sme_alloc(current, true);
 	if (!current->thread.za_state) {
 		current->thread.svcr &= ~SVCR_ZA_MASK;
 		clear_thread_flag(TIF_SME);


