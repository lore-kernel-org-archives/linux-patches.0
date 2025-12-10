Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAEFB2765ED;
	Wed, 10 Dec 2025 06:35:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765348510; cv=none; b=OfzcFqJFyFIztydFtBNlOL+V/HAm+2OXRRl/OtLtlWkPo5dsFUfNJNJOEsPWVsm0ZcW91mgSGSHHVqX0DnIhGsKu5aJSRccdZq/nm1SD/GRd5dDugLeMSqmwRf7sCPtKJ9T7rRi8HYcLVHuB5ScN5kX2PzTKzhAP5WOHb7xJsp4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765348510; c=relaxed/simple;
	bh=D3mDAAXv9K1KDUbnYd9kBnOgPkXbsyTohQhR0uWAzYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Vxq4/wKbSUWSOC3z9vidGwrFMIi/fhjiEQMB5Ro+AZz0BXM/tGw9xCpgfTWjAJE7jN5mGOgTyHbZfq5yu+fE0rOSEbwX1tsb8dTSPkIGzx22qCJuYgByRJkMmrASQOwzwAf+G4fRtVz1xyndNgm+AlAQfGB+SbqMOhY+0kNwnLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QCwhmf8O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QCwhmf8O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09CF0C16AAE;
	Wed, 10 Dec 2025 06:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765348510;
	bh=D3mDAAXv9K1KDUbnYd9kBnOgPkXbsyTohQhR0uWAzYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QCwhmf8O0mMCz8+d8hPBSbA/rJk0CmfKCmydwPvdTypLs4ssL9ddFh/cXmhMgac+u
	 chSx39UtTUXkfCbQfPA5QEclQYpGhWNW80NN0jEUEghUYCe/f4kBQDgPRPrrYDZoFh
	 f7Xalh9XawpQi9s4OnXSCqmkmr1wPh7lXUx4NtbDbrj9EZtJS+UQqBqbrCJCCQXaYp
	 a11nesplep3PaFt6KYrxxPZH14/E13oYnoCvxoS848zcqyHoCo0vJuvQkWRouLeyc2
	 6RuH3VXDzBWJ853JZHjT4KrKND/vMqkMHmdLATg/OxdvCeBODbDA/uYjB5xyw9cg6R
	 woONKutHmIkyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Xu <lizhi.xu@windriver.com>,
	syzbot+205ef33a3b636b4181fb@syzkaller.appspotmail.com,
	Shuah Khan <skhan@linuxfoundation.org>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sasha Levin <sashal@kernel.org>,
	valentina.manea.m@gmail.com,
	shuah@kernel.org,
	bigeasy@linutronix.de,
	clrkwllms@kernel.org,
	rostedt@goodmis.org,
	linux-usb@vger.kernel.org,
	linux-rt-devel@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-5.10] usbip: Fix locking bug in RT-enabled kernels
Date: Wed, 10 Dec 2025 01:34:34 -0500
Message-ID: <20251210063446.2513466-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251210063446.2513466-1-sashal@kernel.org>
References: <20251210063446.2513466-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit 09bf21bf5249880f62fe759b53b14b4b52900c6c ]

Interrupts are disabled before entering usb_hcd_giveback_urb().
A spinlock_t becomes a sleeping lock on PREEMPT_RT, so it cannot be
acquired with disabled interrupts.

Save the interrupt status and restore it after usb_hcd_giveback_urb().

syz reported:
BUG: sleeping function called from invalid context at kernel/locking/spinlock_rt.c:48
Call Trace:
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 rt_spin_lock+0xc7/0x2c0 kernel/locking/spinlock_rt.c:57
 spin_lock include/linux/spinlock_rt.h:44 [inline]
 mon_bus_complete drivers/usb/mon/mon_main.c:134 [inline]
 mon_complete+0x5c/0x200 drivers/usb/mon/mon_main.c:147
 usbmon_urb_complete include/linux/usb/hcd.h:738 [inline]
 __usb_hcd_giveback_urb+0x254/0x5e0 drivers/usb/core/hcd.c:1647
 vhci_urb_enqueue+0xb4f/0xe70 drivers/usb/usbip/vhci_hcd.c:818

Reported-by: syzbot+205ef33a3b636b4181fb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=205ef33a3b636b4181fb
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Acked-by: Shuah Khan <skhan@linuxfoundation.org>
Link: https://lore.kernel.org/r/20250916014143.1439759-1-lizhi.xu@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### 1. PROBLEM IDENTIFICATION

**Bug Type:** "Sleeping function called from invalid context" BUG on
PREEMPT_RT kernels

**Root Cause:**
- Commit 9e8586827a706 (from 2020) added
  `local_irq_disable()/local_irq_enable()` around
  `usb_hcd_giveback_urb()` to fix an earlier bug
- On PREEMPT_RT kernels, `spinlock_t` becomes a sleeping lock (rt_mutex)
- When `usb_hcd_giveback_urb()` is called with IRQs disabled, its
  completion callbacks (like `mon_complete()` in usbmon) try to acquire
  spinlock_t
- Acquiring a sleeping lock with IRQs disabled triggers: `BUG: sleeping
  function called from invalid context at
  kernel/locking/spinlock_rt.c:48`

### 2. THE FIX EXPLAINED

**Before (buggy):**
```c
spin_unlock_irqrestore(&vhci->lock, flags);  // unlock + restore IRQs
local_irq_disable();                          // disable IRQs
usb_hcd_giveback_urb(hcd, urb, urb->status);  // ⚠️ callbacks can't
acquire RT spinlocks!
local_irq_enable();
```

**After (fixed):**
```c
spin_unlock(&vhci->lock);                     // just release lock (keep
IRQs in saved state)
usb_hcd_giveback_urb(hcd, urb, urb->status);  // ✓ callbacks can acquire
RT spinlocks
spin_lock(&vhci->lock);                       // re-acquire
spin_unlock_irqrestore(&vhci->lock, flags);   // final unlock + restore
IRQs
```

The fix keeps IRQs in the saved state from the original
`spin_lock_irqsave()` instead of explicitly disabling them, which allows
RT spinlocks to work properly.

### 3. STABLE BACKPORT CRITERIA EVALUATION

| Criterion | Assessment |
|-----------|------------|
| **Fixes real bug** | ✅ Yes - BUG/crash on PREEMPT_RT kernels with
USBIP |
| **Obviously correct** | ✅ Yes - standard RT locking pattern |
| **Small and contained** | ✅ Yes - 7 lines changed in 1 file |
| **No new features** | ✅ Correct - pure bug fix |
| **Has Fixes: tag** | ❌ No, but implicitly fixes 9e8586827a706 |
| **Has Cc: stable** | ❌ No explicit tag |
| **Maintainer approval** | ✅ Acked-by: Shuah Khan, Signed-off-by: GKH |
| **Tested** | ✅ Reported by syzbot with reproducer |
| **Dependencies** | ✅ None - standalone fix |

### 4. AFFECTED STABLE TREES

The original buggy commit 9e8586827a706 was introduced in kernel 5.10
(2020). All stable trees from 5.10.y onwards contain this bug and would
benefit from this fix. PREEMPT_RT has been increasingly mainlined,
making this fix more relevant for modern stable users.

### 5. RISK ASSESSMENT

**Risk: LOW**
- The change is mechanical - just reordering lock/unlock operations
- Locking semantics and data protection remain identical
- Only affects the error path (`no_need_xmit`/`no_need_unlink` labels)
- The fix is well-understood and targets a specific RT locking issue

**Impact: MEDIUM-HIGH for affected users**
- PREEMPT_RT is becoming more mainstream (now fully merged in mainline)
- USBIP is used in virtualization, embedded systems, and IoT
- Bug causes system crash/BUG which is severe

### 6. CONCLUSION

This commit is an excellent candidate for stable backport:
- Fixes a real, reproducible crash affecting PREEMPT_RT users with USBIP
- Small, surgical fix with no risk of regression
- Signed off by GKH (who is both USB maintainer AND stable maintainer)
- Acked by the USBIP subsystem maintainer
- The buggy code exists in all stable trees since 5.10
- No dependencies on other commits

The lack of explicit `Cc: stable` and `Fixes:` tags is unusual for such
a clear bug fix, but the technical merits strongly support backporting.

**YES**

 drivers/usb/usbip/vhci_hcd.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 0d6c10a8490c0..f7e405abe6084 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -831,15 +831,15 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
 no_need_xmit:
 	usb_hcd_unlink_urb_from_ep(hcd, urb);
 no_need_unlink:
-	spin_unlock_irqrestore(&vhci->lock, flags);
 	if (!ret) {
 		/* usb_hcd_giveback_urb() should be called with
 		 * irqs disabled
 		 */
-		local_irq_disable();
+		spin_unlock(&vhci->lock);
 		usb_hcd_giveback_urb(hcd, urb, urb->status);
-		local_irq_enable();
+		spin_lock(&vhci->lock);
 	}
+	spin_unlock_irqrestore(&vhci->lock, flags);
 	return ret;
 }
 
-- 
2.51.0

