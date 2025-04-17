Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 554B71B4153;
	Thu, 17 Apr 2025 18:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744916105; cv=none; b=j2n5dOYd1PUp6YZv1M++b03mnSuFrT2xaKWmz5u17W5fWif5sztvHQAnQyBsWALvx6FfZmljdB6WSEfNqmPagLg937DIyOjJ9Jo9hmPPWwKSIUn+PkvH3KW34LZFd43Mi6oyKbkyiPfIjk4P0grH/CkjlJNxgjV5OJwME+azTew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744916105; c=relaxed/simple;
	bh=RpnTUqq+Xe6cs78fR7krYws5UQ7Zg54rFpVTJfptdYs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9oYdbK0xPwoAAUgRtISTulWrqMmY0OY0jj/9QpQ3GgoYsjtnvxtaiHoshz3OzyhCOE0FBs/Zd8PsS1itA90wB7/3aOQxXchD9PTTbgtugUsfcN7Zj+otQS2E6/SrRbg5DogICbYrOpEAdu6tWjvtPqNZfGDyvZRbtj9BahsqqY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nZPlL8m5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nZPlL8m5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE6C8C4CEE4;
	Thu, 17 Apr 2025 18:55:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744916105;
	bh=RpnTUqq+Xe6cs78fR7krYws5UQ7Zg54rFpVTJfptdYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nZPlL8m55OJF8Q/jlohzXBzOXaJPhHG50Nmgzy5EYy3dbGN/Ff11q+9TjG8Y6l7hi
	 Hqd+8JQRqa+Pw4fbOB+bV62BeSDEJnn+bug3LOTGdLXQ/SiNx2ziGBrmn3N3RbgV/k
	 DVlmR77kiavQcnRqQ/s2Bq5xWQbDTA7pKPVx4k20=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Jim Mattson <jmattson@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 344/393] KVM: x86: Explicitly zero-initialize on-stack CPUID unions
Date: Thu, 17 Apr 2025 19:52:33 +0200
Message-ID: <20250417175121.436940749@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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
@@ -1047,8 +1047,8 @@ static inline int __do_cpuid_func(struct
 		}
 		break;
 	case 0xa: { /* Architectural Performance Monitoring */
-		union cpuid10_eax eax;
-		union cpuid10_edx edx;
+		union cpuid10_eax eax = { };
+		union cpuid10_edx edx = { };
 
 		if (!enable_pmu || !static_cpu_has(X86_FEATURE_ARCH_PERFMON)) {
 			entry->eax = entry->ebx = entry->ecx = entry->edx = 0;
@@ -1064,8 +1064,6 @@ static inline int __do_cpuid_func(struct
 
 		if (kvm_pmu_cap.version)
 			edx.split.anythread_deprecated = 1;
-		edx.split.reserved1 = 0;
-		edx.split.reserved2 = 0;
 
 		entry->eax = eax.full;
 		entry->ebx = kvm_pmu_cap.events_mask;
@@ -1383,7 +1381,7 @@ static inline int __do_cpuid_func(struct
 		break;
 	/* AMD Extended Performance Monitoring and Debug */
 	case 0x80000022: {
-		union cpuid_0x80000022_ebx ebx;
+		union cpuid_0x80000022_ebx ebx = { };
 
 		entry->ecx = entry->edx = 0;
 		if (!enable_pmu || !kvm_cpu_cap_has(X86_FEATURE_PERFMON_V2)) {


