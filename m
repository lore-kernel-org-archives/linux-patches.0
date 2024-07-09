Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE7AC157E61;
	Tue,  9 Jul 2024 11:18:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720523889; cv=none; b=QruSwyYZWKUoPJNMuVcAO3VBdQkMR5JnqJa57hfyGv9312GHTYcQEpmgc5f12i96vOG3bFVlxYmH+y1l0n24+yxPAsGUaTBJitQM74EH5AHqjqymcQLeYu5ckNdNbROg3KOblR9l82zjUNgyeVmFDe4sI79a7SFmKU4enLIgUBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720523889; c=relaxed/simple;
	bh=cTDOHTUvXBzTcjIKJMWw2LIcwfRqVSIMOTXm0MuTRsU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L5jCBAY2dQn8/Uk6sa8X9WXgg6UgVR8coDhIDO/uKsRLTYdkG1JSiU2r9upKhvGKhnvZ8RQQok+0JblrjhgCfPWL7qqyPP8TcyZh/xnV1WxfZ9fs5CKE2KLOxWP2YUOEaEYUkbYd/BRjwwAN2tm3Zn7FCkmO3kFeK1I/fFl2lq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2LeSHv9l; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2LeSHv9l"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7558EC3277B;
	Tue,  9 Jul 2024 11:18:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720523888;
	bh=cTDOHTUvXBzTcjIKJMWw2LIcwfRqVSIMOTXm0MuTRsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2LeSHv9l+0bacB1aQZ/QcNwlB9YDQVx2vt/W8d2v5qZAxNvmzKzp3Di6iSA4/XvF6
	 eXK4WtHNLiADt7//OEQ2u4/MBWQuGrJ9Rgg7o86xdaWxdr2DhgX4+wF8tJT1qiRFBi
	 dykPS7n1NN0v8X+iezxhpD29w8SwCqXDN1F2bNmQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	GUO Zihua <guozihua@huawei.com>,
	John Johansen <john.johansen@canonical.com>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Casey Schaufler <casey@schaufler-ca.com>,
	Paul Moore <paul@paul-moore.com>
Subject: [PATCH 6.6 116/139] ima: Avoid blocking in RCU read-side critical section
Date: Tue,  9 Jul 2024 13:10:16 +0200
Message-ID: <20240709110702.656504280@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110658.146853929@linuxfoundation.org>
References: <20240709110658.146853929@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: GUO Zihua <guozihua@huawei.com>

commit 9a95c5bfbf02a0a7f5983280fe284a0ff0836c34 upstream.

A panic happens in ima_match_policy:

BUG: unable to handle kernel NULL pointer dereference at 0000000000000010
PGD 42f873067 P4D 0
Oops: 0000 [#1] SMP NOPTI
CPU: 5 PID: 1286325 Comm: kubeletmonit.sh
Kdump: loaded Tainted: P
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996),
               BIOS 0.0.0 02/06/2015
RIP: 0010:ima_match_policy+0x84/0x450
Code: 49 89 fc 41 89 cf 31 ed 89 44 24 14 eb 1c 44 39
      7b 18 74 26 41 83 ff 05 74 20 48 8b 1b 48 3b 1d
      f2 b9 f4 00 0f 84 9c 01 00 00 <44> 85 73 10 74 ea
      44 8b 6b 14 41 f6 c5 01 75 d4 41 f6 c5 02 74 0f
RSP: 0018:ff71570009e07a80 EFLAGS: 00010207
RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000200
RDX: ffffffffad8dc7c0 RSI: 0000000024924925 RDI: ff3e27850dea2000
RBP: 0000000000000000 R08: 0000000000000000 R09: ffffffffabfce739
R10: ff3e27810cc42400 R11: 0000000000000000 R12: ff3e2781825ef970
R13: 00000000ff3e2785 R14: 000000000000000c R15: 0000000000000001
FS:  00007f5195b51740(0000)
GS:ff3e278b12d40000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000010 CR3: 0000000626d24002 CR4: 0000000000361ee0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ima_get_action+0x22/0x30
 process_measurement+0xb0/0x830
 ? page_add_file_rmap+0x15/0x170
 ? alloc_set_pte+0x269/0x4c0
 ? prep_new_page+0x81/0x140
 ? simple_xattr_get+0x75/0xa0
 ? selinux_file_open+0x9d/0xf0
 ima_file_check+0x64/0x90
 path_openat+0x571/0x1720
 do_filp_open+0x9b/0x110
 ? page_counter_try_charge+0x57/0xc0
 ? files_cgroup_alloc_fd+0x38/0x60
 ? __alloc_fd+0xd4/0x250
 ? do_sys_open+0x1bd/0x250
 do_sys_open+0x1bd/0x250
 do_syscall_64+0x5d/0x1d0
 entry_SYSCALL_64_after_hwframe+0x65/0xca

Commit c7423dbdbc9e ("ima: Handle -ESTALE returned by
ima_filter_rule_match()") introduced call to ima_lsm_copy_rule within a
RCU read-side critical section which contains kmalloc with GFP_KERNEL.
This implies a possible sleep and violates limitations of RCU read-side
critical sections on non-PREEMPT systems.

Sleeping within RCU read-side critical section might cause
synchronize_rcu() returning early and break RCU protection, allowing a
UAF to happen.

The root cause of this issue could be described as follows:
|	Thread A	|	Thread B	|
|			|ima_match_policy	|
|			|  rcu_read_lock	|
|ima_lsm_update_rule	|			|
|  synchronize_rcu	|			|
|			|    kmalloc(GFP_KERNEL)|
|			|      sleep		|
==> synchronize_rcu returns early
|  kfree(entry)		|			|
|			|    entry = entry->next|
==> UAF happens and entry now becomes NULL (or could be anything).
|			|    entry->action	|
==> Accessing entry might cause panic.

To fix this issue, we are converting all kmalloc that is called within
RCU read-side critical section to use GFP_ATOMIC.

Fixes: c7423dbdbc9e ("ima: Handle -ESTALE returned by ima_filter_rule_match()")
Cc: stable@vger.kernel.org
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Acked-by: John Johansen <john.johansen@canonical.com>
Reviewed-by: Mimi Zohar <zohar@linux.ibm.com>
Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>
[PM: fixed missing comment, long lines, !CONFIG_IMA_LSM_RULES case]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/lsm_hook_defs.h       |    2 +-
 include/linux/security.h            |    5 +++--
 kernel/auditfilter.c                |    5 +++--
 security/apparmor/audit.c           |    6 +++---
 security/apparmor/include/audit.h   |    2 +-
 security/integrity/ima/ima.h        |    2 +-
 security/integrity/ima/ima_policy.c |   15 +++++++++------
 security/security.c                 |    6 ++++--
 security/selinux/include/audit.h    |    4 +++-
 security/selinux/ss/services.c      |    5 +++--
 security/smack/smack_lsm.c          |    4 +++-
 11 files changed, 34 insertions(+), 22 deletions(-)

--- a/include/linux/lsm_hook_defs.h
+++ b/include/linux/lsm_hook_defs.h
@@ -390,7 +390,7 @@ LSM_HOOK(int, 0, key_getsecurity, struct
 
 #ifdef CONFIG_AUDIT
 LSM_HOOK(int, 0, audit_rule_init, u32 field, u32 op, char *rulestr,
-	 void **lsmrule)
+	 void **lsmrule, gfp_t gfp)
 LSM_HOOK(int, 0, audit_rule_known, struct audit_krule *krule)
 LSM_HOOK(int, 0, audit_rule_match, u32 secid, u32 field, u32 op, void *lsmrule)
 LSM_HOOK(void, LSM_RET_VOID, audit_rule_free, void *lsmrule)
--- a/include/linux/security.h
+++ b/include/linux/security.h
@@ -1953,7 +1953,8 @@ static inline int security_key_getsecuri
 
 #ifdef CONFIG_AUDIT
 #ifdef CONFIG_SECURITY
-int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule);
+int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule,
+			     gfp_t gfp);
 int security_audit_rule_known(struct audit_krule *krule);
 int security_audit_rule_match(u32 secid, u32 field, u32 op, void *lsmrule);
 void security_audit_rule_free(void *lsmrule);
@@ -1961,7 +1962,7 @@ void security_audit_rule_free(void *lsmr
 #else
 
 static inline int security_audit_rule_init(u32 field, u32 op, char *rulestr,
-					   void **lsmrule)
+					   void **lsmrule, gfp_t gfp)
 {
 	return 0;
 }
--- a/kernel/auditfilter.c
+++ b/kernel/auditfilter.c
@@ -529,7 +529,8 @@ static struct audit_entry *audit_data_to
 			entry->rule.buflen += f_val;
 			f->lsm_str = str;
 			err = security_audit_rule_init(f->type, f->op, str,
-						       (void **)&f->lsm_rule);
+						       (void **)&f->lsm_rule,
+						       GFP_KERNEL);
 			/* Keep currently invalid fields around in case they
 			 * become valid after a policy reload. */
 			if (err == -EINVAL) {
@@ -799,7 +800,7 @@ static inline int audit_dupe_lsm_field(s
 
 	/* our own (refreshed) copy of lsm_rule */
 	ret = security_audit_rule_init(df->type, df->op, df->lsm_str,
-				       (void **)&df->lsm_rule);
+				       (void **)&df->lsm_rule, GFP_KERNEL);
 	/* Keep currently invalid fields around in case they
 	 * become valid after a policy reload. */
 	if (ret == -EINVAL) {
--- a/security/apparmor/audit.c
+++ b/security/apparmor/audit.c
@@ -217,7 +217,7 @@ void aa_audit_rule_free(void *vrule)
 	}
 }
 
-int aa_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
+int aa_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule, gfp_t gfp)
 {
 	struct aa_audit_rule *rule;
 
@@ -230,14 +230,14 @@ int aa_audit_rule_init(u32 field, u32 op
 		return -EINVAL;
 	}
 
-	rule = kzalloc(sizeof(struct aa_audit_rule), GFP_KERNEL);
+	rule = kzalloc(sizeof(struct aa_audit_rule), gfp);
 
 	if (!rule)
 		return -ENOMEM;
 
 	/* Currently rules are treated as coming from the root ns */
 	rule->label = aa_label_parse(&root_ns->unconfined->label, rulestr,
-				     GFP_KERNEL, true, false);
+				     gfp, true, false);
 	if (IS_ERR(rule->label)) {
 		int err = PTR_ERR(rule->label);
 		aa_audit_rule_free(rule);
--- a/security/apparmor/include/audit.h
+++ b/security/apparmor/include/audit.h
@@ -193,7 +193,7 @@ static inline int complain_error(int err
 }
 
 void aa_audit_rule_free(void *vrule);
-int aa_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule);
+int aa_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule, gfp_t gfp);
 int aa_audit_rule_known(struct audit_krule *rule);
 int aa_audit_rule_match(u32 sid, u32 field, u32 op, void *vrule);
 
--- a/security/integrity/ima/ima.h
+++ b/security/integrity/ima/ima.h
@@ -430,7 +430,7 @@ static inline void ima_free_modsig(struc
 #else
 
 static inline int ima_filter_rule_init(u32 field, u32 op, char *rulestr,
-				       void **lsmrule)
+				       void **lsmrule, gfp_t gfp)
 {
 	return -EINVAL;
 }
--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -401,7 +401,8 @@ static void ima_free_rule(struct ima_rul
 	kfree(entry);
 }
 
-static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry)
+static struct ima_rule_entry *ima_lsm_copy_rule(struct ima_rule_entry *entry,
+						gfp_t gfp)
 {
 	struct ima_rule_entry *nentry;
 	int i;
@@ -410,7 +411,7 @@ static struct ima_rule_entry *ima_lsm_co
 	 * Immutable elements are copied over as pointers and data; only
 	 * lsm rules can change
 	 */
-	nentry = kmemdup(entry, sizeof(*nentry), GFP_KERNEL);
+	nentry = kmemdup(entry, sizeof(*nentry), gfp);
 	if (!nentry)
 		return NULL;
 
@@ -425,7 +426,8 @@ static struct ima_rule_entry *ima_lsm_co
 
 		ima_filter_rule_init(nentry->lsm[i].type, Audit_equal,
 				     nentry->lsm[i].args_p,
-				     &nentry->lsm[i].rule);
+				     &nentry->lsm[i].rule,
+				     gfp);
 		if (!nentry->lsm[i].rule)
 			pr_warn("rule for LSM \'%s\' is undefined\n",
 				nentry->lsm[i].args_p);
@@ -438,7 +440,7 @@ static int ima_lsm_update_rule(struct im
 	int i;
 	struct ima_rule_entry *nentry;
 
-	nentry = ima_lsm_copy_rule(entry);
+	nentry = ima_lsm_copy_rule(entry, GFP_KERNEL);
 	if (!nentry)
 		return -ENOMEM;
 
@@ -664,7 +666,7 @@ retry:
 		}
 
 		if (rc == -ESTALE && !rule_reinitialized) {
-			lsm_rule = ima_lsm_copy_rule(rule);
+			lsm_rule = ima_lsm_copy_rule(rule, GFP_ATOMIC);
 			if (lsm_rule) {
 				rule_reinitialized = true;
 				goto retry;
@@ -1140,7 +1142,8 @@ static int ima_lsm_rule_init(struct ima_
 	entry->lsm[lsm_rule].type = audit_type;
 	result = ima_filter_rule_init(entry->lsm[lsm_rule].type, Audit_equal,
 				      entry->lsm[lsm_rule].args_p,
-				      &entry->lsm[lsm_rule].rule);
+				      &entry->lsm[lsm_rule].rule,
+				      GFP_KERNEL);
 	if (!entry->lsm[lsm_rule].rule) {
 		pr_warn("rule for LSM \'%s\' is undefined\n",
 			entry->lsm[lsm_rule].args_p);
--- a/security/security.c
+++ b/security/security.c
@@ -5116,15 +5116,17 @@ int security_key_getsecurity(struct key
  * @op: rule operator
  * @rulestr: rule context
  * @lsmrule: receive buffer for audit rule struct
+ * @gfp: GFP flag used for kmalloc
  *
  * Allocate and initialize an LSM audit rule structure.
  *
  * Return: Return 0 if @lsmrule has been successfully set, -EINVAL in case of
  *         an invalid rule.
  */
-int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule)
+int security_audit_rule_init(u32 field, u32 op, char *rulestr, void **lsmrule,
+			     gfp_t gfp)
 {
-	return call_int_hook(audit_rule_init, 0, field, op, rulestr, lsmrule);
+	return call_int_hook(audit_rule_init, 0, field, op, rulestr, lsmrule, gfp);
 }
 
 /**
--- a/security/selinux/include/audit.h
+++ b/security/selinux/include/audit.h
@@ -21,12 +21,14 @@
  *	@op: the operator the rule uses
  *	@rulestr: the text "target" of the rule
  *	@rule: pointer to the new rule structure returned via this
+ *	@gfp: GFP flag used for kmalloc
  *
  *	Returns 0 if successful, -errno if not.  On success, the rule structure
  *	will be allocated internally.  The caller must free this structure with
  *	selinux_audit_rule_free() after use.
  */
-int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **rule);
+int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **rule,
+			    gfp_t gfp);
 
 /**
  *	selinux_audit_rule_free - free an selinux audit rule structure.
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -3497,7 +3497,8 @@ void selinux_audit_rule_free(void *vrule
 	}
 }
 
-int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
+int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule,
+			    gfp_t gfp)
 {
 	struct selinux_state *state = &selinux_state;
 	struct selinux_policy *policy;
@@ -3538,7 +3539,7 @@ int selinux_audit_rule_init(u32 field, u
 		return -EINVAL;
 	}
 
-	tmprule = kzalloc(sizeof(struct selinux_audit_rule), GFP_KERNEL);
+	tmprule = kzalloc(sizeof(struct selinux_audit_rule), gfp);
 	if (!tmprule)
 		return -ENOMEM;
 	context_init(&tmprule->au_ctxt);
--- a/security/smack/smack_lsm.c
+++ b/security/smack/smack_lsm.c
@@ -4616,11 +4616,13 @@ static int smack_post_notification(const
  * @op: required testing operator (=, !=, >, <, ...)
  * @rulestr: smack label to be audited
  * @vrule: pointer to save our own audit rule representation
+ * @gfp: type of the memory for the allocation
  *
  * Prepare to audit cases where (@field @op @rulestr) is true.
  * The label to be audited is created if necessay.
  */
-static int smack_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule)
+static int smack_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule,
+				 gfp_t gfp)
 {
 	struct smack_known *skp;
 	char **rule = (char **)vrule;


