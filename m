Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E54FA264A78;
	Thu, 17 Apr 2025 18:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914897; cv=none; b=gf4asnTOrvm8aQaFFelk4ZJ+ZTqiG0xs2Jrcg6WWkaCCfmUjQUqSZF3AZOu+kLqiIqKMGfCp48CBr8c60sLtNCIpoHnogicOlfHeQDRbyPjhODCmRX6jOtD7Sww6K3c0Bq6R3PQdtYKR2LCweex+lEVVm5tJggo7StMpkXubaSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914897; c=relaxed/simple;
	bh=3t96zPAsSHQWmDbdZWpAn+NwnALAO1t9esz+XmmulYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I+nUlEGJOpFpYNpqgFjoqATxPnKfEnFxOXYe2VQASXFMOtEQOg1mdJ1jvxnXMUEgbydCLc9uqUBKnAOq2DMhJVzJAIOIYjUg6+JLFqrPFKM4VGL7SWZwUc+5nVsyVy8yvOK88TTBQVH+DpTjm/QsneP9qJeWfpSP6/g5YYqE2pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IjHCzy/O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IjHCzy/O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E3EAC4CEE4;
	Thu, 17 Apr 2025 18:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914896;
	bh=3t96zPAsSHQWmDbdZWpAn+NwnALAO1t9esz+XmmulYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IjHCzy/O3ShhLG0pCLV71U1FfLeLM6WikGwy5kPoDRQqqehzBrojBDBWuyKzMWHcK
	 vW3zJCsmJ3+k32ye2zcTgbQe0lCQlGM2kBbSO53TGFIgFbDPUO/yFh+bWuF5NGSJpS
	 Bkq+zpWO/PQia1linlaW3/bkHtdo4B93LiEGp0Hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.13 366/414] KVM: x86: Explicitly zero-initialize on-stack CPUID unions
Date: Thu, 17 Apr 2025 19:52:04 +0200
Message-ID: <20250417175126.187138923@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

From: Sean Christopherson <seanjc@google.com>

commit bc52ae0a708cb6fa3926d11c88e3c55e1171b4a1 upstream.

Explicitly zero/empty-initialize the unions used for PMU related CPUID
entries, instead of manually zeroing all fields (hopefully), or in the
case of 0x80000022, relying on the compiler to clobber the uninitialized
bitfields.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Jim Mattson <jmattson@google.com>
Message-ID: <20250315024102.2361628-1-seanjc@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1053,8 +1053,8 @@ static inline int __do_cpuid_func(struct
 		}
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
-		union cpuid10_eax eax;
-		union cpuid10_edx edx;
+		union cpuid10_eax eax = { };
+		union cpuid10_edx edx = { };
 
 		if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
@@ -1070,8 +1070,6 @@ static inline int __do_cpuid_func(struct
 
 		if (kvm_pmu_cap.version)
 			edx.split.anythread_deprecated = 1;
-		edx.split.reserved1 = 0;
-		edx.split.reserved2 = 0;
 
 		entry->eax = eax.full;
 		entry->ebx = kvm_pmu_cap.events_mask;
@@ -1389,7 +1387,7 @@ static inline int __do_cpuid_func(struct
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
-		union cpuid_0x80000022_ebx ebx;
+		union cpuid_0x80000022_ebx ebx = { };
 
 		entry->ecx = entry->edx = 0;
 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {


