Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297B2425894;
	Thu, 16 Jul 2026 13:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209620; cv=none; b=WHBkNrnD1LOyBdMmAsK30TDkNSwjLW9v7obqC6LqtEeGnRstvfD5wA24t6vXRuqu+PG2yK12yJOS4O7/P3/psKgk08e6Yndxh3uRxmbjPN88KkcW0ub6Ys7IagBqYfIGd1OISG2ic0SkGtZE03UBoeUBB/oYbeVXhZxQXlLjH50=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209620; c=relaxed/simple;
	bh=3KcnqzGZt1AssIRM/CHKpEQ9LCO/b5VS3F0QTvufbYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C/97kkYHL4qZmjwkgRzFh6Dlz2+2eJXYOoOHgdQM4EYd6/GxyeeAqdAqtYgZHtQG7V8e+lR0s/pOWAx6gfi8yqMwg6beGvi1gCQcy+6L0wNQ59nP3Nn5XbDPMktoCP/UpEP/kgnJovQWFas4+1uypIKm1MMafuZC7SC7fSXkXG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v5B6Wosi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v5B6Wosi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B9C1F000E9;
	Thu, 16 Jul 2026 13:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209610;
	bh=fyO+On32SJbuAhyzJnG/w7dq4ua/qI/RJUp7dDpH3G4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v5B6WosijT4SI/GlSggfKe+TArmK5BiNQLCcDZzqXoO+eMch7hpIpLogpurBhOAHN
	 ugoikrNewNjCHQrQvpimzvIfnoolUByaj7kPtE82p/aRex+jYKKhKt5qH0SbV0wiUP
	 XLMDT9Y9uRwQKf6rpNmPVFlIoKWzWATm48ss5+DY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>
Subject: [PATCH 7.1 250/518] perf/x86/intel/uncore: Defer ADL global PMON enable to enable_box()
Date: Thu, 16 Jul 2026 15:28:38 +0200
Message-ID: <20260716133053.286592746@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zide Chen <zide.chen@intel.com>

commit 9a0bb848a37150aeccc10088e141339917d995dc upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/events/intel/uncore_snb.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/arch/x86/events/intel/uncore_snb.c
+++ b/arch/x86/events/intel/uncore_snb.c
@@ -563,12 +563,6 @@ void tgl_uncore_cpu_init(void)
 	skl_uncore_msr_ops.init_box = rkl_uncore_msr_init_box;
 }
 
-static void adl_uncore_msr_init_box(struct intel_uncore_box *box)
-{
-	if (box->pmu->pmu_idx == 0)
-		wrmsrq(ADL_UNC_PERF_GLOBAL_CTL, SNB_UNC_GLOBAL_CTL_EN);
-}
-
 static void adl_uncore_msr_enable_box(struct intel_uncore_box *box)
 {
 	wrmsrq(ADL_UNC_PERF_GLOBAL_CTL, SNB_UNC_GLOBAL_CTL_EN);
@@ -587,7 +581,6 @@ static void adl_uncore_msr_exit_box(stru
 }
 
 static struct intel_uncore_ops adl_uncore_msr_ops = {
-	.init_box	= adl_uncore_msr_init_box,
 	.enable_box	= adl_uncore_msr_enable_box,
 	.disable_box	= adl_uncore_msr_disable_box,
 	.exit_box	= adl_uncore_msr_exit_box,


