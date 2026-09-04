Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86E1351C04;
	Fri,  4 Sep 2026 05:26:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788499602; cv=none; b=g97SAqcbsh83MOxvPD1LNddaVXUmw4SFItceYnYVSAxZCJYoQw1oKTRAts3SKdKz/JTTDn3LQytAGf952MILxcuMyc/dGtdoiT4wD8JPcMgX8Jbzw3gdl0uxWoH+i8sHebc21xLrF35nFwOGUyw7UBARrL6pGzjST9dLhZY1SKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788499602; c=relaxed/simple;
	bh=Lwc+878EeyRB2/CIQRFCWJ0GuKcflFa5o+5mY01PadA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gEhZWeOhcc3b9B2m3NaDAdwNxdL+GuYZmad17xdtGAyMv0YucHcEp1WIsVlfhRhHTsl9tAahIeWpYoweg/jLVuBM2ZiQp4Hj9z9CFdskFHC6RORGkpsov8dezRGWpKd7dllvPfO3QDxsOP6NBy/yvoqtAzZ8onISrnvb63HOTRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCxbveAc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCxbveAc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE0871F00A3D;
	Fri,  4 Sep 2026 05:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788499601;
	bh=nplQxVwEniCGwsB8H+KtPJG2Ep9TcWDsgv9/hAeWmDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SCxbveAcaluJeGX1z8qlSojuE+uHM982B4BzyD7rIeON4IUqhJHqMk3sK92bfxpNF
	 lKBT6mPCdfSj5MoF3nD/1p+OtVtuC42wcUzA1lSWeB2g5drkMC5dt07eq1Vz6Xr8sO
	 mBp+UvuhRxXxeVTcS6uy36g5ICFKyxDnHfS+RW3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Karl Mehltretter <kmehltretter@gmail.com>,
	Will Deacon <will@kernel.org>
Subject: [PATCH 7.2 475/713] arm64: proton-pack: Restore the nospectre_bhb command-line option
Date: Fri,  4 Sep 2026 06:57:23 +0200
Message-ID: <20260904045814.471735091@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Karl Mehltretter <kmehltretter@gmail.com>

commit 2f6fc0612607c95489c960aaefc8cb5578cdab8c upstream.

Commit 7f1635737823 ("arm64: proton-pack: Fix hard lockup due to print in
scheduler context") moved the "mitigation disabled" printks into
spectre_print_disabled_mitigations(). For spectre-v2 and spectre-v4 only
the pr_info_once() calls were removed, but for spectre-bhb the whole
branch went with the print:

  -   } else if (cpu_mitigations_off() || __nospectre_bhb) {
  -           pr_info_once("spectre-bhb mitigation disabled ...\n");

spectre_bhb_enable_mitigation() therefore no longer tests __nospectre_bhb
or cpu_mitigations_off() and the mitigation is enabled regardless of the
command line. The parameter is still parsed and its flag is still checked
by spectre_print_disabled_mitigations(), so the kernel prints "spectre-bhb
mitigation disabled by command-line option" while
/sys/devices/system/cpu/vulnerabilities/spectre_v2 reports "Mitigation:
CSV2, BHB" and the vectors are switched to EL1_VECTOR_BHB_LOOP.

The only remaining escape is the SPECTRE_VULNERABLE arm at the top of the
chain, which a CSV2 core never reaches, so from Cortex-A76 and Neoverse N1
onwards both nospectre_bhb and mitigations=off are ignored. Both are
documented in Documentation/admin-guide/kernel-parameters.txt.

The identical mistake was made on the neighbouring compile-time-option
branch immediately before this regression and fixed shortly afterwards;
this command-line branch was missed.
build_bhb_mitigation() in arch/arm64/net/bpf_jit_comp.c still tests both
flags, so nospectre_bhb currently keeps the exception-vector loop while
dropping the cBPF epilogue mitigation.

Restore the check, folded into a spectre_bhb_mitigations_off() helper
alongside its spectre_v2/v4 counterparts, and use it for the boot-time
print in spectre_print_disabled_mitigations() as well. The print itself
already lives there and does not need restoring.

Tested under QEMU with -cpu neoverse-n1 (CSV2, no ECBHB, no CLRBHB).
Before, spectre_v2 read "Mitigation: CSV2, BHB" with and without the
option; after, nospectre_bhb and mitigations=off both give "Mitigation:
CSV2, but not BHB" and a boot without either is unchanged.

Fixes: 7f1635737823 ("arm64: proton-pack: Fix hard lockup due to print in scheduler context")
Assisted-by: Claude:claude-opus-5
Cc: stable@vger.kernel.org
Signed-off-by: Karl Mehltretter <kmehltretter@gmail.com>
Signed-off-by: Will Deacon <will@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/kernel/proton-pack.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/arch/arm64/kernel/proton-pack.c
+++ b/arch/arm64/kernel/proton-pack.c
@@ -1023,6 +1023,11 @@ static int __init parse_spectre_bhb_para
 }
 early_param("nospectre_bhb", parse_spectre_bhb_param);
 
+static bool spectre_bhb_mitigations_off(void)
+{
+	return __nospectre_bhb || cpu_mitigations_off();
+}
+
 void spectre_bhb_enable_mitigation(const struct arm64_cpu_capabilities *entry)
 {
 	bp_hardening_cb_t cpu_cb;
@@ -1036,6 +1041,8 @@ void spectre_bhb_enable_mitigation(const
 		/* No point mitigating Spectre-BHB alone. */
 	} else if (!IS_ENABLED(CONFIG_MITIGATE_SPECTRE_BRANCH_HISTORY)) {
 		/* Do nothing */
+	} else if (spectre_bhb_mitigations_off()) {
+		/* Mitigation disabled on the command line */
 	} else if (supports_ecbhb(SCOPE_LOCAL_CPU)) {
 		state = SPECTRE_MITIGATED;
 		set_bit(BHB_HW, &system_bhb_mitigations);
@@ -1201,6 +1208,6 @@ void spectre_print_disabled_mitigations(
 	if (spectre_v4_mitigations_off())
 		pr_info("spectre-v4 %s", spectre_disabled_suffix);
 
-	if (__nospectre_bhb || cpu_mitigations_off())
+	if (spectre_bhb_mitigations_off())
 		pr_info("spectre-bhb %s", spectre_disabled_suffix);
 }


