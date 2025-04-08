Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 662462698BE;
	Tue,  8 Apr 2025 11:51:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744113090; cv=none; b=mLHlSjdxESw2awuDkIP7/6u6BqfQxJ4mKRGYxMP7eVfIHMq9hnnwIrcaT/7j20jSrlrPy48MeptLP7yNM4RbXyhj5S+pqfxKmDPVkr0j8VLcgxxsCetuqgICeH2qRvI/CYe7xxIHSHbciXbZhADEYfNXziWrh92+PNpvAWPIvbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744113090; c=relaxed/simple;
	bh=yO5PRmpTHrPnPF7Eaps0Prm2n15iHpSmiKIhZXiPiZw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BZ6OZ4VE01rrnWT21iiJKZaylhfw9FDWSZk8+TeBMFL76MqNxeypvnP6nINsf8DkKOEz460fQcN4h5fCGB5QfvMSiMs4FlEKbcEGD+XRzJydS7/wPLBy/UcN602ZgIyGxxcYGT+4FFZLjZWkDI5a5CwbEJlS1orv41l8ERVo+80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xenm+82u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xenm+82u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64592C4CEE5;
	Tue,  8 Apr 2025 11:51:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744113089;
	bh=yO5PRmpTHrPnPF7Eaps0Prm2n15iHpSmiKIhZXiPiZw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xenm+82uo4wO7ct5rvmgtudMXl6QpoNLeTSkf+Pc3p5wSOptSPElt0TrqyVPHQUdO
	 /HtCV+jNqsFXz5+Xvq9QSDDzm5h2O1z0u0yYkB5xJ+bmwhZXfr+qqI9dgWZcCBNaQE
	 ox7T58/cZfU861eM3F+t1Oo1neW6ruV9/OS3Xe5M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Chao Gao <chao.gao@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Juergen Gross <jgross@suse.com>,
	Stefano Stabellini <sstabellini@kernel.org>,
	Paolo Bonzini <pbonzini@redhat.com>,
	Vitaly Kuznetsov <vkuznets@redhat.com>,
	Sean Christopherson <seanjc@google.com>,
	David Woodhouse <dwmw2@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/268] x86/fpu/xstate: Fix inconsistencies in guest FPU xfeatures
Date: Tue,  8 Apr 2025 12:47:14 +0200
Message-ID: <20250408104829.132596608@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104828.499967190@linuxfoundation.org>
References: <20250408104828.499967190@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chao Gao <chao.gao@intel.com>

[ Upstream commit dda366083e5ff307a4a728757db874bbfe7550be ]

Guest FPUs manage vCPU FPU states. They are allocated via
fpu_alloc_guest_fpstate() and are resized in fpstate_realloc() when XFD
features are enabled.

Since the introduction of guest FPUs, there have been inconsistencies in
the kernel buffer size and xfeatures:

 1. fpu_alloc_guest_fpstate() uses fpu_user_cfg since its introduction. See:

    69f6ed1d14c6 ("x86/fpu: Provide infrastructure for KVM FPU cleanup")
    36487e6228c4 ("x86/fpu: Prepare guest FPU for dynamically enabled FPU features")

 2. __fpstate_reset() references fpu_kernel_cfg to set storage attributes.

 3. fpu->guest_perm uses fpu_kernel_cfg, affecting fpstate_realloc().

A recent commit in the tip:x86/fpu tree partially addressed the inconsistency
between (1) and (3) by using fpu_kernel_cfg for size calculation in (1),
but left fpu_guest->xfeatures and fpu_guest->perm still referencing
fpu_user_cfg:

  https://lore.kernel.org/all/20250218141045.85201-1-stanspas@amazon.de/

  1937e18cc3cf ("x86/fpu: Fix guest FPU state buffer allocation size")

The inconsistencies within fpu_alloc_guest_fpstate() and across the
mentioned functions cause confusion.

Fix them by using fpu_kernel_cfg consistently in fpu_alloc_guest_fpstate(),
except for fields related to the UABI buffer. Referencing fpu_kernel_cfg
won't impact functionalities, as:

 1. fpu_guest->perm is overwritten shortly in fpu_init_guest_permissions()
    with fpstate->guest_perm, which already uses fpu_kernel_cfg.

 2. fpu_guest->xfeatures is solely used to check if XFD features are enabled.
    Including supervisor xfeatures doesn't affect the check.

Fixes: 36487e6228c4 ("x86/fpu: Prepare guest FPU for dynamically enabled FPU features")
Suggested-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Chao Gao <chao.gao@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Juergen Gross <jgross@suse.com>
Cc: Stefano Stabellini <sstabellini@kernel.org>
Cc: Paolo Bonzini <pbonzini@redhat.com>
Cc: Vitaly Kuznetsov <vkuznets@redhat.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: David Woodhouse <dwmw2@infradead.org>
Link: https://lore.kernel.org/r/20250317140613.1761633-1-chao.gao@intel.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/arch/x86/kernel/fpu/core.c b/arch/x86/kernel/fpu/core.c
index db200990b5569..aaed20f46be4c 100644
--- a/arch/x86/kernel/fpu/core.c
+++ b/arch/x86/kernel/fpu/core.c
@@ -232,8 +232,8 @@ bool fpu_alloc_guest_fpstate(struct fpu_guest *gfpu)
 	fpstate->is_guest	= true;
 
 	gfpu->fpstate		= fpstate;
-	gfpu->xfeatures		= fpu_user_cfg.default_features;
-	gfpu->perm		= fpu_user_cfg.default_features;
+	gfpu->xfeatures		= fpu_kernel_cfg.default_features;
+	gfpu->perm		= fpu_kernel_cfg.default_features;
 
 	/*
 	 * KVM sets the FP+SSE bits in the XSAVE header when copying FPU state
-- 
2.39.5



