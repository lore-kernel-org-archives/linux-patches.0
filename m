Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C024D46C4DE;
	Tue, 21 Jul 2026 18:29:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658564; cv=none; b=o5XYJb+pRPo3s0s5MOGqgEDBhfQQTBuyx4EGTv2DJNf/Tty1mtYjGfpgrqDIERNC3+uet6/D9UcC91NAnRiQmSlW8n1MKRop+W+Ds2CK5A/9Y+4JAmgk/zvnoCyBY2z9o2ah3n4cz6AtFSs/J/uEYD428ThtaWSpHLayXaUm7Io=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658564; c=relaxed/simple;
	bh=7mwc0784+sxsShXTiye3ztgP0o2cGe2p3senDCFZgsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=earyeobj2azzsQpn5XSKsWab6Cz30xjQtMnOiGATpPwOm6LO5m4K9WeZlq0EV7IaYK28tpQTUzODINg/Fw6EEOMa/ls+lBXM2Dn88IUw6VuvSSL7mbTi8/gld5Y/KHfKwJ593fta0vgSeJLPJFQt7d7DoLKc/4eFptmxLEffASE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SeXEpNx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SeXEpNx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 312C71F000E9;
	Tue, 21 Jul 2026 18:29:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658563;
	bh=w0xfB6tclmDNrW18TWCsDcOYK3FEIscyGWQv/mLzXGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SeXEpNx9EBTpWld8vjo4gtXEIPDyCSKUm0i6almIXCcmHZ2hbUovTKUAATbh3bpNy
	 UrX5zHBg2P17/t3VeaiR9XlKkGiobOxaBrdfm+Z5GvWt/YEh7aFUwYq0R7/DG1/Anx
	 Vr+ElL1AgtJSJHaXY43hFQ6NYEjESfePiO8Redcw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ian Rogers <irogers@google.com>,
	Sandipan Das <sandipan.das@amd.com>,
	Ingo Molnar <mingo@kernel.org>,
	Peter Zijlstra <peterz@infradead.org>
Subject: [PATCH 6.18 1190/1611] perf/x86/amd/lbr: Fix kernel address leakage
Date: Tue, 21 Jul 2026 17:21:46 +0200
Message-ID: <20260721152542.198793733@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Sandipan Das <sandipan.das@amd.com>

commit 2a892294b83f541115c94b0bb637f39bef187657 upstream.

A user-only branch stack can contain branches that originate from
the kernel. As a result, kernel addresses are exposed to user space
even when PERF_SAMPLE_BRANCH_USER is requested. On AMD processors
supporting X86_FEATURE_AMD_LBR_V2, perf can still report SYSRET/ERET
entries for which the branch-from addresses are in the kernel.

E.g.

  $ perf record -e cycles -o - -j any,save_type,u -- \
        perf bench syscall basic --loop 1000 | \
        perf script -i - -F brstack|tr ' ' '\n'| \
        grep -E '0x[89a-f][0-9a-f]{15}'

  ...
  0xffffffff81001268/0x717a90a38f1a/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a39157/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a2c628/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a41b60/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a260db/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a90a260db/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a8bef1c30/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  0xffffffff81001268/0x717a8e4d3c90/M/-/-/0/ERET/NON_SPEC_CORRECT_PATH
  ...

The reason is that the hardware filter only considers the privilege
level applicable to the branch target. Extend software filtering to
also validate the branch-from addresses against br_sel, so that any
branch record whose branch-from address is in the kernel is dropped
when PERF_SAMPLE_BRANCH_USER is requested.

Fixes: f4f925dae741 ("perf/x86/amd/lbr: Add LbrExtV2 hardware branch filter support")
Reported-by: Ian Rogers <irogers@google.com>
Signed-off-by: Sandipan Das <sandipan.das@amd.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <peterz@infradead.org>
Link: https://patch.msgid.link/a898a29725f6b2f30518354cdc2e432db66c43cf.1783680119.git.sandipan.das@amd.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/amd/lbr.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/events/amd/lbr.c
+++ b/arch/x86/events/amd/lbr.c
@@ -125,7 +125,8 @@ static void amd_pmu_lbr_filter(void)
 		}
 
 		/* If type does not correspond, then discard */
-		if (type == X86_BR_NONE || (br_sel & type) != type) {
+		if (type == X86_BR_NONE || (br_sel & type) != type ||
+		    (!(br_sel & X86_BR_KERNEL) && kernel_ip(cpuc->lbr_entries[i].from))) {
 			cpuc->lbr_entries[i].from = 0;	/* mark invalid */
 			compress = true;
 		}


