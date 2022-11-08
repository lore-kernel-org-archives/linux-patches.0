Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 602EF15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:15:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D40E0C433C1;
	Tue,  8 Nov 2022 14:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916904;
	bh=GgxqAO/tZodUbANrCQ789Z3til62yVlDwK0nOcnCJEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2lAm2EHImcfwpfktCK8H1ca27eNTMrspopg6RHN1BcC/WHUKBhD9GkYO7oGoHT2hK
	 GSGct8Jm7tIIfwPFIhfP33yloyiOHNra3tFoihNhm9bOvKQAGtAvojY4Detq/yDZeJ
	 S/yQzcn7Qx8mKE10ZcfjHgo0IpbXGL6qsQjR5Mto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 170/197] KVM: x86: Mask off reserved bits in CPUID.80000006H
Date: Tue,  8 Nov 2022 14:40:08 +0100
Message-Id: <20221108133402.672887050@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133354.787209461@linuxfoundation.org>
References: <20221108133354.787209461@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jim Mattson <jmattson@google.com>

commit eeb69eab57c6604ac90b3fd8e5ac43f24a5535b1 upstream.

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. CPUID.80000006H:EDX[17:16] are reserved bits and
should be masked off.

Fixes: 43d05de2bee7 ("KVM: pass through CPUID(0x80000006)")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220929225203.2234702-2-jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1121,7 +1121,8 @@ static inline int __do_cpuid_func(struct
 		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
 		break;
 	case 0x80000006:
-		/* L2 cache and TLB: pass through host info. */
+		/* Drop reserved bits, pass host L2 cache and TLB info. */
+		entry->edx &= ~GENMASK(17, 16);
 		break;
 	case 0x80000007: /* Advanced power management */
 		/* invariant TSC is CPUID.80000007H:EDX[8] */


