Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59BA747B40D;
	Sat, 12 Sep 2026 12:02:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789214530; cv=none; b=jexLuuvw0wZ3HAK4vPFopXigk4lW1itwE6SroyBPZ3cxFND/kneqD5WV4NJUERbqj36NQyinSQKLldZ7Dl4krR99uMgY15bmPJ3OWpKsJt3Eefh2FGqkV+h78UEesiNL098a9AeEzZHzXFp+u/TSKsNOyAn7LbH73tWZc2kFW/8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789214530; c=relaxed/simple;
	bh=zO2n/qbhrCDqEOr1ddd/ksj3ZO9knyeYzTHWm8rLVyg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F+OS8ZY1WgucZr4X8V7WJcBPpiwrLU7yWpPsZtd6665rZfyGHk2+b6ozCeR1R4H5dzJ7dBdL9AA1cIiPqKKjhnk9914zTZ5Gxon+XGNbaFTBz/rxjYuYTOXrNg+1AZA7M4L2geYfpax4zO7U161etUsW5PMlf+XdoRkidtZxMWA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UmJSnfnw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UmJSnfnw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FD01F00893;
	Sat, 12 Sep 2026 12:02:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789214525;
	bh=yvWerYoA8wutCiU1MMuO0jVijxVZdNrTByZefX98Q94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UmJSnfnw+A/ifQ6H6nJAxn/8y74evlPF7pvMg3uh4HJgVoGXyYPbRfAF08/SHqWRX
	 azL4wQrEmUzctkMJtBVVV17msPxmdPz/rCFkeoJ4D3kUavuGEmdzcUiGEz553viHoo
	 11PD7HPcRiufo8HFPZt0VfOqGBoTi7ZuaX+G3vas=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0345/1376] perf/x86/intel/uncore: Keep PCI PMUs working when MMIO/MSR setup fails
Date: Sat, 12 Sep 2026 08:46:11 +0200
Message-ID: <20260912065615.241337720@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Zide Chen <zide.chen@intel.com>

[ Upstream commit 3012af7df3430788eddd30b3c6654d0a0a5f06c6 ]

uncore_event_cpu_online() returns -ENOMEM early when both the MSR and
MMIO box allocations fail.  This also aborts PCI uncore setup, even
though PCI PMUs are independent of the MSR/MMIO paths.

Remove the early return so PCI uncore setup always runs regardless
of whether MSR or MMIO box allocation succeeds.

Fixes: 3da04b8a00dd ("perf/x86/intel/uncore: Support MMIO type uncore blocks")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Ian Rogers <irogers@google.com>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260611160033.66760-5-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore.c b/arch/x86/events/intel/uncore.c
index 96607174a0a93..2736815e651c7 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1629,8 +1629,6 @@ static int uncore_event_cpu_online(unsigned int cpu)
 	die = topology_logical_die_id(cpu);
 	msr_ret = uncore_box_ref(uncore_msr_uncores, die, cpu);
 	mmio_ret = uncore_box_ref(uncore_mmio_uncores, die, cpu);
-	if (msr_ret && mmio_ret)
-		return -ENOMEM;
 
 	/*
 	 * Check if there is an online cpu in the package
-- 
2.53.0



