Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2D723E025C;
	Mon, 17 Aug 2026 14:00:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786975245; cv=none; b=iSYl72EOPSC4F/kTBIsRLtxkqfuz4UjWZgApmYJMunQssf1AGPiAFki9gdtxyg76cRLcw06MdX7whrF1BBfJ+lqQZWY1PQaIKczaEQ5iPspBQVRq8eO7sf3GT+HJCreDET+199gcFfhYgDJ8HCiKs9plgKBO6+MTKIytnw3MAZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786975245; c=relaxed/simple;
	bh=+Tl8tp7zOPoDhdiMA8dO+G/NKjJHdV0D5xQs++S33GA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7NVmIiQxV95a16aDjKhk7HOMdNJ5tzG2GmzW9UngK+Eoe4L764BxyH9/xZPAXfXiwAwwA5QAVfunZkWihoaxq+bbhSL6vqBjWtPKEYwvSF+tDZsPAyR1KIcc48e5dynLLGNye5SYI3v2Xr7aAI1BXJIoAJy1/m8i4aIYPItgNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C6Zhd4x4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C6Zhd4x4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16FC71F000E9;
	Mon, 17 Aug 2026 14:00:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786975244;
	bh=IsAQEEetCwV0MYKKMIb688PINwTPUtiOA5r8flkyIgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C6Zhd4x489ZOXh0RVYSPDujAsqXvIyQ0qH2bHlomD0bBkjxSe/jfyqKjjl9kd7Ig0
	 JCqY2u+DBpSBvGSzZL6xtW4HDUM+JL0oSLmeb3EJn+dCFvWYH5qaHClfTrm9tXbD6e
	 QlERa6b+CZROcHVOwZqToMwAKqwecpYgxd1ggn7A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	"Borislav Petkov (AMD)" <bp@alien8.de>
Subject: [PATCH 6.18 213/250] x86/mce: Set up the polling timer before CMCI discovery
Date: Mon, 17 Aug 2026 15:32:54 +0200
Message-ID: <20260817132545.249804223@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Breno Leitao <leitao@debian.org>

commit a213dfaa2596c1c0dc4dae91c14fbfa499c03223 upstream.

I hit the following on one of my machines:

  mce: CPU0 BANK15 CMCI inherited storm
  ------------[ cut here ]------------
  ODEBUG: assert_init not available (active state 0) object: (____ptrval____) object type: timer_list hint: 0x0
  WARNING: lib/debugobjects.c:632 at debug_object_assert_init+0x178/0x230, CPU#0: swapper/0/0
  CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 7.2.0-rc5 #3 PREEMPTLAZY
  RIP: 0010:debug_object_assert_init+0x18f/0x230
  Call Trace:
   <TASK>
   __mod_timer
   mce_timer_kick
   cmci_discover
   intel_init_cmci
   mce_intel_feature_init
   mcheck_cpu_init
   identify_cpu
   identify_boot_cpu
   arch_cpu_finalize_init
   start_kernel

A second splat follows right after, from timer_setup() finding that same
timer already queued:

  ODEBUG: init active (active state 0) object: (____ptrval____) object type: timer_list hint: stub_timer+0x0/0x10

This is happening because CMCI storm detection is trying to modify the timer
before latter was properly set up.

Set up the timer first. __mcheck_cpu_setup_timer() only calls timer_setup(),
and depends on neither the generic nor the vendor init.

  [ bp: Massage commit message. ]

Fixes: 1f68ce2a0272 ("x86/mce: Handle Intel threshold interrupt storms")
Signed-off-by: Breno Leitao <leitao@debian.org>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260803-mce_timer_init-v1-1-9539db424330@debian.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/cpu/mce/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2236,10 +2236,10 @@ void mcheck_cpu_init(struct cpuinfo_x86
 
 	mca_cfg.initialized = 1;
 
+	__mcheck_cpu_setup_timer();
 	__mcheck_cpu_init_generic();
 	__mcheck_cpu_init_vendor(c);
 	__mcheck_cpu_init_prepare_banks();
-	__mcheck_cpu_setup_timer();
 	cr4_set_bits(X86_CR4_MCE);
 }
 


