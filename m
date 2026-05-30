Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D571234389F;
	Sat, 30 May 2026 17:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780162811; cv=none; b=Xy6V6DXNF1WbM5KisALXtyFnKXXs3yiAwqSHqYqp6Gcs7l61emD0QJCUpHHESCN8i7TThws6K+0lbyofZuM94LE8iSYtlCpmXvrYy1VjCK+VzX4amsOLHNcd5kRHHKqqadNj3PIqoGW8Qhc1BHSlIqsxNCG3LDTakbs0K+JERNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780162811; c=relaxed/simple;
	bh=uWSOaAhzCRbjYkupHuS2xMs07+ogJixBQy+7E+PByAw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hfxFYmO0wM6v7cNMgQvdFAZmbF9ErXtg2S3m2uSBXmGa4zw8q9rmjTMDrMqp55Q5T0M8I8spMJ5Z+c/lLNvBkd79Mq7HXyilVA1miF7I42T/77hvIi5s5qg6gyxySAiOH0s7nfxat7IptftW6M5wIsaSa4trFCCydNKYaxW2xUc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vMq8NEtZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vMq8NEtZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB20E1F00893;
	Sat, 30 May 2026 17:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780162808;
	bh=xSYm5TNgvDjGbtr+fgR+hVJxxCvrOHw6cQCMCxV/dpM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vMq8NEtZ6qz2LRQGQacQ2qH/w3i3sSGY5BVr1vMP1ygHYLgbwABYeu1Az4eSp1YDU
	 SbZSGGVM3jvUazE8+bSetjoLPZFOIeO6jBtnbJdvMaIkl4RNdWBP/hFOz5jBdReRkn
	 tjQKh+XaBo+WQHXUrHkoZQyVskrOSYcX6kdzAnXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wahl <steve.wahl@hpe.com>,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 040/776] perf/x86/intel/uncore: Skip discovery table for offline dies
Date: Sat, 30 May 2026 17:55:54 +0200
Message-ID: <20260530160241.332439820@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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

[ Upstream commit 7b568e9eba2fad89a696f22f0413d44cf4a1f892 ]

This warning can be triggered if NUMA is disabled and the system
boots with fewer CPUs than the number of CPUs in die 0.

WARNING: CPU: 9 PID: 7257 at uncore.c:1157 uncore_pci_pmu_register+0x136/0x160 [intel_uncore]

Currently, the discovery table continues to be parsed even if all CPUs
in the associated die are offline.  This can lead to an array overflow
at "pmu->boxes[die] = box" in uncore_pci_pmu_register(), which may
trigger the warning above or cause other issues.

Fixes: edae1f06c2cd ("perf/x86/intel/uncore: Parse uncore discovery tables")
Reported-by: Steve Wahl <steve.wahl@hpe.com>
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Tested-by: Steve Wahl <steve.wahl@hpe.com>
Link: https://patch.msgid.link/20260313174050.171704-3-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_discovery.c b/arch/x86/events/intel/uncore_discovery.c
index c8e1f9f0b466d..be7a63808462e 100644
--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -303,7 +303,7 @@ bool intel_uncore_has_discovery_tables(void)
 				     (val & UNCORE_DISCOVERY_DVSEC2_BIR_MASK) * UNCORE_DISCOVERY_BIR_STEP;
 
 			die = get_device_die_id(dev);
-			if (die < 0)
+			if ((die < 0) || (die >= uncore_max_dies()))
 				continue;
 
 			parse_discovery_table(dev, die, bar_offset, &parsed);
-- 
2.53.0



