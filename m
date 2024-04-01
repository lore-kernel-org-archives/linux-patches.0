Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404721CA8F;
	Mon,  1 Apr 2024 16:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711987375; cv=none; b=FpotCwor5Ncd4dEf3+HfgJo3t6PlZoyT281ze+qOGuDn3E4CL6eVkNvAcjYyC2PZfSkTXOx31NMCqIdDt1q0DJGoimQ39rnXvwOGcQlofqdBGP9GfZ9kkQW5U/XXtBn3TD3uBQWPvniTLahwX2djp04rXW6BdpXoGuhUCO4RR4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711987375; c=relaxed/simple;
	bh=FHmuL/LWoQKOkzasEmsfHUvRUfVJeGYFgGmLGZtoiC8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA0EfxrJ1hT76iEvdiMVe4DEu7SJEKVi6trGcIrqOizelmHhvhkVIrkmMx66TAs0GMXrCDbZQf0Zr0+pWWyeB1Lc4iZDct/qv7+kmWpVctchVm5s5ntlNWWGG5wtnKkOSa7qtFv+DSD9gWx0IcYocA8jsaQjptQ7eXteuqP7wGg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQUJ+yD0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQUJ+yD0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A253EC433C7;
	Mon,  1 Apr 2024 16:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711987375;
	bh=FHmuL/LWoQKOkzasEmsfHUvRUfVJeGYFgGmLGZtoiC8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQUJ+yD0XxoNVIUkUuebDjRprKisfiSXRzPRfdJzSxIN/WWePspcJMrBwP/86Bguh
	 0wylPd6q+9BYYyy4hF7E018HCTx0eSceikOqIVkMZ1P1x63UKMBZunRG7t9wH5hx8h
	 6iRpgVTTStOx3SqFQ1fufffagylQ5pbM97OCy6vg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adamos Ttofari <attofari@amazon.de>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.8 269/399] x86/fpu: Keep xfd_state in sync with MSR_IA32_XFD
Date: Mon,  1 Apr 2024 17:43:55 +0200
Message-ID: <20240401152557.215474850@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152549.131030308@linuxfoundation.org>
References: <20240401152549.131030308@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Adamos Ttofari <attofari@amazon.de>

[ Upstream commit 10e4b5166df9ff7a2d5316138ca668b42d004422 ]

Commit 672365477ae8 ("x86/fpu: Update XFD state where required") and
commit 8bf26758ca96 ("x86/fpu: Add XFD state to fpstate") introduced a
per CPU variable xfd_state to keep the MSR_IA32_XFD value cached, in
order to avoid unnecessary writes to the MSR.

On CPU hotplug MSR_IA32_XFD is reset to the init_fpstate.xfd, which
wipes out any stale state. But the per CPU cached xfd value is not
reset, which brings them out of sync.

As a consequence a subsequent xfd_update_state() might fail to update
the MSR which in turn can result in XRSTOR raising a #NM in kernel
space, which crashes the kernel.

To fix this, introduce xfd_set_state() to write xfd_state together
with MSR_IA32_XFD, and use it in all places that set MSR_IA32_XFD.

Fixes: 672365477ae8 ("x86/fpu: Update XFD state where required")
Signed-off-by: Adamos Ttofari <attofari@amazon.de>
Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20240322230439.456571-1-chang.seok.bae@intel.com

Closes: https://lore.kernel.org/lkml/20230511152818.13839-1-attofari@amazon.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/xstate.c |  5 +++--
 arch/x86/kernel/fpu/xstate.h | 14 ++++++++++----
 2 files changed, 13 insertions(+), 6 deletions(-)

diff --git a/arch/x86/kernel/fpu/xstate.c b/arch/x86/kernel/fpu/xstate.c
index 117e74c44e756..33a214b1a4cec 100644
--- a/arch/x86/kernel/fpu/xstate.c
+++ b/arch/x86/kernel/fpu/xstate.c
@@ -178,10 +178,11 @@ void fpu__init_cpu_xstate(void)
 	 * Must happen after CR4 setup and before xsetbv() to allow KVM
 	 * lazy passthrough.  Write independent of the dynamic state static
 	 * key as that does not work on the boot CPU. This also ensures
-	 * that any stale state is wiped out from XFD.
+	 * that any stale state is wiped out from XFD. Reset the per CPU
+	 * xfd cache too.
 	 */
 	if (cpu_feature_enabled(X86_FEATURE_XFD))
-		wrmsrl(MSR_IA32_XFD, init_fpstate.xfd);
+		xfd_set_state(init_fpstate.xfd);
 
 	/*
 	 * XCR_XFEATURE_ENABLED_MASK (aka. XCR0) sets user features
diff --git a/arch/x86/kernel/fpu/xstate.h b/arch/x86/kernel/fpu/xstate.h
index 3518fb26d06b0..19ca623ffa2ac 100644
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -148,20 +148,26 @@ static inline void xfd_validate_state(struct fpstate *fpstate, u64 mask, bool rs
 #endif
 
 #ifdef CONFIG_X86_64
+static inline void xfd_set_state(u64 xfd)
+{
+	wrmsrl(MSR_IA32_XFD, xfd);
+	__this_cpu_write(xfd_state, xfd);
+}
+
 static inline void xfd_update_state(struct fpstate *fpstate)
 {
 	if (fpu_state_size_dynamic()) {
 		u64 xfd = fpstate->xfd;
 
-		if (__this_cpu_read(xfd_state) != xfd) {
-			wrmsrl(MSR_IA32_XFD, xfd);
-			__this_cpu_write(xfd_state, xfd);
-		}
+		if (__this_cpu_read(xfd_state) != xfd)
+			xfd_set_state(xfd);
 	}
 }
 
 extern int __xfd_enable_feature(u64 which, struct fpu_guest *guest_fpu);
 #else
+static inline void xfd_set_state(u64 xfd) { }
+
 static inline void xfd_update_state(struct fpstate *fpstate) { }
 
 static inline int __xfd_enable_feature(u64 which, struct fpu_guest *guest_fpu) {
-- 
2.43.0



