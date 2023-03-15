Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B10E4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:31:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F218C4339C;
	Wed, 15 Mar 2023 12:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678883512;
	bh=07NYLGJawFW259QlfQ/h3/9ExKNxMJaP24sNumloQ2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zu8BKpjMWPBGPHev2F49I7SRCxJvsQlGm1xrhfrB6pJc1LCiFMb4lhhGVgGFsCFjo
	 qoOFLpcvJ8A5bLw1LoMs0Eq08Xe9koYyQJqYqW/M+oPFVtsKW5/s+i7IJ/DC0PDuq4
	 rnWuePzSZ+K0cM2LRrJiv0yMklogrZ9VQHnqSajE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 027/143] KVM: VMX: Dont bother disabling eVMCS static key on module exit
Date: Wed, 15 Mar 2023 13:11:53 +0100
Message-Id: <20230315115741.334374554@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115740.429574234@linuxfoundation.org>
References: <20230315115740.429574234@linuxfoundation.org>
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

[ Upstream commit da66de44b01e9b7fa09731057593850394bf32e4 ]

Don't disable the eVMCS static key on module exit, kvm_intel.ko owns the
key so there can't possibly be users after the kvm_intel.ko is unloaded,
at least not without much bigger issues.

Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20221130230934.1014142-12-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Stable-dep-of: e32b120071ea ("KVM: VMX: Do _all_ initialization before exposing /dev/kvm to userspace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kvm/vmx/vmx.c | 4 ----
 1 file changed, 4 deletions(-)

diff --git a/arch/x86/kvm/vmx/vmx.c b/arch/x86/kvm/vmx/vmx.c
index 87874b22ba4bf..d3d84563a7f9c 100644
--- a/arch/x86/kvm/vmx/vmx.c
+++ b/arch/x86/kvm/vmx/vmx.c
@@ -8465,10 +8465,6 @@ static void vmx_exit(void)
 
 	kvm_exit();
 
-#if IS_ENABLED(CONFIG_HYPERV)
-	if (static_branch_unlikely(&enable_evmcs))
-		static_branch_disable(&enable_evmcs);
-#endif
 	vmx_cleanup_l1d_flush();
 
 	allow_smaller_maxphyaddr = false;
-- 
2.39.2



