Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD2D947044B;
	Sat, 12 Sep 2026 10:59:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210791; cv=none; b=SgwHHlIsxC7c4wPktCjULB9K97E/80gQapWUtqhC6l5QJZ88YkLX7HzZ1ww013drXakRa135zj3jJr7tApG2XfwzixL+GkyMf/Jcta1Uea+NqRG2dm64d40nOXiOqP0R2eQmXuN3dXknWdrSEebRMyDJ56OHPbVvS6tsOpFUxCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210791; c=relaxed/simple;
	bh=2W7ESZqc/GIZR91oy2yA7aymS7j1TIsrRSDm9Daz+wA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1HxhM+8/A/v59kfLJVm01Onr6J0l6oauDGcTS27nJmckgM1y6sAyPzWuOw6QKSrs6I4zDjG1TvcxWb1VgiHRlvrQRc0BMHgRTmqUTKTK2E1gDp6alR03a7dX3+dcSvANjU+GxM3AqZbXlTcUP7syT2G/jfXiMuz2AitQTccndA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V19p7oFW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V19p7oFW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2BE2F1F000FF;
	Sat, 12 Sep 2026 10:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210784;
	bh=mub6Em2TQF5Lar2G5+4lfOrwBnXxRxTNIrchTzbesbo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V19p7oFW0wJ246VqmmHcPD6xp3J96RDLH7dF77lyPVqg2fd7t5ULbJ8ftFrhOe3vS
	 AqRR1h13JlI6n5MBLvHQukXJcULo06aKNIZ+PFhco2pg8o1JXUrlUfG46bdJm5BUnQ
	 PTdu5wqHTF/hSM861Cse/aa1Erct15lLoJqG3k44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1095/1518] apparmor: fix unconfined user namespace restriction forced stack
Date: Sat, 12 Sep 2026 08:54:24 +0200
Message-ID: <20260912065648.222908861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit 08c2f7c8d4b1434cfae006f3daf4d1bce330b57b ]

If a task is already confined by a stack the unprivileged transition
restriction on unconfined is not correctly, applied. This results in
an escape if two transitions through an unconfined profile can be
executed.

Fix this by pushing the check into the per profile label build. The
check will always be done against unconfined and result in a stack of
just the unconfined component when necessary.

Fixes: 2d9da9b188b8 ("apparmor: allow restricting unprivileged change_profile")
Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/domain.c | 80 +++++++++++++++++++++++++-------------
 1 file changed, 54 insertions(+), 26 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index aed9f9fd47d0e..d8f3aba9b358e 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -874,6 +874,52 @@ static struct aa_label *label_merge_wrap(struct aa_label *a, struct aa_label *b,
 	return label;
 }
 
+static bool is_profile_priv_restricted_to_stack(const struct cred *subj_cred,
+						struct aa_profile *profile)
+{
+	if (profile_unconfined(profile) && profile == profile->ns->unconfined &&
+	    aa_unprivileged_unconfined_restricted &&
+	    /* cap_capable returns false (0) if true, hence true here means
+	     * doesn't have capability and the stack will be restricted
+	     */
+	    cap_capable(current_cred(), &init_user_ns, CAP_MAC_OVERRIDE,
+			CAP_OPT_NOAUDIT))
+		return true;
+	return false;
+}
+
+static const char *stack_msg = "change_profile unprivileged unconfined converted to stacking";
+
+static struct aa_label *priv_restricted_transition(const struct cred *subj_cred,
+						   struct aa_profile *profile,
+						   const char *op, u32 request,
+						   const char *name,
+						   struct aa_label *transition,
+						   gfp_t gfp)
+{
+	if (!is_profile_priv_restricted_to_stack(subj_cred, profile))
+		return aa_get_newest_label(transition);
+
+	/* transition allowed but only via stack */
+	struct aa_label *target = label_merge_wrap(&profile->label,
+						      transition, gfp);
+	if (IS_ERR_OR_NULL(target))
+		return target;
+
+	/* doing this here is less than optimal but good enough until the
+	 * fs mediation rework lands
+	 */
+	struct aa_perms perms = {
+		.allow = request,
+		.audit = request,
+	};
+	aa_audit_file(subj_cred, profile, &perms, op,
+		      request, name, NULL, target,
+		      subj_cred->euid, stack_msg, 0);
+
+	return target;
+}
+
 static struct aa_label *handle_onexec(const struct cred *subj_cred,
 				      struct aa_label *label,
 				      struct aa_label *onexec, bool stack,
@@ -902,7 +948,10 @@ static struct aa_label *handle_onexec(const struct cred *subj_cred,
 	new = fn_label_build_in_scope(label, profile, GFP_KERNEL,
 			stack ? label_merge_wrap(&profile->label, onexec,
 						 GFP_KERNEL)
-			      : aa_get_newest_label(onexec),
+			      : priv_restricted_transition(subj_cred, profile,
+						OP_CHANGE_ONEXEC, AA_MAY_ONEXEC,
+						bprm->filename, onexec,
+						GFP_KERNEL),
 			profile_transition(subj_cred, profile, bprm,
 					   buffer, cond, unsafe));
 	AA_BUG(!new);
@@ -1406,8 +1455,6 @@ static int change_profile_perms_wrapper(const char *op, const char *name,
 	return error;
 }
 
-static const char *stack_msg = "change_profile unprivileged unconfined converted to stacking";
-
 /**
  * aa_change_profile - perform a one-way profile transition
  * @fqname: name of profile may include namespace (NOT NULL)
@@ -1467,28 +1514,6 @@ int aa_change_profile(const char *fqname, int flags)
 			op = OP_CHANGE_PROFILE;
 	}
 
-	/* This should move to a per profile test. Requires pushing build
-	 * into callback
-	 */
-	if (!stack && unconfined(label) &&
-	    label == &labels_ns(label)->unconfined->label &&
-	    aa_unprivileged_unconfined_restricted &&
-	    /* TODO: refactor so this check is a fn */
-	    cap_capable(current_cred(), &init_user_ns, CAP_MAC_OVERRIDE,
-			CAP_OPT_NOAUDIT)) {
-		/* regardless of the request in this case apparmor
-		 * stacks against unconfined so admin set policy can't be
-		 * by-passed
-		 */
-		stack = true;
-		perms.audit = request;
-		(void) fn_for_each_in_scope(label, profile,
-				aa_audit_file(subj_cred, profile, &perms, op,
-					      request, auditname, NULL, target,
-					      GLOBAL_ROOT_UID, stack_msg, 0));
-		perms.audit = 0;
-	}
-
 	if (*fqname == '&') {
 		stack = true;
 		/* don't have label_parse() do stacking */
@@ -1559,7 +1584,10 @@ int aa_change_profile(const char *fqname, int flags)
 	/* stacking is always a subset, so only check the nonstack case */
 	if (!stack) {
 		new = fn_label_build_in_scope(label, profile, GFP_KERNEL,
-					   aa_get_label(target),
+				priv_restricted_transition(subj_cred, profile,
+							   op, request,
+							   auditname, target,
+							   GFP_KERNEL),
 					   aa_get_label(&profile->label));
 		AA_BUG(!new);
 		if (IS_ERR(new))
-- 
2.53.0



