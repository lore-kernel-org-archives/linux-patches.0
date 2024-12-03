Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00C821F75AC;
	Tue,  3 Dec 2024 16:10:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242225; cv=none; b=V0aLvGrFcGw7SIqGs3zc/aUjAAsDcnRwgBWL5qjHt1klZadBJPEsCtwAmQZeI4ghXPHyHPBXvFLGkGMZ94eYq1siHbekNdlIbd/dGwKP/g9aq5akSrcuGWz2URWtO1nOh4NyZiOwSlz8iDgnrpEhkaaxnZZe/3qSvgu54X8omzs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242225; c=relaxed/simple;
	bh=WQLyL4cPxbTGi/OTGCtE9scf/5jrgdXJml20qbhKHok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nLbsylsYhvJpGGQTv9pzhbrdN7aSh3lobIVKjsRj3bpyeE4/IG8FRUVzYxhFGFZ23u7vScgptHXPXF1wWN02U9RIsCocIBv8qQXZI7FE7SRl00x9TUHq0To7BtafvCJnJv+ODg+71BxiO6NurVG/M3d6dqgJkSQHhI3sxuWmKHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EE0EAaMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EE0EAaMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15EB3C4CECF;
	Tue,  3 Dec 2024 16:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242224;
	bh=WQLyL4cPxbTGi/OTGCtE9scf/5jrgdXJml20qbhKHok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EE0EAaMsjVJ+sR4xVoLWANNJEQ0lrYWR8ix3LeCLSfrzkvpanRe1iSFJA1rvuGgtC
	 JwDga4e5SgdJ1QHXxGcOAZmBTEiczNV9msJ9vMbGzM7oY7+VCzI6zs+KWDTNX9p7E2
	 itBJ5M2Z7n45rdZSJixto+JKp0q0wXYmdKk9cQ8k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Sean Christopherson <seanjc@google.com>,
	Paolo Bonzini <pbonzini@redhat.com>
Subject: [PATCH 6.12 642/826] KVM: x86: add back X86_LOCAL_APIC dependency
Date: Tue,  3 Dec 2024 15:46:09 +0100
Message-ID: <20241203144808.793325198@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 1331343af6f502aecd274d522dd34bf7c965f484 upstream.

Enabling KVM now causes a build failure on x86-32 if X86_LOCAL_APIC
is disabled:

arch/x86/kvm/svm/svm.c: In function 'svm_emergency_disable_virtualization_cpu':
arch/x86/kvm/svm/svm.c:597:9: error: 'kvm_rebooting' undeclared (first use in this function); did you mean 'kvm_irq_routing'?
  597 |         kvm_rebooting = true;
      |         ^~~~~~~~~~~~~
      |         kvm_irq_routing
arch/x86/kvm/svm/svm.c:597:9: note: each undeclared identifier is reported only once for each function it appears in
make[6]: *** [scripts/Makefile.build:221: arch/x86/kvm/svm/svm.o] Error 1
In file included from include/linux/rculist.h:11,
                 from include/linux/hashtable.h:14,
                 from arch/x86/kvm/svm/avic.c:18:
arch/x86/kvm/svm/avic.c: In function 'avic_pi_update_irte':
arch/x86/kvm/svm/avic.c:909:38: error: 'struct kvm' has no member named 'irq_routing'
  909 |         irq_rt = srcu_dereference(kvm->irq_routing, &kvm->irq_srcu);
      |                                      ^~
include/linux/rcupdate.h:538:17: note: in definition of macro '__rcu_dereference_check'
  538 |         typeof(*p) *local = (typeof(*p) *__force)READ_ONCE(p); \

Move the dependency to the same place as before.

Fixes: ea4290d77bda ("KVM: x86: leave kvm.ko out of the build if no vendor module is requested")
Cc: stable@vger.kernel.org
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202410060426.e9Xsnkvi-lkp@intel.com/
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Sean Christopherson <seanjc@google.com>
[sean: add Cc to stable, tweak shortlog scope]
Signed-off-by: Sean Christopherson <seanjc@google.com>
Message-ID: <20241118172002.1633824-2-seanjc@google.com>
Signed-off-by: Paolo Bonzini <pbonzini@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kvm/Kconfig |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kvm/Kconfig
+++ b/arch/x86/kvm/Kconfig
@@ -19,7 +19,6 @@ if VIRTUALIZATION
 
 config KVM_X86
 	def_tristate KVM if KVM_INTEL || KVM_AMD
-	depends on X86_LOCAL_APIC
 	select KVM_COMMON
 	select KVM_GENERIC_MMU_NOTIFIER
 	select HAVE_KVM_IRQCHIP
@@ -50,6 +49,7 @@ config KVM_X86
 
 config KVM
 	tristate "Kernel-based Virtual Machine (KVM) support"
+	depends on X86_LOCAL_APIC
 	help
 	  Support hosting fully virtualized guest machines using hardware
 	  virtualization extensions.  You will need a fairly recent


