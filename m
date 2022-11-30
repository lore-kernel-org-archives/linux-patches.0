Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4777A79C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4CB5C433D6;
	Wed, 30 Nov 2022 18:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833609;
	bh=c+lE0ZZZLKJZ0rR6vUXkQsCX6ojb+cTTXxbcLNlDigQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pfFm43eyeI4EV9OL91jaApY7sh0Gt18f/rGM2Yimpq3CZPe9rOt3J7X7ImSbJA5Qd
	 ILXw/OPQiui5g2U+ZI4h2Af73J1nyz6/Z4e+/iuWstGT0VWogEPueVNovuy8XMp7PB
	 6AknRVVrQh7ikwvik6RtSO63YHOlLYzyV3EKODgU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 5.15 157/206] KVM: x86: forcibly leave nested mode on vCPU reset
Date: Wed, 30 Nov 2022 19:23:29 +0100
Message-Id: <20221130180537.028421738@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maxim Levitsky <mlevitsk@redhat.com>

commit ed129ec9057f89d615ba0c81a4984a90345a1684 upstream.

While not obivous, kvm_vcpu_reset() leaves the nested mode by clearing
'vcpu->arch.hflags' but it does so without all the required housekeeping.

On SVM,	it is possible to have a vCPU reset while in guest mode because
unlike VMX, on SVM, INIT's are not latched in SVM non root mode and in
addition to that L1 doesn't have to intercept triple fault, which should
also trigger L1's reset if happens in L2 while L1 didn't intercept it.

If one of the above conditions happen, KVM will	continue to use vmcb02
while not having in the guest mode.

Later the IA32_EFER will be cleared which will lead to freeing of the
nested guest state which will (correctly) free the vmcb02, but since
KVM still uses it (incorrectly) this will lead to a use after free
and kernel crash.

This issue is assigned CVE-2022-3344

Cc: stable@vger.kernel.org
Signed-off-by: Maxim Levitsky <mlevitsk@redhat.com>
Message-Id: <20221103141351.50662-5-mlevitsk@redhat.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/x86.c |   10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/arch/x86/kvm/x86.c
+++ b/arch/x86/kvm/x86.c
@@ -11111,8 +11111,18 @@ void kvm_vcpu_reset(struct kvm_vcpu *vcp
 	unsigned long new_cr0;
 	u32 eax, dummy;
 
+	/*
+	 * SVM doesn't unconditionally VM-Exit on INIT and SHUTDOWN, thus it's
+	 * possible to INIT the vCPU while L2 is active.  Force the vCPU back
+	 * into L1 as EFER.SVME is cleared on INIT (along with all other EFER
+	 * bits), i.e. virtualization is disabled.
+	 */
+	if (is_guest_mode(vcpu))
+		kvm_leave_nested(vcpu);
+
 	kvm_lapic_reset(vcpu, init_event);
 
+	WARN_ON_ONCE(is_guest_mode(vcpu) || is_smm(vcpu));
 	vcpu->arch.hflags = 0;
 
 	vcpu->arch.smi_pending = 0;


