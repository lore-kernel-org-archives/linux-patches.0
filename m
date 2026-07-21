Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 616F246C4B2;
	Tue, 21 Jul 2026 15:52:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649135; cv=none; b=Lu8TcIesrQaf630QdXiLYe/Btv4pYDG+n3+y+IpWX9ls6qzoF0JO8jv5es3O0PYoChodm2icjeEwDQmFzqQRZK7OelrN7ux2RpXepIKkCqKp/bmteLSyUbj+HnLj9VTtiPS8kf+Rt8sHUF/mzSpBwmtAqxqZrBDS6tfbbNvrqHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649135; c=relaxed/simple;
	bh=6OQ+V9x9AOOZVE+MXrNV65HDeH0JWPWC4qu5DuWGcVs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k3iIUWTWGeNE3ShmwEnN391V7x2bLK5T3mxq2ngq60+2k00zEy4doySfzEhhgEArYnBofSdu/BZeWiCXTSsztAhZFAUYg+47t/E0LvcmtGXJYWvKTQd/f+vx1Es/p3ENeaZWMLDRm6QQzZEvuzo/KWdmw9C1Ue69ePZgFTMGI6M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ROSZ1dM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ROSZ1dM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C87DF1F000E9;
	Tue, 21 Jul 2026 15:52:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649134;
	bh=izWKGsK4ynvnDFFEZgkPgUi3g7aBEVaBxxZEkSQD7JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ROSZ1dM5V3Ui5vp2XR1on344gsGXv/Z0Sg6XRtpcj1xKMpnH6X3QmKhtdY1XVfaiO
	 SNuFYz2dcID6D0HlnyEfGw8DOe6UE3WcWhHuyCaihp5JUU4ung/9PNdMlJWUID95UW
	 IcVdRTESJ7Zkt+AWM1I5qzYOaFKEafVApQfQjYks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0464/2077] perf/x86/intel/uncore: Fix discovery unit lookup for multi-die systems
Date: Tue, 21 Jul 2026 17:02:17 +0200
Message-ID: <20260721152603.738365331@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

[ Upstream commit 63f48abd55d0417996bca86022925c853a2b436b ]

In uncore_find_add_unit(), PMON units with the same unit ID may be
added to the uncore discovery RB-tree for different dies. These units
are distinguished by node->die.

However, intel_generic_uncore_box_ctl() uses a fixed die ID of -1 when
looking up the discovery unit, which may retrieve the wrong node on
multi-die systems.

Use box->dieid instead so the correct discovery unit is selected.

No functional issue has been observed so far because currently supported
platforms happen to use the same unit control register for such units.

Remove WARN_ON_ONCE() because with the above change a NULL unit can be
expected, e.g. when a CPU die is offline during uncore enumeration and
the unit is not added to the RB-tree. In this case,
intel_uncore_find_discovery_unit() returns NULL once the die becomes
online, and it is expected that the PMU box is not functional for that
die.

Fixes: b1d9ea2e1ca4 ("perf/x86/uncore: Apply the unit control RB tree to MSR uncore units")
Signed-off-by: Zide Chen <zide.chen@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Dapeng Mi <dapeng1.mi@linux.intel.com>
Link: https://patch.msgid.link/20260602144908.263680-2-zide.chen@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/uncore_discovery.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/uncore_discovery.c b/arch/x86/events/intel/uncore_discovery.c
index 583cbd06b9b881..60e1200c4691d7 100644
--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -481,8 +481,8 @@ static u64 intel_generic_uncore_box_ctl(struct intel_uncore_box *box)
 	struct intel_uncore_discovery_unit *unit;
 
 	unit = intel_uncore_find_discovery_unit(box->pmu->type->boxes,
-						-1, box->pmu->pmu_idx);
-	if (WARN_ON_ONCE(!unit))
+						box->dieid, box->pmu->pmu_idx);
+	if (!unit)
 		return 0;
 
 	return unit->addr;
-- 
2.53.0



