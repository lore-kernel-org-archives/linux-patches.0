Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC4C1F0E36;
	Tue, 21 Jan 2025 18:02:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482528; cv=none; b=WhUMRBoO1lyp3m5Im9ppMinvYRV4q5/cnYB+mmD/lHAISl5GfgoFGUfuOF9E8Da1m/DufyofOkDFc9mAzbWnDf9Yi7BTvUicaEu0f6/SV16c6sYQXewcbWbNpT9gbb1ikkkfzBBieLHRHpose5kQHR9SlWPATJC3MTejORojqeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482528; c=relaxed/simple;
	bh=wv008ugb0dPoLydl3poiZVNNE4bp1ct7va7/mIRxbS8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Adn2avEgiEAzeTYH3mKm7r6cHOLdYApKcDlAZvM79ZdadFINPH4TeiBDxOsrjjzwXyRQeLR1VYyGwlRJPE8AaaEQv947/XyXo9p0JK+HYKveQL1leM4+kAoE/Verb/84Rs5lAHtYtY9RRHOzxWPIvduFg4HiMgAtJNRFOne4EeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l1C41G5n; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l1C41G5n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9DC3C4CEDF;
	Tue, 21 Jan 2025 18:02:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482528;
	bh=wv008ugb0dPoLydl3poiZVNNE4bp1ct7va7/mIRxbS8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l1C41G5nAvKW9EytoSHc7UgeQOfrs1Flf+iHn3ptHFIezY895T4AE6o3K+u7EfNqM
	 AhQQ58mrWsJjj57oJ3Doq43YjE2atekKKXZ4HWRdAvUOJRwu3fLFhoLpVMYe8Q5rex
	 s23cUxfXng+KUgWRR8kwJMryjzyUVs+pKd6+ElNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frederic Weisbecker <frederic@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.12 108/122] timers/migration: Enforce group initialization visibility to tree walkers
Date: Tue, 21 Jan 2025 18:52:36 +0100
Message-ID: <20250121174537.202159596@linuxfoundation.org>
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

commit de3ced72a79280fefd680e5e101d8b9f03cfa1d7 upstream.

Commit 2522c84db513 ("timers/migration: Fix another race between hotplug
and idle entry/exit") fixed yet another race between idle exit and CPU
hotplug up leading to a wrong "0" value migrator assigned to the top
level. However there is yet another situation that remains unhandled:

         [GRP0:0]
      migrator  = TMIGR_NONE
      active    = NONE
      groupmask = 1
      /     \      \
     0       1     2..7
   idle      idle   idle

0) The system is fully idle.

         [GRP0:0]
      migrator  = CPU 0
      active    = CPU 0
      groupmask = 1
      /     \      \
     0       1     2..7
   active   idle   idle

1) CPU 0 is activating. It has done the cmpxchg on the top's ->migr_state
but it hasn't yet returned to __walk_groups().

         [GRP0:0]
      migrator  = CPU 0
      active    = CPU 0, CPU 1
      groupmask = 1
      /     \      \
     0       1     2..7
   active  active  idle

2) CPU 1 is activating. CPU 0 stays the migrator (still stuck in
__walk_groups(), delayed by #VMEXIT for example).

                    [GRP1:0]
                migrator = TMIGR_NONE
                active   = NONE
                groupmask = 1
             /                   \
         [GRP0:0]                  [GRP0:1]
      migrator  = CPU 0           migrator = TMIGR_NONE
      active    = CPU 0, CPU1     active   = NONE
      groupmask = 1               groupmask = 2
      /     \      \
     0       1     2..7                   8
   active  active  idle                !online

3) CPU 8 is preparing to boot. CPUHP_TMIGR_PREPARE is being ran by CPU 1
which has created the GRP0:1 and the new top GRP1:0 connected to GRP0:1
and GRP0:0. CPU 1 hasn't yet propagated its activation up to GRP1:0.

                    [GRP1:0]
               migrator = GRP0:0
               active   = GRP0:0
               groupmask = 1
             /                   \
         [GRP0:0]                  [GRP0:1]
     migrator  = CPU 0           migrator = TMIGR_NONE
     active    = CPU 0, CPU1     active   = NONE
     groupmask = 1               groupmask = 2
     /     \      \
    0       1     2..7                   8
  active  active  idle                !online

4) CPU 0 finally resumed after its #VMEXIT. It's in __walk_groups()
returning from tmigr_cpu_active(). The new top GRP1:0 is visible and
fetched and the pre-initialized groupmask of GRP0:0 is also visible.
As a result tmigr_active_up() is called to GRP1:0 with GRP0:0 as active
and migrator. CPU 0 is returning to __walk_groups() but suffers again
a #VMEXIT.

                    [GRP1:0]
               migrator = GRP0:0
               active   = GRP0:0
               groupmask = 1
             /                   \
         [GRP0:0]                  [GRP0:1]
     migrator  = CPU 0           migrator = TMIGR_NONE
     active    = CPU 0, CPU1     active   = NONE
     groupmask = 1               groupmask = 2
     /     \      \
    0       1     2..7                   8
  active  active  idle                 !online

5) CPU 1 propagates its activation of GRP0:0 to GRP1:0. This has no
   effect since CPU 0 did it already.

                    [GRP1:0]
               migrator = GRP0:0
               active   = GRP0:0, GRP0:1
               groupmask = 1
             /                   \
         [GRP0:0]                  [GRP0:1]
     migrator  = CPU 0           migrator = CPU 8
     active    = CPU 0, CPU1     active   = CPU 8
     groupmask = 1               groupmask = 2
     /     \      \                     \
    0       1     2..7                   8
  active  active  idle                 active

6) CPU 1 links CPU 8 to its group. CPU 8 boots and goes through
   CPUHP_AP_TMIGR_ONLINE which propagates activation.

                                   [GRP2:0]
                              migrator = TMIGR_NONE
                              active   = NONE
                              groupmask = 1
                             /                \
                    [GRP1:0]                    [GRP1:1]
               migrator = GRP0:0              migrator = TMIGR_NONE
               active   = GRP0:0, GRP0:1      active   = NONE
               groupmask = 1                  groupmask = 2
             /                   \
         [GRP0:0]                  [GRP0:1]                [GRP0:2]
     migrator  = CPU 0           migrator = CPU 8        migrator = TMIGR_NONE
     active    = CPU 0, CPU1     active   = CPU 8        active   = NONE
     groupmask = 1               groupmask = 2           groupmask = 0
     /     \      \                     \
    0       1     2..7                   8                  64
  active  active  idle                 active             !online

7) CPU 64 is booting. CPUHP_TMIGR_PREPARE is being ran by CPU 1
which has created the GRP1:1, GRP0:2 and the new top GRP2:0 connected to
GRP1:1 and GRP1:0. CPU 1 hasn't yet propagated its activation up to
GRP2:0.

                                   [GRP2:0]
                              migrator = 0 (!!!)
                              active   = NONE
                              groupmask = 1
                             /                \
                    [GRP1:0]                    [GRP1:1]
               migrator = GRP0:0              migrator = TMIGR_NONE
               active   = GRP0:0, GRP0:1      active   = NONE
               groupmask = 1                  groupmask = 2
             /                   \
         [GRP0:0]                  [GRP0:1]                [GRP0:2]
     migrator  = CPU 0           migrator = CPU 8        migrator = TMIGR_NONE
     active    = CPU 0, CPU1     active   = CPU 8        active   = NONE
     groupmask = 1               groupmask = 2           groupmask = 0
     /     \      \                     \
    0       1     2..7                   8                  64
  active  active  idle                 active             !online

8) CPU 0 finally resumed after its #VMEXIT. It's in __walk_groups()
returning from tmigr_cpu_active(). The new top GRP2:0 is visible and
fetched but the pre-initialized groupmask of GRP1:0 is not because no
ordering made its initialization visible. As a result tmigr_active_up()
may be called to GRP2:0 with a "0" child's groumask. Leaving the timers
ignored for ever when the system is fully idle.

The race is highly theoretical and perhaps impossible in practice but
the groupmask of the child is not the only concern here as the whole
initialization of the child is not guaranteed to be visible to any
tree walker racing against hotplug (idle entry/exit, remote handling,
etc...). Although the current code layout seem to be resilient to such
hazards, this doesn't tell much about the future.

Fix this with enforcing address dependency between group initialization
and the write/read to the group's parent's pointer. Fortunately that
doesn't involve any barrier addition in the fast paths.

Fixes: 10a0e6f3d3db ("timers/migration: Move hierarchy setup into cpuhotplug prepare callback")
Signed-off-by: Frederic Weisbecker <frederic@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/all/20250114231507.21672-3-frederic@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/time/timer_migration.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index c8a8ea2e5b98..371a62a749aa 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -534,8 +534,13 @@ static void __walk_groups(up_f up, struct tmigr_walk *data,
 			break;
 
 		child = group;
-		group = group->parent;
+		/*
+		 * Pairs with the store release on group connection
+		 * to make sure group initialization is visible.
+		 */
+		group = READ_ONCE(group->parent);
 		data->childmask = child->groupmask;
+		WARN_ON_ONCE(!data->childmask);
 	} while (group);
 }
 
@@ -1578,7 +1583,12 @@ static void tmigr_connect_child_parent(struct tmigr_group *child,
 		child->groupmask = BIT(parent->num_children++);
 	}
 
-	child->parent = parent;
+	/*
+	 * Make sure parent initialization is visible before publishing it to a
+	 * racing CPU entering/exiting idle. This RELEASE barrier enforces an
+	 * address dependency that pairs with the READ_ONCE() in __walk_groups().
+	 */
+	smp_store_release(&child->parent, parent);
 
 	raw_spin_unlock(&parent->lock);
 	raw_spin_unlock_irq(&child->lock);
-- 
2.48.1



