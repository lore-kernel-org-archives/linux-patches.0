Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4D51268685;
	Tue,  8 Apr 2025 11:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744110409; cv=none; b=VbmZ7+b+GFnjqq0z0q1eAMrNz7O+eIB4e8oJFoqcZkxI0/3Jwx5+LgILBqbr2HQeLmZxnENTqQEVlKzyX2pya5WW6I+p/jO6vN+InN9wOAANaxtYBAw8Q8wwwWsVDBJfZ2EOazsDX809FhI4vMSlBRxMkfVhATSk1e5DcSrNi8U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744110409; c=relaxed/simple;
	bh=4qAK8KTF2RDWE3tEx3EuDgp2+x5l2IzNctdi2usM1fQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HOwogTEjlrnO3r1dO0txnwAx7gUYnTeWuk50DgbI0ttAL1gqNlUR1S6McitjncygnLfLIC0RVt+Woci0IKi+E0yakuYgO/SuchnMQ2pgJgOZX3IOLorlZBr7Kt8DGilIAU2b/s3Ok6GO6z60jex6dFVb2D/yQoI9iO8UgWuGFsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AOPPZYA5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AOPPZYA5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 343A7C4CEE5;
	Tue,  8 Apr 2025 11:06:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744110409;
	bh=4qAK8KTF2RDWE3tEx3EuDgp2+x5l2IzNctdi2usM1fQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AOPPZYA5HgtEcM8fTUQHXmEYKzb9B2yPqpCCCCouV5pRo+2XVkfyuQ9A/eABBqQ6z
	 IQdFrG/5+93rjZm2xaK7s96oVtwfdRbsIivs3RgDoejC6T1MQdEEF59gLoyimba/Vl
	 NK/ojCdVHO8si8Vx4ZHXHbyg7Lj621gDH7+q/Is4=
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
Subject: [PATCH 6.14 054/731] x86/fpu/xstate: Fix inconsistencies in guest FPU xfeatures
Date: Tue,  8 Apr 2025 12:39:11 +0200
Message-ID: <20250408104915.528935403@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104914.247897328@linuxfoundation.org>
References: <20250408104914.247897328@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
index 36df548acc403..dcac3c058fb76 100644
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



