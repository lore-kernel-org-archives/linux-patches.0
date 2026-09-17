Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D6F477994;
	Thu, 17 Sep 2026 15:46:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660023; cv=none; b=rfYJUPST6X3mS6JANuCp7BfavoSmOSm8Cbz/7Aso9tSCrLT8HW4KTu/j3xFwCVGOzKgsRTjR6jPLogXfK+mRHM+mZmvczrNEkNCNDXoDvfOjFYcMQVSv+q7jBhmKho93A1xZTjIGaE/bucOpuR6C5GDe3Q58XDWk6R4js/6txZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660023; c=relaxed/simple;
	bh=Jz0BrYXgURfRNMcpxGI8ZVKRK7cfQDQoaKY3tIggQKg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IE3qVCxl09Pmkj9vT4vgBWGAhuP3dOTT6U9oQPSpC4fx8H6xgzVfSpkbcAyWXXhIBl+KJjhUZq4Aio+AZStP+bcDKzqdzL2fhmUYN3jkORLAu4ck305BDG18Y/PN/wJhrpjnofWQBV4cE3tCAJpegP+gGaNncw8Kr5o5wI4I0cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BqRyQWzI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BqRyQWzI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53C901F00898;
	Thu, 17 Sep 2026 15:46:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660017;
	bh=d69fco3J+Jv+LG7vaqDipMJtj5yw/PbX/poAuY/FNGI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BqRyQWzIoIgxxaY6ShvPf8PLDP45yAxfSBywZVZD/ogwqgssrwQFQz+vj2u68V/Fr
	 39rSEyVfxPwObR7UVcRAD3Le4helDkXMX20mXjPth/3v8+k2VsQ4jNsla3MFtb8F+6
	 PK2JjPsN4bVHhRWSW0UWPjTE5r2tuiC2uulzFMOc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 414/733] perf/x86/intel: Correct pt_regs->flags update for PEBS path
Date: Thu, 17 Sep 2026 16:12:02 +0100
Message-ID: <20260917151402.096029610@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index 91a093d8cf2e7..e71cca7bbe77b 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -2445,7 +2445,7 @@ static inline void __setup_pebs_basic_group(struct perf_event *event,
 {
 	/* The ip in basic is EventingIP */
 	set_linear_ip(regs, ip);
-	regs->flags = PERF_EFLAGS_EXACT;
+	regs->flags |= PERF_EFLAGS_EXACT;
 	setup_pebs_time(event, data, tsc);
 
 	if (sample_type & PERF_SAMPLE_WEIGHT_STRUCT)
@@ -2457,9 +2457,17 @@ static inline void __setup_pebs_gpr_group(struct perf_event *event,
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



