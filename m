Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC33D8494
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:37:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C0761C4339C;
	Fri, 10 Mar 2023 14:37:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678459064;
	bh=Vd1WY7foecc0NvYcs5ng13i2Z1ilVHa1TFjBbMJPjug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ddLIK56tjIDZaFx8guJCWMpkGd83b03fwJ6bfA+B/RL9TGyMPrXUa6QsTT0eR+/qS
	 0ZRfHDNZygPeIWWZEsotqBQaawNa33bW3iSFMRFCOl9RvaSbqjt1Y5aemArqj4yrP+
	 yIvCH1X5nKW0daYjKYhPzzu6Wovj5m/EpLcKKSu8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Sean Christopherson <seanjc@google.com>
Subject: [PATCH 5.4 236/357] x86/reboot: Disable SVM, not just VMX, when stopping CPUs
Date: Fri, 10 Mar 2023 14:38:45 +0100
Message-Id: <20230310133745.158360857@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133733.973883071@linuxfoundation.org>
References: <20230310133733.973883071@linuxfoundation.org>
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

commit a2b07fa7b93321c059af0c6d492cc9a4f1e390aa upstream.

Disable SVM and more importantly force GIF=1 when halting a CPU or
rebooting the machine.  Similar to VMX, SVM allows software to block
INITs via CLGI, and thus can be problematic for a crash/reboot.  The
window for failure is smaller with SVM as INIT is only blocked while
GIF=0, i.e. between CLGI and STGI, but the window does exist.

Fixes: fba4f472b33a ("x86/reboot: Turn off KVM when halting a CPU")
Cc: stable@vger.kernel.org
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20221130233650.1404148-5-seanjc@google.com
Signed-off-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/smp.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/arch/x86/kernel/smp.c
+++ b/arch/x86/kernel/smp.c
@@ -31,7 +31,7 @@
 #include <asm/mce.h>
 #include <asm/trace/irq_vectors.h>
 #include <asm/kexec.h>
-#include <asm/virtext.h>
+#include <asm/reboot.h>
 
 /*
  *	Some notes on x86 processor bugs affecting SMP operation:
@@ -121,7 +121,7 @@ static int smp_stop_nmi_callback(unsigne
 	if (raw_smp_processor_id() == atomic_read(&stopping_cpu))
 		return NMI_HANDLED;
 
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 
 	return NMI_HANDLED;
@@ -134,7 +134,7 @@ static int smp_stop_nmi_callback(unsigne
 asmlinkage __visible void smp_reboot_interrupt(void)
 {
 	ipi_entering_ack_irq();
-	cpu_emergency_vmxoff();
+	cpu_emergency_disable_virtualization();
 	stop_this_cpu(NULL);
 	irq_exit();
 }


