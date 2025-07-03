Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD5352EF672;
	Thu,  3 Jul 2025 14:53:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554409; cv=none; b=Fie4S/lSVtKEpNSFXdDUWu8kCZHMB+n4kt5fd92mZlGuXxnnqFOoZl5j4lV+Moiep2nEahwvkO6hiMZp+DNlBHucwgpcLetETCFDVCymQna1qPqQPjbTCsJcZP8YNSH1PUpPyAGe7Oh60sDgLE7km4X62BhjpNn4j7W+1xM7y94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554409; c=relaxed/simple;
	bh=rplAOk9FeIbzKJONL3+Sga+ZOFFcDlu16cCWW8M2b9U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jW0EeBuPpRDDiHIAZJ7yuLv/vLhjskKlOdAkqF+KU1ZQn/F4Xl3QiLGCJulzqlYqcbuauOSbL4RHwyNEY+1MajcDToqWgQqkgP6gVx0IMOGVoJQPukqTWaX9jsoSmWTPKaSiydO9O56wlUAKssa0Lvuq9qOoKmx4yp0nJHQM7lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FGz+gSRK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FGz+gSRK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DB5EC4CEE3;
	Thu,  3 Jul 2025 14:53:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554409;
	bh=rplAOk9FeIbzKJONL3+Sga+ZOFFcDlu16cCWW8M2b9U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FGz+gSRKNXVRL1M7bPpQ25x1OlXWn50a3n2wSTx/IA4TqLviC5/pFTg3v+rLKg/X+
	 iy78TtVyerXsVNQfiGx1OBw95hUXSlwTAJPaayQdp/CBIDbug3gwMUa78QRAlu09aT
	 fZjp6CHZEalvuWMcx/aCJP+hAAvzBcgq3bjrs2HI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Chang S. Bae" <chang.seok.bae@intel.com>,
	Ingo Molnar <mingo@kernel.org>,
	Andy Lutomirski <luto@kernel.org>,
	"H. Peter Anvin" <hpa@zytor.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Oleg Nesterov <oleg@redhat.com>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 6.12 178/218] x86/fpu: Refactor xfeature bitmask update code for sigframe XSAVE
Date: Thu,  3 Jul 2025 16:42:06 +0200
Message-ID: <20250703144003.293716786@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703143955.956569535@linuxfoundation.org>
References: <20250703143955.956569535@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chang S. Bae <chang.seok.bae@intel.com>

commit 64e54461ab6e8524a8de4e63b7d1a3e4481b5cf3 upstream.

Currently, saving register states in the signal frame, the legacy feature
bits are always set in xregs_state->header->xfeatures. This code sequence
can be generalized for reuse in similar cases.

Refactor the logic to ensure a consistent approach across similar usages.

Signed-off-by: Chang S. Bae <chang.seok.bae@intel.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Link: https://lore.kernel.org/r/20250416021720.12305-8-chang.seok.bae@intel.com
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/kernel/fpu/signal.c |   11 +----------
 arch/x86/kernel/fpu/xstate.h |   13 +++++++++++++
 2 files changed, 14 insertions(+), 10 deletions(-)

--- a/arch/x86/kernel/fpu/signal.c
+++ b/arch/x86/kernel/fpu/signal.c
@@ -119,7 +119,6 @@ static inline bool save_xstate_epilog(vo
 {
 	struct xregs_state __user *x = buf;
 	struct _fpx_sw_bytes sw_bytes = {};
-	u32 xfeatures;
 	int err;
 
 	/* Setup the bytes not touched by the [f]xsave and reserved for SW. */
@@ -133,12 +132,6 @@ static inline bool save_xstate_epilog(vo
 			  (__u32 __user *)(buf + fpstate->user_size));
 
 	/*
-	 * Read the xfeatures which we copied (directly from the cpu or
-	 * from the state in task struct) to the user buffers.
-	 */
-	err |= __get_user(xfeatures, (__u32 __user *)&x->header.xfeatures);
-
-	/*
 	 * For legacy compatible, we always set FP/SSE bits in the bit
 	 * vector while saving the state to the user context. This will
 	 * enable us capturing any changes(during sigreturn) to
@@ -149,9 +142,7 @@ static inline bool save_xstate_epilog(vo
 	 * header as well as change any contents in the memory layout.
 	 * xrestore as part of sigreturn will capture all the changes.
 	 */
-	xfeatures |= XFEATURE_MASK_FPSSE;
-
-	err |= __put_user(xfeatures, (__u32 __user *)&x->header.xfeatures);
+	err |= set_xfeature_in_sigframe(x, XFEATURE_MASK_FPSSE);
 
 	return !err;
 }
--- a/arch/x86/kernel/fpu/xstate.h
+++ b/arch/x86/kernel/fpu/xstate.h
@@ -69,6 +69,19 @@ static inline u64 xfeatures_mask_indepen
 	return fpu_kernel_cfg.independent_features;
 }
 
+static inline int set_xfeature_in_sigframe(struct xregs_state __user *xbuf, u64 mask)
+{
+	u64 xfeatures;
+	int err;
+
+	/* Read the xfeatures value already saved in the user buffer */
+	err  = __get_user(xfeatures, &xbuf->header.xfeatures);
+	xfeatures |= mask;
+	err |= __put_user(xfeatures, &xbuf->header.xfeatures);
+
+	return err;
+}
+
 /*
  * Update the value of PKRU register that was already pushed onto the signal frame.
  */


