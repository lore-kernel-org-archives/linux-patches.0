Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACFD7297B8F;
	Mon, 12 May 2025 18:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747073148; cv=none; b=HWfeD8txTQ8DGMV6urEhwieMkjDJq4NJn6ztV7tYjq+F6o4Fkh4XzZzR1ZupAge2GX95+m+WCqefEpM/vvQSdzxhYUXytYCkkKVgEV3GlsZ9iLxJxVBdrAvhaIDMCKfq62qcGbT9qb0mfc2Wmsw/NOrUbjmyvYpt+Or671SN0Ak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747073148; c=relaxed/simple;
	bh=xhwLDB7fnhEtlM6WzdWsz/RIVJKrVro++wzb0jd61oM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5ZM/+BGkoZ6l6UOD7ArTd+5Sn4nntTN6Dv4bNHxQmlkbo+11rmL4v8wx9h074dMRbz+bRa2McWq7nD+/cw28kdRSu4BqQaokwVl8hcTzv/mG84l0AZtRUS900/JpDjkZ9Ftp5Srz6NKkYi7UsxAaxPKa8Kz92VGIVG1S3ReHIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YjF7AYhm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YjF7AYhm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BA1BC4CEE7;
	Mon, 12 May 2025 18:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747073148;
	bh=xhwLDB7fnhEtlM6WzdWsz/RIVJKrVro++wzb0jd61oM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YjF7AYhmFrFwDFR4oqnivf0geRsi4S464qqczytSgxKoF7IahG7GfKqPWqDQclwkc
	 zM15idWaISgvQ/hYkICf0FAzdayCgNjb+zmebQMsd8s9VaAIP2Z83fOax3f+JUql+c
	 E1jahtcvFZvovK2CrJCSffTWiC+tKuPU2ZWyQOcI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Alexandre Chartre <alexandre.chartre@oracle.com>
Subject: [PATCH 6.12 170/184] x86/bhi: Do not set BHI_DIS_S in 32-bit mode
Date: Mon, 12 May 2025 19:46:11 +0200
Message-ID: <20250512172048.732319650@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>

commit 073fdbe02c69c43fb7c0d547ec265c7747d4a646 upstream.

With the possibility of intra-mode BHI via cBPF, complete mitigation for
BHI is to use IBHF (history fence) instruction with BHI_DIS_S set. Since
this new instruction is only available in 64-bit mode, setting BHI_DIS_S in
32-bit mode is only a partial mitigation.

Do not set BHI_DIS_S in 32-bit mode so as to avoid reporting misleading
mitigated status. With this change IBHF won't be used in 32-bit mode, also
remove the CONFIG_X86_64 check from emit_spectre_bhb_barrier().

Suggested-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Reviewed-by: Josh Poimboeuf <jpoimboe@kernel.org>
Reviewed-by: Alexandre Chartre <alexandre.chartre@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/bugs.c  |    6 +++---
 arch/x86/net/bpf_jit_comp.c |    5 +++--
 2 files changed, 6 insertions(+), 5 deletions(-)

--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1684,11 +1684,11 @@ static void __init bhi_select_mitigation
 			return;
 	}
 
-	/* Mitigate in hardware if supported */
-	if (spec_ctrl_bhi_dis())
+	if (!IS_ENABLED(CONFIG_X86_64))
 		return;
 
-	if (!IS_ENABLED(CONFIG_X86_64))
+	/* Mitigate in hardware if supported */
+	if (spec_ctrl_bhi_dis())
 		return;
 
 	if (bhi_mitigation == BHI_MITIGATION_VMEXIT_ONLY) {
--- a/arch/x86/net/bpf_jit_comp.c
+++ b/arch/x86/net/bpf_jit_comp.c
@@ -1437,8 +1437,7 @@ static int emit_spectre_bhb_barrier(u8 *
 	/* Insert IBHF instruction */
 	if ((cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_LOOP) &&
 	     cpu_feature_enabled(X86_FEATURE_HYPERVISOR)) ||
-	    (cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_HW) &&
-	     IS_ENABLED(CONFIG_X86_64))) {
+	    cpu_feature_enabled(X86_FEATURE_CLEAR_BHB_HW)) {
 		/*
 		 * Add an Indirect Branch History Fence (IBHF). IBHF acts as a
 		 * fence preventing branch history from before the fence from
@@ -1448,6 +1447,8 @@ static int emit_spectre_bhb_barrier(u8 *
 		 * hardware that doesn't need or support it.  The REP and REX.W
 		 * prefixes are required by the microcode, and they also ensure
 		 * that the NOP is unlikely to be used in existing code.
+		 *
+		 * IBHF is not a valid instruction in 32-bit mode.
 		 */
 		EMIT5(0xF3, 0x48, 0x0F, 0x1E, 0xF8); /* ibhf */
 	}


