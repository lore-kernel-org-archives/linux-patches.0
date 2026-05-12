Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24166377EDF;
	Tue, 12 May 2026 18:14:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609664; cv=none; b=hR692Rq+QiPkq54BXbrV8xpWeDAZuuEcHU/AAz9NBIfedbI1u0PrgL13uEpdauah47oewwsvjXrr0SWzoyREIFH436zvesBdQeXJB4i48Wm5JJkepfLdnG1LJiAtCJ93+vQnnmRbwuTwBlFwPRBg6lsUX/ysNNYJo22yO8vjcPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609664; c=relaxed/simple;
	bh=ukg0rR5yls9o3c0B6JwZf0qf68svEwghlmPzW+Nsjbg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gJUr2my59I6hnMJM/VYCBjhShGectI36XXEks3u7XGQqnTJRrVtGUmkG8AbHlmhwNIUrlqheNkgCH1vxGloI1fIJud113/zXtOZR4qL6nO6K1IZbtPRtmRAeNxILkDy2DVHfpHhy/npKjXdfyX9GpegSZ7x1A5ry+DT9cKwJeGo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3TuLfgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3TuLfgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEC7CC2BCFA;
	Tue, 12 May 2026 18:14:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609664;
	bh=ukg0rR5yls9o3c0B6JwZf0qf68svEwghlmPzW+Nsjbg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z3TuLfgSoG3j+dBnxAwStU8ukRICk6QrLV5lzm8fWBfo8tnWa9XhY7H3sB0mX5ear
	 m74LYS9ypKnENyN1VBfscddt52IvH1gKVWbz+5p2B/hTms5yCN65usug7JWRXQq3Ap
	 RrNjt4sQyGcdLFTv9jO8qEsPXetzQ9QXt5fPS6ZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fuad Tabba <tabba@google.com>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 7.0 282/307] KVM: arm64: Fix FEAT_Debugv8p9 to check DebugVer, not PMUVer
Date: Tue, 12 May 2026 19:41:17 +0200
Message-ID: <20260512173946.079606778@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fuad Tabba <tabba@google.com>

commit 7fe2cd4e1a3ad230d8fcc00cc99c4bcce4412a75 upstream.

FEAT_Debugv8p9 is incorrectly defined against ID_AA64DFR0_EL1.PMUVer
instead of ID_AA64DFR0_EL1.DebugVer.  All three consumers of the macro
gate features that are architecturally tied to FEAT_Debugv8p9
(DebugVer = 0b1011, DDI0487 M.b A2.2.10):

  - HDFGRTR2_EL2.nMDSELR_EL1, HDFGWTR2_EL2.nMDSELR_EL1: MDSELR_EL1
    is present only when FEAT_Debugv8p9 is implemented (D24.3.21).

  - MDCR_EL2.EBWE: the Extended Breakpoint and Watchpoint Enable bit
    is RES0 unless FEAT_Debugv8p9 is implemented (D24.3.17).

Neither register has any dependency on PMUVer.

FEAT_Debugv8p9 and FEAT_PMUv3p9 are independent.  Per DDI0487 M.b
A2.2.10, FEAT_Debugv8p9 is unconditionally mandatory from Armv8.9,
whereas FEAT_PMUv3p9 is mandatory only when FEAT_PMUv3 is implemented.
An Armv8.9 CPU without a PMU has DebugVer = 0b1011 but PMUVer = 0b0000,
so the wrong field check would cause KVM to incorrectly treat EBWE and
MDSELR_EL1 as RES0 on such hardware.

Fixes: 4bc0fe089840 ("KVM: arm64: Add sanitisation for FEAT_FGT2 registers")
Signed-off-by: Fuad Tabba <tabba@google.com>
Link: https://patch.msgid.link/20260424084908.370776-2-tabba@google.com
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kvm/config.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/arm64/kvm/config.c
+++ b/arch/arm64/kvm/config.c
@@ -191,7 +191,7 @@ struct reg_feat_map_desc {
 #define FEAT_SRMASK		ID_AA64MMFR4_EL1, SRMASK, IMP
 #define FEAT_PoPS		ID_AA64MMFR4_EL1, PoPS, IMP
 #define FEAT_PFAR		ID_AA64PFR1_EL1, PFAR, IMP
-#define FEAT_Debugv8p9		ID_AA64DFR0_EL1, PMUVer, V3P9
+#define FEAT_Debugv8p9		ID_AA64DFR0_EL1, DebugVer, V8P9
 #define FEAT_PMUv3_SS		ID_AA64DFR0_EL1, PMSS, IMP
 #define FEAT_SEBEP		ID_AA64DFR0_EL1, SEBEP, IMP
 #define FEAT_EBEP		ID_AA64DFR1_EL1, EBEP, IMP


