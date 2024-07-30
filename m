Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 745DE1A76A5;
	Tue, 30 Jul 2024 17:32:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360765; cv=none; b=kfmydv2fvoLQgDRNj6b/hU+41Ovwl4DX1HTZKZB9rnDfRqAIp4AxkVqlCFvNl/VAwsf4rw9mhNnGgdzxUuAg85tWVocYGs9O6YaZ8oEoRTh4OawO1jWy/XfLTUOEOHmf2KFozj47+YCSRfkkd6fyLP7stlPiBNLztDHqCRGwjuI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360765; c=relaxed/simple;
	bh=/7J3df4+ddymrlggBo6wUDCTLHVBidIOWSY69cyQdpA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1YfMn89DDD2NNg1ZgQJkJPIh2JRqyUSMN3TH1j5PSHffNlJhncrlvkEiEDqqgEByVQ1dTe+0DF2/3HW7BFrMi579vdlTqrQARiQoVigCUUntlyq/u051TJrsfL1ENLvUYcQycs7QMMDKqfoE6+EIGaffUO7oEOyYpGos2IBxMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dNmTBQqx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dNmTBQqx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA3B5C32782;
	Tue, 30 Jul 2024 17:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360765;
	bh=/7J3df4+ddymrlggBo6wUDCTLHVBidIOWSY69cyQdpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dNmTBQqxTnfJj55ruLjESRgeef64be5rk9fpn+KdTsVuny3D+UpuwARCiQZX2Pmi0
	 FOGbZsAZJfs1gnRzL2AzmTRoOpb1nWea9B1Q636606pJ6S9TZWrSXki6dOBbRJ4eEM
	 NCcILWSScvyHsovwKbefUqzjl+7SVSFubDpyhFAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Borislav Petkov <bp@alien8.de>,
	Anna-Maria Behnsen <anna-maria@linutronix.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Frederic Weisbecker <frederic@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 793/809] timers/migration: Do not rely always on group->parent
Date: Tue, 30 Jul 2024 17:51:09 +0200
Message-ID: <20240730151756.292195728@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Anna-Maria Behnsen <anna-maria@linutronix.de>

[ Upstream commit facd40aa5c4699f94014012e4e58414c082f2c01 ]

When reading group->parent without holding the group lock it is racy
against CPUs coming online the first time and thereby creating another
level of the hierarchy. This is not a problem when this value is read once
to decide whether to abort a propagation or not. The worst outcome is an
unnecessary/early CPU wake up. But it is racy when reading it several times
during a single 'action' (like activation, deactivation, checking for
remote timer expiry,...) and relying on the consitency of this value
without holding the lock. This happens at the moment e.g. in
tmigr_inactive_up() which is also calling tmigr_udpate_events(). Code relys
on group->parent not to change during this 'action'.

Update parent struct member description to explain the above only
once. Remove parent pointer checks when they are not mandatory (like update
of data->childmask). Remove a warning, which would be nice but the trigger
of this warning is not reliable and add expand the data structure member
description instead. Expand a comment, why it is safe to rely on parent
pointer here (inside hierarchy update).

Fixes: 7ee988770326 ("timers: Implement the hierarchical pull model")
Reported-by: Borislav Petkov <bp@alien8.de>
Signed-off-by: Anna-Maria Behnsen <anna-maria@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Frederic Weisbecker <frederic@kernel.org>
Link: https://lore.kernel.org/r/20240716-tmigr-fixes-v4-1-757baa7803fe@linutronix.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/time/timer_migration.c | 33 +++++++++++++++------------------
 kernel/time/timer_migration.h | 12 +++++++++++-
 2 files changed, 26 insertions(+), 19 deletions(-)

diff --git a/kernel/time/timer_migration.c b/kernel/time/timer_migration.c
index 84413114db5c5..d91efe1dc3bf5 100644
--- a/kernel/time/timer_migration.c
+++ b/kernel/time/timer_migration.c
@@ -507,7 +507,14 @@ static void walk_groups(up_f up, void *data, struct tmigr_cpu *tmc)
  *			(get_next_timer_interrupt())
  * @firstexp:		Contains the first event expiry information when last
  *			active CPU of hierarchy is on the way to idle to make
- *			sure CPU will be back in time.
+ *			sure CPU will be back in time. It is updated in top
+ *			level group only. Be aware, there could occur a new top
+ *			level of the hierarchy between the 'top level call' in
+ *			tmigr_update_events() and the check for the parent group
+ *			in walk_groups(). Then @firstexp might contain a value
+ *			!= KTIME_MAX even if it was not the final top
+ *			level. This is not a problem, as the worst outcome is a
+ *			CPU which might wake up a little early.
  * @evt:		Pointer to tmigr_event which needs to be queued (of idle
  *			child group)
  * @childmask:		childmask of child group
@@ -649,7 +656,7 @@ static bool tmigr_active_up(struct tmigr_group *group,
 
 	} while (!atomic_try_cmpxchg(&group->migr_state, &curstate.state, newstate.state));
 
-	if ((walk_done == false) && group->parent)
+	if (walk_done == false)
 		data->childmask = group->childmask;
 
 	/*
@@ -1317,20 +1324,9 @@ static bool tmigr_inactive_up(struct tmigr_group *group,
 	/* Event Handling */
 	tmigr_update_events(group, child, data);
 
-	if (group->parent && (walk_done == false))
+	if (walk_done == false)
 		data->childmask = group->childmask;
 
-	/*
-	 * data->firstexp was set by tmigr_update_events() and contains the
-	 * expiry of the first global event which needs to be handled. It
-	 * differs from KTIME_MAX if:
-	 * - group is the top level group and
-	 * - group is idle (which means CPU was the last active CPU in the
-	 *   hierarchy) and
-	 * - there is a pending event in the hierarchy
-	 */
-	WARN_ON_ONCE(data->firstexp != KTIME_MAX && group->parent);
-
 	trace_tmigr_group_set_cpu_inactive(group, newstate, childmask);
 
 	return walk_done;
@@ -1552,10 +1548,11 @@ static void tmigr_connect_child_parent(struct tmigr_group *child,
 		data.childmask = child->childmask;
 
 		/*
-		 * There is only one new level per time. When connecting the
-		 * child and the parent and set the child active when the parent
-		 * is inactive, the parent needs to be the uppermost
-		 * level. Otherwise there went something wrong!
+		 * There is only one new level per time (which is protected by
+		 * tmigr_mutex). When connecting the child and the parent and
+		 * set the child active when the parent is inactive, the parent
+		 * needs to be the uppermost level. Otherwise there went
+		 * something wrong!
 		 */
 		WARN_ON(!tmigr_active_up(parent, child, &data) && parent->parent);
 	}
diff --git a/kernel/time/timer_migration.h b/kernel/time/timer_migration.h
index 6c37d94a37d90..494f68cc13f4b 100644
--- a/kernel/time/timer_migration.h
+++ b/kernel/time/timer_migration.h
@@ -22,7 +22,17 @@ struct tmigr_event {
  * struct tmigr_group - timer migration hierarchy group
  * @lock:		Lock protecting the event information and group hierarchy
  *			information during setup
- * @parent:		Pointer to the parent group
+ * @parent:		Pointer to the parent group. Pointer is updated when a
+ *			new hierarchy level is added because of a CPU coming
+ *			online the first time. Once it is set, the pointer will
+ *			not be removed or updated. When accessing parent pointer
+ *			lock less to decide whether to abort a propagation or
+ *			not, it is not a problem. The worst outcome is an
+ *			unnecessary/early CPU wake up. But do not access parent
+ *			pointer several times in the same 'action' (like
+ *			activation, deactivation, check for remote expiry,...)
+ *			without holding the lock as it is not ensured that value
+ *			will not change.
  * @groupevt:		Next event of the group which is only used when the
  *			group is !active. The group event is then queued into
  *			the parent timer queue.
-- 
2.43.0



