Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8626A366DBA;
	Tue, 16 Dec 2025 12:16:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765887371; cv=none; b=JrOUcb52njXBUAk3ayLOv128y5K/BlWX3YQX4sUFMI2uGiIzYz0UsrKEATiLEjXHGIdaGhXaUa75aM7oxDZI+eqaAFwu3+Jji01zyk9IHdAdN355Skw9uj2DS4BUgK+XKmMAZVg814qZRSjDlCqTGBu6TnMs11hKvTcPeXin4zw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765887371; c=relaxed/simple;
	bh=oOK3erHLT7O0rArS53ybUWVCTYxoVxzAyY4AXcHhy0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kXWKkHqSsqYHfwMo2XWcPktVmwk0dd8RiZQFxImgnDbvhKBsd1VRN2SZnCo49ZYCsWUd+NuHDevtYOWEr0JEGTC/luLzP2K3moi03dlUdO7Vg8wlIDg9vCHe7KRjJv6UNkPHi9RqbcXh8sHLnoY/ppUmvY9qknvvM8t6IZHhE+A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfKex+GY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfKex+GY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F82C4CEF5;
	Tue, 16 Dec 2025 12:16:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765887371;
	bh=oOK3erHLT7O0rArS53ybUWVCTYxoVxzAyY4AXcHhy0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SfKex+GYZ5X4NPQWavso/cmpa+l8byMKez4I70ZCC7jHXIQa/giotm0HXhp4Ns0Az
	 D5MIeszoWnHkVlipbk0O4B0WEVbBOiRRIPaSD8YECAC66GP10u6cyx53+QC30y8L8B
	 gtQVHR3ObtokWd1upfAgmUT0V/bi3YoyV+ryvjhI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 176/614] timers/migration: Remove locking on group connection
Date: Tue, 16 Dec 2025 12:09:03 +0100
Message-ID: <20251216111407.748433896@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111401.280873349@linuxfoundation.org>
References: <20251216111401.280873349@linuxfoundation.org>
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

From: Frederic Weisbecker <frederic@kernel.org>

[ Upstream commit fa9620355d4192200f15cb3d97c6eb9c02442249 ]

Initializing the tmc's group, the group's number of children and the
group's parent can all be done without locking because:

  1) Reading the group's parent and its group mask is done locklessly.

  2) The connections prepared for a given CPU hierarchy are visible to the
     target CPU once online, thanks to the CPU hotplug enforced memory
     ordering.

  3) In case of a newly created upper level, the new root and its
     connections and initialization are made visible by the CPU which made
     the connections. When that CPUs goes idle in the future, the new link
     is published by tmigr_inactive_up() through the atomic RmW on
     ->migr_state.

  4) If CPUs were still walking up the active hierarchy, they could observe
     the new root earlier. In this case the ordering is enforced by an
     early initialization of the group mask and by barriers that maintain
     address dependency as explained in:

     b729cc1ec21a ("timers/migration: Fix another race between hotplug and idle entry/exit")
     de3ced72a792 ("timers/migration: Enforce group initialization visibility to tree walkers")

  5) Timers are propagated by a chain of group locking from the bottom to
     the top. And while doing so, the tree also propagates groups links
     and initialization. Therefore remote expiration, which also relies
     on group locking, will observe those links and initialization while
     holding the root lock before walking the tree remotely and update
     remote timers. This is especially important for migrators in the
     active hierarchy that may observe the new root early.

Therefore the locking is unnecessary at initialization. If anything, it
just brings confusion. Remove it.

Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://patch.msgid.link/20251024132536.39841-3-frederic@kernel.org
Stable-dep-of: 5eb579dfd46b ("timers/migration: Fix imbalanced NUMA trees")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer_migration.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 1e371f1fdc86c..5f8aef94ca0f7 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -1573,9 +1573,6 @@ static void tmigr_connect_child_parent(struct tmigr_group *child,
 {
 	struct tmigr_walk data;
 
-	raw_spin_lock_irq(&child->lock);
-	raw_spin_lock_nested(&parent->lock, SINGLE_DEPTH_NESTING);
-
 	if (activate) {
 		/*
 		 * @child is the old top and @parent the new one. In this
@@ -1596,9 +1593,6 @@ static void tmigr_connect_child_parent(struct tmigr_group *child,
 	 */
 	smp_store_release(&child->parent, parent);
 
-	raw_spin_unlock(&parent->lock);
-	raw_spin_unlock_irq(&child->lock);
-
 	trace_tmigr_connect_child_parent(child);
 
 	if (!activate)
@@ -1695,13 +1689,9 @@ static int tmigr_setup_groups(unsigned int cpu, unsigned int node)
 		if (i == 0) {
 			struct tmigr_cpu *tmc = per_cpu_ptr(&tmigr_cpu, cpu);
 
-			raw_spin_lock_irq(&group->lock);
-
 			tmc->tmgroup = group;
 			tmc->groupmask = BIT(group->num_children++);
 
-			raw_spin_unlock_irq(&group->lock);
-
 			trace_tmigr_connect_cpu_parent(tmc);
 
 			/* There are no children that need to be connected */
-- 
2.51.0



