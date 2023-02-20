Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEB9463B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:50:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D958C433EF;
	Mon, 20 Feb 2023 13:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901009;
	bh=+iqTeL3cDJaa3hEzcRuZuEksB8evryCKe+Mu9Fp7Xdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0fbNyegFgam+BHrbR+tYrgDekR0A8GqLy1C1rPYn9RHe00BMdMjT/iAnqkP+b2DmH
	 QdW34t21oTn2RDCsNWpoYiKVIIY0zHI6bqAxZqCGPDyV0lkpJXYr76p3NcS0S3fcFZ
	 qsM4aW3jdxHPPZyR2X0d2sOreZPBOVJ3XA89XKCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	x86@kernel.org,
	"H. Peter Anvin" <hpa@zytor.com>,
	stable <stable@kernel.org>,
	Xingyuan Mo <hdthky0@gmail.com>
Subject: [PATCH 5.4 152/156] kvm: initialize all of the kvm_debugregs structure before sending it to userspace
Date: Mon, 20 Feb 2023 14:36:36 +0100
Message-Id: <20230220133609.003326741@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133602.515342638@linuxfoundation.org>
References: <20230220133602.515342638@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 2c10b61421a28e95a46ab489fd56c0f442ff6952 upstream.

When calling the KVM_GET_DEBUGREGS ioctl, on some configurations, there
might be some unitialized portions of the kvm_debugregs structure that
could be copied to userspace.  Prevent this as is done in the other kvm
ioctls, by setting the whole structure to 0 before copying anything into
it.

Bonus is that this reduces the lines of code as the explicit flag
setting and reserved space zeroing out can be removed.

Cc: Sean Christopherson <seanjc@google.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: <x86@kernel.org>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: stable <stable@kernel.org>
Reported-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Message-Id: <20230214103304.3689213-1-gregkh@linuxfoundation.org>
Tested-by: Xingyuan Mo <hdthky0@gmail.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -3948,12 +3948,11 @@ static void kvm_vcpu_ioctl_x86_get_debug
 {
 	unsigned long val;
 
+	memset(dbgregs, 0, sizeof(*dbgregs));
 	memcpy(dbgregs->db, vcpu->arch.db, sizeof(vcpu->arch.db));
 	kvm_get_dr(vcpu, 6, &val);
 	dbgregs->dr6 = val;
 	dbgregs->dr7 = vcpu->arch.dr7;
-	dbgregs->flags = 0;
-	memset(&dbgregs->reserved, 0, sizeof(dbgregs->reserved));
 }
 
 static int kvm_vcpu_ioctl_x86_set_debugregs(struct kvm_vcpu *vcpu,


