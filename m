Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2496215CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E39FC433D6;
	Tue,  8 Nov 2022 14:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916315;
	bh=x4mi+LHmA+cJiFmv76uBODy4nLkFpuj1MSfFfvWwAcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8fu4oG2RFW8SXX+azfV55vojrh7FD9WxSJVjzX2lwjdp6o7HRITOX9X3SQJlBLrW
	 gEJ77RFtEfaIm/PsQFc1Tk7ABMTtfHaW6EA1udpTkOt0yz6kHcgMM994isuHakm1iZ
	 xolBvG8fglW45RS6Exw6mGstoIq8R2R4salFk5vw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 126/144] KVM: x86: Mask off reserved bits in CPUID.80000006H
Date: Tue,  8 Nov 2022 14:40:03 +0100
Message-Id: <20221108133350.603880996@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133345.346704162@linuxfoundation.org>
References: <20221108133345.346704162@linuxfoundation.org>
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
@@ -906,7 +906,8 @@ static inline int __do_cpuid_func(struct
 		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
 		break;
 	case 0x80000006:
-		/* L2 cache and TLB: pass through host info. */
+		/* Drop reserved bits, pass host L2 cache and TLB info. */
+		entry->edx &= ~GENMASK(17, 16);
 		break;
 	case 0x80000007: /* Advanced power management */
 		/* invariant TSC is CPUID.80000007H:EDX[8] */


