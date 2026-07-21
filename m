Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C86042FCC9;
	Tue, 21 Jul 2026 19:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662413; cv=none; b=DmjOSAaacwJtYULP1Skv/frLQPcQ5U8Yb79vWhWBLobUQNPesCOeYtax7BBIOvSyvYBpCiBRM2EJNOV/x4hymvdf+Fk3mZgpxp1F7CxfNJHVI317BTI5mXIDvPG6eOClcqGXQYKGtoU8jG6L5omIr4jFcNuZ0SVQOQY5o8QNmkA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662413; c=relaxed/simple;
	bh=6I8VMfyjr4Mqv9qfPf0ORsdmuc9aFiRCWMl8A3LqMrw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q8ImgPHMS8T3p/fkd8sM7eKPfI30YO1Z2FnH0YdBB9zBNkMwVfJPWOvY/fQ8x8kHE4q2M6rEdapEhfTrgJK6Kb44CtuqZzYVb5Vx+VQI0ROvxSkdO5wGtzPjQfAhj2Q7ozS9E9iU7jaxLAmTpRISEeW4Fh633kJJy7/Pj5zZ36A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wslRlaNH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wslRlaNH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E136B1F000E9;
	Tue, 21 Jul 2026 19:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662412;
	bh=8G1jmeul4ptv1M1GZreasFbR64dgz2mZkP8YgouJoTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wslRlaNHuZ8Kv0RNsl6Yn217NV7NQR2mkF6sHw8gp+nscNRYlKIMUuOEwUnA9Y5UL
	 Q27LilGAG7juIDW/YPw9irrZjOlpLHoOAkVDLeRncUB2alhGoy5p35lzKE6KsSaJs4
	 RxWOv9LKwu9bUX2bxOdmjlHNeleIP2kK9nGG56Qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0435/1276] perf arm-spe: Add branch stack
Date: Tue, 21 Jul 2026 17:14:38 +0200
Message-ID: <20260721152455.838365504@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leo Yan <leo.yan@arm.com>

[ Upstream commit 73cb57f56f749ac640b889f076d5db96264020f8 ]

Although Arm SPE cannot generate continuous branch records, this commit
creates a branch stack with only one branch entry.  A single branch info
can be used for performance optimization.

A branch stack structure is dynamically allocated in the decode queue.
The branch stack and stack flags are synthesized based on branch types
and associated events.

After:

  # perf script --itrace=bl1 -F flags,addr,brstack

  jcc                   ffffc0fad9c6b214 0xffffc0fad9c6b234/0xffffc0fad9c6b214/P/-/-/7/COND/-
  jcc/miss,not_taken/   ffffc0fadaaebb30 0xffffc0fadaaebb2c/0xffffc0fadaaebb30/MN/-/-/7/COND/-
  jmp                   ffffc0fadaaea358 0xffffc0fadaaea5ec/0xffffc0fadaaea358/P/-/-/5//-
  jcc/not_taken/        ffffc0fadaae6494 0xffffc0fadaae6490/0xffffc0fadaae6494/PN/-/-/11/COND/-
  jcc/not_taken/            ffff7f83ab54 0xffff7f83ab50/0xffff7f83ab54/PN/-/-/13/COND/-
  jcc/not_taken/            ffff7f83ab08 0xffff7f83ab04/0xffff7f83ab08/PN/-/-/8/COND/-
  jcc                       ffff7f83aa80 0xffff7f83aa58/0xffff7f83aa80/P/-/-/10/COND/-
  jcc                       ffff7f9a45d0 0xffff7f9a43f0/0xffff7f9a45d0/P/-/-/29/COND/-
  jcc/not_taken/        ffffc0fad9ba6db4 0xffffc0fad9ba6db0/0xffffc0fad9ba6db4/PN/-/-/44/COND/-
  jcc                   ffffc0fadaac2964 0xffffc0fadaac2970/0xffffc0fadaac2964/P/-/-/6/COND/-
  jcc                   ffffc0fad99ddc10 0xffffc0fad99ddc04/0xffffc0fad99ddc10/P/-/-/72/COND/-
  jcc/not_taken/        ffffc0fad9b3f21c 0xffffc0fad9b3f218/0xffffc0fad9b3f21c/PN/-/-/64/COND/-
  jcc                   ffffc0fad9c3b604 0xffffc0fad9c3b5f8/0xffffc0fad9c3b604/P/-/-/13/COND/-
  jcc                   ffffc0fadaad6048 0xffffc0fadaad5f8c/0xffffc0fadaad6048/P/-/-/5/COND/-
  return/miss/              ffff7f84e614 0xffffc0fad98a2274/0xffff7f84e614/M/-/-/13/RET/-
  jcc/not_taken/        ffffc0fadaac4eb4 0xffffc0fadaac4eb0/0xffffc0fadaac4eb4/PN/-/-/5/COND/-
  jmp                       ffff7f8e3130 0xffff7f87555c/0xffff7f8e3130/P/-/-/5//-
  jcc/not_taken/        ffffc0fad9b3d9b0 0xffffc0fad9b3d9ac/0xffffc0fad9b3d9b0/PN/-/-/14/COND/-
  return                ffffc0fad9b91950 0xffffc0fad98c3e28/0xffffc0fad9b91950/P/-/-/12/RET/-

Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Link: https://lore.kernel.org/r/20250304111240.3378214-12-leo.yan@arm.com
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: 059e9100d82a ("perf event: Fix size of synthesized sample with branch stacks")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/arm-spe.c | 99 +++++++++++++++++++++++++++++++++++++++
 1 file changed, 99 insertions(+)

diff --git a/tools/perf/util/arm-spe.c b/tools/perf/util/arm-spe.c
index a004e1721a1ff1..80fcb8b10f52e4 100644
--- a/tools/perf/util/arm-spe.c
+++ b/tools/perf/util/arm-spe.c
@@ -99,6 +99,7 @@ struct arm_spe_queue {
 	struct thread			*thread;
 	u64				period_instructions;
 	u32				flags;
+	struct branch_stack		*last_branch;
 };
 
 static void arm_spe_dump(struct arm_spe *spe __maybe_unused,
@@ -217,6 +218,16 @@ static struct arm_spe_queue *arm_spe__alloc_queue(struct arm_spe *spe,
 	params.get_trace = arm_spe_get_trace;
 	params.data = speq;
 
+	if (spe->synth_opts.last_branch) {
+		size_t sz = sizeof(struct branch_stack);
+
+		/* Allocate one entry for TGT */
+		sz += sizeof(struct branch_entry);
+		speq->last_branch = zalloc(sz);
+		if (!speq->last_branch)
+			goto out_free;
+	}
+
 	/* create new decoder */
 	speq->decoder = arm_spe_decoder_new(&params);
 	if (!speq->decoder)
@@ -226,6 +237,7 @@ static struct arm_spe_queue *arm_spe__alloc_queue(struct arm_spe *spe,
 
 out_free:
 	zfree(&speq->event_buf);
+	zfree(&speq->last_branch);
 	free(speq);
 
 	return NULL;
@@ -332,6 +344,73 @@ static void arm_spe_prep_sample(struct arm_spe *spe,
 	event->sample.header.size = sizeof(struct perf_event_header);
 }
 
+static void arm_spe__prep_branch_stack(struct arm_spe_queue *speq)
+{
+	struct arm_spe_record *record = &speq->decoder->record;
+	struct branch_stack *bstack = speq->last_branch;
+	struct branch_flags *bs_flags;
+	size_t sz = sizeof(struct branch_stack) +
+		    sizeof(struct branch_entry) /* TGT */;
+
+	/* Clean up branch stack */
+	memset(bstack, 0x0, sz);
+
+	if (!(speq->flags & PERF_IP_FLAG_BRANCH))
+		return;
+
+	bstack->entries[0].from = record->from_ip;
+	bstack->entries[0].to = record->to_ip;
+
+	bs_flags = &bstack->entries[0].flags;
+	bs_flags->value = 0;
+
+	if (record->op & ARM_SPE_OP_BR_CR_BL) {
+		if (record->op & ARM_SPE_OP_BR_COND)
+			bs_flags->type |= PERF_BR_COND_CALL;
+		else
+			bs_flags->type |= PERF_BR_CALL;
+	/*
+	 * Indirect branch instruction without link (e.g. BR),
+	 * take this case as function return.
+	 */
+	} else if (record->op & ARM_SPE_OP_BR_CR_RET ||
+		   record->op & ARM_SPE_OP_BR_INDIRECT) {
+		if (record->op & ARM_SPE_OP_BR_COND)
+			bs_flags->type |= PERF_BR_COND_RET;
+		else
+			bs_flags->type |= PERF_BR_RET;
+	} else if (record->op & ARM_SPE_OP_BR_CR_NON_BL_RET) {
+		if (record->op & ARM_SPE_OP_BR_COND)
+			bs_flags->type |= PERF_BR_COND;
+		else
+			bs_flags->type |= PERF_BR_UNCOND;
+	} else {
+		if (record->op & ARM_SPE_OP_BR_COND)
+			bs_flags->type |= PERF_BR_COND;
+		else
+			bs_flags->type |= PERF_BR_UNKNOWN;
+	}
+
+	if (record->type & ARM_SPE_BRANCH_MISS) {
+		bs_flags->mispred = 1;
+		bs_flags->predicted = 0;
+	} else {
+		bs_flags->mispred = 0;
+		bs_flags->predicted = 1;
+	}
+
+	if (record->type & ARM_SPE_BRANCH_NOT_TAKEN)
+		bs_flags->not_taken = 1;
+
+	if (record->type & ARM_SPE_IN_TXN)
+		bs_flags->in_tx = 1;
+
+	bs_flags->cycles = min(record->latency, 0xFFFFU);
+
+	bstack->nr = 1;
+	bstack->hw_idx = -1ULL;
+}
+
 static int arm_spe__inject_event(union perf_event *event, struct perf_sample *sample, u64 type)
 {
 	event->header.size = perf_event__sample_event_size(sample, type, 0);
@@ -394,6 +473,7 @@ static int arm_spe__synth_branch_sample(struct arm_spe_queue *speq,
 	sample.addr = record->to_ip;
 	sample.weight = record->latency;
 	sample.flags = speq->flags;
+	sample.branch_stack = speq->last_branch;
 
 	return arm_spe_deliver_synth_event(spe, speq, event, &sample);
 }
@@ -424,6 +504,7 @@ static int arm_spe__synth_instruction_sample(struct arm_spe_queue *speq,
 	sample.period = spe->instructions_sample_period;
 	sample.weight = record->latency;
 	sample.flags = speq->flags;
+	sample.branch_stack = speq->last_branch;
 
 	return arm_spe_deliver_synth_event(spe, speq, event, &sample);
 }
@@ -685,6 +766,10 @@ static int arm_spe_sample(struct arm_spe_queue *speq)
 		}
 	}
 
+	if (spe->synth_opts.last_branch &&
+	    (spe->sample_branch || spe->sample_instructions))
+		arm_spe__prep_branch_stack(speq);
+
 	if (spe->sample_branch && (record->op & ARM_SPE_OP_BRANCH_ERET)) {
 		err = arm_spe__synth_branch_sample(speq, spe->branch_id);
 		if (err)
@@ -1109,6 +1194,7 @@ static void arm_spe_free_queue(void *priv)
 	thread__zput(speq->thread);
 	arm_spe_decoder_free(speq->decoder);
 	zfree(&speq->event_buf);
+	zfree(&speq->last_branch);
 	free(speq);
 }
 
@@ -1283,6 +1369,19 @@ arm_spe_synth_events(struct arm_spe *spe, struct perf_session *session)
 		id += 1;
 	}
 
+	if (spe->synth_opts.last_branch) {
+		if (spe->synth_opts.last_branch_sz > 1)
+			pr_debug("Arm SPE supports only one bstack entry (TGT).\n");
+
+		attr.sample_type |= PERF_SAMPLE_BRANCH_STACK;
+		/*
+		 * We don't use the hardware index, but the sample generation
+		 * code uses the new format branch_stack with this field,
+		 * so the event attributes must indicate that it's present.
+		 */
+		attr.branch_sample_type |= PERF_SAMPLE_BRANCH_HW_INDEX;
+	}
+
 	if (spe->synth_opts.branches) {
 		spe->sample_branch = true;
 
-- 
2.53.0



