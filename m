Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDA90415F21;
	Tue, 21 Jul 2026 17:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784656327; cv=none; b=j658txfY88fOsvQZIltYW/DBrBPoo0QzTalMsGG3S+o4gfUYEApD/Tv3rMMoP/PV+SOj/U33mCC9Un63MFF4CMvApL9j1QVd3thynYnBYmw3JtFldNnMzuW+dt8q+EYtHuxYQA1G2Gteo2OXnZB9VRQRd5gp07Wct98cI8p28Z8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784656327; c=relaxed/simple;
	bh=Dfpp4mE0siHq6yfHq5v+36OqncqR3wPd8FMfefcfk9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CJgzTxvPh1P1104KY433cFjyaZ3h5/pMnwU4N2uF6lzi3KlLfaEJJ9ZZQO+MokI7XStyVpITeYye0p4V4wcD8frmj4DQKVsCX6zBeWJs/G/RxFXSutcq1x4RbLDKMDGhoXz+LQIfYBCOcjJtvCCBVie3zc5ZektG0DgoU0ULB04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JBacwJe2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JBacwJe2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A0701F000E9;
	Tue, 21 Jul 2026 17:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784656325;
	bh=/Da04PfR0pSDXMeOn5M9nVADwNumG2A+clzUZ/B7fgQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JBacwJe24SPf3tW95zXzLKDh1gWwxboyxCKCLVCdQmxFhBaHpOUQyROw2bf305Sba
	 rpN+FynLrggG+d/w4ep2uOQAbuNPpuCSiTDPKtgjonY330kYMJAXoGfzZc3S8sQB/j
	 oIvgQMPq/lhAGDXTmJLACZsqq1+ytoqEC3zGWNkk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zide Chen <zide.chen@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Dapeng Mi <dapeng1.mi@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0328/1611] perf/x86/intel/uncore: Fix discovery unit lookup for multi-die systems
Date: Tue, 21 Jul 2026 17:07:24 +0200
Message-ID: <20260721152522.471715519@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index c5adbe44090470..7dd3910d8de3af 100644
--- a/arch/x86/events/intel/uncore_discovery.c
+++ b/arch/x86/events/intel/uncore_discovery.c
@@ -480,8 +480,8 @@ static u64 intel_generic_uncore_box_ctl(struct intel_uncore_box *box)
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



