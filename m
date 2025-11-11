Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FD04086A;
	Tue, 11 Nov 2025 00:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822358; cv=none; b=W+xzecEhteIKMRZStx15HljvrqETEY31BD8TiRZfouNsD+6tEYCHILxlL0Q/0IHLjEm4WRbrr1REWtZnDLgjIC3vJZcZa2H/Ik0jDqeVWQY3rCyGGlIMMVYtgP2Y2zRA0HNkmkNE0I1bdI/nay82B+O03xurK2HLEpIiWmVQjHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822358; c=relaxed/simple;
	bh=lg+OX0CrwGvVNZ3fYIqiSMfU5LTNCd7lEQlHl7tVlMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VvUFGBOKwwFhjG6vcWSH5LsLbWlZVZWuJKr7LgPMGOxC2Hhd5i+5kGE+E94X6sBRc89C1p6gKvhbKE1hbn0FuteYQ5BasCxYBQzZUepK8X4l1sdPN7bvZReiLBFarGZPsi79kDm0EuRZpnPyPR9cii/OT/y6w1tSoDnyiBK9Yrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=imoAgGnU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="imoAgGnU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C959BC4CEF5;
	Tue, 11 Nov 2025 00:52:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822358;
	bh=lg+OX0CrwGvVNZ3fYIqiSMfU5LTNCd7lEQlHl7tVlMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=imoAgGnU8IYgClBUcM96tfeMrbdbKmQF49pMaIprTYyAW8q5yAynDii+NUsgZudQf
	 ou7qS+X/0Aipgw9mymkaNxEpkdJIpwVrfN5x47OGsdZcscEiVQ1tzP2C0fax4QTsKJ
	 hiZ+6hZRYnXxb6X2xhLGq6P91DyGLCLkVhPkjTx8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xudong Hao <xudong.hao@intel.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Zide Chen <zide.chen@intel.com>
Subject: [PATCH 6.17 092/849] perf/x86/intel: Fix KASAN global-out-of-bounds warning
Date: Tue, 11 Nov 2025 09:34:22 +0900
Message-ID: <20251111004538.637484914@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -317,7 +317,8 @@ static u64 __grt_latency_data(struct per
 {
 	u64 val;
 
-	WARN_ON_ONCE(hybrid_pmu(event->pmu)->pmu_type == hybrid_big);
+	WARN_ON_ONCE(is_hybrid() &&
+		     hybrid_pmu(event->pmu)->pmu_type == hybrid_big);
 
 	dse &= PERF_PEBS_DATA_SOURCE_GRT_MASK;
 	val = hybrid_var(event->pmu, pebs_data_source)[dse];


