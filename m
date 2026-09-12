Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0513337E2E7;
	Sat, 12 Sep 2026 12:27:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789216073; cv=none; b=tVYx2YkBFU7/KuvbWOnh1tBwl8kJ9Ehcv4+QoSPviDvLcHUzCTs3XuYouNy3OPqYyijqmLlCrbpsJTk+6Z4x0sH3CpqgsM8ookX0QYHzLdrwT1QdcYecTfBEBYzarefyx/X0u5zrj59MGcGemWUUsJrpndEM0oV6Njdg3ZTSIQU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789216073; c=relaxed/simple;
	bh=+qP/UmUZ8KcG88KVs9RXR6m/RMCvYWDqiei5uqY9Poo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M+4lp9PRCSISEZTZWQxr2OsRBVEfdsy2a50VClVAV+BZFHnvhP+TYZl9bONfl4NXfu8lIz21l4AojrdOtB4nKUC0tcemUOih+FApOx6SqHDFx9JLsDyEMslZZdoozv6laV8tQDLxSikxFkaPiqNesagOoVqEnzysvLe5fPzvNrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xNzgBF2T; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xNzgBF2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB7F21F000FF;
	Sat, 12 Sep 2026 12:27:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789216071;
	bh=xxPTG83G3UAfJzFXM+YpXlNBnwnfnndTC3W4cAEkWPQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xNzgBF2Tugb1A1IIVnLKKykQvtUV093novjZ5c+t+6u9ye8NtJ4G5d9ViJTx8C9mV
	 r0eRAYC/qqClktOGI39cNw0mg8kxvscLrc9lrnqOmwBFOMBP7VLV08Qnz/l/XYicnT
	 WJFXAd3OR7pB6eNx6BTweHReD9XX9P7eByYVnrdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0663/1376] perf cs-etm: Flush thread stacks after decoder reset
Date: Sat, 12 Sep 2026 08:51:29 +0200
Message-ID: <20260912065622.318493811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

[ Upstream commit ea5075e3776846d4941dddf1549426ebd3feb81f ]

Perf resets the CoreSight decoder when moving to a new AUX trace buffer,
this causes trace discontinunity globally.

For callchain synthesis, keeping thread-stack state after decoder reset
can leave stale call/return history attached to threads that are decoded
later, producing incorrect synthesized callchains.

Flush all host thread stacks after a decoder reset. When virtualization
is present, flush the guest thread stacks as well.

Reviewed-by: James Clark <james.clark@linaro.org>
Signed-off-by: Leo Yan <leo.yan@arm.com>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Stable-dep-of: ec99be8a31db ("perf cs-etm: Avoid truncating AUX buffer sizes to int")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/util/cs-etm.c | 45 ++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/tools/perf/util/cs-etm.c b/tools/perf/util/cs-etm.c
index 29f0211324970..5b0dc7ef3a964 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -2039,6 +2039,45 @@ static int cs_etm__end_block(struct cs_etm_queue *etmq,
 
 	return 0;
 }
+
+static int cs_etm__flush_stack_cb(struct thread *thread,
+				  void *data __maybe_unused)
+{
+	thread_stack__flush(thread);
+	return 0;
+}
+
+static void cs_etm__flush_machine_stack(struct cs_etm_queue *etmq, pid_t pid)
+{
+	struct machine *machine;
+
+	machine = machines__find(&etmq->etm->session->machines, pid);
+	if (machine)
+		machine__for_each_thread(machine, cs_etm__flush_stack_cb, NULL);
+}
+
+static void cs_etm__flush_all_stack(struct cs_etm_queue *etmq)
+{
+	enum cs_etm_pid_fmt pid_fmt = cs_etm__get_pid_fmt(etmq);
+
+	if (!etmq->etm->synth_opts.last_branch)
+		return;
+
+	switch (pid_fmt) {
+	case CS_ETM_PIDFMT_CTXTID2:
+		/* Clear the guest stack if virtualization is supported */
+		cs_etm__flush_machine_stack(etmq, DEFAULT_GUEST_KERNEL_ID);
+		fallthrough;
+	case CS_ETM_PIDFMT_CTXTID:
+		cs_etm__flush_machine_stack(etmq, HOST_KERNEL_ID);
+		break;
+	case CS_ETM_PIDFMT_NONE:
+	default:
+		break;
+
+	}
+}
+
 /*
  * cs_etm__get_data_block: Fetch a block from the auxtrace_buffer queue
  *			   if need be.
@@ -2061,6 +2100,12 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
 		ret = cs_etm_decoder__reset(etmq->decoder);
 		if (ret)
 			return ret;
+
+		/*
+		 * Since the decoder is reset, this causes a global trace
+		 * discontinuity. Flush all thread stacks.
+		 */
+		cs_etm__flush_all_stack(etmq);
 	}
 
 	return etmq->buf_len;
-- 
2.53.0



