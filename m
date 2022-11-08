Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 218F315CAD
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 13:57:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C184C433C1;
	Tue,  8 Nov 2022 13:57:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667915838;
	bh=eZFcXq1mEV95v6XVAru3NKSe5vW+89S3YgamF/hjrMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EXoMkvj4oUZIbhQxril5q8VASMEZ/S3nZFIte8qoYzeYYULs012WA11lswJaU8w95
	 mlsXsKqJusO3YdnUb86z6aFukI+jmg31D3DaF9K6sV3TJhIob/nb4zRMnNqIyacSwI
	 kBLySrZYxeL+g4zK/C82RQFCzzJRu64wFhTSPAH8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.10 106/118] KVM: x86: Mask off reserved bits in CPUID.80000006H
Date: Tue,  8 Nov 2022 14:39:44 +0100
Message-Id: <20221108133345.334465759@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221108133340.718216105@linuxfoundation.org>
References: <20221108133340.718216105@linuxfoundation.org>
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
@@ -817,7 +817,8 @@ static inline int __do_cpuid_func(struct
 		cpuid_entry_override(entry, CPUID_8000_0001_ECX);
 		break;
 	case 0x80000006:
-		/* L2 cache and TLB: pass through host info. */
+		/* Drop reserved bits, pass host L2 cache and TLB info. */
+		entry->edx &= ~GENMASK(17, 16);
 		break;
 	case 0x80000007: /* Advanced power management */
 		/* invariant TSC is CPUID.80000007H:EDX[8] */


