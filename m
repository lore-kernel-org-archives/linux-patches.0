Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA452F8EAE;
	Sat, 12 Sep 2026 14:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789222673; cv=none; b=OoaTDWdKj3a2Imq+RBAgK4vsjvLAyaBn+nX/A/t1aTiuK9Z1JoeqXk74JL7s381LNbqfEV2jY4GzEzTmKOw2D+Xg01VADumV6SA+9ofF7lXMOJ9KcanP/uFnXuGdotii1N1ki8CjmCk0ft1DajSYBFr5ecaHTc9O0bVR1k6qd04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789222673; c=relaxed/simple;
	bh=wFRsZ2mzYuqBNx1F6wSNvN4MS6C3Vr+Qjfd1QL+NvkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xpc1ZGfIR8IGfzNk4jvioiSoa2aPWkysNV/ARJeCUiOkAtwPgGdVBD0v738oAJc7fKwZiVbmGf1WKKQ/iWkE73aJ0RLzk9P3cR1u32ROdGUd/44TaJKIkYpVZZRbQo2VLBI/7ze8Cq46wa53oZjjaZmy082Bn+g9AxI5qUMqDXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=thD5vA2h; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="thD5vA2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1162B1F000FF;
	Sat, 12 Sep 2026 14:17:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789222672;
	bh=oUO5O1+UMlac7xJ+cfZ49Jg5KPFSiKcv0B19fN08x/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=thD5vA2hfcfYLqV/jFeLAyme0Y+M3CBVsU2RoCU2sUga3ZwoxC94ATJfNf/Yf+Tfh
	 RS2HLYou1289LClHqbZOkNeGJ9l5AgBfXMKXz7Izm45VJfVRj1fgswSv3XnmPtMqps
	 S/P461XWiSyxZA2DuS+B51bkWkldOqIXoJIBh/pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Ian Rogers <irogers@google.com>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0591/1424] perf/x86/intel/uncore: Keep PCI PMUs working when MMIO/MSR setup fails
Date: Sat, 12 Sep 2026 08:50:23 +0200
Message-ID: <20260912065620.527815298@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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
index 42dba09461dae..6769820a007b7 100644
--- a/arch/x86/events/intel/uncore.c
+++ b/arch/x86/events/intel/uncore.c
@@ -1607,8 +1607,6 @@ static int uncore_event_cpu_online(unsigned int cpu)
 	die = topology_logical_die_id(cpu);
 	msr_ret = uncore_box_ref(uncore_msr_uncores, die, cpu);
 	mmio_ret = uncore_box_ref(uncore_mmio_uncores, die, cpu);
-	if (msr_ret && mmio_ret)
-		return -ENOMEM;
 
 	/*
 	 * Check if there is an online cpu in the package
-- 
2.53.0



