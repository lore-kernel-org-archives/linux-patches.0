Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB2E268FE5;
	Tue,  8 Apr 2025 12:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113742; cv=none; b=Kp8cMiI9koJhco6U6lWMHjdtt54/e7t5dX+QyX6a69E4TjkCDxxQz1JfjqILTgdxrVwkrmF0EXy4gsy7c9asHJb5ra89X4t6mitPGEPS3mA6KArsTwBUVkhrNR4Rd8t/KINJUnENSv2sMMF+6Rc5lPN1Zmj+QC+HeH1Lx128DVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113742; c=relaxed/simple;
	bh=OQxlgmhRErWKkCzvi5onNf/st6YkIjzFvheEP2FjeAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZWX/Y8kmWYC6rS9jh/XoiqyUuh9czJ5L/73d/nm8EotVCdm94+pRTZ78QYR2DYTJm/qljiDuaijPEIh4/q8SYotJzdAcJHQYCxtjc7zprxsyiQoAucoJw2sdaCdNvHw8MQCfqmmSII/68fnKy36mrIlgW2/I29R+DFjP5HAiuls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0J767O7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0J767O7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2CA27C4CEE5;
	Tue,  8 Apr 2025 12:02:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113742;
	bh=OQxlgmhRErWKkCzvi5onNf/st6YkIjzFvheEP2FjeAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0J767O7D4EZZ/BZDubfx6V5OoxV3WCVfLukg4RL3IL/zg9qEWpi1dPg3mq1D0Ljji
	 4uMNUJXGv62jR7vqx8tBpHJhRmzHD8Fr6C83nM8r7vanuyc/Yeg/zJJPJ2xFfekR1K
	 G2uUlK5e83MSJ5dbyvcMSalWSdxgTqtTEkoINC+o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 6.6 240/268] perf/x86/intel: Apply static call for drain_pebs
Date: Tue,  8 Apr 2025 12:50:51 +0200
Message-ID: <20250408104835.060657819@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Zijlstra (Intel) <peterz@infradead.org>

commit 314dfe10576912e1d786b13c5d4eee8c51b63caa upstream.

The x86_pmu_drain_pebs static call was introduced in commit 7c9903c9bf71
("x86/perf, static_call: Optimize x86_pmu methods"), but it's not really
used to replace the old method.

Apply the static call for drain_pebs.

Fixes: 7c9903c9bf71 ("x86/perf, static_call: Optimize x86_pmu methods")
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Kan Liang <kan.liang@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: stable@vger.kernel.org
Link: https://lkml.kernel.org/r/20250121152303.3128733-1-kan.liang@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/core.c |    2 +-
 arch/x86/events/intel/ds.c   |    2 +-
 arch/x86/events/perf_event.h |    1 +
 3 files changed, 3 insertions(+), 2 deletions(-)

--- a/arch/x86/events/intel/core.c
+++ b/arch/x86/events/intel/core.c
@@ -3006,7 +3006,7 @@ static int handle_pmi_common(struct pt_r
 
 		handled++;
 		x86_pmu_handle_guest_pebs(regs, &data);
-		x86_pmu.drain_pebs(regs, &data);
+		static_call(x86_pmu_drain_pebs)(regs, &data);
 		status &= intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;
 
 		/*
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -847,7 +847,7 @@ static inline void intel_pmu_drain_pebs_
 {
 	struct perf_sample_data data;
 
-	x86_pmu.drain_pebs(NULL, &data);
+	static_call(x86_pmu_drain_pebs)(NULL, &data);
 }
 
 /*
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1052,6 +1052,7 @@ extern struct x86_pmu x86_pmu __read_mos
 
 DECLARE_STATIC_CALL(x86_pmu_set_period, *x86_pmu.set_period);
 DECLARE_STATIC_CALL(x86_pmu_update,     *x86_pmu.update);
+DECLARE_STATIC_CALL(x86_pmu_drain_pebs,	*x86_pmu.drain_pebs);
 
 static __always_inline struct x86_perf_task_context_opt *task_context_opt(void *ctx)
 {


