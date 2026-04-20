Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E27FC47884A;
	Mon, 20 Apr 2026 13:30:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776691848; cv=none; b=Nybd1A1h1XRT6uXHmlg6jq4RgeGdITFEPiSZxOzSDFpeP7W8Me1KtNrBcopQvXNqzqpSNhPm3nAnUYFuupCEAqBp0sp55Csrgw+X5YKSaMPJibA/CeHOVpkzcxXh3zm+7d6shSjMO70UyIZklo8YaJ+wn0wx5MXTTL4gLLvMKT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776691848; c=relaxed/simple;
	bh=TeoLPPwq3Fx1XsavGr3Vtm/74wb5AG2x7nwXrg7SrGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fnHDJ9g0ZzxsGioQkXJzfC0tnAGh73PgYzDFjktdA1HZAuzjIiY9/Ao5mXmZaFTbQjbKHk5fc+U3skyJnVJlnz/7ujy16jpjVyLHAOsrWSXLcdcRgO/28h1vIMDSJER1ixl2pW2TfONmjUdO/rl1QmZTTbJHrGuydjPhTZ8304I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OzVUsg9x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OzVUsg9x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 369A2C2BCB7;
	Mon, 20 Apr 2026 13:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1776691847;
	bh=TeoLPPwq3Fx1XsavGr3Vtm/74wb5AG2x7nwXrg7SrGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OzVUsg9xqCwzNrVSeobTlH3x/6RGtaqaec2Zb/MqTKpSJ8hpuJEnYmHO1uUZXwNpf
	 Q3XunUBvaMnr9D7Cta2ubLfISfQmK3AlLGh6BO0AeS8iNNa8JgTccKndHHhO52Up+z
	 QNAGJpQNfZM8nvza7Tw/2tv827dUPrGukJWnlnIV3E8UYqWmUjr1tTrbCCSy5ZDh9g
	 stIwe6geu853gba9Fh8ZxAJ8qHa5k63fimKHMwXOdGbAcw+x/EufvFFpF3uvIsDvHa
	 udmioWx7qD7TQwB9Tk6HGE/HpWxwqkXLIYwwjREsnHlmaV21a5bx4waZW00Y46iX67
	 sN9dwDit17JMw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Zide Chen <zide.chen@intel.com>,
	Steve Wahl <steve.wahl@hpe.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	mingo@redhat.com,
	acme@kernel.org,
	namhyung@kernel.org,
	tglx@kernel.org,
	bp@alien8.de,
	dave.hansen@linux.intel.com,
	x86@kernel.org,
	kan.liang@linux.intel.com,
	linux-perf-users@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.18] perf/x86/intel/uncore: Skip discovery table for offline dies
Date: Mon, 20 Apr 2026 09:20:23 -0400
Message-ID: <20260420132314.1023554-229-sashal@kernel.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420132314.1023554-1-sashal@kernel.org>
References: <20260420132314.1023554-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18.23
Content-Transfer-Encoding: 8bit

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

LLM Generated explanations, may be completely bogus:

Error: Failed to generate final synthesis

 arch/x86/events/intel/uncore_discovery.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/x86/events/intel/uncore_discovery.c b/arch/x86/events/intel/uncore_discovery.c
index 7d57ce706feb1..c5adbe4409047 100644
--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -383,7 +383,7 @@ static bool intel_uncore_has_discovery_tables_pci(int *ignore)
 				     (val & UNCORE_DISCOVERY_DVSEC2_BIR_MASK) * UNCORE_DISCOVERY_BIR_STEP;
 
 			die = get_device_die_id(dev);
-			if (die < 0)
+			if ((die < 0) || (die >= uncore_max_dies()))
 				continue;
 
 			parse_discovery_table(dev, die, bar_offset, &parsed, ignore);
-- 
2.53.0

