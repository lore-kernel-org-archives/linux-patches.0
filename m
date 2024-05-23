Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F29BB14B955;
	Thu, 23 May 2024 13:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470200; cv=none; b=mxCB9/mqm4Y1gTu42CzRV0SYVCLN3Z2nZsLXXO3p4EUkw/bD0t85PEBj5YNm6kaaizaxlVePZNPBUTpjKy2zDSNuUZHg6VQNcublqzyEO71Vb/vk4Ab6Ttd5wOhJGMuZhIoHGYPBla20gg0DKhvq9+RTvpzqqSSmjJ9D8XxueZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470200; c=relaxed/simple;
	bh=coHV7cK9U7GffXQ0kq2o2gTUQBGK8YuQV6blCCWmoUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ten48e/ehCQxD1YKdwX2kDvuAwKWflE3G+OO8KgpQFg4+dUYeF1pqCOH/7jrrOgCdo33tnHaQgldYQT0i84zoflg1xOOGt6dG7lhK2N+7FVmITHmz5XAFiuRzmmvePjj3OGalXuKUAFnoMLKGJaVPPkk1yN4vRuELbW/u0R9NxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aCsEOz+q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aCsEOz+q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74D61C32782;
	Thu, 23 May 2024 13:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470199;
	bh=coHV7cK9U7GffXQ0kq2o2gTUQBGK8YuQV6blCCWmoUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aCsEOz+qPCws3BaMLHNAwKl1Tt1i02OlfpQUM/8Ym68YCpzw2dsiQ3NP59iONsiJu
	 6Asf5Fu7Ce4hSvsBjA8h7BAuzXQCkWXYgRlKGUgGLpldRLhWX6gYIFy8QqQSd+E+yS
	 uyWGnBFhjEH2VZpz25i4jN33dkV3bJ+zcS6V8Bkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	liqiong <liqiong@nfschina.com>,
	THOBY Simon <Simon.THOBY@viveris.fr>,
	Mimi Zohar <zohar@linux.ibm.com>,
	GUO Zihua <guozihua@huawei.com>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH 5.10 06/15] ima: fix deadlock when traversing "ima_default_rules".
Date: Thu, 23 May 2024 15:12:48 +0200
Message-ID: <20240523130326.696422945@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: liqiong <liqiong@nfschina.com>

commit eb0782bbdfd0d7c4786216659277c3fd585afc0e upstream.

The current IMA ruleset is identified by the variable "ima_rules"
that default to "&ima_default_rules". When loading a custom policy
for the first time, the variable is updated to "&ima_policy_rules"
instead. That update isn't RCU-safe, and deadlocks are possible.
Indeed, some functions like ima_match_policy() may loop indefinitely
when traversing "ima_default_rules" with list_for_each_entry_rcu().

When iterating over the default ruleset back to head, if the list
head is "ima_default_rules", and "ima_rules" have been updated to
"&ima_policy_rules", the loop condition (&entry->list != ima_rules)
stays always true, traversing won't terminate, causing a soft lockup
and RCU stalls.

Introduce a temporary value for "ima_rules" when iterating over
the ruleset to avoid the deadlocks.

Signed-off-by: liqiong <liqiong@nfschina.com>
Reviewed-by: THOBY Simon <Simon.THOBY@viveris.fr>
Fixes: 38d859f991f3 ("IMA: policy can now be updated multiple times")
Reported-by: kernel test robot <lkp@intel.com> (Fix sparse: incompatible types in comparison expression.)
Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
Signed-off-by: GUO Zihua <guozihua@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 security/integrity/ima/ima_policy.c |   29 ++++++++++++++++++++---------
 1 file changed, 20 insertions(+), 9 deletions(-)

--- a/security/integrity/ima/ima_policy.c
+++ b/security/integrity/ima/ima_policy.c
@@ -210,7 +210,7 @@ static struct ima_rule_entry *arch_polic
 static LIST_HEAD(ima_default_rules);
 static LIST_HEAD(ima_policy_rules);
 static LIST_HEAD(ima_temp_rules);
-static struct list_head *ima_rules = &ima_default_rules;
+static struct list_head __rcu *ima_rules = (struct list_head __rcu *)(&ima_default_rules);
 
 static int ima_policy __initdata;
 
@@ -648,12 +648,14 @@ int ima_match_policy(struct inode *inode
 {
 	struct ima_rule_entry *entry;
 	int action = 0, actmask = flags | (flags << 1);
+	struct list_head *ima_rules_tmp;
 
 	if (template_desc)
 		*template_desc = ima_template_desc_current();
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(entry, ima_rules, list) {
+	ima_rules_tmp = rcu_dereference(ima_rules);
+	list_for_each_entry_rcu(entry, ima_rules_tmp, list) {
 
 		if (!(entry->action & actmask))
 			continue;
@@ -701,11 +703,15 @@ int ima_match_policy(struct inode *inode
 void ima_update_policy_flag(void)
 {
 	struct ima_rule_entry *entry;
+	struct list_head *ima_rules_tmp;
 
-	list_for_each_entry(entry, ima_rules, list) {
+	rcu_read_lock();
+	ima_rules_tmp = rcu_dereference(ima_rules);
+	list_for_each_entry_rcu(entry, ima_rules_tmp, list) {
 		if (entry->action & IMA_DO_MASK)
 			ima_policy_flag |= entry->action;
 	}
+	rcu_read_unlock();
 
 	ima_appraise |= (build_ima_appraise | temp_ima_appraise);
 	if (!ima_appraise)
@@ -898,10 +904,10 @@ void ima_update_policy(void)
 
 	list_splice_tail_init_rcu(&ima_temp_rules, policy, synchronize_rcu);
 
-	if (ima_rules != policy) {
+	if (ima_rules != (struct list_head __rcu *)policy) {
 		ima_policy_flag = 0;
-		ima_rules = policy;
 
+		rcu_assign_pointer(ima_rules, policy);
 		/*
 		 * IMA architecture specific policy rules are specified
 		 * as strings and converted to an array of ima_entry_rules
@@ -989,7 +995,7 @@ static int ima_lsm_rule_init(struct ima_
 		pr_warn("rule for LSM \'%s\' is undefined\n",
 			entry->lsm[lsm_rule].args_p);
 
-		if (ima_rules == &ima_default_rules) {
+		if (ima_rules == (struct list_head __rcu *)(&ima_default_rules)) {
 			kfree(entry->lsm[lsm_rule].args_p);
 			entry->lsm[lsm_rule].args_p = NULL;
 			result = -EINVAL;
@@ -1598,9 +1604,11 @@ void *ima_policy_start(struct seq_file *
 {
 	loff_t l = *pos;
 	struct ima_rule_entry *entry;
+	struct list_head *ima_rules_tmp;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(entry, ima_rules, list) {
+	ima_rules_tmp = rcu_dereference(ima_rules);
+	list_for_each_entry_rcu(entry, ima_rules_tmp, list) {
 		if (!l--) {
 			rcu_read_unlock();
 			return entry;
@@ -1619,7 +1627,8 @@ void *ima_policy_next(struct seq_file *m
 	rcu_read_unlock();
 	(*pos)++;
 
-	return (&entry->list == ima_rules) ? NULL : entry;
+	return (&entry->list == &ima_default_rules ||
+		&entry->list == &ima_policy_rules) ? NULL : entry;
 }
 
 void ima_policy_stop(struct seq_file *m, void *v)
@@ -1823,6 +1832,7 @@ bool ima_appraise_signature(enum kernel_
 	struct ima_rule_entry *entry;
 	bool found = false;
 	enum ima_hooks func;
+	struct list_head *ima_rules_tmp;
 
 	if (id >= READING_MAX_ID)
 		return false;
@@ -1834,7 +1844,8 @@ bool ima_appraise_signature(enum kernel_
 	func = read_idmap[id] ?: FILE_CHECK;
 
 	rcu_read_lock();
-	list_for_each_entry_rcu(entry, ima_rules, list) {
+	ima_rules_tmp = rcu_dereference(ima_rules);
+	list_for_each_entry_rcu(entry, ima_rules_tmp, list) {
 		if (entry->action != APPRAISE)
 			continue;
 


