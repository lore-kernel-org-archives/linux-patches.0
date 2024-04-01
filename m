Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 474D54D137;
	Mon,  1 Apr 2024 16:53:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990399; cv=none; b=cV3pxDaG4L1NhEpSjNAJABlGIobd7gSpnJlJQD8Y5tcM1ABVR9HJQa3j9pKr0qcw0iDdX6+1ShNrc4x2q4S7mQTZt4EBWII6kj7mmFzNDcj/c0IgHWPJl6T8zrAxuqsH0mhS1CV8aS0+wkoZy4leboPbzosbMt67bd5CanXBK1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990399; c=relaxed/simple;
	bh=5iKdgqtd2yxApdW3qo97plm4KNZ6KRLKa0UZv8mZtzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q+9GdUtyID0ANN+q3yIYqMyG42g/N50h+rFAbo9pQUmbD9IgO8tyAC3p4ZbpDl2shfg/QGO/oDhlJ7HL/DoyPWe20yQRHNQaY0UAJ88i3iPFCjR7r7YGMFzODQEGYZMNh0TsYGnv16wOvTqOC/BNDRCB3lzcy9HwSVSTaIAa0Jg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Odjqq4S+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Odjqq4S+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCED9C43399;
	Mon,  1 Apr 2024 16:53:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990399;
	bh=5iKdgqtd2yxApdW3qo97plm4KNZ6KRLKa0UZv8mZtzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Odjqq4S+HSm3YHln2b7hCeY/D4PbK8Gdlh8TgCeSn19CDODcOQEwJeIrdDq3hmrF4
	 zqsdVdvfYYcVbIUF8aLjozKAjxnjDGeqodsZGxNgnjgkOspJLA/fHbDt1eDwoN0dby
	 t9dvJSOxPnIhSxR7O9q2GB9dsOieeFaslKpj0MtQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Adamos Ttofari <attofari@amazon.de>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 302/396] x86/fpu: Keep xfd_state in sync with MSR_IA32_XFD
Date: Mon,  1 Apr 2024 17:45:51 +0200
Message-ID: <20240401152556.904628725@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index ef6906107c541..571a43b3105df 100644
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



