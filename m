Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB252561C7;
	Thu, 17 Apr 2025 18:13:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913632; cv=none; b=TLxOI7Lvca1Q2OAOppEWtIhzPuYSUpZVPsaWF6OIJX1Jb0aa7uuzpz1KAw+YIe2EC5BMtdBapK3grBnE/Kn3qC45EjSyk5/HoA8i1o46YwKrTTp0xWZ4igG1A/HHQh/hQIH+N6WYkDaWUwSCHfxpLW0Y/i2tPUR9/tHGsGgQ250=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913632; c=relaxed/simple;
	bh=W4Gz+6YWP8jm8AA8kESS5UiZCddEfYDk5pYHmX09O6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oPR051MMPZ4V1lXXZxuiPgWbi6JAvBP/M/3NqGC86cPu5OkzZyGD7F0G1aVbFkioPn98KR1SNMkdJnw52O2xe8MqmIJqJ56sI3k+4jzYGKtkqQTjwbtQKJCKPtfRro9r9JXULtTIaePTxv1ig5aJDsn/Cl+ZEf0XhER3r0SDzmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KhsvfeWb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KhsvfeWb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4CB4AC4CEE4;
	Thu, 17 Apr 2025 18:13:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913632;
	bh=W4Gz+6YWP8jm8AA8kESS5UiZCddEfYDk5pYHmX09O6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KhsvfeWbCaC+9/EHsuWMWOJWQpgLDRweHEFbePbDnAg5QG13KpIgLtTUfhNPoxrJr
	 Ay/tiIC9ZxsA0p8sNzGTzghv8G5GVeJorj8dJEsPbCxEIR3U2PkD/0ZyLbgiyrdMDw
	 9RXB+9/aty9KtW62OrVX1d2ncoHRYlopQo1CtWFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.14 403/449] KVM: x86: Explicitly zero-initialize on-stack CPUID unions
Date: Thu, 17 Apr 2025 19:51:31 +0200
Message-ID: <20250417175134.489347050@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1423,8 +1423,8 @@ static inline int __do_cpuid_func(struct
 		}
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
-		union cpuid10_eax eax;
-		union cpuid10_edx edx;
+		union cpuid10_eax eax = { };
+		union cpuid10_edx edx = { };
 
 		if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
@@ -1440,8 +1440,6 @@ static inline int __do_cpuid_func(struct
 
 		if (kvm_pmu_cap.version)
 			edx.split.anythread_deprecated = 1;
-		edx.split.reserved1 = 0;
-		edx.split.reserved2 = 0;
 
 		entry->eax = eax.full;
 		entry->ebx = kvm_pmu_cap.events_mask;
@@ -1759,7 +1757,7 @@ static inline int __do_cpuid_func(struct
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
-		union cpuid_0x80000022_ebx ebx;
+		union cpuid_0x80000022_ebx ebx = { };
 
 		entry->ecx = entry->edx = 0;
 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {


