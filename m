Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6A47BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:35:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6627BC433EF;
	Tue,  7 Mar 2023 18:35:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214115;
	bh=+T1Y5A8WfZ2IGuh3WNtzzvpPKCR07N1irvhFW7YwtYA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2Kb6gL0dQE1pv8da8wO+riesKimDW6/Wa6Ywi1Wv2CRX3/3D1G2370ua8/UcITGM
	 u9/iPpbQ1fyrImY5IOxDxGkhGKdvrGCYY/dA6J1v3GLn2+H0ze01PW/qDpHTyUcA+c
	 apqsxqpWDefIystl413KVwAQDvmw79dKPb2dPjUE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Orr <marcorr@google.com>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 726/885] KVM: x86: Inject #GP on x2APIC WRMSR that sets reserved bits 63:32
Date: Tue,  7 Mar 2023 18:01:00 +0100
Message-Id: <20230307170033.542224942@linuxfoundation.org>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2950,13 +2950,17 @@ static int kvm_lapic_msr_read(struct kvm
 static int kvm_lapic_msr_write(struct kvm_lapic *apic, u32 reg, u64 data)
 {
 	/*
-	 * ICR is a 64-bit register in x2APIC mode (and Hyper'v PV vAPIC) and
+	 * ICR is a 64-bit register in x2APIC mode (and Hyper-V PV vAPIC) and
 	 * can be written as such, all other registers remain accessible only
 	 * through 32-bit reads/writes.
 	 */
 	if (reg == APIC_ICR)
 		return kvm_x2apic_icr_write(apic, data);
 
+	/* Bits 63:32 are reserved in all other registers. */
+	if (data >> 32)
+		return 1;
+
 	return kvm_lapic_reg_write(apic, reg, (u32)data);
 }
 


