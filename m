Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78673C4551;
	Wed, 30 Sep 2026 19:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795494; cv=none; b=k+Mroezk0pYFqvtF0/JVVoh1BrRlBR9x/56C7l9TIqiI8RxGvH7ghc+g1Z71RrfDHt4TZ4FI+WmTTbVnQoXYYI9PO/Kpx8mTpnOtFt81FG1MwrONTy0Eb7wE9RV8wA1uDV8Fkkor5WxvdFskKuFNo6sBymNm6obq20PzNC6uHiA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795494; c=relaxed/simple;
	bh=8JqembmcKmmuKWwdKqcoDN66FBat8+5Aj/6udJI212Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jr4eZiioM1rVFbVx7zVPNmsusZ6ntMUpCbSwVDiYL7XAtoJHp8R2teK0BYfisNyBXiskaWK4Cog2GsRPPiHIqYPeljJpUhYNdcS9DqVVM4slV7GyRnbf29q/sSvgPCnrRZHZyy1PEaE4oxgpm6mN2ffKdprV60t7meRxBMrFJjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqB9Za6l; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqB9Za6l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E0C91F000FF;
	Wed, 30 Sep 2026 19:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795493;
	bh=7WyaZzKL0K1uohb/C+57npMesUkKXKQpcqt3tMRRKjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KqB9Za6lyJYkpGNx6dv8+QeFgkDStfPufUc1MQDNDMsPaixMd7K4A9BEbxXTE7vwe
	 2LdEmR7abP0uICZH65FYaF/B+SpXFUkYab6Rx03zYOfI/t3QtV7gccvCQuCU6lsjD5
	 sjXvGw0ozu3a8ln4biYIZM6NWoiMNhPxq2AYcri4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0582/1193] perf/x86/intel: Correct pt_regs->flags update for PEBS path
Date: Wed, 30 Sep 2026 17:21:06 +0200
Message-ID: <20260930152447.173216673@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 461475dd2b045..0c8c0e50262f1 100644
--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -1805,7 +1805,7 @@ static inline void __setup_pebs_basic_group(struct perf_event *event,
 {
 	/* The ip in basic is EventingIP */
 	set_linear_ip(regs, ip);
-	regs->flags = PERF_EFLAGS_EXACT;
+	regs->flags |= PERF_EFLAGS_EXACT;
 	setup_pebs_time(event, data, tsc);
 
 	if (sample_type & PERF_SAMPLE_WEIGHT_STRUCT)
@@ -1817,9 +1817,17 @@ static inline void __setup_pebs_gpr_group(struct perf_event *event,
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



