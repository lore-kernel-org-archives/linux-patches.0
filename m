Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F8E46EC9B;
	Tue, 21 Jul 2026 18:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784658850; cv=none; b=aZdVKUieZG/BLpCsCKBSPGT2xvcA4ek0eBFRbcjEI7D09XS7h1kx1k+NEnsMUbHApisIv4uleQV0i4ihYUqh6iBJ58CFFDbiS392ZOnO3smwmPNfCtDDELflVZRlYSoh9RonWziYJZvlxxQZBW1DlqW0GrnxbIjQgRmyDXwb3fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784658850; c=relaxed/simple;
	bh=ufnPjS1ax5XRIVjJQvwcTVT3yNtTe4qz9HAnq2z6xWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvzl4SyuLEbJLew10nVozbNO1Mug7AY7S6I7ImdBLumrtNlMfCa+fEI9D9nSDZdhl15CcEdr3Z6FIkfVwHlfOe0JHGCNgpvsWL1xh60TUY2GPv9HEeiTk4llRq5lIVYQ+AiXSXUJoBhkRsCo1qYsO7/WMFH6nEppoLHsY2LePP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wqscLfIV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wqscLfIV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5CDB71F000E9;
	Tue, 21 Jul 2026 18:34:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784658848;
	bh=y4BflOfPHi/coKt87IzkmysZdK4IZhyhqnPTeBNbqis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wqscLfIV/3gGwEq6sl14vfYL/YxQ4Oug6RTGxwAsr+ApXIKImjWTA4Pt6olflRynJ
	 Qn92BP2tFnX4Ejq1PBqoRKq1sLiqIXDNEEwYHWPfmCEUVfI/dDcY3diNfA2HRlZ5LY
	 gv/54lxQpQYERmI+rmzkVI3sgomChKq9V0hyja6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amit Machhiwal <amachhiw@linux.ibm.com>,
	"Mukesh Kumar Chaurasiya (IBM)" <mkchauras@gmail.com>,
	"Christophe Leroy (CS GROUP)" <chleroy@kernel.org>,
	Madhavan Srinivasan <maddy@linux.ibm.com>
Subject: [PATCH 6.18 1256/1611] powerpc/dt_cpu_ftrs: Set CPU_FTR_P11_PVR for Power11 and later processors
Date: Tue, 21 Jul 2026 17:22:52 +0200
Message-ID: <20260721152543.699933044@linuxfoundation.org>
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

From: Amit Machhiwal <amachhiw@linux.ibm.com>

commit e4de1b9cb3b5c981e4fe9bca253a7fb9161f5acd upstream.

When using device tree CPU features (dt-cpu-ftrs), the kernel bypasses
the traditional cputable-based CPU identification and instead derives
CPU features from the device tree's "ibm,powerpc-cpu-features" node
provided by firmware.

However, CPU_FTR_P11_PVR is a kernel-internal feature flag used to
identify Power11 and later processors, and is not represented in the
device tree's ISA feature set. While ISA v3.1 support (indicated by
CPU_FTR_ARCH_31) is present on both Power10 and Power11, the
CPU_FTR_P11_PVR flag is specifically needed by code that must
distinguish between Power10 and Power11 processors.

Without this flag set, code that checks for Power11 using
cpu_has_feature(CPU_FTR_P11_PVR) will incorrectly return false on
Power11+ systems using dt-cpu-ftrs, leading to incorrect behavior.

This issue manifests specifically in powernv environments (bare-metal
or QEMU TCG with powernv machine type), where skiboot/OPAL firmware
provides the "ibm,powerpc-cpu-features" node, causing the kernel to
use dt-cpu-ftrs. The issue does not affect pseries guests, where SLOF
firmware does not provide this node, causing the kernel to fall back
to the traditional cputable path (identify_cpu) which correctly sets
CPU_FTR_P11_PVR during PVR-based CPU identification.

In powernv TCG guests, the missing flag causes KVM code to trigger
warnings when attempting to create KVM guests, as cpu_features shows
0x000c00eb8f4fb187 (missing bit 53) instead of the correct
0x002c00eb8f4fb187 (with bit 53 set).

Fix this by setting CPU_FTR_P11_PVR for all processors with
PVR >= PVR_POWER11 when ISA v3.1 support is detected in
cpufeatures_setup_start(). This approach ensures forward
compatibility with future processor generations.

Fixes: 96e266e3bcd6 ("KVM: PPC: Book3S HV: Add Power11 capability support for Nested PAPR guests")
Cc: stable@vger.kernel.org # v6.13+
Signed-off-by: Amit Machhiwal <amachhiw@linux.ibm.com>
Reviewed-by: Mukesh Kumar Chaurasiya (IBM) <mkchauras@gmail.com>
Reviewed-by: Christophe Leroy (CS GROUP) <chleroy@kernel.org>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/20260614173437.26352-1-amachhiw@linux.ibm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/powerpc/kernel/dt_cpu_ftrs.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/arch/powerpc/kernel/dt_cpu_ftrs.c
+++ b/arch/powerpc/kernel/dt_cpu_ftrs.c
@@ -704,6 +704,15 @@ static void __init cpufeatures_setup_sta
 	if (isa >= ISA_V3_1) {
 		cur_cpu_spec->cpu_features |= CPU_FTR_ARCH_31;
 		cur_cpu_spec->cpu_user_features2 |= PPC_FEATURE2_ARCH_3_1;
+
+		/*
+		 * CPU_FTR_P11_PVR is a kernel-internal flag to identify
+		 * Power11 and later processors. While ISA v3.1 is supported
+		 * by Power10+, this flag specifically indicates Power11+
+		 * for code that needs to distinguish between P10 and P11.
+		 */
+		if (PVR_VER(mfspr(SPRN_PVR)) >= PVR_POWER11)
+			cur_cpu_spec->cpu_features |= CPU_FTR_P11_PVR;
 	}
 }
 


