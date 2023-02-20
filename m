Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6353F63B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:41:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1FDC433D2;
	Mon, 20 Feb 2023 13:41:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676900508;
	bh=h4TouaqaRVhHXSxgxA+VwQ4JlQtxe0goMILlS6sE13U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2VCC1ypFEFlSC2CtVOf1kc+WT2u3HjcqKfPlA9KjSof4C/cDdk7kjNngZsyQ8XC79
	 nHnhe9q7+GMyohwjJEOyD6vq56ugplm3g3Fj+laYienaYUUwlbOZmFmdo6qc2u1YOe
	 NzUS/Tu4P3uLiLmAGbQ0QrB5T/HRlDfAaI5W0b+I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <sean.j.christopherson@intel.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 23/89] KVM: VMX: Move caching of MSR_IA32_XSS to hardware_setup()
Date: Mon, 20 Feb 2023 14:35:22 +0100
Message-Id: <20230220133553.985538065@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133553.066768704@linuxfoundation.org>
References: <20230220133553.066768704@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <sean.j.christopherson@intel.com>

[ Upstream commit 71d9409e20934e16f2d2ea88f0d1fb9851a7da3b ]

MSR_IA32_XSS has no relation to the VMCS whatsoever, it doesn't belong
in setup_vmcs_config() and its reference to host_xss prevents moving
setup_vmcs_config() to a dedicated file.

Signed-off-by: Sean Christopherson <sean.j.christopherson@intel.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: a44b331614e6 ("KVM: x86/vmx: Do not skip segment attributes if unusable bit is set")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index f8ad29968e85..5c4d2758b1d9 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -4740,9 +4740,6 @@ static __init int setup_vmcs_config(struct vmcs_config *vmcs_conf)
 		}
 	}
 
-	if (boot_cpu_has(X86_FEATURE_XSAVES))
-		rdmsrl(MSR_IA32_XSS, host_xss);
-
 	return 0;
 }
 
@@ -7957,6 +7954,9 @@ static __init int hardware_setup(void)
 		WARN_ONCE(host_bndcfgs, "KVM: BNDCFGS in host will be lost");
 	}
 
+	if (boot_cpu_has(X86_FEATURE_XSAVES))
+		rdmsrl(MSR_IA32_XSS, host_xss);
+
 	if (!cpu_has_vmx_vpid() || !cpu_has_vmx_invvpid() ||
 		!(cpu_has_vmx_invvpid_single() || cpu_has_vmx_invvpid_global()))
 		enable_vpid = 0;
-- 
2.39.0



