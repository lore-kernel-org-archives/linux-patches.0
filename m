Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27AAF24E000;
	Tue, 29 Apr 2025 17:36:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948203; cv=none; b=HZoN3UZPLPcCLM7iyYYXJGhu6U43+vczesy6kLWpWIH4RSSmtXuLKiIQjLMLf8IrYgNmTRHiVjeeSFRi8SQy/gwDm/YJ29zhccBIKALDsXxXY2NTMZApUioHNltn6KwluU3aVa6Os/m5hm1I7oyQhKhIZeyas9LH8oSEbprjZyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948203; c=relaxed/simple;
	bh=c+Kh6WfT5bdn/SiYK4hxOWLEqdRaY2Odw94/hV7xJzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r0oee+sBvhGdEYUKNMpKkArYmY8UZORgjuMvAFc/pNf7TABgi30krTbKI3MeseMhQ7o+xJ00D3bsO3IaR0gYRETJ8Fhpr7yNF7Kye2eQhjx2ZT/5yoJ3QAhIDRb76+D5h2yNNwyVpdtRixLJkccOwAgawaava+iMCx70nPMEpuw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FQkhBQic; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FQkhBQic"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD73BC4CEE3;
	Tue, 29 Apr 2025 17:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948203;
	bh=c+Kh6WfT5bdn/SiYK4hxOWLEqdRaY2Odw94/hV7xJzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FQkhBQicY+Z/mqqWFmr48Rx2AdtsXK+VIh1qqTSgV8Xbb32EHEI9tiIHj+PttTvW5
	 5GJSMvHKEM4szYWeEcqbxdaqzbcdyvXwgTlIkdCeHnC3ZjkIjp3VMNhZIJa9MDzba+
	 OFBr0Fia9A3hkVPYgznx1tOAt1CN4Xlo8+c8rNJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pawan Gupta <pawan.kumar.gupta@linux.intel.com>,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	Ingo Molnar <mingo@kernel.org>,
	Amit Shah <amit.shah@amd.com>,
	Nikolay Borisov <nik.borisov@suse.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 219/280] x86/bugs: Dont fill RSB on VMEXIT with eIBRS+retpoline
Date: Tue, 29 Apr 2025 18:42:40 +0200
Message-ID: <20250429161124.083079893@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161115.008747050@linuxfoundation.org>
References: <20250429161115.008747050@linuxfoundation.org>
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

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 18bae0dfec15b24ec14ca17dc18603372f5f254f ]

eIBRS protects against guest->host RSB underflow/poisoning attacks.
Adding retpoline to the mix doesn't change that.  Retpoline has a
balanced CALL/RET anyway.

So the current full RSB filling on VMEXIT with eIBRS+retpoline is
overkill.  Disable it or do the VMEXIT_LITE mitigation if needed.

Suggested-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Pawan Gupta <pawan.kumar.gupta@linux.intel.com>
Reviewed-by: Amit Shah <amit.shah@amd.com>
Reviewed-by: Nikolay Borisov <nik.borisov@suse.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Link: https://lore.kernel.org/r/84a1226e5c9e2698eae1b5ade861f1b8bf3677dc.1744148254.git.jpoimboe@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/cpu/bugs.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/arch/x86/kernel/cpu/bugs.c b/arch/x86/kernel/cpu/bugs.c
index 5fba44a4f988c..589e34c0b70b5 100644
--- a/arch/x86/kernel/cpu/bugs.c
+++ b/arch/x86/kernel/cpu/bugs.c
@@ -1604,20 +1604,20 @@ static void __init spectre_v2_determine_rsb_fill_type_at_vmexit(enum spectre_v2_
 	case SPECTRE_V2_NONE:
 		return;
 
-	case SPECTRE_V2_EIBRS_LFENCE:
 	case SPECTRE_V2_EIBRS:
+	case SPECTRE_V2_EIBRS_LFENCE:
+	case SPECTRE_V2_EIBRS_RETPOLINE:
 		if (boot_cpu_has_bug(X86_BUG_EIBRS_PBRSB)) {
-			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 			pr_info("Spectre v2 / PBRSB-eIBRS: Retire a single CALL on VMEXIT\n");
+			setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT_LITE);
 		}
 		return;
 
-	case SPECTRE_V2_EIBRS_RETPOLINE:
 	case SPECTRE_V2_RETPOLINE:
 	case SPECTRE_V2_LFENCE:
 	case SPECTRE_V2_IBRS:
-		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 		pr_info("Spectre v2 / SpectreRSB : Filling RSB on VMEXIT\n");
+		setup_force_cpu_cap(X86_FEATURE_RSB_VMEXIT);
 		return;
 	}
 
-- 
2.39.5



