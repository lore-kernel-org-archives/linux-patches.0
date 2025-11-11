Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 890094C97;
	Tue, 11 Nov 2025 00:55:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822500; cv=none; b=UIJM/ow9KWsX/WV1C9pOVN7TVkvhyW1K8Fwfg79rXmcEHb2iUdA41h5z83f50tGLCWcWKPFiz/OwF2F7ap7UL8IYcEi0R1YT28J5K+3IHm3pEtezHLK53P54wYO5kQn3CtjfNyT8M4t74Uli+ugXkspLUjvrYn7sN2uzYJfeoOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822500; c=relaxed/simple;
	bh=0G9ASr8sa0o/o0erfp3+IsWW5IAcyYmtLiO54/swpYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qGhhUiKnpnh7fRvOgZmm7u9753mzXmDlSY9W3f2JyecO7cntVEHhJlUSCrxMbg/aLqEqDrBv29xVzsorzlrYYJuxdVU5RkXWRElW7MfeA1SOOBYXEr8Xd+y3SDVPFPWJrIEJpirdDZolduog3wdk26SsT6ssC+RYObjVAGI6Llo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=N+GTLK5D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N+GTLK5D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 25611C116B1;
	Tue, 11 Nov 2025 00:54:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822500;
	bh=0G9ASr8sa0o/o0erfp3+IsWW5IAcyYmtLiO54/swpYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N+GTLK5DOHtW4AlzShskzQwKoglTLxm44NLaoPPUW2j2FSuvREAAzpUPlq5BkDSBn
	 VRRJK/ZPIhzIeH5UP9JKx2Uvzn1IoE6vvO/DxAdSjqk260fV/XxxThIOgVBfGBbCjN
	 ALCAnXyjEmSfJ8bwJr9eFKnVyscTRl6f4nXO+u9g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xudong Hao <xudong.hao@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH 6.12 062/565] perf/x86/intel: Fix KASAN global-out-of-bounds warning
Date: Tue, 11 Nov 2025 09:38:38 +0900
Message-ID: <20251111004528.325919807@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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

commit 0ba6502ce167fc3d598c08c2cc3b4ed7ca5aa251 upstream.

When running "perf mem record" command on CWF, the below KASAN
global-out-of-bounds warning is seen.

  ==================================================================
  BUG: KASAN: global-out-of-bounds in cmt_latency_data+0x176/0x1b0
  Read of size 4 at addr ffffffffb721d000 by task dtlb/9850

  Call Trace:

   kasan_report+0xb8/0xf0
   cmt_latency_data+0x176/0x1b0
   setup_arch_pebs_sample_data+0xf49/0x2560
   intel_pmu_drain_arch_pebs+0x577/0xb00
   handle_pmi_common+0x6c4/0xc80

The issue is caused by below code in __grt_latency_data(). The code
tries to access x86_hybrid_pmu structure which doesn't exist on
non-hybrid platform like CWF.

        WARN_ON_ONCE(hybrid_pmu(event->pmu)->pmu_type == hybrid_big)

So add is_hybrid() check before calling this WARN_ON_ONCE to fix the
global-out-of-bounds access issue.

Fixes: 090262439f66 ("perf/x86/intel: Rename model-specific pebs_latency_data functions")
Reported-by: Xudong Hao <xudong.hao@intel.com>
Signed-off-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Zide Chen <zide.chen@intel.com>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20251028064214.1451968-1-dapeng1.mi@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/ds.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/events/intel/ds.c
+++ b/arch/x86/events/intel/ds.c
@@ -305,7 +305,8 @@ static u64 __grt_latency_data(struct per
 {
 	u64 val;
 
-	WARN_ON_ONCE(hybrid_pmu(event->pmu)->pmu_type == hybrid_big);
+	WARN_ON_ONCE(is_hybrid() &&
+		     hybrid_pmu(event->pmu)->pmu_type == hybrid_big);
 
 	dse &= PERF_PEBS_DATA_SOURCE_GRT_MASK;
 	val = hybrid_var(event->pmu, pebs_data_source)[dse];


