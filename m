Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9008F847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:49:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 059E5C433D2;
	Fri, 10 Mar 2023 13:49:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456188;
	bh=s7/xobAQRrsurvzSjHrXxO+rqxzENtSff3QKSZbLo/Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LhELsoPfhbXT8K26e9gFJ9BovHs6IixZQpHZiY6fERQ/WF1cfWV16VmHa0JmaiUsa
	 CNh+qGGONMZYcFCE4BOk6lOzfPoTkv0aPpUmWE+o4OgPH6qmWUVuBXB7fK7P3cfoY+
	 22mWlcVJl1RyZ5715srUC4r4qLRGErbqUkNml55M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Cooper <Andrew.Cooper3@citrix.com>,
	Tom Lendacky <thomas.lendacky@amd.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 4.14 111/193] x86/virt: Force GIF=1 prior to disabling SVM (for reboot flows)
Date: Fri, 10 Mar 2023 14:38:13 +0100
Message-Id: <20230310133714.985122172@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
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
@@ -114,7 +114,21 @@ static inline void cpu_svm_disable(void)
 
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


