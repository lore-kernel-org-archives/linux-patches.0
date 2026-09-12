Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D33553515C1;
	Sat, 12 Sep 2026 15:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227824; cv=none; b=GQSdBVLczy4cs4WNWpGxdXVgrMJkNkJWxxOQcsSlU8+bA7Wi0Z+bQuS1JVMXM/LqzJkF4aCKN2mnXPnsR1AJcI9ZMhn4ouSsQf7NYBlJe4we258m5Yyc8s6iZX2ZwMsyt69h2uerfX+EHjTHjWKh2g9BqtJTr1e4/Vip0MGuEKc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227824; c=relaxed/simple;
	bh=g28vsrp9DuC1iij5oBMIy4Cc4hCO220OdlUCkGFEdFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBG1lxGZN4UpyyN7PZUuTc7ioI6a33SmDS6UlUtPAdpJN2DuHzNycx10YcnNwsZk1wskPAV3fIBdIgSWd0tYJJhPm7+Od67WSrcHiWFDocS1se9Xnlgmu3uiTbBe3yJ9rchWEhPn5pa7vhlOUjbQ86QLCovA5rBP9o18lw1sQaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TiM7w388; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TiM7w388"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 313641F000FF;
	Sat, 12 Sep 2026 15:43:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227822;
	bh=DGqE2dGG1MAkyxCO6Pb71dpIwuDCQxeH2UxGW4rvsZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TiM7w388DR8YVLVxmNE5lYcAM830xvVbIXbpBEAFZUYC9rfNJlJB3+3bfaN/xQXXi
	 gKA2dY71BWYn9/d0/M1eYGbJ4YboiM8pqh/k1NGwO50SFqTJ+VLe8D0NtGDB/UPWah
	 TslUeutwMTKsaCOTiXtR70krfn83P8d4K8/TCHnI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Christian=20G=C3=B6ttsche?= <cgzones@googlemail.com>,
	Paul Moore <paul@paul-moore.com>,
	Alexander Martyniuk <alexevgmart@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0260/1191] selinux: avoid implicit conversions in services code
Date: Sat, 12 Sep 2026 08:49:48 +0200
Message-ID: <20260912065554.059284887@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Göttsche <cgzones@googlemail.com>

commit c50e125d057152bc68dfd5669b73611343653eb7 upstream.

Use u32 as the output parameter type in security_get_classes() and
security_get_permissions(), based on the type of the symtab nprim
member.

Declare the read-only class string parameter of
security_get_permissions() const.

Avoid several implicit conversions by using the identical type for the
destination.

Use the type identical to the source for local variables.

Signed-off-by: Christian Göttsche <cgzones@googlemail.com>
[PM: cleanup extra whitespace in subject]
Signed-off-by: Paul Moore <paul@paul-moore.com>
Signed-off-by: Alexander Martyniuk <alexevgmart@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/selinux/include/security.h |  4 ++--
 security/selinux/selinuxfs.c        |  7 ++++---
 security/selinux/ss/services.c      | 23 ++++++++++++-----------
 3 files changed, 18 insertions(+), 16 deletions(-)

diff --git a/security/selinux/include/security.h b/security/selinux/include/security.h
index 393aff41d3ef8..4176326ca4f58 100644
--- a/security/selinux/include/security.h
+++ b/security/selinux/include/security.h
@@ -379,9 +379,9 @@ int security_net_peersid_resolve(struct selinux_state *state,
 				 u32 *peer_sid);
 
 int security_get_classes(struct selinux_policy *policy,
-			 char ***classes, int *nclasses);
+			 char ***classes, u32 *nclasses);
 int security_get_permissions(struct selinux_policy *policy,
-			     char *class, char ***perms, int *nperms);
+			     char *class, char ***perms, u32 *nperms);
 int security_get_reject_unknown(struct selinux_state *state);
 int security_get_allow_unknown(struct selinux_state *state);
 
diff --git a/security/selinux/selinuxfs.c b/security/selinux/selinuxfs.c
index ab804d4ea9117..f74fdabaa541b 100644
--- a/security/selinux/selinuxfs.c
+++ b/security/selinux/selinuxfs.c
@@ -1874,7 +1874,8 @@ static int sel_make_perm_files(struct selinux_policy *newpolicy,
 			char *objclass, int classvalue,
 			struct dentry *dir)
 {
-	int i, rc, nperms;
+	u32 i, nperms;
+	int rc;
 	char **perms;
 
 	rc = security_get_permissions(newpolicy, objclass, &perms, &nperms);
@@ -1944,8 +1945,8 @@ static int sel_make_classes(struct selinux_policy *newpolicy,
 			    struct dentry *class_dir,
 			    unsigned long *last_class_ino)
 {
-
-	int rc, nclasses, i;
+	u32 i, nclasses;
+	int rc;
 	char **classes;
 
 	rc = security_get_classes(newpolicy, &classes, &nclasses);
diff --git a/security/selinux/ss/services.c b/security/selinux/ss/services.c
index 48d67b26110bc..80340bc0ee6a7 100644
--- a/security/selinux/ss/services.c
+++ b/security/selinux/ss/services.c
@@ -869,7 +869,7 @@ int security_bounded_transition(struct selinux_state *state,
 	struct sidtab *sidtab;
 	struct sidtab_entry *old_entry, *new_entry;
 	struct type_datum *type;
-	int index;
+	u32 index;
 	int rc;
 
 	if (!selinux_initialized(state))
@@ -1537,7 +1537,7 @@ static int security_context_to_sid_core(struct selinux_state *state,
 		return -ENOMEM;
 
 	if (!selinux_initialized(state)) {
-		int i;
+		u32 i;
 
 		for (i = 1; i < SECINITSID_NUM; i++) {
 			const char *s = initial_sid_to_string[i];
@@ -2886,7 +2886,6 @@ static inline int __security_genfs_sid(struct selinux_policy *policy,
 {
 	struct policydb *policydb = &policy->policydb;
 	struct sidtab *sidtab = policy->sidtab;
-	int len;
 	u16 sclass;
 	struct genfs *genfs;
 	struct ocontext *c;
@@ -2908,7 +2907,7 @@ static inline int __security_genfs_sid(struct selinux_policy *policy,
 		return -ENOENT;
 
 	for (c = genfs->head; c; c = c->next) {
-		len = strlen(c->u.name);
+		size_t len = strlen(c->u.name);
 		if ((!c->v.sclass || sclass == c->v.sclass) &&
 		    (strncmp(c->u.name, path, len) == 0))
 			break;
@@ -3402,7 +3401,7 @@ static int get_classes_callback(void *k, void *d, void *args)
 {
 	struct class_datum *datum = d;
 	char *name = k, **classes = args;
-	int value = datum->value - 1;
+	u32 value = datum->value - 1;
 
 	classes[value] = kstrdup(name, GFP_ATOMIC);
 	if (!classes[value])
@@ -3412,7 +3411,7 @@ static int get_classes_callback(void *k, void *d, void *args)
 }
 
 int security_get_classes(struct selinux_policy *policy,
-			 char ***classes, int *nclasses)
+			 char ***classes, u32 *nclasses)
 {
 	struct policydb *policydb;
 	int rc;
@@ -3428,7 +3427,8 @@ int security_get_classes(struct selinux_policy *policy,
 	rc = hashtab_map(&policydb->p_classes.table, get_classes_callback,
 			 *classes);
 	if (rc) {
-		int i;
+		u32 i;
+
 		for (i = 0; i < *nclasses; i++)
 			kfree((*classes)[i]);
 		kfree(*classes);
@@ -3442,7 +3442,7 @@ static int get_permissions_callback(void *k, void *d, void *args)
 {
 	struct perm_datum *datum = d;
 	char *name = k, **perms = args;
-	int value = datum->value - 1;
+	u32 value = datum->value - 1;
 
 	perms[value] = kstrdup(name, GFP_ATOMIC);
 	if (!perms[value])
@@ -3452,10 +3452,11 @@ static int get_permissions_callback(void *k, void *d, void *args)
 }
 
 int security_get_permissions(struct selinux_policy *policy,
-			     char *class, char ***perms, int *nperms)
+			     char *class, char ***perms, u32 *nperms)
 {
 	struct policydb *policydb;
-	int rc, i;
+	u32 i;
+	int rc;
 	struct class_datum *match;
 
 	policydb = &policy->policydb;
@@ -3675,7 +3676,7 @@ int selinux_audit_rule_init(u32 field, u32 op, char *rulestr, void **vrule,
 /* Check to see if the rule contains any selinux fields */
 int selinux_audit_rule_known(struct audit_krule *rule)
 {
-	int i;
+	u32 i;
 
 	for (i = 0; i < rule->field_count; i++) {
 		struct audit_field *f = &rule->fields[i];
-- 
2.53.0



