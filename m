Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7869834252D;
	Sat, 12 Sep 2026 07:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789199371; cv=none; b=DexNlpEcKKRZK6mFpqp0AgwDBZYYPgFpeYGTTNig8bWaDAGwnuemW+53aSyHXPA4D/SSwsM1dsvws8l51JzpU5Vx1E2litfaF0Zg9JCnVRPSS6c315DcbJyX0a19P/S4kwV7VXtoML4HPQGV8NbLZ/1n26EsvVbdVxAvEmt9718=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789199371; c=relaxed/simple;
	bh=S11dEdqbjKHGXF02AH9jXgtn/PkKwWNNhmbctDIAu/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TyY9SHrF++xfXAoro2NIM6vf71KPkHqkDK/qfqF7vEIVIam9BkIsY1rYfneJb4N/Ww9lEldqi16tstb/I9S8LRMQK05bAFthB+KBbHYD4ldh6BHPH3gMscTta2nPzUHyFjQtkZXwwZHrbAAMOwTWn7cZ6gLgsEcg0j9cEB5bdyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNTyrGEZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNTyrGEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACF7B1F000FF;
	Sat, 12 Sep 2026 07:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789199370;
	bh=Oq8z7v7Mn1rNki46lysduHWE2ogxkrIQGAhx6UmEkQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dNTyrGEZDrc9nKqL/pgT8pi6pxtWDUPcd0ZrzPdFIpCXLnhiAQfc51TIQPeTkm826
	 o3W6Jubo3G8bQ2kqZ+LwBZpjapGbM1jFcK8HJY0aTZ21MikFo+YXfzIWDtYSaBnTKq
	 rc6yC4bq1QVppTbdrNhqBwVMNQ+2KOarJmBTtJHg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kohei Enju <enju.kohei@fujitsu.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Gavin Shan <gshan@redhat.com>,
	Steven Price <steven.price@arm.com>,
	Will Deacon <will@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0571/1815] virt: arm-cca-guest: use migrate_disable() for attestation token requests
Date: Sat, 12 Sep 2026 08:38:41 +0200
Message-ID: <20260912065702.286718440@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kohei Enju <enju.kohei@fujitsu.com>

[ Upstream commit 24f55f511b9e1c19dc48d11bfe0dc60c86bdb376 ]

The RSI attestation token init and continue calls must be issued from
the same CPU. arm_cca_report_new() currently snapshots the CPU number
and uses smp_call_function_single() to issue those calls on that CPU.

With CONFIG_DEBUG_PREEMPT=y, the smp_processor_id() call used for the
snapshot triggers a debug splat [0] because it runs in preemptible
context. The snapshot does not pin the task to that CPU; it is only used
to choose the target CPU for smp_call_function_single(), which can fail
if that CPU is no longer available.

Use migrate_disable() and issue the token init and continue operations
directly, without the smp_call_function_single() callbacks. This keeps
the token request sequence on the same CPU while preserving a sleepable
context for the GFP_KERNEL allocations needed after the init call.

[0]
 BUG: using smp_processor_id() in preemptible [00000000] code: cca-workload-at/264
 caller is debug_smp_processor_id+0x20/0x30
 CPU: 0 UID: 0 PID: 264 Comm: cca-workload-at Not tainted 7.1.0-rc1-00044-g55542ab273f2 #80 PREEMPT(lazy)
 Hardware name: linux,dummy-virt (DT)
 Call trace:
  [...]
  check_preemption_disabled+0xd8/0xf8
  debug_smp_processor_id+0x20/0x30
  arm_cca_report_new+0x48/0x278
  tsm_report_read+0x154/0x1f8
  tsm_report_outblob_read+0x20/0x38
  configfs_bin_read_iter+0x118/0x208
  vfs_read+0x220/0x318
  [...]

Fixes: 7999edc484ca ("virt: arm-cca-guest: TSM_REPORT support for realms")
Signed-off-by: Kohei Enju <enju.kohei@fujitsu.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Reviewed-by: Gavin Shan <gshan@redhat.com>
Reviewed-by: Steven Price <steven.price@arm.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../virt/coco/arm-cca-guest/arm-cca-guest.c   | 97 +++++++------------
 1 file changed, 36 insertions(+), 61 deletions(-)

diff --git a/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c b/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
index 32cd038cb79bd..dbbb2cc0e124a 100644
--- a/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
+++ b/drivers/virt/coco/arm-cca-guest/arm-cca-guest.c
@@ -16,54 +16,38 @@
 
 /**
  * struct arm_cca_token_info - a descriptor for the token buffer.
- * @challenge:		Pointer to the challenge data
- * @challenge_size:	Size of the challenge data
  * @granule:		PA of the granule to which the token will be written
  * @offset:		Offset within granule to start of buffer in bytes
- * @result:		result of rsi_attestation_token_continue operation
  */
 struct arm_cca_token_info {
-	void           *challenge;
-	unsigned long   challenge_size;
 	phys_addr_t     granule;
 	unsigned long   offset;
-	unsigned long   result;
 };
 
-static void arm_cca_attestation_init(void *param)
-{
-	struct arm_cca_token_info *info;
-
-	info = (struct arm_cca_token_info *)param;
-
-	info->result = rsi_attestation_token_init(info->challenge,
-						  info->challenge_size);
-}
-
 /**
  * arm_cca_attestation_continue - Retrieve the attestation token data.
  *
- * @param: pointer to the arm_cca_token_info
+ * @info: pointer to the arm_cca_token_info
  *
  * Attestation token generation is a long running operation and therefore
  * the token data may not be retrieved in a single call. Moreover, the
  * token retrieval operation must be requested on the same CPU on which the
  * attestation token generation was initialised.
- * This helper function is therefore scheduled on the same CPU multiple
+ * This helper function must therefore be executed on the same CPU multiple
  * times until the entire token data is retrieved.
  */
-static void arm_cca_attestation_continue(void *param)
+static unsigned long
+arm_cca_attestation_continue(struct arm_cca_token_info *info)
 {
+	unsigned long ret;
 	unsigned long len;
 	unsigned long size;
-	struct arm_cca_token_info *info;
-
-	info = (struct arm_cca_token_info *)param;
 
 	size = RSI_GRANULE_SIZE - info->offset;
-	info->result = rsi_attestation_token_continue(info->granule,
-						      info->offset, size, &len);
+	ret = rsi_attestation_token_continue(info->granule, info->offset, size,
+					     &len);
 	info->offset += len;
+	return ret;
 }
 
 /**
@@ -74,8 +58,8 @@ static void arm_cca_attestation_continue(void *param)
  *
  * Initialise the attestation token generation using the challenge data
  * passed in the TSM descriptor. Allocate memory for the attestation token
- * and schedule calls to retrieve the attestation token on the same CPU
- * on which the attestation token generation was initialised.
+ * and retrieve the attestation token on the same CPU on which the
+ * attestation token generation was initialised.
  *
  * The challenge data must be at least 32 bytes and no more than 64 bytes. If
  * less than 64 bytes are provided it will be zero padded to 64 bytes.
@@ -85,12 +69,11 @@ static void arm_cca_attestation_continue(void *param)
  * * %-EINVAL  - A parameter was not valid.
  * * %-ENOMEM  - Out of memory.
  * * %-EFAULT  - Failed to get IPA for memory page(s).
- * * A negative status code as returned by smp_call_function_single().
  */
 static int arm_cca_report_new(struct tsm_report *report, void *data)
 {
-	int ret;
-	int cpu;
+	int ret = 0;
+	unsigned long rsi_result;
 	long max_size;
 	unsigned long token_size = 0;
 	struct arm_cca_token_info info;
@@ -103,37 +86,33 @@ static int arm_cca_report_new(struct tsm_report *report, void *data)
 
 	/*
 	 * The attestation token 'init' and 'continue' calls must be
-	 * performed on the same CPU. smp_call_function_single() is used
-	 * instead of simply calling get_cpu() because of the need to
-	 * allocate outblob based on the returned value from the 'init'
-	 * call and that cannot be done in an atomic context.
+	 * performed on the same CPU, so disable CPU migration around
+	 * those operations.
 	 */
-	cpu = smp_processor_id();
+	migrate_disable();
 
-	info.challenge = desc->inblob;
-	info.challenge_size = desc->inblob_len;
-
-	ret = smp_call_function_single(cpu, arm_cca_attestation_init,
-				       &info, true);
-	if (ret)
-		return ret;
-	max_size = info.result;
-
-	if (max_size <= 0)
-		return -EINVAL;
+	max_size = rsi_attestation_token_init(desc->inblob, desc->inblob_len);
+	if (max_size <= 0) {
+		ret = -EINVAL;
+		goto exit_migrate_enable;
+	}
 
 	/* Allocate outblob */
 	token = kvzalloc(max_size, GFP_KERNEL);
-	if (!token)
-		return -ENOMEM;
+	if (!token) {
+		ret = -ENOMEM;
+		goto exit_migrate_enable;
+	}
 
 	/*
 	 * Since the outblob may not be physically contiguous, use a page
 	 * to bounce the buffer from RMM.
 	 */
 	buf = alloc_pages_exact(RSI_GRANULE_SIZE, GFP_KERNEL);
-	if (!buf)
-		return -ENOMEM;
+	if (!buf) {
+		ret = -ENOMEM;
+		goto exit_migrate_enable;
+	}
 
 	/* Get the PA of the memory page(s) that were allocated */
 	info.granule = (unsigned long)virt_to_phys(buf);
@@ -144,21 +123,15 @@ static int arm_cca_report_new(struct tsm_report *report, void *data)
 		info.offset = 0;
 		do {
 			/*
-			 * Schedule a call to retrieve a sub-granule chunk
-			 * of data per loop iteration.
+			 * Retrieve a sub-granule chunk of data per loop
+			 * iteration.
 			 */
-			ret = smp_call_function_single(cpu,
-						       arm_cca_attestation_continue,
-						       (void *)&info, true);
-			if (ret != 0) {
-				token_size = 0;
-				goto exit_free_granule_page;
-			}
-		} while (info.result == RSI_INCOMPLETE &&
+			rsi_result = arm_cca_attestation_continue(&info);
+		} while (rsi_result == RSI_INCOMPLETE &&
 			 info.offset < RSI_GRANULE_SIZE);
 
 		/* Break out in case of failure */
-		if (info.result != RSI_SUCCESS && info.result != RSI_INCOMPLETE) {
+		if (rsi_result != RSI_SUCCESS && rsi_result != RSI_INCOMPLETE) {
 			ret = -ENXIO;
 			token_size = 0;
 			goto exit_free_granule_page;
@@ -173,12 +146,14 @@ static int arm_cca_report_new(struct tsm_report *report, void *data)
 			break;
 		memcpy(&token[token_size], buf, info.offset);
 		token_size += info.offset;
-	} while (info.result == RSI_INCOMPLETE);
+	} while (rsi_result == RSI_INCOMPLETE);
 
 	report->outblob = no_free_ptr(token);
 exit_free_granule_page:
 	report->outblob_len = token_size;
 	free_pages_exact(buf, RSI_GRANULE_SIZE);
+exit_migrate_enable:
+	migrate_enable();
 	return ret;
 }
 
-- 
2.53.0



