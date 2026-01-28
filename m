Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEAE42FF178;
	Wed, 28 Jan 2026 15:58:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615908; cv=none; b=QHu7P/7T3Ru4ChT/3beIldj7C2EEDYaaBFnP2OMim9OeBJjsiBGhuBli0z8yZg2U0wdAU1Mcv9IYbb2B3lQXv+CIQ0sBsaAWC8990iCT7MXHuP1Pn64L5+82tPqXryaOxtcePReNfN1/Krt+YTU/qfRRUwUwUCEGUG5OMDfgFgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615908; c=relaxed/simple;
	bh=wgjwVbS8ePusXgxicjjtBzO7MqseixBg2NnW1CiK9F4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IC7iIk6xCbTxEmPEbQeogaoMn2QMEyXsfIjVt6qi1zGcUXfUESH4Swm/Zhag7TKDpaKLpmlvbW+X5uHRz9CvoHeBXRUqaWhGhBR6W1WRIwWWCj1HCrD5ghoCXb9ISApiyGjNHoxf3dWsmuey58mDon6gKexmPzQHdmHuGLSURjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QGYdq6FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QGYdq6FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8778C4CEF7;
	Wed, 28 Jan 2026 15:58:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615908;
	bh=wgjwVbS8ePusXgxicjjtBzO7MqseixBg2NnW1CiK9F4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QGYdq6FUI6z9dNdr7KPI6K3uYjDGx2SvaUm9TkKmxLpIPJKzGNLz0rGkvrzEwRSpT
	 9tT6t/AGjW0ZVRqYZoNuf968sQCLoLim800ptDouwnolOOq5q3/ZEjj65MGOnlHMes
	 W1KwjXmhd5Invixgdt8rNmUSJ3efVmeUAHQKV9+w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cedric Xing <cedric.xing@intel.com>,
	Dave Hansen <dave.hansen@linux.intel.com>,
	Peter Zijlstra <peterz@infradead.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 150/227] x86: make page fault handling disable interrupts properly
Date: Wed, 28 Jan 2026 16:23:15 +0100
Message-ID: <20260128145349.853665327@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Cedric Xing <cedric.xing@intel.com>

[ Upstream commit 614da1d3d4cdbd6e41aea06bc97ec15aacff6daf ]

There's a big comment in the x86 do_page_fault() about our interrupt
disabling code:

    * User address page fault handling might have reenabled
    * interrupts. Fixing up all potential exit points of
    * do_user_addr_fault() and its leaf functions is just not
    * doable w/o creating an unholy mess or turning the code
    * upside down.

but it turns out that comment is subtly wrong, and the code as a result
is also wrong.

Because it's certainly true that we may have re-enabled interrupts when
handling user page faults.  And it's most certainly true that we don't
want to bother fixing up all the cases.

But what isn't true is that it's limited to user address page faults.

The confusion stems from the fact that we have logic here that depends
on the address range of the access, but other code then depends on the
_context_ the access was done in.  The two are not related, even though
both of them are about user-vs-kernel.

In other words, both user and kernel addresses can cause interrupts to
have been enabled (eg when __bad_area_nosemaphore() gets called for user
accesses to kernel addresses).  As a result we should make sure to
disable interrupts again regardless of the address range before
returning to the low-level fault handling code.

The __bad_area_nosemaphore() code actually did disable interrupts again
after enabling them, just not consistently.  Ironically, as noted in the
original comment, fixing up all the cases is just not worth it, when the
simple solution is to just do it unconditionally in one single place.

So remove the incomplete case that unsuccessfully tried to do what the
comment said was "not doable" in commit ca4c6a9858c2 ("x86/traps: Make
interrupt enable/disable symmetric in C code"), and just make it do the
simple and straightforward thing.

Signed-off-by: Cedric Xing <cedric.xing@intel.com>
Reviewed-by: Dave Hansen <dave.hansen@linux.intel.com>
Fixes: ca4c6a9858c2 ("x86/traps: Make interrupt enable/disable symmetric in C code")
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/mm/fault.c | 15 +++++----------
 1 file changed, 5 insertions(+), 10 deletions(-)

diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index 998bd807fc7ba..b83a06739b511 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -821,8 +821,6 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		force_sig_pkuerr((void __user *)address, pkey);
 	else
 		force_sig_fault(SIGSEGV, si_code, (void __user *)address);
-
-	local_irq_disable();
 }
 
 static noinline void
@@ -1474,15 +1472,12 @@ handle_page_fault(struct pt_regs *regs, unsigned long error_code,
 		do_kern_addr_fault(regs, error_code, address);
 	} else {
 		do_user_addr_fault(regs, error_code, address);
-		/*
-		 * User address page fault handling might have reenabled
-		 * interrupts. Fixing up all potential exit points of
-		 * do_user_addr_fault() and its leaf functions is just not
-		 * doable w/o creating an unholy mess or turning the code
-		 * upside down.
-		 */
-		local_irq_disable();
 	}
+	/*
+	 * page fault handling might have reenabled interrupts,
+	 * make sure to disable them again.
+	 */
+	local_irq_disable();
 }
 
 DEFINE_IDTENTRY_RAW_ERRORCODE(exc_page_fault)
-- 
2.51.0



