Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C6D4AD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:13:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16F53C433F0;
	Wed,  4 Jan 2023 16:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672848787;
	bh=HNHAXmBcubcvWn3+Ys9vdX8K2VWtpMxI/K9zX0VRouE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XMUkNmwuroXY87LkazER1c5M4JiwREEGEZpsNXTZ3zzySKNMYXL+SgNBjQ4vWCHEa
	 lxPH9hNyRlU14vVBXU6Is7l20SLomg6MXXaPSEn3QP9JSxpCnp8YSuZcYm1YkkmnhY
	 Yowm52wuCNHjwjYQdMt1Vfx0IqqK/IEYAIiAqxtY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kai Huang <kai.huang@intel.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 082/207] KVM: VMX: Resume guest immediately when injecting #GP on ECREATE
Date: Wed,  4 Jan 2023 17:05:40 +0100
Message-Id: <20230104160514.543129366@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160511.905925875@linuxfoundation.org>
References: <20230104160511.905925875@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sean Christopherson <seanjc@google.com>

commit eb3992e833d3a17f9b0a3e0371d0b1d3d566f740 upstream.

Resume the guest immediately when injecting a #GP on ECREATE due to an
invalid enclave size, i.e. don't attempt ECREATE in the host.  The #GP is
a terminal fault, e.g. skipping the instruction if ECREATE is successful
would result in KVM injecting #GP on the instruction following ECREATE.

Fixes: 70210c044b4e ("KVM: VMX: Add SGX ENCLS[ECREATE] handler to enforce CPUID restrictions")
Cc: stable@vger.kernel.org
Cc: Kai Huang <kai.huang@intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Kai Huang <kai.huang@intel.com>
Link: https://lore.kernel.org/r/20220930233132.1723330-1-seanjc@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/vmx/sgx.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/vmx/sgx.c
+++ b/arch/x86/kvm/vmx/sgx.c
@@ -182,8 +182,10 @@ static int __handle_encls_ecreate(struct
 	/* Enforce CPUID restriction on max enclave size. */
 	max_size_log2 = (attributes & SGX_ATTR_MODE64BIT) ? sgx_12_0->edx >> 8 :
 							    sgx_12_0->edx;
-	if (size >= BIT_ULL(max_size_log2))
+	if (size >= BIT_ULL(max_size_log2)) {
 		kvm_inject_gp(vcpu, 0);
+		return 1;
+	}
 
 	/*
 	 * sgx_virt_ecreate() returns:


