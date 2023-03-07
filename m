Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16BD6BA49
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 18:35:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E183C433EF;
	Tue,  7 Mar 2023 18:35:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678214112;
	bh=bBjjq0SmBxSSIZUiQzFJmaeYDdxmF6vncQeJHdCxfyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LmBgNv7+DygJKC8P990LVXTnJoCCs7nb6Cc+EnW3Y/7CifypGi6UPLBW+MNwcseGf
	 bAPBHxll65VcTf2gd/T3q/bKrIZG+kr/SsKSMXIQjhNmFKTsENSds11uFNRXDOwHjo
	 63rlezV48e9ELSeildhn+EMAYCcSbVOvIdQl/zKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Orr <marcorr@google.com>,
	Ben Gardon <bgardon@google.com>,
	Venkatesh Srinivas <venkateshs@chromium.org>,
	Maxim Levitsky <mlevitsk@redhat.com>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 6.1 725/885] KVM: x86: Inject #GP if WRMSR sets reserved bits in APIC Self-IPI
Date: Tue,  7 Mar 2023 18:00:59 +0100
Message-Id: <20230307170033.507441786@linuxfoundation.org>
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

commit ba5838abb05334e4abfdff1490585c7f365e0424 upstream.

Inject a #GP if the guest attempts to set reserved bits in the x2APIC-only
Self-IPI register.  Bits 7:0 hold the vector, all other bits are reserved.

Reported-by: Marc Orr <marcorr@google.com>
Cc: Ben Gardon <bgardon@google.com>
Cc: Venkatesh Srinivas <venkateshs@chromium.org>
Cc: stable@vger.kernel.org
Reviewed-by: Maxim Levitsky <mlevitsk@redhat.com>
Link: https://lore.kernel.org/r/20230107011025.565472-2-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/lapic.c |   10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

--- a/arch/x86/kvm/lapic.c
+++ b/arch/x86/kvm/lapic.c
@@ -2227,10 +2227,14 @@ static int kvm_lapic_reg_write(struct kv
 		break;
 
 	case APIC_SELF_IPI:
-		if (apic_x2apic_mode(apic))
-			kvm_apic_send_ipi(apic, APIC_DEST_SELF | (val & APIC_VECTOR_MASK), 0);
-		else
+		/*
+		 * Self-IPI exists only when x2APIC is enabled.  Bits 7:0 hold
+		 * the vector, everything else is reserved.
+		 */
+		if (!apic_x2apic_mode(apic) || (val & ~APIC_VECTOR_MASK))
 			ret = 1;
+		else
+			kvm_apic_send_ipi(apic, APIC_DEST_SELF | val, 0);
 		break;
 	default:
 		ret = 1;


