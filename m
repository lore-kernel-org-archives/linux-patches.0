Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4932673B7;
	Tue,  8 Apr 2025 12:29:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115370; cv=none; b=Pjfhw6LIjvDPcjfKM4fMAnbVJ4yV8mlzqnxT88dzNac9fV4Hf2KO7+TSlScIBp2oBv/UsXGOZZaK2s7ABTGEYVZrQ7/wudG5HLH1IsrmmV1eXotWqexHzT9CT5Q0Va/K8yAfSb9P4GK5hashxa4kfeUQ0RB5ZSweccjGlpcNhbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115370; c=relaxed/simple;
	bh=tLPTdlomFVDUTp5aAnWaWJhcqXf0MWfbhpPJmT0ADTo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hS+cPxGnCDmgK9iUOHokCsR0JD4hhgQFY8B/ngKZfpj7hIdfxTZyfY8guAyM5OELZ7MJQyGOkm0KleePIYw1FgcPDUaEKFlPEn/2vk+oLdKzb027yHDwXpvyqhWWHdDp4l8CbvVcPmRlBmqAmVHpEOpJsJ+5g2Q5s6duuKxNjz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zTWiTRB1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zTWiTRB1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C69BAC4CEE5;
	Tue,  8 Apr 2025 12:29:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115370;
	bh=tLPTdlomFVDUTp5aAnWaWJhcqXf0MWfbhpPJmT0ADTo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zTWiTRB1vkNX7RHwOVcid0lXxJNKJhjm/9ieeUM9BTpDDoe7Y5V7fe23pCJGZbunj
	 tT7VUleoytes2ROZg+bHxCaG8IYBWhVRNP6CFiI+TcK5rehjdxfcfJfmufeex9rmQN
	 WP8YTCVNKmOGmDgCNm9NcwQqaikZRtEPB2mH8QFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 6.13 449/499] perf/x86/intel: Apply static call for drain_pebs
Date: Tue,  8 Apr 2025 12:51:01 +0200
Message-ID: <20250408104902.429443083@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -3067,7 +3067,7 @@ static int handle_pmi_common(struct pt_r
 
 		handled++;
 		x86_pmu_handle_guest_pebs(regs, &data);
-		x86_pmu.drain_pebs(regs, &data);
+		static_call(x86_pmu_drain_pebs)(regs, &data);
 		status &= intel_ctrl | GLOBAL_STATUS_TRACE_TOPAPMI;
 
 		/*
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -957,7 +957,7 @@ static inline void intel_pmu_drain_pebs_
 {
 	struct perf_sample_data data;
 
-	x86_pmu.drain_pebs(NULL, &data);
+	static_call(x86_pmu_drain_pebs)(NULL, &data);
 }
 
 /*
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1106,6 +1106,7 @@ extern struct x86_pmu x86_pmu __read_mos
 
 DECLARE_STATIC_CALL(x86_pmu_set_period, *x86_pmu.set_period);
 DECLARE_STATIC_CALL(x86_pmu_update,     *x86_pmu.update);
+DECLARE_STATIC_CALL(x86_pmu_drain_pebs,	*x86_pmu.drain_pebs);
 
 static __always_inline struct x86_perf_task_context_opt *task_context_opt(void *ctx)
 {


