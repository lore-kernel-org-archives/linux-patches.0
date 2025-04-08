Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D111527CB03;
	Tue,  8 Apr 2025 12:58:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744117082; cv=none; b=hVodDooECozLScjMeKGV2Tf10bY+F9VPkNpZpPGVzPd+i7sOiGOXhamM7ZsKRzs/srxIMsB8MxvgiaHRgBbl1hydwCAiJhkf91s1oi2lN0xzVRXJmcFPjQ1Suyi5cDrdXMrx0+H0njxAewxSTmzBdSPApoAdWu4NxZ0opb06QU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744117082; c=relaxed/simple;
	bh=EtL9DX/aBwpaSf1iYIOhiAyPpq+Jb2I8SDk5GZJVKEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OfAqSlCdmJdevFV0maQ/IRwKyXFQx+fkoQhzJqCS63w28RR7Z34RkbUDlTgWw+o8DLN0hvREDISpvL1E8cQkAJSXWN0MNwZ34gOeh8p6XcubGPCr36GCty7PB3gwFdKDGHpSXTAI8p+1ehcZtPFE/772vREU3dXGcYbccxkRqYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z1MEjdAc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z1MEjdAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62198C4CEE5;
	Tue,  8 Apr 2025 12:58:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744117082;
	bh=EtL9DX/aBwpaSf1iYIOhiAyPpq+Jb2I8SDk5GZJVKEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1MEjdAcx1cyalKu/dg9hl6uJcMAJzgYNHSG3MKbcHs27hmMkTDCqwyp6RjGWcJV5
	 zLGQkzNFOAWNSVoG8l/mWNeBHK1+oe/8StV7oz3K7EKA8rgCnI49Lw3LoPgZDnJP3s
	 Kn/2mqWVoJaWraoUiNOt29mKZfrZpGOd7XumAJow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>
Subject: [PATCH 6.12 377/423] perf/x86/intel: Apply static call for drain_pebs
Date: Tue,  8 Apr 2025 12:51:43 +0200
Message-ID: <20250408104854.658452177@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -936,7 +936,7 @@ static inline void intel_pmu_drain_pebs_
 {
 	struct perf_sample_data data;
 
-	x86_pmu.drain_pebs(NULL, &data);
+	static_call(x86_pmu_drain_pebs)(NULL, &data);
 }
 
 /*
--- a/arch/x86/events/perf_event.h
+++ b/arch/x86/events/perf_event.h
@@ -1092,6 +1092,7 @@ extern struct x86_pmu x86_pmu __read_mos
 
 DECLARE_STATIC_CALL(x86_pmu_set_period, *x86_pmu.set_period);
 DECLARE_STATIC_CALL(x86_pmu_update,     *x86_pmu.update);
+DECLARE_STATIC_CALL(x86_pmu_drain_pebs,	*x86_pmu.drain_pebs);
 
 static __always_inline struct x86_perf_task_context_opt *task_context_opt(void *ctx)
 {


