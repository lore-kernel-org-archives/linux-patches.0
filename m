Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDE282F28;
	Mon, 10 Mar 2025 17:17:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627072; cv=none; b=R78RYYMPpAMQi+aZOYrI/gsyRi6FNiTnMr4DrmfYofKN6xYMbxNX3VNJbbS9nsJfZgScau0zoKX5l/QGUvWU3O7WEwQvTCEKIg8Ks2KArt+HK9yjll3M2Kojxwa/ZH2UnhD/XF1ahOdtKpSpyxGWO4Hc20GFFzUcBLcBS4H3gwE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627072; c=relaxed/simple;
	bh=XqxBMi1bpAH5Qo42dDNiLc5BscLFwrEoqEbeBC84D0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZFRnjGdC0hAiXpyyVYC5QOJYtIt/6ryFgdsDOP+B/3UGO9llJsH6ILBh8iDa6SiUCIpZ+BQbHH/e6Zzye/RP5mN+5zcbbZorqYTNIpuX27/Rl3Xhl4mim6CARfcobACZoR/aUyvn83x1gcgdRH8+SBWHhwmMe1wzhOyuJTf++I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wWfbGbNv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wWfbGbNv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B877C4CEE5;
	Mon, 10 Mar 2025 17:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627072;
	bh=XqxBMi1bpAH5Qo42dDNiLc5BscLFwrEoqEbeBC84D0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wWfbGbNvFFWdFSt59CqyDbeDa2bgsj2PTUe/mZ+yu817PrVmsNZLJoyyKohNA2kjc
	 JmpvRQwlNnxNTUa+rv4AVk+lXfdsJbhRguy6U50l8mkLrv9++Pb8+KLqay70FT8H5y
	 m3T/32XdgVFVmDSY2IGu8YIhx2vpCAOEc7EtNYJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaoyao Li <xiaoyao.li@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.13 179/207] KVM: x86: Explicitly zero EAX and EBX when PERFMON_V2 isnt supported by KVM
Date: Mon, 10 Mar 2025 18:06:12 +0100
Message-ID: <20250310170454.905903776@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1393,7 +1393,7 @@ static inline int __do_cpuid_func(struct
 
 		entry->ecx = entry->edx = 0;
 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {
-			entry->eax = entry->ebx;
+			entry->eax = entry->ebx = 0;
 			break;
 		}
 


