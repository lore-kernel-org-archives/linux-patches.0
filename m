Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E97F11DE89C;
	Mon, 10 Mar 2025 17:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741628170; cv=none; b=eVQs964iNp60kKDvz4XIeCl4gt6+vcrcOnPBUgtjUTwzJtb/1kj8opM2LaWqsCPym23f1FcfbDLcJpGqMrSEqxNpV0U8nARRUh6gncwUOegjKIJAALSYy1oHmjeHNI3gaThctE2PRtTIQqAE00ZLOvjBFTSSJkwceiLyaOAB/D0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741628170; c=relaxed/simple;
	bh=KSfMBLieZYt9IQc/+43bHhqlw9SjLfx5Vzh3l7Bjyk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jKaVigsf32sjrr93IBltZGLJ/dnihLbp+4ceJWJEoTsZ+amchsXTiaaRoBej5m0FyOU9hZ75oOGY2+kPCqhC8XsWGFFHB1vCSB14dcWf9vnAunIjilxSdoR1exoecAB0z/miXhZHIgKQKo32/8mCxvnzMuZiHWuj92kAbl+anb0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xnr8LlJD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xnr8LlJD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 708B6C4CEE5;
	Mon, 10 Mar 2025 17:36:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741628169;
	bh=KSfMBLieZYt9IQc/+43bHhqlw9SjLfx5Vzh3l7Bjyk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Xnr8LlJDRSigEx69omon1sx2ojM8KPNPo0F8mnjXZOOEQwp3X7QwRmZj/M/Dczu4j
	 sowsEq69JrlAtiYhv9o4aX6fszpe9LmdUr3Yk0kU3yzXilHf0iYu3yTVPKCcst/NdG
	 3XmdJqjl0ow7jv6guLfx9NI0ILEPv3rcLUTcJWms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.6 112/145] KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isnt supported by KVM
Date: Mon, 10 Mar 2025 18:06:46 +0100
Message-ID: <20250310170439.280730572@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170434.733307314@linuxfoundation.org>
References: <20250310170434.733307314@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1307,7 +1307,7 @@ static inline int __do_cpuid_func(struct
 
 		entry->ecx = entry->edx = 0;
 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {
-			entry->eax = entry->ebx;
+			entry->eax = entry->ebx = 0;
 			break;
 		}
 


