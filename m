Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59F30373BF2;
	Sat, 12 Sep 2026 10:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789208354; cv=none; b=hfgUaOh+FjAD+QsVCrNBLADFmNdloi+mXtcM0poVgREjLI3du+nTcH7P5M0QJIJC8tMRQdfM1jjPTq+AISDitiDTuMSq3gJoxKEAU0S6B99Oq93Zjs0/l9cI6fZ1NncojIzbJ4cUfsA054udDIKJtGK+P2t6houTAZMtSxAFwDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789208354; c=relaxed/simple;
	bh=nfuY20UEHW4BMTvexSEpia6j/3fD3y+o8u7OIsLo2qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knWxsrR8D/M/0rt5zuNhXCuPu/PvLW7xHcEN613IYu/zkzv40VwEjK32tk65SZxpbDkB7FQA5ioYrqNkgqipiVoxipj052JXweILL8QF25syiOrsvTW5dX58P9l7bthQgEsSbEHVsh/7oNFX+pjSArLoqxlKJaNsMUyhF2NApa0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yc18VAo0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yc18VAo0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F27C1F000FF;
	Sat, 12 Sep 2026 10:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789208353;
	bh=JetAGvxgXWD2ouhOMZL+BqlMhqbGCpe+6RcWhtaEw/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yc18VAo0gbVJNUz94etSEegEaqNZjfDnIED6VRFQZf/RJKKwXFwcuyGGsL092UnrO
	 Q5K5vbX2ytrAADU9tfeECfwXnPAV0uw5Axm6TktG7rbGSNjKb2RHBmOgABVv8M/3lg
	 DR6+wSCW9NUZOMa8KKjyaga70yoPWrHq+7Adsjc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Clark <james.clark@linaro.org>,
	Leo Yan <leo.yan@arm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0556/1518] perf cs-etm: Flush thread stacks after decoder reset
Date: Sat, 12 Sep 2026 08:45:25 +0200
Message-ID: <20260912065636.015677972@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index 66dbead2c03bc..215414a8f61f1 100644
--- a/tools/perf/util/cs-etm.c
+++ b/tools/perf/util/cs-etm.c
@@ -2066,6 +2066,45 @@ static int cs_etm__end_block(struct cs_etm_queue *etmq,
 
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
@@ -2088,6 +2127,12 @@ static int cs_etm__get_data_block(struct cs_etm_queue *etmq)
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



