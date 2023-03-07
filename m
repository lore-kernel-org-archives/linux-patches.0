Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21372BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:34:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B304C433D2;
	Tue,  7 Mar 2023 18:34:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214098;
	bh=rCZT13204XvcPLPk4GzSS/0ET62ntobqNzn48L4mZ+Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RHQjW4vBZf4EmtRNsYnozil9kwPJ2L36aw6n8toPSUwTx86XNtsra7LUwcApfpaYn
	 Iq9rmWOv0CxiAPnYtMJ9RyA/sbssAyq2ZdLImohgFWrLISALLtCiIWIrX3B5VGHaG1
	 Ufgin0hDUWmebRp0zGcRbqNyiqWZEWzOt1YQF/8c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.1 720/885] KVM: x86: Dont inhibit APICv/AVIC on xAPIC ID "change" if APIC is disabled
Date: Tue,  7 Mar 2023 18:00:54 +0100
Message-Id: <20230307170033.288986795@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170001.594919529@linuxfoundation.org>
References: <20230307170001.594919529@linuxfoundation.org>
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

commit a58a66afc464d6d2ec294cd3102f36f3652e7ce4 upstream.

Don't inhibit APICv/AVIC due to an xAPIC ID mismatch if the APIC is
hardware disabled.  The ID cannot be consumed while the APIC is disabled,
and the ID is guaranteed to be set back to the vcpu_id when the APIC is
hardware enabled (architectural behavior correctly emulated by KVM).

Fixes: 3743c2f02517 ("KVM: x86: inhibit APICv/AVIC on changes to APIC ID or APIC base")
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-Id: <20230106011306.85230-6-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2072,6 +2072,9 @@ static void kvm_lapic_xapic_id_updated(s
 {
 	struct kvm *kvm = apic->vcpu->kvm;
 
+	if (!kvm_apic_hw_enabled(apic))
+		return;
+
 	if (KVM_BUG_ON(apic_x2apic_mode(apic), kvm))
 		return;
 


