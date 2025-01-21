Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4497DE571;
	Tue, 21 Jan 2025 18:02:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482525; cv=none; b=Ng+mVjRKEuowZIF8dmk9DMViP/lJZvFfyy7OswvYhz6+NfoUeCFrcWAuqci+vpTYz48NgP3l5SFrPpdjbTHAA37mX0itVwCqSpTlv6czXpLrhtOkTjil7xmiLtgTlwCLHwpqCxaU8BVk+6jsp5C+D/dwPhHPk2Kdp1+A5dNOlng=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482525; c=relaxed/simple;
	bh=Ikg7oLP2dEsYY8AMnZbhgbmqVzbCKam7UiZOozKW85Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WwsSmrbX1mZ3gkZNNWlZQ0Jv9Bq7/gTcIIyOz87ey9V1/28pUmrxIOBEkb9lczaFZVo85NGC3fFDYAgwhrwSNxY5ihh8LbfszXZOohWTEm4cHbZHFpAPRY7orz5LD8Yq+LvuhPIF/p4Gb2t/WANzwSfc4KRz+Mw41yhHn9rC7CE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ryhbPFn/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ryhbPFn/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD352C4CEDF;
	Tue, 21 Jan 2025 18:02:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482525;
	bh=Ikg7oLP2dEsYY8AMnZbhgbmqVzbCKam7UiZOozKW85Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ryhbPFn/Lb+Cvec7opGN3rfrgo1PTIiNy2Ju9XIBA1ex+nZQ7aQt96J9wyX9LhL62
	 oSyuzgSxx99Jlqti5zA7RNlL+hFH8+5txlg6OjOtGkW7OGCCfhdBOeNE8waeLEHQwj
	 YgA+ilnjcoXahl6xbd50aFz+yqiW9/maj4eBH4jc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 107/122] timers/migration: Fix another race between hotplug and idle entry/exit
Date: Tue, 21 Jan 2025 18:52:35 +0100
Message-ID: <20250121174537.164063933@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

commit b729cc1ec21a5899b7879ccfbe1786664928d597 upstream.

Commit 10a0e6f3d3db ("timers/migration: Move hierarchy setup into
cpuhotplug prepare callback") fixed a race between idle exit and CPU
hotplug up leading to a wrong "0" value migrator assigned to the top
level. However there is still a situation that remains unhandled:

         [GRP0:0]
        migrator  = TMIGR_NONE
        active    = NONE
        groupmask = 0
        /     \      \
       0       1     2..7
     idle      idle   idle

0) The system is fully idle.

         [GRP0:0]
        migrator  = CPU 0
        active    = CPU 0
        groupmask = 0
        /     \      \
       0       1     2..7
     active   idle   idle

1) CPU 0 is activating. It has done the cmpxchg on the top's ->migr_state
but it hasn't yet returned to __walk_groups().

         [GRP0:0]
        migrator  = CPU 0
        active    = CPU 0, CPU 1
        groupmask = 0
        /     \      \
       0       1     2..7
     active  active  idle

2) CPU 1 is activating. CPU 0 stays the migrator (still stuck in
__walk_groups(), delayed by #VMEXIT for example).

                 [GRP1:0]
              migrator = TMIGR_NONE
              active   = NONE
              groupmask = 0
              /                  \
        [GRP0:0]                      [GRP0:1]
       migrator  = CPU 0           migrator = TMIGR_NONE
       active    = CPU 0, CPU1     active   = NONE
       groupmask = 2               groupmask = 1
       /     \      \
      0       1     2..7                   8
    active  active  idle              !online

3) CPU 8 is preparing to boot. CPUHP_TMIGR_PREPARE is being ran by CPU 1
which has created the GRP0:1 and the new top GRP1:0 connected to GRP0:1
and GRP0:0. The groupmask of GRP0:0 is now 2. CPU 1 hasn't yet
propagated its activation up to GRP1:0.

                 [GRP1:0]
              migrator = 0 (!!!)
              active   = NONE
              groupmask = 0
              /                  \
        [GRP0:0]                  [GRP0:1]
       migrator  = CPU 0           migrator = TMIGR_NONE
       active    = CPU 0, CPU1     active   = NONE
       groupmask = 2               groupmask = 1
       /     \      \
      0       1     2..7                   8
    active  active  idle                !online

4) CPU 0 finally resumed after its #VMEXIT. It's in __walk_groups()
returning from tmigr_cpu_active(). The new top GRP1:0 is visible and
fetched but the freshly updated groupmask of GRP0:0 may not be visible
due to lack of ordering! As a result tmigr_active_up() is called to
GRP0:0 with a child's groupmask of "0". This buggy "0" groupmask then
becomes the migrator for GRP1:0 forever. As a result, timers on a fully
idle system get ignored.

One possible fix would be to define TMIGR_NONE as "0" so that such a
race would have no effect. And after all TMIGR_NONE doesn't need to be
anything else. However this would leave an uncomfortable state machine
where gears happen not to break by chance but are vulnerable to future
modifications.

Keep TMIGR_NONE as is instead and pre-initialize to "1" the groupmask of
any newly created top level. This groupmask is guaranteed to be visible
upon fetching the corresponding group for the 1st time:

_ By the upcoming CPU thanks to CPU hotplug synchronization between the
  control CPU (BP) and the booting one (AP).

_ By the control CPU since the groupmask and parent pointers are
  initialized locally.

_ By all CPUs belonging to the same group than the control CPU because
  they must wait for it to ever become idle before needing to walk to
  the new top. The cmpcxhg() on ->migr_state then makes sure its
  groupmask is visible.

With this pre-initialization, it is guaranteed that if a future top level
is linked to an old one, it is walked through with a valid groupmask.

Fixes: 10a0e6f3d3db ("timers/migration: Move hierarchy setup into cpuhotplug prepare callback")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250114231507.21672-2-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timer_migration.c | 29 ++++++++++++++++++++++++++++-
 1 file changed, 28 insertions(+), 1 deletion(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 8d57f7686bb0..c8a8ea2e5b98 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -1487,6 +1487,21 @@ static void tmigr_init_group(struct tmigr_group *group, unsigned int lvl,
 	s.seq = 0;
 	atomic_set(&group->migr_state, s.state);
 
+	/*
+	 * If this is a new top-level, prepare its groupmask in advance.
+	 * This avoids accidents where yet another new top-level is
+	 * created in the future and made visible before the current groupmask.
+	 */
+	if (list_empty(&tmigr_level_list[lvl])) {
+		group->groupmask = BIT(0);
+		/*
+		 * The previous top level has prepared its groupmask already,
+		 * simply account it as the first child.
+		 */
+		if (lvl > 0)
+			group->num_children = 1;
+	}
+
 	timerqueue_init_head(&group->events);
 	timerqueue_init(&group->groupevt.nextevt);
 	group->groupevt.nextevt.expires = KTIME_MAX;
@@ -1550,8 +1565,20 @@ static void tmigr_connect_child_parent(struct tmigr_group *child,
 	raw_spin_lock_irq(&child->lock);
 	raw_spin_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
 
+	if (activate) {
+		/*
+		 * @child is the old top and @parent the new one. In this
+		 * case groupmask is pre-initialized and @child already
+		 * accounted, along with its new sibling corresponding to the
+		 * CPU going up.
+		 */
+		WARN_ON_ONCE(child->groupmask != BIT(0) || parent->num_children != 2);
+	} else {
+		/* Adding @child for the CPU going up to @parent. */
+		child->groupmask = BIT(parent->num_children++);
+	}
+
 	child->parent = parent;
-	child->groupmask = BIT(parent->num_children++);
 
 	raw_spin_unlock(&parent->lock);
 	raw_spin_unlock_irq(&child->lock);
-- 
2.48.1



