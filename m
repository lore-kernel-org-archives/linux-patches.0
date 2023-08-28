Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EC9469F
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:33:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 594C9C433C8;
	Mon, 28 Aug 2023 10:33:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693218819;
	bh=9WZj/MZdB7nEYAZxzOQ9a6hmYg4FGBlsZLrZu7/kDfI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JW9dBc5YM29G+XDDy04pcnZGqiNtwpysuabIvwUEmvOYWUxDYQJxELESKAFgSv1Od
	 OZ9i4V0h+QvHi3+u06kPRaR5E2cHzPDZDOh9NSqWdP7iDN2x2bGCV0eEOY/dLBSmYF
	 AMQlw1Q+0PxMFJAHyPeulonluzmoGclNcweRDnXY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Feng Tang <feng.tang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.1 096/122] x86/fpu: Set X86_FEATURE_OSXSAVE feature after enabling OSXSAVE in CR4
Date: Mon, 28 Aug 2023 12:13:31 +0200
Message-ID: <20230828101159.586915333@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101156.480754469@linuxfoundation.org>
References: <20230828101156.480754469@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Tang <feng.tang@intel.com>

commit 2c66ca3949dc701da7f4c9407f2140ae425683a5 upstream.

0-Day found a 34.6% regression in stress-ng's 'af-alg' test case, and
bisected it to commit b81fac906a8f ("x86/fpu: Move FPU initialization into
arch_cpu_finalize_init()"), which optimizes the FPU init order, and moves
the CR4_OSXSAVE enabling into a later place:

   arch_cpu_finalize_init
       identify_boot_cpu
	   identify_cpu
	       generic_identify
                   get_cpu_cap --> setup cpu capability
       ...
       fpu__init_cpu
           fpu__init_cpu_xstate
               cr4_set_bits(X86_CR4_OSXSAVE);

As the FPU is not yet initialized the CPU capability setup fails to set
X86_FEATURE_OSXSAVE. Many security module like 'camellia_aesni_avx_x86_64'
depend on this feature and therefore fail to load, causing the regression.

Cure this by setting X86_FEATURE_OSXSAVE feature right after OSXSAVE
enabling.

[ tglx: Moved it into the actual BSP FPU initialization code and added a comment ]

Fixes: b81fac906a8f ("x86/fpu: Move FPU initialization into arch_cpu_finalize_init()")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Feng Tang <feng.tang@intel.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/lkml/202307192135.203ac24e-oliver.sang@intel.com
Link: https://lore.kernel.org/lkml/20230823065747.92257-1-feng.tang@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/xstate.c |    7 +++++++
 1 file changed, 7 insertions(+)

--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -882,6 +882,13 @@ void __init fpu__init_system_xstate(unsi
 		goto out_disable;
 	}
 
+	/*
+	 * CPU capabilities initialization runs before FPU init. So
+	 * X86_FEATURE_OSXSAVE is not set. Now that XSAVE is completely
+	 * functional, set the feature bit so depending code works.
+	 */
+	setup_force_cpu_cap(X86_FEATURE_OSXSAVE);
+
 	print_xstate_offset_size();
 	pr_info("x86/fpu: Enabled xstate features 0x%llx, context size is %d bytes, using '%s' format.\n",
 		fpu_kernel_cfg.max_features,


