Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6CAE822CBED;
	Mon, 10 Mar 2025 17:29:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627749; cv=none; b=fvYTUJEGVXVLTc61T2LUftR0bjMa+6N62EFiljfCDwPMqW4ama32bF7kR8252zGf3fpvf3bVV0UrNmPnDmGNepW3+Ge6XyL0uUAZPkv0vJpl3Y3H4iFf2VbT2wMgRAS88ktq59VLkMcKxLU3FL6ezwRJ1Z4scuGx4PiS6lZHeZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627749; c=relaxed/simple;
	bh=zu2gyNj41OxDBYfOxWjy/KYHIC5AKcoNBBn5+RVH/JA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P0Asds7upO9S0mChDS2KgO3G6+HwJNsfqY5E3QBCjiBKTYwv9JEMQsWEbMrC0NenyMNN5653vYhUyOQBsbaMNLHwR1MzQBrB4uznIz6HGM2AoPs85ny1nNawww07/t3bJ4hEP/Aymss0EYk0Nba9dYPWZN+7DjZc/J05a7EAKQI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ftk7XHOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ftk7XHOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBDABC4CEEC;
	Mon, 10 Mar 2025 17:29:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627749;
	bh=zu2gyNj41OxDBYfOxWjy/KYHIC5AKcoNBBn5+RVH/JA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ftk7XHOSTXvGgjSgDcvTcFv2GCDj9sX0JO/7g3nBL+hs2Z5O74WpfKBEOha28U+xV
	 egSAVDaTcXjS/G2C7wjPWzLaGmdEau1n7odw7dTadZoC6vIkk4X02HcQpB1xyMi4cm
	 xzfwZuwi2j+CGUI7NB0cV9o4RI9qctktPAE0yFlI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.12 236/269] KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isnt supported by KVM
Date: Mon, 10 Mar 2025 18:06:29 +0100
Message-ID: <20250310170507.091497322@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

From: Xiaoyao Li <xiaoyao.li@intel.com>

commit f9dc8fb3afc968042bdaf4b6e445a9272071c9f3 upstream.

Fix a goof where KVM sets CPUID.0x80000022.EAX to CPUID.0x80000022.EBX
instead of zeroing both when PERFMON_V2 isn't supported by KVM.  In
practice, barring a buggy CPU (or vCPU model when running nested) only the
!enable_pmu case is affected, as KVM always supports PERFMON_V2 if it's
available in hardware, i.e. CPUID.0x80000022.EBX will be '0' if PERFMON_V2
is unsupported.

For the !enable_pmu case, the bug is relatively benign as KVM will refuse
to enable PMU capabilities, but a VMM that reflects KVM's supported CPUID
into the guest could inadvertently induce #GPs in the guest due to
advertising support for MSRs that KVM refuses to emulate.

Fixes: 94cdeebd8211 ("KVM: x86/cpuid: Add AMD CPUID ExtPerfMonAndDbg leaf 0x80000022")
Signed-off-by: Xiaoyao Li <xiaoyao.li@intel.com>
Link: https://lore.kernel.org/r/20250304082314.472202-3-xiaoyao.li@intel.com
[sean: massage shortlog and changelog, tag for stable]
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1387,7 +1387,7 @@ static inline int __do_cpuid_func(struct
 
 		entry->ecx = entry->edx = 0;
 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {
-			entry->eax = entry->ebx;
+			entry->eax = entry->ebx = 0;
 			break;
 		}
 


