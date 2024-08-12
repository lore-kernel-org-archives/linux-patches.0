Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C52EE134AC;
	Mon, 12 Aug 2024 16:23:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723479827; cv=none; b=od83SH8BbjFMfQwk3H2DJranCACP7MVEtmIeMwiKr/CP/oazCxPUb5iSVOcSXPyAswdMemhBQKMsXqdWGbTAvXULxNiLY50w4bOkkKDSEKBCdBK7ncTLjuoKZTJkJCQ+UEZHOdY1CHbYIA7t8hWCc781j5Su6rrOnW/raJUwjLo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723479827; c=relaxed/simple;
	bh=NCvueZtja5JJFY81JEMKclZQROjDFPCdJUKyCVBF/c4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QvdH36H2gDiKK2dvH9lSiqKbm/MOP/SKg/kkyGlIX5+dMAOpwe5zjsRBBs76CSzPAU3poeJMiKtTtvT/xegPz7g7gSvYggxNdjx/SfRqXchJZmCJYSNm9QU4xkSYld7/ghucIO6p91Xla7fkIA+RvvF4ldPC170rpKtYdblcUlo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FT4FAtwg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FT4FAtwg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48246C32782;
	Mon, 12 Aug 2024 16:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723479827;
	bh=NCvueZtja5JJFY81JEMKclZQROjDFPCdJUKyCVBF/c4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FT4FAtwgeypbVgYInbjXp2z5Sde/+QL0zOIuaGgZNJgSHp4y8ojZsusb2WNw9WnpV
	 w38DU3ab7/Z23oEm9XfWm8dM7bFY96Xi0RZDvby7C/5fRrqx9/oFKqNgI7i0bSl4Zb
	 pdgRdqsRm9FBuL84Dlb3gdQDFVPw+Ym4BQgPE6CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Rui <rui.zhang@intel.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Kan Liang <kan.liang@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 003/263] perf/x86/intel/cstate: Add Arrowlake support
Date: Mon, 12 Aug 2024 18:00:04 +0200
Message-ID: <20240812160146.653920400@linuxfoundation.org>
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

From: Zhang Rui <rui.zhang@intel.com>

[ Upstream commit a31000753d41305d2fb7faa8cc80a8edaeb7b56b ]

Like Alderlake, Arrowlake supports CC1/CC6/CC7 and PC2/PC3/PC6/PC8/PC10.

Signed-off-by: Zhang Rui <rui.zhang@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Kan Liang <kan.liang@linux.intel.com>
Link: https://lore.kernel.org/r/20240628031758.43103-3-rui.zhang@intel.com
Stable-dep-of: b1d0e15c8725 ("perf/x86/intel/cstate: Add pkg C2 residency counter for Sierra Forest")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/events/intel/cstate.c | 20 ++++++++++++--------
 1 file changed, 12 insertions(+), 8 deletions(-)

diff --git a/arch/x86/events/intel/cstate.c b/arch/x86/events/intel/cstate.c
index dd18320558914..cb165af1a1bfd 100644
--- a/arch/x86/events/intel/cstate.c
+++ b/arch/x86/events/intel/cstate.c
@@ -41,7 +41,7 @@
  *	MSR_CORE_C1_RES: CORE C1 Residency Counter
  *			 perf code: 0x00
  *			 Available model: SLM,AMT,GLM,CNL,ICX,TNT,ADL,RPL
- *					  MTL,SRF,GRR
+ *					  MTL,SRF,GRR,ARL
  *			 Scope: Core (each processor core has a MSR)
  *	MSR_CORE_C3_RESIDENCY: CORE C3 Residency Counter
  *			       perf code: 0x01
@@ -53,30 +53,31 @@
  *			       Available model: SLM,AMT,NHM,WSM,SNB,IVB,HSW,BDW,
  *						SKL,KNL,GLM,CNL,KBL,CML,ICL,ICX,
  *						TGL,TNT,RKL,ADL,RPL,SPR,MTL,SRF,
- *						GRR
+ *						GRR,ARL
  *			       Scope: Core
  *	MSR_CORE_C7_RESIDENCY: CORE C7 Residency Counter
  *			       perf code: 0x03
  *			       Available model: SNB,IVB,HSW,BDW,SKL,CNL,KBL,CML,
- *						ICL,TGL,RKL,ADL,RPL,MTL
+ *						ICL,TGL,RKL,ADL,RPL,MTL,ARL
  *			       Scope: Core
  *	MSR_PKG_C2_RESIDENCY:  Package C2 Residency Counter.
  *			       perf code: 0x00
  *			       Available model: SNB,IVB,HSW,BDW,SKL,KNL,GLM,CNL,
  *						KBL,CML,ICL,ICX,TGL,TNT,RKL,ADL,
- *						RPL,SPR,MTL
+ *						RPL,SPR,MTL,ARL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C3_RESIDENCY:  Package C3 Residency Counter.
  *			       perf code: 0x01
  *			       Available model: NHM,WSM,SNB,IVB,HSW,BDW,SKL,KNL,
  *						GLM,CNL,KBL,CML,ICL,TGL,TNT,RKL,
- *						ADL,RPL,MTL
+ *						ADL,RPL,MTL,ARL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C6_RESIDENCY:  Package C6 Residency Counter.
  *			       perf code: 0x02
  *			       Available model: SLM,AMT,NHM,WSM,SNB,IVB,HSW,BDW,
  *						SKL,KNL,GLM,CNL,KBL,CML,ICL,ICX,
- *						TGL,TNT,RKL,ADL,RPL,SPR,MTL,SRF
+ *						TGL,TNT,RKL,ADL,RPL,SPR,MTL,SRF,
+ *						ARL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C7_RESIDENCY:  Package C7 Residency Counter.
  *			       perf code: 0x03
@@ -86,7 +87,7 @@
  *	MSR_PKG_C8_RESIDENCY:  Package C8 Residency Counter.
  *			       perf code: 0x04
  *			       Available model: HSW ULT,KBL,CNL,CML,ICL,TGL,RKL,
- *						ADL,RPL,MTL
+ *						ADL,RPL,MTL,ARL
  *			       Scope: Package (physical package)
  *	MSR_PKG_C9_RESIDENCY:  Package C9 Residency Counter.
  *			       perf code: 0x05
@@ -95,7 +96,7 @@
  *	MSR_PKG_C10_RESIDENCY: Package C10 Residency Counter.
  *			       perf code: 0x06
  *			       Available model: HSW ULT,KBL,GLM,CNL,CML,ICL,TGL,
- *						TNT,RKL,ADL,RPL,MTL
+ *						TNT,RKL,ADL,RPL,MTL,ARL
  *			       Scope: Package (physical package)
  *	MSR_MODULE_C6_RES_MS:  Module C6 Residency Counter.
  *			       perf code: 0x00
@@ -760,6 +761,9 @@ static const struct x86_cpu_id intel_cstates_match[] __initconst = {
 	X86_MATCH_VFM(INTEL_RAPTORLAKE_S,	&adl_cstates),
 	X86_MATCH_VFM(INTEL_METEORLAKE,		&adl_cstates),
 	X86_MATCH_VFM(INTEL_METEORLAKE_L,	&adl_cstates),
+	X86_MATCH_VFM(INTEL_ARROWLAKE,		&adl_cstates),
+	X86_MATCH_VFM(INTEL_ARROWLAKE_H,	&adl_cstates),
+	X86_MATCH_VFM(INTEL_ARROWLAKE_U,	&adl_cstates),
 	{ },
 };
 MODULE_DEVICE_TABLE(x86cpu, intel_cstates_match);
-- 
2.43.0



