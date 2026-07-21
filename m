Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A962D3B6BE5;
	Tue, 21 Jul 2026 22:27:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672876; cv=none; b=NFKhoCrrWWhJFq+ZF2YJ3xgYtZCEVeGOTsYN/YC5uOcGFCSPn39uK9f59Ii9kkuCo7Qu4t1C3UsuvW6fspnRPmtpcVyFA8pvDO2Ez6HNJK/wjbCIQpIH4R8+G3qG+vPh4oJtjb6CKn3HeAEpFl4y3FawnupGywWrl+Wx+y2AsJk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672876; c=relaxed/simple;
	bh=gw+fX9XAD2PWwocg4UOGWXeQD5QZxUqmu9R4D3YnE/M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiT2/vVM/7G8MFGvbZdNtQFniKid1IruSXQCmP1WghycNZ/tMU37ePXHKej9yerSQeGp68paPE7tHjPUMuCbOG3TuwOuVi/JXW213+RwHmwOa6hSYjKw0Swu88TbP/wGMKFFCJkW9PWvL/VP4dZzPn9gCuR9Uzazfr/DcIAdFpM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TkIYFVMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TkIYFVMC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E27CA1F000E9;
	Tue, 21 Jul 2026 22:27:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672875;
	bh=V42MvAplSdlbHKLEzjbET/eIELplZthYakb7dx9Ufdk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TkIYFVMCj32xsoI/0cPXMDkA/R6VFhJ6AiFziMqcBGB0xlYuW2XfFIND8jwAdcJtM
	 O07/VtOM0M+35aIn+dWqLbZtzE/5S3syFFtaNcEwm2HYrOI/LDPSIOiTXzG9LrvfVP
	 qrHbvwnQ4kcmifZwKemdkknIdUngQblsOQ2HXeXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 790/843] perf/x86/intel/uncore: Defer ADL global PMON enable to enable_box()
Date: Tue, 21 Jul 2026 17:27:05 +0200
Message-ID: <20260721152423.832980443@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -445,12 +445,6 @@ void tgl_uncore_cpu_init(void)
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
@@ -469,7 +463,6 @@ static void adl_uncore_msr_exit_box(stru
 }
 
 static struct intel_uncore_ops adl_uncore_msr_ops = {
-	.init_box	= adl_uncore_msr_init_box,
 	.enable_box	= adl_uncore_msr_enable_box,
 	.disable_box	= adl_uncore_msr_disable_box,
 	.exit_box	= adl_uncore_msr_exit_box,


