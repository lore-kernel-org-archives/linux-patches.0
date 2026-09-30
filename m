Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7186C51993C;
	Wed, 30 Sep 2026 18:43:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790793791; cv=none; b=qbe+M5y1RkCQRfH4tm9AG8oNbDssYwPibbPhQuRrcXVQIUODaRMWxxoM70KIlu26KJQW6Ryi+2YlPId7J7O5blFz+O7bwZWdMxLaNpsYtFqjv0xwwnN47bLDNLlNjQDcXJfWVk/QuX1ngQtI4u0i/A3JTNg96ICD/oPkuxNyBdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790793791; c=relaxed/simple;
	bh=JdC42iW/ub9H0oRnJy+AcRMfcIid7Xwmb4VgdtBNB6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KEhk1YsSfpq8IaQf5GNsBz1dQWA0aL6kMGuYWmmKqVzSdIhDXXufbTuSV59Ssp7izNTl5jBOVHGSbfrBHkAy6jz8bRV2ySUr+PIDs1f/t5RPuMzf6Arn3dZsM+lZlAMbwZFIIMiu2jTAM98tdxZev7LufRAG+DTsR7FbzcqGRns=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wAg+lZUi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wAg+lZUi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBC681F00898;
	Wed, 30 Sep 2026 18:43:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790793790;
	bh=sxNk3rtsN6ffzxAdOi4ZDyU6/Be1gNV7HBOqr3+hNq8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wAg+lZUikKMwOpvVH/Iorq3yD+f2Q2pdX/mPMW7zwUgZYpsNYLAKp3FvgoDketVd7
	 XVX6p3ncFy9b3ricI5BNScbrCsJSwbz1jAvUTR3gJr/OV+u6vjvVx/VrbT0gMPaTX4
	 NXwsRni2/zR0ZC/pj+nEH7WxBcAx2fMirWf1MchE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Nikunj A Dadhania <nikunj@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 380/395] x86/sev: Remove redundant ghcbs_initialized checks around __sev_{get,put}_ghcb()
Date: Wed, 30 Sep 2026 17:30:42 +0200
Message-ID: <20260930152348.942417450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152340.591469096@linuxfoundation.org>
References: <20260930152340.591469096@linuxfoundation.org>
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

From: Nikunj A Dadhania <nikunj@amd.com>

[ Upstream commit 9d8460a1c7a6b0f2dc6302e5d0f31d4e8c2a7913 ]

After

  3645eb7e3915 ("x86/fred: Fix early boot failures on SEV-ES/SNP guests"),

__sev_{get,put}_ghcb() handle the early-boot GHCB fallback internally, making
the ghcbs_initialized guards in __set_pages_state() and
svsm_perform_call_protocol() redundant.

Remove them.

Also initialize state->ghcb to NULL in the early-boot path of
__sev_get_ghcb() so that the ghcb_state is well-defined for all callers,
even though __sev_put_ghcb() currently returns early before reading it.

No functional change intended.

Suggested-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Nikunj A Dadhania <nikunj@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Reviewed-by: Tom Lendacky <thomas.lendacky@amd.com>
Link: https://patch.msgid.link/20260518102230.3394603-1-nikunj@amd.com
Stable-dep-of: 6c43c72748ff ("x86/sev: Make vTPM SVSM calls preemption-safe")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/coco/sev/core.c    |    8 ++------
 arch/x86/coco/sev/noinstr.c |    4 +++-
 arch/x86/coco/sev/svsm.c    |   10 ++--------
 3 files changed, 7 insertions(+), 15 deletions(-)

--- a/arch/x86/coco/sev/core.c
+++ b/arch/x86/coco/sev/core.c
@@ -367,17 +367,13 @@ static unsigned long __set_pages_state(s
 
 	local_irq_save(flags);
 
-	if (sev_cfg.ghcbs_initialized)
-		ghcb = __sev_get_ghcb(&state);
-	else
-		ghcb = boot_ghcb;
+	ghcb = __sev_get_ghcb(&state);
 
 	/* Invoke the hypervisor to perform the page state changes */
 	if (!ghcb || vmgexit_psc(ghcb, data))
 		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PSC);
 
-	if (sev_cfg.ghcbs_initialized)
-		__sev_put_ghcb(&state);
+	__sev_put_ghcb(&state);
 
 	local_irq_restore(flags);
 
--- a/arch/x86/coco/sev/noinstr.c
+++ b/arch/x86/coco/sev/noinstr.c
@@ -121,8 +121,10 @@ noinstr struct ghcb *__sev_get_ghcb(stru
 
 	WARN_ON(!irqs_disabled());
 
-	if (!sev_cfg.ghcbs_initialized)
+	if (!sev_cfg.ghcbs_initialized) {
+		state->ghcb = NULL;
 		return boot_ghcb;
+	}
 
 	data = this_cpu_read(runtime_data);
 	ghcb = &data->ghcb_page;
--- a/arch/x86/coco/sev/svsm.c
+++ b/arch/x86/coco/sev/svsm.c
@@ -74,20 +74,14 @@ int svsm_perform_call_protocol(struct sv
 
 	flags = native_local_irq_save();
 
-	if (sev_cfg.ghcbs_initialized)
-		ghcb = __sev_get_ghcb(&state);
-	else if (boot_ghcb)
-		ghcb = boot_ghcb;
-	else
-		ghcb = NULL;
+	ghcb = __sev_get_ghcb(&state);
 
 	do {
 		ret = ghcb ? svsm_perform_ghcb_protocol(ghcb, call)
 			   : __pi_svsm_perform_msr_protocol(call);
 	} while (ret == -EAGAIN);
 
-	if (sev_cfg.ghcbs_initialized)
-		__sev_put_ghcb(&state);
+	__sev_put_ghcb(&state);
 
 	native_local_irq_restore(flags);
 


