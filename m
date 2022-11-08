Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B476A15CAE
	for <patches@lists.linux.dev>; Tue,  8 Nov 2022 14:15:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B632C433C1;
	Tue,  8 Nov 2022 14:15:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667916915;
	bh=foHzr2f32ZTT8ecc6tY19n81TeiFZSJ/vA7AcEy3Fy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=w7+AlIxcgFer4QdwC0KteREe3uoYwd5GUlbP8uSg+r2sm43tw8MnwrQwKmDjH33om
	 S2KB/ZK8QQtD9Z279aKRSdjNURCb0paXK1G7v9KdxxkI8h8t2iB/tKvj3wG6vrF6mn
	 dyY7NPX7vb53iS8ELGpNQm1i2xdADyL2f4yxRGRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jim Mattson <jmattson@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.0 172/197] KVM: x86: Mask off reserved bits in CPUID.80000008H
Date: Tue,  8 Nov 2022 14:40:10 +0100
Message-Id: <20221108133402.762198250@linuxfoundation.org>
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

commit 7030d8530e533844e2f4b0e7476498afcd324634 upstream.

KVM_GET_SUPPORTED_CPUID should only enumerate features that KVM
actually supports. The following ranges of CPUID.80000008H are reserved
and should be masked off:
    ECX[31:18]
    ECX[11:8]

In addition, the PerfTscSize field at ECX[17:16] should also be zero
because KVM does not set the PERFTSC bit at CPUID.80000001H.ECX[27].

Fixes: 24c82e576b78 ("KVM: Sanitize cpuid")
Signed-off-by: Jim Mattson <jmattson@google.com>
Message-Id: <20220929225203.2234702-3-jmattson@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/cpuid.c |    1 +
 1 file changed, 1 insertion(+)

--- a/arch/x86/kvm/cpuid.c
+++ b/arch/x86/kvm/cpuid.c
@@ -1152,6 +1152,7 @@ static inline int __do_cpuid_func(struct
 			g_phys_as = phys_as;
 
 		entry->eax = g_phys_as | (virt_as << 8);
+		entry->ecx &= ~(GENMASK(31, 16) | GENMASK(11, 8));
 		entry->edx = 0;
 		cpuid_entry_override(entry, CPUID_8000_0008_EBX);
 		break;


