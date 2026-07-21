Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 118A643C7B1;
	Tue, 21 Jul 2026 21:50:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670641; cv=none; b=BzpxvenQT/CI67FgQyzVzTTAQ/a7hfGxm6W3HMVnnnulElSAJ25lfF1oKdYEq59qV8VgtZlbmTUuN5ZGhe5ML9Fk5x21GacuM1kcH5/DTzSmiNfGSTnr1Bw3xZe/TWyZ9MAOOYzvdZOFCD8tlAM33mdCHPpyde1E1R1Kth5gQ0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670641; c=relaxed/simple;
	bh=ql25+0qFKps3azdntC9sAMMme20pa1TsSoWYGLtQajE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MHARi8eP2Ssq2u5SBG9ZFO5APWEVwq0zs0bJndOgt/8srRz6H+hvg1j5UcbnFSHYkDMPHkCR7EZuKnvStYXPjd6rgRc5IRMNUBeDVGA1CgFSE3BmYWWCeMXSwzEIfdBX34iqP/CnQmq1BaSPkE8A01LUR1M665M9ZhWeUb51Npc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jFUle9yL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jFUle9yL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 789671F000E9;
	Tue, 21 Jul 2026 21:50:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670640;
	bh=x9sVEGZVZDA22UBCCyJVkLhslTCZPgoEoYp+JaBC20Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jFUle9yL2jZ0OsQ4TB9TbS6yjN6aMr4kc0V7XyyDbfWaAX1F9mPeazVUOytGpDe3G
	 jIX4SFhNpfqMPiAxLyVSaTwaDJ/f4nYlbSyCog7JAe5V2yrI1OTT14tarV9QStqSYJ
	 kxS6W6n0Mf3tQOBkXak522MWhfGe18nujBlr/MIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1008/1067] perf/x86/intel/uncore: Defer ADL global PMON enable to enable_box()
Date: Tue, 21 Jul 2026 17:26:49 +0200
Message-ID: <20260721152447.119818486@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 9a0bb848a37150aeccc10088e141339917d995dc ]

On some Raptor Cove CPUs, enabling uncore PMON globally at driver init
may increase power consumption even when no perf events are in use.

Drop adl_uncore_msr_init_box() and defer programming the global control
register to enable_box(), so it is only set when a box is actually used.

IMC and IMC freerunning counters use a separate control path and are
unaffected.

Fixes: 772ed05f3c5c ("perf/x86/intel/uncore: Add Alder Lake support")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260602144908.263680-5-zide.chen@intel.com
[ deleted adl_uncore_msr_init_box() in its 6.12 wrmsrl() spelling since the tree predates the wrmsrq() rename ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snb.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -537,12 +537,6 @@ void tgl_uncore_cpu_init(void)
 	skl_uncore_msr_ops.init_box = rkl_uncore_msr_init_box;
 }
 
-static void adl_uncore_msr_init_box(struct intel_uncore_box *box)
-{
-	if (box->pmu->pmu_idx == 0)
-		wrmsrl(ADL_UNC_PERF_GLOBAL_CTL, SNB_UNC_GLOBAL_CTL_EN);
-}
-
 static void adl_uncore_msr_enable_box(struct intel_uncore_box *box)
 {
 	wrmsrl(ADL_UNC_PERF_GLOBAL_CTL, SNB_UNC_GLOBAL_CTL_EN);
@@ -561,7 +555,6 @@ static void adl_uncore_msr_exit_box(stru
 }
 
 static struct intel_uncore_ops adl_uncore_msr_ops = {
-	.init_box	= adl_uncore_msr_init_box,
 	.enable_box	= adl_uncore_msr_enable_box,
 	.disable_box	= adl_uncore_msr_disable_box,
 	.exit_box	= adl_uncore_msr_exit_box,


