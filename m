Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2813315AC5
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 10:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99403C433C8;
	Tue, 25 Jul 2023 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690282219;
	bh=dYcUxV4GsbYlJfid9MLn9l1Qs39rVSDi3SBKWe8RnLk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ppaVC9H+r7x7R/WGtfV2IBFcl3DDHO2jlyBGzXhvbR5ZDwKYsJPs0lB0ONMVh/oJ5
	 ggV0NQ5ZGRSNZAUjoVuzykbotfz/l0vJ4ALZb/H4ZhDrMPNNh0tensClInjf/RRN2E
	 5r2ZGZ0p8hBI2pdhOsQZPA2cD+f6mElfWlQt7BXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Spickett <David.Spickett@arm.com>,
	Mark Brown <broonie@kernel.org>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 6.4 033/227] arm64/fpsimd: Ensure SME storage is allocated after SVE VL changes
Date: Tue, 25 Jul 2023 12:43:20 +0200
Message-ID: <20230725104516.216945984@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104514.821564989@linuxfoundation.org>
References: <20230725104514.821564989@linuxfoundation.org>
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

commit d4d5be94a87872421ea2569044092535aff0b886 upstream.

When we reconfigure the SVE vector length we discard the backing storage
for the SVE vectors and then reallocate on next SVE use, leaving the SME
specific state alone. This means that we do not enable SME traps if they
were already disabled. That means that userspace code can enter streaming
mode without trapping, putting the task in a state where if we try to save
the state of the task we will fault.

Since the ABI does not specify that changing the SVE vector length disturbs
SME state, and since SVE code may not be aware of SME code in the process,
we shouldn't simply discard any ZA state. Instead immediately reallocate
the storage for SVE, and disable SME if we change the SVE vector length
while there is no SME state active.

Disabling SME traps on SVE vector length changes would make the overall
code more complex since we would have a state where we have valid SME state
stored but might get a SME trap.

Fixes: 9e4ab6c89109 ("arm64/sme: Implement vector length configuration prctl()s")
Reported-by: David Spickett <David.Spickett@arm.com>
Signed-off-by: Mark Brown <broonie@kernel.org>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20230720-arm64-fix-sve-sme-vl-change-v2-1-8eea06b82d57@kernel.org
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/fpsimd.c |   33 +++++++++++++++++++++++++--------
 1 file changed, 25 insertions(+), 8 deletions(-)

--- a/arch/arm64/kernel/fpsimd.c
+++ b/arch/arm64/kernel/fpsimd.c
@@ -847,6 +847,8 @@ void sve_sync_from_fpsimd_zeropad(struct
 int vec_set_vector_length(struct task_struct *task, enum vec_type type,
 			  unsigned long vl, unsigned long flags)
 {
+	bool free_sme = false;
+
 	if (flags & ~(unsigned long)(PR_SVE_VL_INHERIT |
 				     PR_SVE_SET_VL_ONEXEC))
 		return -EINVAL;
@@ -897,21 +899,36 @@ int vec_set_vector_length(struct task_st
 		task->thread.fp_type = FP_STATE_FPSIMD;
 	}
 
-	if (system_supports_sme() && type == ARM64_VEC_SME) {
-		task->thread.svcr &= ~(SVCR_SM_MASK |
-				       SVCR_ZA_MASK);
-		clear_thread_flag(TIF_SME);
+	if (system_supports_sme()) {
+		if (type == ARM64_VEC_SME ||
+		    !(task->thread.svcr & (SVCR_SM_MASK | SVCR_ZA_MASK))) {
+			/*
+			 * We are changing the SME VL or weren't using
+			 * SME anyway, discard the state and force a
+			 * reallocation.
+			 */
+			task->thread.svcr &= ~(SVCR_SM_MASK |
+					       SVCR_ZA_MASK);
+			clear_thread_flag(TIF_SME);
+			free_sme = true;
+		}
 	}
 
 	if (task == current)
 		put_cpu_fpsimd_context();
 
 	/*
-	 * Force reallocation of task SVE and SME state to the correct
-	 * size on next use:
+	 * Free the changed states if they are not in use, SME will be
+	 * reallocated to the correct size on next use and we just
+	 * allocate SVE now in case it is needed for use in streaming
+	 * mode.
 	 */
-	sve_free(task);
-	if (system_supports_sme() && type == ARM64_VEC_SME)
+	if (system_supports_sve()) {
+		sve_free(task);
+		sve_alloc(task, true);
+	}
+
+	if (free_sme)
 		sme_free(task);
 
 	task_set_vl(task, type, vl);


