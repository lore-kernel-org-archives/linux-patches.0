Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 151AC547042;
	Thu, 17 Sep 2026 18:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670802; cv=none; b=aQ8xcKLKodX7kT4VYsmoo0Upkw3kiUJ2bPNAr/fC9eu/Vlqkiy94vxV0Hb6S+6L2RuJXYLwKjl3cqKuP32ReR+wl8Gp4GUKLVVDRw+i14JJG2y883D7AcggFPP+3LAyS0edJ1dJL59QdRkfSJeHLT8BA1qfxImItjBJKwsRf+6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670802; c=relaxed/simple;
	bh=l7RIRbsIHAwSKnuQ3LpJSi9rcuI77+jCFohV++Qtfng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s9YXbGatFqTscgbC6bL40nUKLRFW+rxD0WJEcWOKgQKCp8Bfin34hVAHDZSwkXwkgydNHrHe4ZSliNqR6ZenQlSfj5NBKYdxldRbtkB4PQ/oPkslQ2QBpqgIADOVQrU47k1udw8D5y2C8q5lmCVZ4Y1qs0vDsUwbz3DzdujSuHE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BghNDBiN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BghNDBiN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04FC81F000FF;
	Thu, 17 Sep 2026 18:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670800;
	bh=2alJJQLbtJURu2VmacwHsVp46FDLxY+wSD1+K2hkWsk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BghNDBiNRLlz4cU90K921ZQErmoBd0ABDE8zh/JxI5Cy5YocAvpbbXPJBisjUiD19
	 UYa+fRB2vsRc/EPTyiZ+A2odsKs2AdIUf75wjirADYb2mlRfCBaoMVgCZRN2IwAYS5
	 5PaeLf0CQ+2zOdTv6iPDE42G5u1TtOctHsLw97qI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0775/1102] perf/x86/intel: Correct pt_regs->flags update for PEBS path
Date: Thu, 17 Sep 2026 16:11:58 +0100
Message-ID: <20260917151559.908283716@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

From: Dapeng Mi <dapeng1.mi@linux.intel.com>

[ Upstream commit 88aa1223bfffb1a0a98c639e9e1f71058f0d9178 ]

pt_regs->flags holds the saved CPU FLAGS register. In the PEBS path,
it was incorrectly set to PERF_EFLAGS_EXACT instead of being populated
from the PEBS flags snapshot.

Update pt_regs->flags from PEBS GPR flags if GPRs group is present.

Fixes: c22497f5838c ("perf/x86/intel: Support adaptive PEBS v4")
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260908075102.540715-1-dapeng1.mi@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/ds.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/ds.c b/arch/x86/events/intel/ds.c
index 2ea9b4d4f7500..39f5038f5ce4f 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1920,7 +1920,7 @@ static inline void __setup_pebs_basic_group(struct perf_event *event,
 {
 	/* The ip in basic is EventingIP */
 	set_linear_ip(regs, ip);
-	regs->flags = PERF_EFLAGS_EXACT;
+	regs->flags |= PERF_EFLAGS_EXACT;
 	setup_pebs_time(event, data, tsc);
 
 	if (sample_type & PERF_SAMPLE_WEIGHT_STRUCT)
@@ -1932,9 +1932,17 @@ static inline void __setup_pebs_gpr_group(struct perf_event *event,
 					  struct pebs_gprs *gprs,
 					  u64 sample_type)
 {
+	/*
+	 * Update flags with PEBS data. PERF_EFLAGS_EXACT must be set
+	 * in previous basic group handling.
+	 */
+	regs->flags = gprs->flags | PERF_EFLAGS_EXACT;
+
 	if (event->attr.precise_ip < 2) {
 		set_linear_ip(regs, gprs->ip);
 		regs->flags &= ~PERF_EFLAGS_EXACT;
+	} else if (regs->flags & X86_VM_MASK) {
+		regs->flags ^= (PERF_EFLAGS_VM | X86_VM_MASK);
 	}
 
 	if (sample_type & (PERF_SAMPLE_REGS_INTR | PERF_SAMPLE_REGS_USER))
-- 
2.53.0



