Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E1B446C9;
	Tue, 20 Feb 2024 21:38:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465085; cv=none; b=mnKH+u7OPFmGFS+Z/8yNmxxQZlt3dG6aR2K6VrP+zJQlhrEvu8sM9KZNIBLubI0vAH512ejgyCIhOjSynM9WFEgKTwmKn9hFk2Bt9DixxQsM5iOaVFTnrgIRCda5hqJ3PPoWTL7XWeOCOlbBp92THJfR2SqArjHdMhbUghDzFFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465085; c=relaxed/simple;
	bh=1QJU8iREy5eHm9ydU3ntJemUmP/qmJ/hP9mGfO3ueXE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FIWy/atIPYm2kcHzdD2kmICzjwXrAdluk/y5LKYkPaR0heob4OtAny3dvH52S/2CdAFq1GCBH7PKN+eMH7ON2/HmDI+5D2L/cz8geK3eEuQDL+Y42vdvyX3794X9rFzVP7ReDbLsM+D5kTm1yEaGbp+3SiZ7C5gLupSDAM6PfQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=s3XQKhpw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="s3XQKhpw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CE00C433F1;
	Tue, 20 Feb 2024 21:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465085;
	bh=1QJU8iREy5eHm9ydU3ntJemUmP/qmJ/hP9mGfO3ueXE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=s3XQKhpwj+utx8/Hf5fPz3XzrkoHQFCDTGOFHmEV4nLnszJlolvSOchLe38qOeN4S
	 llRbx7j0O5H4b4ywKjy/nii6d2566w6/SRK0J8u0UDO12Pd5d0apROzCMvz/m9a7nx
	 EluOsfPx8Tv8U+6d1HnMjJdtJerGqICXW5etjHCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Bogomolov <bogomolov@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrei Vagin <avagin@google.com>,
	Dave Hansen <dave.hansen@linux.intel.com>
Subject: [PATCH 6.7 232/309] x86/fpu: Stop relying on userspace for info to fault in xsave buffer
Date: Tue, 20 Feb 2024 21:56:31 +0100
Message-ID: <20240220205640.417769088@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Andrei Vagin <avagin@google.com>

commit d877550eaf2dc9090d782864c96939397a3c6835 upstream.

Before this change, the expected size of the user space buffer was
taken from fx_sw->xstate_size. fx_sw->xstate_size can be changed
from user-space, so it is possible construct a sigreturn frame where:

 * fx_sw->xstate_size is smaller than the size required by valid bits in
   fx_sw->xfeatures.
 * user-space unmaps parts of the sigrame fpu buffer so that not all of
   the buffer required by xrstor is accessible.

In this case, xrstor tries to restore and accesses the unmapped area
which results in a fault. But fault_in_readable succeeds because buf +
fx_sw->xstate_size is within the still mapped area, so it goes back and
tries xrstor again. It will spin in this loop forever.

Instead, fault in the maximum size which can be touched by XRSTOR (taken
from fpstate->user_size).

[ dhansen: tweak subject / changelog ]

Fixes: fcb3635f5018 ("x86/fpu/signal: Handle #PF in the direct restore path")
Reported-by: Konstantin Bogomolov <bogomolov@google.com>
Suggested-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Andrei Vagin <avagin@google.com>
Signed-off-by: Dave Hansen <dave.hansen@linux.intel.com>
Cc:stable@vger.kernel.org
Link: https://lore.kernel.org/all/20240130063603.3392627-1-avagin%40google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/signal.c |   13 +++++--------
 1 file changed, 5 insertions(+), 8 deletions(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -274,12 +274,13 @@ static int __restore_fpregs_from_user(vo
  * Attempt to restore the FPU registers directly from user memory.
  * Pagefaults are handled and any errors returned are fatal.
  */
-static bool restore_fpregs_from_user(void __user *buf, u64 xrestore,
-				     bool fx_only, unsigned int size)
+static bool restore_fpregs_from_user(void __user *buf, u64 xrestore, bool fx_only)
 {
 	struct fpu *fpu = &current->thread.fpu;
 	int ret;
 
+	/* Restore enabled features only. */
+	xrestore &= fpu->fpstate->user_xfeatures;
 retry:
 	fpregs_lock();
 	/* Ensure that XFD is up to date */
@@ -309,7 +310,7 @@ retry:
 		if (ret != X86_TRAP_PF)
 			return false;
 
-		if (!fault_in_readable(buf, size))
+		if (!fault_in_readable(buf, fpu->fpstate->user_size))
 			goto retry;
 		return false;
 	}
@@ -339,7 +340,6 @@ static bool __fpu_restore_sig(void __use
 	struct user_i387_ia32_struct env;
 	bool success, fx_only = false;
 	union fpregs_state *fpregs;
-	unsigned int state_size;
 	u64 user_xfeatures = 0;
 
 	if (use_xsave()) {
@@ -349,17 +349,14 @@ static bool __fpu_restore_sig(void __use
 			return false;
 
 		fx_only = !fx_sw_user.magic1;
-		state_size = fx_sw_user.xstate_size;
 		user_xfeatures = fx_sw_user.xfeatures;
 	} else {
 		user_xfeatures = XFEATURE_MASK_FPSSE;
-		state_size = fpu->fpstate->user_size;
 	}
 
 	if (likely(!ia32_fxstate)) {
 		/* Restore the FPU registers directly from user memory. */
-		return restore_fpregs_from_user(buf_fx, user_xfeatures, fx_only,
-						state_size);
+		return restore_fpregs_from_user(buf_fx, user_xfeatures, fx_only);
 	}
 
 	/*


