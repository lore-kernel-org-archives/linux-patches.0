Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4894A2D593E;
	Wed,  4 Feb 2026 15:11:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217909; cv=none; b=E1qZsq0YaIf8JhKMxxO8yI5jx3p6dMrpORjyZOhezAgxO4KLz2xg5QQ44wh4AAiIKUsJn8/4K1HmFbuBigPGnpz/fZsTIeSooi/yfKNzZHO8s/38ij+unwqJTbEz+tIr6d5K4QMiLb+zfu5wdAFn3xwadqQkLtq5TeUFjztxFcw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217909; c=relaxed/simple;
	bh=2DwsjoQlQblf2TypGIASCw4KrpOThYQVL5/nsZPzpQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aB7iAcXW0Y8nhT1k4iuxGe1fo3P1Lv1LBjQg8bvekgqJfdKH19HiURvGtWfWl3Rt2kE4XGH2wkAmW7RCNl4kY9kwnU/IUZFerb6R7KN1/4GQWsHOOACy3fWfeL05SdC3RRbA/vnUOJHopit3BsLCsRJ5hWegA7ZWy10G5g3Vyuo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=p2muYk6m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="p2muYk6m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A48B4C4CEF7;
	Wed,  4 Feb 2026 15:11:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217909;
	bh=2DwsjoQlQblf2TypGIASCw4KrpOThYQVL5/nsZPzpQo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=p2muYk6mmmP+avfvlUStFp2ENNg2Tcj7Gpn6s89egQpnhqAxbW9jkxYT0kkUP+mUV
	 9T8/HJL8Zjup3JwJw462Ot45WnVWkGbSWsqyO2qj0YKUYdgzlZKLg6ewyVeretGIVf
	 Oanc4BcS41f8QfC/C4teI96lLiEa3XUi5eBN8bhg=
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
Subject: [PATCH 6.1 154/280] x86: make page fault handling disable interrupts properly
Date: Wed,  4 Feb 2026 15:38:48 +0100
Message-ID: <20260204143915.170969680@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2fc007752ceb1..54f8fe0ea5a93 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -835,8 +835,6 @@ __bad_area_nosemaphore(struct pt_regs *regs, unsigned long error_code,
 		force_sig_pkuerr((void __user *)address, pkey);
 	else
 		force_sig_fault(SIGSEGV, si_code, (void __user *)address);
-
-	local_irq_disable();
 }
 
 static noinline void
@@ -1429,15 +1427,12 @@ handle_page_fault(struct pt_regs *regs, unsigned long error_code,
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



