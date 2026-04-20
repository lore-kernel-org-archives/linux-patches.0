Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16A3433A70A;
	Mon, 20 Apr 2026 16:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776701376; cv=none; b=XCQnPSQ5DUWBuC9u+TtaTGvodnH5GZzPMGsWygWGyqe8bwWO29Kf1jkMkxddtMbOsKJNsQCEV9QOHFkeSVnBrMtA5DUPfZQzCg+hu9CcMbPIm6GQVdmaR5bO8G02aJ946lEtFhyELoRgxJiF6SILZhTcB+5HugXidn29Kc6d+QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776701376; c=relaxed/simple;
	bh=3Nik1ZK5bPsvAmcXy0By0p6u9VKRT0MYQR886nNZ738=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LlEUJKNvyIam3Sz+2xHGQToFJ6h45yeG7TfA2ZGXGIp7xroKaEEtEA9ied+2iTm2UDP9idIv68XeJMvww9/5v0WBCujiRpCIEyS9QRfcPInIeu7DCFLtNNE3GOwBIbF5PPf3O0F7TtxvW9Weg8676ooY0KoNAlTn8O0bCB02DOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aHtm0i5F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aHtm0i5F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1013C19425;
	Mon, 20 Apr 2026 16:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776701376;
	bh=3Nik1ZK5bPsvAmcXy0By0p6u9VKRT0MYQR886nNZ738=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aHtm0i5F1IEV5Jzq/8/8S9WERccFAcmqHgfjQxcXAzNdIZu6IBuBHNRq8PkXj5zNx
	 LUWnJzokQYylxrFwzbCuU4NoDaAH4hNdEwexVWhbzIq3enpN/9N+2lNfmdgTfrHRBb
	 Iz3lr+GosNpAbo0rN7PRWUGHR1qyuckkwQG87DNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steve Wahl <steve.wahl@hpe.com>,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 082/162] perf/x86/intel/uncore: Skip discovery table for offline dies
Date: Mon, 20 Apr 2026 17:41:54 +0200
Message-ID: <20260420153930.005446198@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153927.006696811@linuxfoundation.org>
References: <20260420153927.006696811@linuxfoundation.org>
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
index 571e44b496910..aad35190ccf64 100644
--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -374,7 +374,7 @@ bool intel_uncore_has_discovery_tables(int *ignore)
 				     (val & UNCORE_DISCOVERY_DVSEC2_BIR_MASK) * UNCORE_DISCOVERY_BIR_STEP;
 
 			die = get_device_die_id(dev);
-			if (die < 0)
+			if ((die < 0) || (die >= uncore_max_dies()))
 				continue;
 
 			parse_discovery_table(dev, die, bar_offset, &parsed, ignore);
-- 
2.53.0



