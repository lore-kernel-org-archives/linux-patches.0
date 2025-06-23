Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65BDB2222B2;
	Mon, 23 Jun 2025 22:23:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750717387; cv=none; b=dE/SjQDwk45lj53IRQ+2ksP2NEpLvyNMA7WceNFMXmkxILuou9fzbsn8fsuJIVc7pLJuXcrrASBGCtvp6Xh8kaVpD+rudTQI1d0XyF2DRT9LPuHRJXJytEjeZh8CChchu4PjhGFJ8GoG7t4eZ/e/JHWkRbLfqHm8xR3I5xWeabU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750717387; c=relaxed/simple;
	bh=zVm804zSFNlp+VtL7g+FiokwyJnlaEOqAYn2wjxRiSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SKwn7ihjgF7tr0p7KaJX3D9DSlA3CPvJfAmnY657xqB449WsBsrCVJY0D7DZ6C4b8wXj38lZESNL9eTYasoVva01bWHC92uDUoRnijWA1B/6FIsKtLw70ngd2iKt4hlJAPrJmr2oXn+Z0+gn/iWb9A6ckZFVQtrcphOpqMwQa14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YsPrcPEt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YsPrcPEt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA933C4CEEA;
	Mon, 23 Jun 2025 22:23:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750717387;
	bh=zVm804zSFNlp+VtL7g+FiokwyJnlaEOqAYn2wjxRiSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YsPrcPEtSqN0zIq3+WaG/MjIjI5egR1pCOuKU2VCjALngnu67HxwWMph18BhYc4bU
	 qx+klY4Xy3a+v6Oy2Q0AKI6z6RjyNu6NMpc+xoriqktTR2x/lfyerkdzLcVIWxDcSG
	 peyZphBCu51QKORYJQsrbBYxUWizNa7xN5O+aQcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 377/414] ptp: fix breakage after ptp_vclock_in_use() rework
Date: Mon, 23 Jun 2025 15:08:34 +0200
Message-ID: <20250623130651.377519933@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5ab73b010cad294851e558f1d4714a85c6f206c7 ]

What is broken
--------------

ptp4l, and any other application which calls clock_adjtime() on a
physical clock, is greeted with error -EBUSY after commit 87f7ce260a3c
("ptp: remove ptp->n_vclocks check logic in ptp_vclock_in_use()").

Explanation for the breakage
----------------------------

The blamed commit was based on the false assumption that
ptp_vclock_in_use() callers already test for n_vclocks prior to calling
this function.

This is notably incorrect for the code path below, in which there is, in
fact, no n_vclocks test:

ptp_clock_adjtime()
-> ptp_clock_freerun()
   -> ptp_vclock_in_use()

The result is that any clock adjustment on any physical clock is now
impossible. This is _despite_ there not being any vclock over this
physical clock.

$ ptp4l -i eno0 -2 -P -m
ptp4l[58.425]: selected /dev/ptp0 as PTP clock
[   58.429749] ptp: physical clock is free running
ptp4l[58.431]: Failed to open /dev/ptp0: Device or resource busy
failed to create a clock
$ cat /sys/class/ptp/ptp0/n_vclocks
0

The patch makes the ptp_vclock_in_use() function say "if it's not a
virtual clock, then this physical clock does have virtual clocks on
top".

Then ptp_clock_freerun() uses this information to say "this physical
clock has virtual clocks on top, so it must stay free-running".

Then ptp_clock_adjtime() uses this information to say "well, if this
physical clock has to be free-running, I can't do it, return -EBUSY".

Simply put, ptp_vclock_in_use() cannot be simplified so as to remove the
test whether vclocks are in use.

What did the blamed commit intend to fix
----------------------------------------

The blamed commit presents a lockdep warning stating "possible recursive
locking detected", with the n_vclocks_store() and ptp_clock_unregister()
functions involved.

The recursive locking seems this:
n_vclocks_store()
-> mutex_lock_interruptible(&ptp->n_vclocks_mux) // 1
-> device_for_each_child_reverse(..., unregister_vclock)
   -> unregister_vclock()
      -> ptp_vclock_unregister()
         -> ptp_clock_unregister()
            -> ptp_vclock_in_use()
               -> mutex_lock_interruptible(&ptp->n_vclocks_mux) // 2

The issue can be triggered by creating and then deleting vclocks:
$ echo 2 > /sys/class/ptp/ptp0/n_vclocks
$ echo 0 > /sys/class/ptp/ptp0/n_vclocks

But note that in the original stack trace, the address of the first lock
is different from the address of the second lock. This is because at
step 1 marked above, &ptp->n_vclocks_mux is the lock of the parent
(physical) PTP clock, and at step 2, the lock is of the child (virtual)
PTP clock. They are different locks of different devices.

In this situation there is no real deadlock, the lockdep warning is
caused by the fact that the mutexes have the same lock class on both the
parent and the child. Functionally it is fine.

Proposed alternative solution
-----------------------------

We must reintroduce the body of ptp_vclock_in_use() mostly as it was
structured prior to the blamed commit, but avoid the lockdep warning.

Based on the fact that vclocks cannot be nested on top of one another
(ptp_is_attribute_visible() hides n_vclocks for virtual clocks), we
already know that ptp->n_vclocks is zero for a virtual clock. And
ptp->is_virtual_clock is a runtime invariant, established at
ptp_clock_register() time and never changed. There is no need to
serialize on any mutex in order to read ptp->is_virtual_clock, and we
take advantage of that by moving it outside the lock.

Thus, virtual clocks do not need to acquire &ptp->n_vclocks_mux at
all, and step 2 in the code walkthrough above can simply go away.
We can simply return false to the question "ptp_vclock_in_use(a virtual
clock)".

Other notes
-----------

Releasing &ptp->n_vclocks_mux before ptp_vclock_in_use() returns
execution seems racy, because the returned value can become stale as
soon as the function returns and before the return value is used (i.e.
n_vclocks_store() can run any time). The locking requirement should
somehow be transferred to the caller, to ensure a longer life time for
the returned value, but this seems out of scope for this severe bug fix.

Because we are also fixing up the logic from the original commit, there
is another Fixes: tag for that.

Fixes: 87f7ce260a3c ("ptp: remove ptp->n_vclocks check logic in ptp_vclock_in_use()")
Fixes: 73f37068d540 ("ptp: support ptp physical/virtual clocks conversion")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250613174749.406826-2-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ptp/ptp_private.h | 22 +++++++++++++++++++++-
 1 file changed, 21 insertions(+), 1 deletion(-)

diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 528d86a33f37d..a6aad743c282f 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -98,7 +98,27 @@ static inline int queue_cnt(const struct timestamp_event_queue *q)
 /* Check if ptp virtual clock is in use */
 static inline bool ptp_vclock_in_use(struct ptp_clock *ptp)
 {
-	return !ptp->is_virtual_clock;
+	bool in_use = false;
+
+	/* Virtual clocks can't be stacked on top of virtual clocks.
+	 * Avoid acquiring the n_vclocks_mux on virtual clocks, to allow this
+	 * function to be called from code paths where the n_vclocks_mux of the
+	 * parent physical clock is already held. Functionally that's not an
+	 * issue, but lockdep would complain, because they have the same lock
+	 * class.
+	 */
+	if (ptp->is_virtual_clock)
+		return false;
+
+	if (mutex_lock_interruptible(&ptp->n_vclocks_mux))
+		return true;
+
+	if (ptp->n_vclocks)
+		in_use = true;
+
+	mutex_unlock(&ptp->n_vclocks_mux);
+
+	return in_use;
 }
 
 /* Check if ptp clock shall be free running */
-- 
2.39.5



