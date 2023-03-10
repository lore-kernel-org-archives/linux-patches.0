Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 480548821
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 15:01:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0802C433EF;
	Fri, 10 Mar 2023 15:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678460503;
	bh=/RsfgpQpOMfrG0b4SIMUxFsDhiIl3mcTixF9pZJ25Q4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HrX0AQs6vLXE1NVa4wn7dQuXZMx0FX0rceVJ0+Jl2/ig9l98B3KOyDn8PqECVTXDg
	 W1wXKDX0WmdPKAw5XNaXhW1m/Y3NX/QEKIJVRBKNtOtbUGm+oH++GCt4n0bx3Iv32T
	 X5Cb3pYpHuPToSjaYMaP0bE7Wr01Pid1xlvBeyK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <Andrew.Cooper3@citrix.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.10 357/529] x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)
Date: Fri, 10 Mar 2023 14:38:20 +0100
Message-Id: <20230310133821.556255950@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133804.978589368@linuxfoundation.org>
References: <20230310133804.978589368@linuxfoundation.org>
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

commit 6a3236580b0b1accc3976345e723104f74f6f8e6 upstream.

Set GIF=1 prior to disabling SVM to ensure that INIT is recognized if the
kernel is disabling SVM in an emergency, e.g. if the kernel is about to
jump into a crash kernel or may reboot without doing a full CPU RESET.
If GIF is left cleared, the new kernel (or firmware) will be unabled to
awaken APs.  Eat faults on STGI (due to EFER.SVME=0) as it's possible
that SVM could be disabled via NMI shootdown between reading EFER.SVME
and executing STGI.

Link: https://lore.kernel.org/all/cbcb6f35-e5d7-c1c9-4db9-fe5cc4de579a@amd.com
Cc: stable@vger.kernel.org
Cc: Andrew Cooper <Andrew.Cooper3@citrix.com>
Cc: Tom Lendacky <thomas.lendacky@amd.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20221130233650.1404148-3-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/include/asm/virtext.h |   16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

--- a/arch/x86/include/asm/virtext.h
+++ b/arch/x86/include/asm/virtext.h
@@ -120,7 +120,21 @@ static inline void cpu_svm_disable(void)
 
 	wrmsrl(MSR_VM_HSAVE_PA, 0);
 	rdmsrl(MSR_EFER, efer);
-	wrmsrl(MSR_EFER, efer & ~EFER_SVME);
+	if (efer & EFER_SVME) {
+		/*
+		 * Force GIF=1 prior to disabling SVM to ensure INIT and NMI
+		 * aren't blocked, e.g. if a fatal error occurred between CLGI
+		 * and STGI.  Note, STGI may #UD if SVM is disabled from NMI
+		 * context between reading EFER and executing STGI.  In that
+		 * case, GIF must already be set, otherwise the NMI would have
+		 * been blocked, so just eat the fault.
+		 */
+		asm_volatile_goto("1: stgi\n\t"
+				  _ASM_EXTABLE(1b, %l[fault])
+				  ::: "memory" : fault);
+fault:
+		wrmsrl(MSR_EFER, efer & ~EFER_SVME);
+	}
 }
 
 /** Makes sure SVM is disabled, if it is supported on the CPU


