Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F96A408634;
	Tue, 21 Jul 2026 19:25:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784661946; cv=none; b=cga2YPg0STV7ZhmyIXZNWpeOLOQGqrhZZYcOp9HuYpVMPV+7uARHvo151cgrwZkHh5Rk7AfZC7UbsiNX77eej84nWVeyD27jTnuvYTlxoxks/JoUzNnBi9YLAWPC6b4MpeGmvRxrH4XUVYs5lPMnohQhHCTo182bj1fkAQBHHBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784661946; c=relaxed/simple;
	bh=OJzZbeio2poIz5zqnJ6UOT1xnLnc0Ht0jR+enl1/ctc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NOg5QJRK321Gs4X/oLj52fkh/fI2FTyMwrAwFLRxCVX21rSEX4TsU4KYrJGI0zFo13nBvZ+ZKIeX9O7dGhCV+b5drAyYQvidFoZRwBF/52lC649gXgT1qLjbHm3Oc1NTOMU1ww2okaGRPHybjhZb27filXUfziNPEhIpRrz9yts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WjQ6+0Lc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WjQ6+0Lc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E62A51F000E9;
	Tue, 21 Jul 2026 19:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784661945;
	bh=52kgZP7cLQgyxxpKzyZvB+XtG5TaM6ZV6QzSQndJ7rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WjQ6+0Lc7XR3sv6IWRuIlNUevpR14wC9rTT7O/O28vyO0gb7vFIYJnoTpCNuJK3ag
	 6alqAo1s2zBzKI1Qb8H2w2Zy1hw3fPMWG1/lD2z/JLF6AOGEk3+NJX/fVac315qTZW
	 2N6BvTQmo3mi6R1dyZK7qMpnj7GsOZ5fsAm0BCDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0231/1276] perf/x86/intel/uncore: Fix discovery unit lookup for multi-die systems
Date: Tue, 21 Jul 2026 17:11:14 +0200
Message-ID: <20260721152451.260757519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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
index aad35190ccf649..618481ad9f5791 100644
--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -432,8 +432,8 @@ static u64 intel_generic_uncore_box_ctl(struct intel_uncore_box *box)
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



