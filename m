Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EDBB15A492;
	Mon, 29 Jan 2024 17:08:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548120; cv=none; b=NzpvKQB64T8QcBTC6N8jS9oofuF3coVN/+uyB4K7yu/w04yJkKq7Q+dpyqEXIZks+Il0albM5nOq+mzBPwPyFGKk39wVQLqnFQPttv7idaaM8xz5kqkQKkghEZgk6OEbIXr4yQnMBJnrqTzMPVGwnU4YTDX9u2bchDKgw/52ThU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548120; c=relaxed/simple;
	bh=fNu3ysiapNN2+ocQk10iX5V7JYtEtW3YySBjxE1EDhQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c52A1bDg1AllSrfdLuDLXFu+oJrS832kXMBu8TU/QENpImZjw3sCSUKTReZqnb92V20cxngY24UGg+mx74c9bgVRd0NiIU/RNZNMCj5rh+OnO6pZMjjSYokWgjdQl1fAPLiCo9ILWvffXZEhztroU7GDj7qBivZSXmLG61NnZGY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aDGH9hVZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aDGH9hVZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4CD3C433F1;
	Mon, 29 Jan 2024 17:08:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548119;
	bh=fNu3ysiapNN2+ocQk10iX5V7JYtEtW3YySBjxE1EDhQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aDGH9hVZGZ3x2xZVNpPcxSpUghcrD06TyjLi9g4039M8vRm/7a3ylWRNZcK3uhVR3
	 1k1AYWnwm6JsWu+RvnutH8bx3bbkzuK8UlUQWsa4y2eXsdYjcGuDRTPrMXmlZISuei
	 6UwZRIJSsCt2sEIMZknqdEynZ3rpghGwwEzZYkq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Gowans <jgowans@amazon.com>,
	Baoquan He <bhe@redhat.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	Marc Zyngier <maz@kernel.org>,
	Arnd Bergmann <arnd@arndb.de>,
	Tony Luck <tony.luck@intel.com>,
	Borislav Petkov <bp@alien8.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@redhat.com>,
	Chen-Yu Tsai <wens@csie.org>,
	Jernej Skrabec <jernej.skrabec@gmail.com>,
	Samuel Holland <samuel@sholland.org>,
	Pavel Machek <pavel@ucw.cz>,
	Sebastian Reichel <sre@kernel.org>,
	Orson Zhai <orsonzhai@gmail.com>,
	Alexander Graf <graf@amazon.de>,
	"Jan H. Schoenherr" <jschoenh@amazon.de>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.7 121/346] kexec: do syscore_shutdown() in kernel_kexec
Date: Mon, 29 Jan 2024 09:02:32 -0800
Message-ID: <20240129170019.946265686@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: James Gowans <jgowans@amazon.com>

commit 7bb943806ff61e83ae4cceef8906b7fe52453e8a upstream.

syscore_shutdown() runs driver and module callbacks to get the system into
a state where it can be correctly shut down.  In commit 6f389a8f1dd2 ("PM
/ reboot: call syscore_shutdown() after disable_nonboot_cpus()")
syscore_shutdown() was removed from kernel_restart_prepare() and hence got
(incorrectly?) removed from the kexec flow.  This was innocuous until
commit 6735150b6997 ("KVM: Use syscore_ops instead of reboot_notifier to
hook restart/shutdown") changed the way that KVM registered its shutdown
callbacks, switching from reboot notifiers to syscore_ops.shutdown.  As
syscore_shutdown() is missing from kexec, KVM's shutdown hook is not run
and virtualisation is left enabled on the boot CPU which results in triple
faults when switching to the new kernel on Intel x86 VT-x with VMXE
enabled.

Fix this by adding syscore_shutdown() to the kexec sequence.  In terms of
where to add it, it is being added after migrating the kexec task to the
boot CPU, but before APs are shut down.  It is not totally clear if this
is the best place: in commit 6f389a8f1dd2 ("PM / reboot: call
syscore_shutdown() after disable_nonboot_cpus()") it is stated that
"syscore_ops operations should be carried with one CPU on-line and
interrupts disabled." APs are only offlined later in machine_shutdown(),
so this syscore_shutdown() is being run while APs are still online.  This
seems to be the correct place as it matches where syscore_shutdown() is
run in the reboot and halt flows - they also run it before APs are shut
down.  The assumption is that the commit message in commit 6f389a8f1dd2
("PM / reboot: call syscore_shutdown() after disable_nonboot_cpus()") is
no longer valid.

KVM has been discussed here as it is what broke loudly by not having
syscore_shutdown() in kexec, but this change impacts more than just KVM;
all drivers/modules which register a syscore_ops.shutdown callback will
now be invoked in the kexec flow.  Looking at some of them like x86 MCE it
is probably more correct to also shut these down during kexec.
Maintainers of all drivers which use syscore_ops.shutdown are added on CC
for visibility.  They are:

arch/powerpc/platforms/cell/spu_base.c  .shutdown = spu_shutdown,
arch/x86/kernel/cpu/mce/core.c	        .shutdown = mce_syscore_shutdown,
arch/x86/kernel/i8259.c                 .shutdown = i8259A_shutdown,
drivers/irqchip/irq-i8259.c	        .shutdown = i8259A_shutdown,
drivers/irqchip/irq-sun6i-r.c	        .shutdown = sun6i_r_intc_shutdown,
drivers/leds/trigger/ledtrig-cpu.c	.shutdown = ledtrig_cpu_syscore_shutdown,
drivers/power/reset/sc27xx-poweroff.c	.shutdown = sc27xx_poweroff_shutdown,
kernel/irq/generic-chip.c	        .shutdown = irq_gc_shutdown,
virt/kvm/kvm_main.c	                .shutdown = kvm_shutdown,

This has been tested by doing a kexec on x86_64 and aarch64.

Link: https://lkml.kernel.org/r/20231213064004.2419447-1-jgowans@amazon.com
Fixes: 6735150b6997 ("KVM: Use syscore_ops instead of reboot_notifier to hook restart/shutdown")
Signed-off-by: James Gowans <jgowans@amazon.com>
Cc: Baoquan He <bhe@redhat.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Marc Zyngier <maz@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Chen-Yu Tsai <wens@csie.org>
Cc: Jernej Skrabec <jernej.skrabec@gmail.com>
Cc: Samuel Holland <samuel@sholland.org>
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Sebastian Reichel <sre@kernel.org>
Cc: Orson Zhai <orsonzhai@gmail.com>
Cc: Alexander Graf <graf@amazon.de>
Cc: Jan H. Schoenherr <jschoenh@amazon.de>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kexec_core.c |    1 +
 1 file changed, 1 insertion(+)

--- a/kernel/kexec_core.c
+++ b/kernel/kexec_core.c
@@ -1254,6 +1254,7 @@ int kernel_kexec(void)
 		kexec_in_progress = true;
 		kernel_restart_prepare("kexec reboot");
 		migrate_to_reboot_cpu();
+		syscore_shutdown();
 
 		/*
 		 * migrate_to_reboot_cpu() disables CPU hotplug assuming that


