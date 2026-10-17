Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F3AE2EA15C;
	Sat, 17 Oct 2026 17:18:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257495; cv=none; b=mpO9084qf9efQD4BICguiGvxp3yuUXyDyD9P+sjVtWpt8G/bepOhM1dsCQ96u16uYVL2ivOqu4Es4RuqvKwu5n6TAKm8Hbzjul7JfUuGJEBxBzcS6JbQXLHH/uMwhEGFkLVVfFkzowlEdJjf6NiAj4gdQTVyzuSosOWuqMT17tk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257495; c=relaxed/simple;
	bh=OK6lkE8j6oZUpTGUMOBLLR39VrvQoyyj51TsABN7vgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DtVYxvYXZ5QWnTrCNeY9RKw+/ifH49olY5DPHI2YkTClE5E7FPhOTndqBXn7IkhhhsiO1eqkz3p7Ac6Z11qpZ748jTgSYhh65HRl/1B+JjNW2IC1Zb7TPc+tj1SUf5fSeiQ1iQONIFGNNiZpTtF5K9SJVVZt011jDuCLtIDOXxw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xnTM/X7R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xnTM/X7R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 80AF81F000C4;
	Sat, 17 Oct 2026 17:18:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257494;
	bh=HqbpEw0Mssn3KkkALCcXYGt8e/gp+Rsm4n77Idge+2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xnTM/X7RGfzqUyWPVwmuiGLyVR5rEIN2W42fI0lMWaB8Sg7clXsszXqnOKWuY3G/O
	 xLabXYCK3UC+C0liyD4DUYNNEz/6SFEI6UWI0Z1NvWGJnHTEmWGoLv9NAbck1iuCom
	 JhFPhk4SLLddwvHp8kVPv+KJJUIIstbEwrURsIGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jann Horn <jannh@google.com>,
	John Johansen <john.johansen@canonical.com>,
	Artem Dinaburg <artem@trailofbits.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0578/1674] apparmor: fix cred UAF caused by begin_current_label_crit_section()
Date: Sat, 17 Oct 2026 17:47:30 +0200
Message-ID: <20261017160445.928099010@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jann Horn <jannh@google.com>

[ Upstream commit 3f4ae5fab613dca01d6a2a8210dd832e009fcf47 ]

AppArmor's begin_current_label_crit_section() is a scary function called
from lots of LSM hooks (in particular VFS/socket-related ones) that checks
if the label referenced by the current creds is marked FLAG_STALE, and if
so, attempts to use aa_replace_current_label() to replace the creds with an
updated version that uses a new label.

The first problem with this is that it would directly lead to UAF of
`struct cred` if anything in the kernel takes a pointer to the current
creds and accesses these past a security hook invocation that replaces
creds, like so:
```
const struct cred *cred = current_cred();
alloc_file_pseudo(...);
uid_t uid = cred->euid;
```
I don't know if anything in the kernel actually does this, but I think it
is very surprising that this pattern could lead to UAF.

The second problem is that things go wrong when aa_replace_current_label()
runs with overridden credentials. aa_replace_current_label() bails out if
`current_cred() != current_real_cred()` (mirroring the check in
proc_pid_attr_write()), but this check can't actually reliably detect
overridden credentials because the overridden creds can be the same as the
objective creds.

So in approximately the following scenario, things go wrong:

1. task begins with <creds A> (as both objective and subjective creds),
   with refcount=2
2. task grabs an extra reference on <creds A> for overriding
3. task calls override_creds(<creds A>), which returns a pointer to the old
   subjective creds (<creds A>)
4. task enters AppArmor LSM hook
5. AppArmor checks that objective/subjective creds are equal
6. AppArmor replaces both cred pointers with <creds B> and drops 2 refs on
   <creds A>
7. task leaves AppArmor LSM hook
8. task calls revert_creds(<creds A>)
9. now task->cred is <creds A> while task->real_cred is <creds B>, but the
   task_struct logically holds two references to <creds B>
10. another task drops the extra reference on <creds A> that was used for
    overriding, refcount drops to 0
11. now task->real_cred points to freed creds

At this point, any access to current_cred() will be UAF.

I have a test case where I run aa-disable on a profile while a process
using that profile is blocked on splice() from a FUSE passthrough file into
a full pipe; after the profile update, the pipe becomes empty, splice()
resumes, the credentials go out of sync, and a subsequent getuid() syscall
results in a KASAN UAF splat.

To fix this, instead of directly replacing creds, do it via task_work that
will run at the end of the current syscall. (The point in time at which the
cred replacement happens should have no correctness impact; it is just a
performance optimization to avoid unnecessarily touching the refcount of
the new label.)

Note that AppArmor still performs direct cred replacements in the
sb_pivotroot LSM hook after this change, and that direct cred replacements
can still happen in VFS ->write() callbacks via proc_pid_attr_write().

There are two options for what to do with aa_dup_task_ctx(): Either
explicitly reset new->label_replacement_pending after the entire
aa_task_ctx has been copied, or switch to manually copying members over.
I am switching to manually copying members over because that should make
bugs more obvious.

Cc: stable@vger.kernel.org
Fixes: c75afcd153f6 ("AppArmor: contexts used in attaching policy to system objects")
Signed-off-by: Jann Horn <jannh@google.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Assisted-by: LLM
Signed-off-by: Artem Dinaburg <artem@trailofbits.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/include/cred.h |  6 +-----
 security/apparmor/include/task.h | 15 +++++++++++----
 security/apparmor/task.c         | 27 +++++++++++++++++++++++++++
 3 files changed, 39 insertions(+), 9 deletions(-)

diff --git a/security/apparmor/include/cred.h b/security/apparmor/include/cred.h
index 58fdc72af6645..3fea4da22d08c 100644
--- a/security/apparmor/include/cred.h
+++ b/security/apparmor/include/cred.h
@@ -148,13 +148,9 @@ static inline struct aa_label *begin_current_label_crit_section(void)
 {
 	struct aa_label *label = aa_current_raw_label();
 
-	might_sleep();
-
 	if (label_is_stale(label)) {
 		label = aa_get_newest_label(label);
-		if (aa_replace_current_label(label) == 0)
-			/* task cred will keep the reference */
-			aa_put_label(label);
+		aa_schedule_stale_label_replacement();
 	}
 
 	return label;
diff --git a/security/apparmor/include/task.h b/security/apparmor/include/task.h
index 29ba55107b7d6..9bf4aaa0aa13d 100644
--- a/security/apparmor/include/task.h
+++ b/security/apparmor/include/task.h
@@ -21,15 +21,22 @@ static inline struct aa_task_ctx *task_ctx(struct task_struct *task)
  * @onexec: profile to transition to on next exec  (MAY BE NULL)
  * @previous: profile the task may return to     (MAY BE NULL)
  * @token: magic value the task must know for returning to @previous_profile
+ * @label_replacement_tw: for aa_schedule_stale_label_replacement()
+ * @label_replacement_pending: is @label_replacement_tw pending?
+ *
+ * When changing this, check if aa_dup_task_ctx() needs to be updated.
  */
 struct aa_task_ctx {
 	struct aa_label *nnp;
 	struct aa_label *onexec;
 	struct aa_label *previous;
 	u64 token;
+	struct callback_head label_replacement_tw;
+	bool label_replacement_pending;
 };
 
 int aa_replace_current_label(struct aa_label *label);
+void aa_schedule_stale_label_replacement(void);
 int aa_set_current_onexec(struct aa_label *label, bool stack);
 int aa_set_current_hat(struct aa_label *label, u64 token);
 int aa_restore_previous_label(u64 cookie);
@@ -56,10 +63,10 @@ static inline void aa_free_task_ctx(struct aa_task_ctx *ctx)
 static inline void aa_dup_task_ctx(struct aa_task_ctx *new,
 				   const struct aa_task_ctx *old)
 {
-	*new = *old;
-	aa_get_label(new->nnp);
-	aa_get_label(new->previous);
-	aa_get_label(new->onexec);
+	new->nnp = aa_get_label(old->nnp);
+	new->onexec = aa_get_label(old->onexec);
+	new->previous = aa_get_label(old->previous);
+	new->token = old->token;
 }
 
 /**
diff --git a/security/apparmor/task.c b/security/apparmor/task.c
index 0d7af707cccdd..3dd62624e88f8 100644
--- a/security/apparmor/task.c
+++ b/security/apparmor/task.c
@@ -14,6 +14,7 @@
 
 #include <linux/gfp.h>
 #include <linux/ptrace.h>
+#include <linux/task_work.h>
 
 #include "include/audit.h"
 #include "include/cred.h"
@@ -88,6 +89,32 @@ int aa_replace_current_label(struct aa_label *label)
 	return 0;
 }
 
+static void aa_replace_stale_label_tw_func(struct callback_head *tw)
+{
+	struct aa_task_ctx *ctx = task_ctx(current);
+	struct aa_label *label;
+
+	ctx->label_replacement_pending = false;
+	label = aa_current_raw_label();
+	if (!label_is_stale(label))
+		return;
+	label = aa_get_newest_label(label);
+	aa_replace_current_label(label);
+	aa_put_label(label);
+}
+
+/* replace the current task's stale label on syscall return */
+void aa_schedule_stale_label_replacement(void)
+{
+	struct aa_task_ctx *ctx = task_ctx(current);
+
+	if (ctx->label_replacement_pending)
+		return;
+	init_task_work(&ctx->label_replacement_tw, aa_replace_stale_label_tw_func);
+	if (task_work_add(current, &ctx->label_replacement_tw, TWA_RESUME) == 0)
+		ctx->label_replacement_pending = true;
+}
+
 
 /**
  * aa_set_current_onexec - set the tasks change_profile to happen onexec
-- 
2.53.0



