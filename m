Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 457E96FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:34:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BFD8CC433D2;
	Mon,  3 Apr 2023 14:34:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532458;
	bh=tZgnvcGJbNLHeW0x2kbUNHiYwG547kNTzcdD1A7Wj6s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zM/30+zxdmILdldM/46tKQAQI/CRFl5Ik9o0srYG4leD60BwD/Ow6JO1DRLWzi1pi
	 mK3+xhT7zeKzg/w3x5XqeVCl0YlSfYLhwAUfkSMUIQSgyn7IrV+sHN5J/MOu/Wdv4z
	 50WUTIMeiEroDE0XC+MKUmUGKfbRSML+G2O1k/h0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Orr <marcorr@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Subject: [PATCH 5.15 91/99] KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32
Date: Mon,  3 Apr 2023 16:09:54 +0200
Message-Id: <20230403140406.783567564@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140356.079638751@linuxfoundation.org>
References: <20230403140356.079638751@linuxfoundation.org>
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

commit ab52be1b310bcb39e6745d34a8f0e8475d67381a upstream.

Reject attempts to set bits 63:32 for 32-bit x2APIC registers, i.e. all
x2APIC registers except ICR.  Per Intel's SDM:

  Non-zero writes (by WRMSR instruction) to reserved bits to these
  registers will raise a general protection fault exception

Opportunistically fix a typo in a nearby comment.

Reported-by: Marc Orr <marcorr@google.com>
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20230107011025.565472-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Alejandro Jimenez <alejandro.j.jimenez@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2802,6 +2802,10 @@ int kvm_x2apic_msr_write(struct kvm_vcpu
 	/* if this is ICR write vector before command */
 	if (reg == APIC_ICR)
 		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	else if (data >> 32)
+		/* Bits 63:32 are reserved in all other registers. */
+		return 1;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 
@@ -2836,6 +2840,10 @@ int kvm_hv_vapic_msr_write(struct kvm_vc
 	/* if this is ICR write vector before command */
 	if (reg == APIC_ICR)
 		kvm_lapic_reg_write(apic, APIC_ICR2, (u32)(data >> 32));
+	else if (data >> 32)
+		/* Bits 63:32 are reserved in all other registers. */
+		return 1;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 


