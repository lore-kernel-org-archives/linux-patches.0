Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 612EB1A9F96;
	Sun,  7 Jun 2026 10:21:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780827691; cv=none; b=IiODUeL0AJ1H1IracOqHDa80afX/95Ebu8FGTT5WtSD3BlofdHAC5f5PXPEN661bwKkG3S6xzFzckwW77OjhmBpX+JwbO2/21poHBa/2iZFa0m6OOcYltz687sw/thaPKYJQ9V0eUmANC1HnUCqmSZbjoyZKnGmHCa4mbSbdVbs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780827691; c=relaxed/simple;
	bh=dgvId20HUOkrA+zwprglYs1KZQeivKwWB0mpRVaR3ZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FhVX02UMxdAMpozAYVpDLX/H9SmjHIFEyX3mjDVC7jxxc/VvFFRrQu3H+wtJP4c/pGM5RBJ1d+JKQayL6JoeLc/LW7wX8GSz5Dia0qPMRKd5m8Hc0CI0y+yEhNTKLThQyb06+xG4+hLTfXX2lBrC3Vwt2DVScLvwMEGJSW95BQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q8mjlZSm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q8mjlZSm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E7051F00893;
	Sun,  7 Jun 2026 10:21:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780827689;
	bh=IB/1hBV5yTAetCfgA5nlEsT1JAmprW7hE8aO6xsp2xI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q8mjlZSmTMl4sx09ZZjRQyC6grvbo46CzriL0shX8SMb64009SEv5QFeJgIANGUul
	 et2vche9WmajYpnXiJi9Sg1SPsUZdYtq4GAd4bW9gyLIxleWHQ4zhYiuvR4H4AV+z4
	 ROPzVyc0b9JtsejQ0d8KcxSQF4udULe0xkjAvW24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrei Vagin <avagin@google.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 114/332] Revert "x86/fpu: Refine and simplify the magic number check during signal return"
Date: Sun,  7 Jun 2026 11:58:03 +0200
Message-ID: <20260607095732.299042794@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrei Vagin <avagin@google.com>

[ Upstream commit 44eeff9bc467bc7d1fec34fc3f6001f385fe462c ]

This reverts

  dc8aa31a7ac2 ("x86/fpu: Refine and simplify the magic number check during signal return").

The aforementioned commit broke applications that construct signal frames in
userspace (such as CRIU and gVisor) if the frame's xstate size is smaller than
the kernel's fpstate->user_size.

Furthermore, this introduces a critical issue for checkpoint/restore tools
like CRIU. If a process is checkpointed while inside a signal handler, its
stack contains a signal frame formatted according to the source host's xstate
capabilities.

If that process is later restored on a destination host with larger xstate
capabilities (e.g., a newer CPU with more features enabled, resulting in
a larger fpstate->user_size), the kernel will look for FP_XSTATE_MAGIC2 at the
destination host's larger user_size offset instead of the offset encoded in
the frame's fx_sw->xstate_size.

This causes the magic2 check to fail, forcing sigreturn to silently fall back
to "FX-only" mode. Upon return from the signal handler, the process's extended
state is reset to initial values instead of being restored, leading to silent
data corruption.

The aforementioned commit cited

  d877550eaf2d ("x86/fpu: Stop relying on userspace for info to fault in xsave buffer")

as justification to stop relying on userspace for the magic number check.

However, these two changes are fundamentally different. The last one only
changed how much memory the kernel ensures is paged-in before running XRSTOR
to prevent an infinite loop. It did not change the signal frame format or how
the layout is validated.

Reverting this change restores the use of fx_sw->xstate_size for
locating magic2 and restores the necessary sanity checks, ensuring that
the signal frame remains self-describing and portable.

  [ bp: Massage commit message. ]

Fixes: dc8aa31a7ac2 ("x86/fpu: Refine and simplify the magic number check during signal return")
Signed-off-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Acked-by: Chang S. Bae <chang.seok.bae@intel.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20260429000623.3356606-1-avagin@google.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/kernel/fpu/signal.c | 11 ++++++++---
 1 file changed, 8 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/fpu/signal.c b/arch/x86/kernel/fpu/signal.c
index c3ec2512f2bbe4..20b638c507ca2d 100644
--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -27,14 +27,19 @@
 static inline bool check_xstate_in_sigframe(struct fxregs_state __user *fxbuf,
 					    struct _fpx_sw_bytes *fx_sw)
 {
+	int min_xstate_size = sizeof(struct fxregs_state) +
+			      sizeof(struct xstate_header);
 	void __user *fpstate = fxbuf;
 	unsigned int magic2;
 
 	if (__copy_from_user(fx_sw, &fxbuf->sw_reserved[0], sizeof(*fx_sw)))
 		return false;
 
-	/* Check for the first magic field */
-	if (fx_sw->magic1 != FP_XSTATE_MAGIC1)
+	/* Check for the first magic field and other error scenarios. */
+	if (fx_sw->magic1 != FP_XSTATE_MAGIC1 ||
+	    fx_sw->xstate_size < min_xstate_size ||
+	    fx_sw->xstate_size > x86_task_fpu(current)->fpstate->user_size ||
+	    fx_sw->xstate_size > fx_sw->extended_size)
 		goto setfx;
 
 	/*
@@ -43,7 +48,7 @@ static inline bool check_xstate_in_sigframe(struct fxregs_state __user *fxbuf,
 	 * fpstate layout with out copying the extended state information
 	 * in the memory layout.
 	 */
-	if (__get_user(magic2, (__u32 __user *)(fpstate + x86_task_fpu(current)->fpstate->user_size)))
+	if (__get_user(magic2, (__u32 __user *)(fpstate + fx_sw->xstate_size)))
 		return false;
 
 	if (likely(magic2 == FP_XSTATE_MAGIC2))
-- 
2.53.0



