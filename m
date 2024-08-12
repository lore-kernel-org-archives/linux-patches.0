Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A092183CA6;
	Mon, 12 Aug 2024 16:23:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479834; cv=none; b=dCXM6mzk+3FjJjQLVNPhkRpqwOpOQTdqZ3EZUO9ghItxBdzh5tdtGpdx2QhfvkQMco8WvgEsrtJUlzxbxTxS8yWYmL6SLgOrZOxcgNUgzfgpuLhvHtlY1/So1o82r+PjkoDnp5++CT2uwbv7VJkG104rdBuyQlb8VeHifQyjqK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479834; c=relaxed/simple;
	bh=0ZYQepcXydUOAfzJkaWpTxU2aV1YRnlLc94ajR1PTG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Iv4JwayM1j16VuKNQksCgdfnrdHd6d0JXXu6sG+cFhOvfoI3o+4/HhKTQkxk9jfMlF1iV6k823LTfWKyeBxI5SPBHE/uDfye/5yCKRAgGnYTufsYgCfcRngM4heYmPv7CeU2wWkUJHuf6RwPVm5+xdzMqZu28qsAa0PfCRTMfrc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ss/NqI2Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ss/NqI2Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB20FC4AF0C;
	Mon, 12 Aug 2024 16:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479834;
	bh=0ZYQepcXydUOAfzJkaWpTxU2aV1YRnlLc94ajR1PTG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ss/NqI2ZCM3e822124qzy6bhS2slJ2FqlzcBZGO0orh87iwtfPvhsseEBPo5N5OJx
	 5hLQPRjZgIfCN6Hjb0T/W+0/OW+XwKrb5m4DBDt3IM19QdnT+9+d+hHKqvUPkr9JXD
	 V9RiKnK3O26R2DhC1og5oDmiB/MeMh2E4d6N/lAU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenyu Wang <zhenyuw@linux.intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Wendy Wang <wendy.wang@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 005/263] perf/x86/intel/cstate: Add pkg C2 residency counter for Sierra Forest
Date: Mon, 12 Aug 2024 18:00:06 +0200
Message-ID: <20240812160146.730451626@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhenyu Wang <zhenyuw@linux.intel.com>

[ Upstream commit b1d0e15c8725d21a73c22c099418a63940261041 ]

Package C2 residency counter is also available on Sierra Forest.
So add it support in srf_cstates.

Fixes: 3877d55a0db2 ("perf/x86/intel/cstate: Add Sierra Forest support")
Signed-off-by: Zhenyu Wang <zhenyuw@linux.intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Tested-by: Wendy Wang <wendy.wang@intel.com>
Link: https://lore.kernel.org/r/20240717031609.74513-1-zhenyuw@linux.intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/cstate.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index be58cfb012dd1..9f116dfc47284 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -64,7 +64,7 @@
  *			       perf code: 0x00
  *			       Available model: SNB,IVB,HSW,BDW,SKL,KNL,GLM,CNL,
  *						KBL,CML,ICL,ICX,TGL,TNT,RKL,ADL,
- *						RPL,SPR,MTL,ARL,LNL
+ *						RPL,SPR,MTL,ARL,LNL,SRF
  *			       Scope: Package (physical package)
  *	MSR_PKG_C3_RESIDENCY:  Package C3 Residency Counter.
  *			       perf code: 0x01
@@ -693,7 +693,8 @@ static const struct cstate_model srf_cstates __initconst = {
 	.core_events		= BIT(PERF_CSTATE_CORE_C1_RES) |
 				  BIT(PERF_CSTATE_CORE_C6_RES),
 
-	.pkg_events		= BIT(PERF_CSTATE_PKG_C6_RES),
+	.pkg_events		= BIT(PERF_CSTATE_PKG_C2_RES) |
+				  BIT(PERF_CSTATE_PKG_C6_RES),
 
 	.module_events		= BIT(PERF_CSTATE_MODULE_C6_RES),
 };
-- 
2.43.0



