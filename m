Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBB1547126A;
	Sat, 12 Sep 2026 10:59:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789210782; cv=none; b=fR4aBhI/sGCBQVDm1Ae4OYa6xTQFu6kgSuenTVzgwZQVjLmFqUDLnPFfA2MSlTz45YehXND083XbU1ZUzO4HHHLPbh+Nn09OCNVJLwFZAM5ARmgkobXiICX4WndhQClCHImA8OpTYcR3KrzR2ln6guEZUebXp5iKGJVtk/+r+5c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789210782; c=relaxed/simple;
	bh=eHEazmxlp4GcKPwE+l/a4mMckm9nYG0MrD8RUgpLS34=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B5uY/k6imYeJcpaJOdgzJUptfvGuuhempVOnP5XTbUWZObxlQ8FaypSRl7bWuUPLyx491td4EH2lpEyx3xU2Wcq803cuAi94LxoQSPu3PtYbp5kdwv1iJlOTJt8tlREuEyTZxWhUGOuw1fY6I0x782+5weH1VpYBTH3ix9LHFU4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GySnrP0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GySnrP0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 559F31F000FF;
	Sat, 12 Sep 2026 10:59:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789210774;
	bh=KE2UL7/0H13WP9DS6uzmVVp4Iydy+9YLdJ4kG13hzXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GySnrP0ANO/3BtX0Ivv6j4A1BxowbNUngO5FH6l2BmS3wG2GLFVtUR1PZ9aWqwqTW
	 AXAY3FW1RpE0glXP7zU1uLw/5fGkwHObbzAkWi8zXh+nxdf5YRpH/4X3OJ/TypPcjY
	 25NE9DNpj+2ogcxRAOkN0pnRqp1ORKxNyi8N0olw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Georgia Garcia <georgia.garcia@canonical.com>,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1094/1518] apparmor: change fn_label_build() call to not return NULL
Date: Sat, 12 Sep 2026 08:54:23 +0200
Message-ID: <20260912065648.199847126@linuxfoundation.org>
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

[ Upstream commit ed7cc1c6f240a0c2838c0617afb2b0466edd236f ]

Previously fn_label_build() was accepting a NULL which represented
ENOMEM return and ERR_PTR for errors.

Clean this up by requiring the cb fn to return an ERR_PTR or valid
value.

Reviewed-by: Georgia Garcia <georgia.garcia@canonical.com>
Signed-off-by: John Johansen <john.johansen@canonical.com>
Stable-dep-of: 08c2f7c8d4b1 ("apparmor: fix unconfined user namespace restriction forced stack")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/domain.c      | 41 ++++++++++++++++++---------------
 security/apparmor/include/lib.h | 12 +++++-----
 security/apparmor/mount.c       | 17 +++++---------
 3 files changed, 35 insertions(+), 35 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index e56dc0f2c73fa..aed9f9fd47d0e 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -864,6 +864,15 @@ static int profile_onexec(const struct cred *subj_cred,
 }
 
 /* ensure none ns domain transitions are correctly applied with onexec */
+static struct aa_label *label_merge_wrap(struct aa_label *a, struct aa_label *b,
+					 gfp_t gfp)
+{
+	struct aa_label *label = aa_label_merge(a, b, gfp);
+
+	if (!label)
+		return ERR_PTR(-ENOMEM);
+	return label;
+}
 
 static struct aa_label *handle_onexec(const struct cred *subj_cred,
 				      struct aa_label *label,
@@ -891,12 +900,13 @@ static struct aa_label *handle_onexec(const struct cred *subj_cred,
 		return ERR_PTR(error);
 
 	new = fn_label_build_in_scope(label, profile, GFP_KERNEL,
-			stack ? aa_label_merge(&profile->label, onexec,
-					       GFP_KERNEL)
+			stack ? label_merge_wrap(&profile->label, onexec,
+						 GFP_KERNEL)
 			      : aa_get_newest_label(onexec),
 			profile_transition(subj_cred, profile, bprm,
 					   buffer, cond, unsafe));
-	if (new)
+	AA_BUG(!new);
+	if (!IS_ERR(new))
 		return new;
 
 	/* TODO: get rid of GLOBAL_ROOT_UID */
@@ -905,7 +915,8 @@ static struct aa_label *handle_onexec(const struct cred *subj_cred,
 				      OP_CHANGE_ONEXEC,
 				      AA_MAY_ONEXEC, bprm->filename, NULL,
 				      onexec, GLOBAL_ROOT_UID,
-				      "failed to build target label", -ENOMEM));
+				      "failed to build target label",
+				      PTR_ERR(new)));
 	return ERR_PTR(error);
 }
 
@@ -968,14 +979,10 @@ int apparmor_bprm_creds_for_exec(struct linux_binprm *bprm)
 				profile_transition(subj_cred, profile, bprm,
 						   buffer,
 						   &cond, &unsafe));
-
 	AA_BUG(!new);
 	if (IS_ERR(new)) {
 		error = PTR_ERR(new);
 		goto done;
-	} else if (!new) {
-		error = -ENOMEM;
-		goto done;
 	}
 
 	/* Policy has specified a domain transitions. If no_new_privs and
@@ -1223,12 +1230,10 @@ static struct aa_label *change_hat(const struct cred *subj_cred,
 				   build_change_hat(subj_cred, profile, name,
 						    sibling),
 				   aa_get_label(&profile->label));
-	if (!new) {
-		info = "label build failed";
-		error = -ENOMEM;
-		goto fail;
-	} /* else if (IS_ERR) build_change_hat has logged error so return new */
 	mutex_unlock(&ns->lock);
+	AA_BUG(!new);
+	/* return new label or error ptr */
+
 	return new;
 }
 
@@ -1556,7 +1561,8 @@ int aa_change_profile(const char *fqname, int flags)
 		new = fn_label_build_in_scope(label, profile, GFP_KERNEL,
 					   aa_get_label(target),
 					   aa_get_label(&profile->label));
-		if (IS_ERR_OR_NULL(new))
+		AA_BUG(!new);
+		if (IS_ERR(new))
 			goto build_fail;
 		/*
 		 * no new privs prevents domain transitions that would
@@ -1580,10 +1586,9 @@ int aa_change_profile(const char *fqname, int flags)
 			goto build_fail;
 		error = aa_replace_current_label(new);
 	} else {
-		if (new) {
-			aa_put_label(new);
-			new = NULL;
-		}
+		/* new will be recomputed so at exec time. So discard */
+		aa_put_label(new);
+		new = NULL;
 
 		/* full transition will be built in exec path */
 		aa_set_current_onexec(target, stack);
diff --git a/security/apparmor/include/lib.h b/security/apparmor/include/lib.h
index ede5728a0def4..1721782c6f923 100644
--- a/security/apparmor/include/lib.h
+++ b/security/apparmor/include/lib.h
@@ -272,7 +272,6 @@ void aa_policy_destroy(struct aa_policy *policy);
  *
  * Returns: new label on success
  *          ERR_PTR if build @FN fails
- *          NULL if label_build fails due to low memory conditions
  *
  * @FN must return a label or ERR_PTR on failure. NULL is not allowed
  */
@@ -288,7 +287,7 @@ void aa_policy_destroy(struct aa_policy *policy);
 		DEFINE_VEC(label, __lvec);				\
 		DEFINE_VEC(profile, __pvec);				\
 		if (vec_setup(label, __lvec, (L)->size, (GFP)))	{	\
-			__new_ = NULL;					\
+			__new_ = ERR_PTR(-ENOMEM);			\
 			goto __done;					\
 		}							\
 		__j = 0;						\
@@ -310,23 +309,24 @@ void aa_policy_destroy(struct aa_policy *policy);
 			if (__count > 1) {				\
 				__new_ = aa_vec_find_or_create_label(__pvec,\
 						     __count, (GFP));	\
-				/* only fails if out of Mem */		\
 				if (!__new_)				\
-					__new_ = NULL;			\
+					__new_ = ERR_PTR(-ENOMEM);	\
 			} else						\
 				__new_ = aa_get_label(&__pvec[0]->label); \
 			vec_cleanup(profile, __pvec, __count);		\
 		} else							\
-			__new_ = NULL;					\
+			__new_ = ERR_PTR(-ENOMEM);			\
 __do_cleanup:								\
 		vec_cleanup(label, __lvec, (L)->size);			\
 	} else {							\
 		(P) = labels_profile(L);				\
 		__new_ = (FN);						\
+		AA_BUG(!__new_);					\
 	}								\
 __done:									\
-	if (!__new_)							\
+	if (PTR_ERR(__new_))						\
 		AA_DEBUG(DEBUG_LABEL, "label build failed\n");		\
+	AA_BUG(!__new_);						\
 	(__new_);							\
 })
 
diff --git a/security/apparmor/mount.c b/security/apparmor/mount.c
index 523570aa1a5a1..2f5d918832c10 100644
--- a/security/apparmor/mount.c
+++ b/security/apparmor/mount.c
@@ -735,17 +735,11 @@ int aa_pivotroot(const struct cred *subj_cred, struct aa_label *label,
 			build_pivotroot(subj_cred, profile, new_path,
 					new_buffer,
 					old_path, old_buffer));
-	if (!target) {
-		info = "label build failed";
-		error = -ENOMEM;
-		goto fail;
-	} else if (!IS_ERR(target)) {
+	AA_BUG(!target);
+	if (!IS_ERR(target)) {
 		error = aa_replace_current_label(target);
-		if (error) {
-			/* TODO: audit target */
-			aa_put_label(target);
-			goto out;
-		}
+		if (error)
+			goto fail;
 		aa_put_label(target);
 	} else
 		/* already audited error */
@@ -763,7 +757,8 @@ int aa_pivotroot(const struct cred *subj_cred, struct aa_label *label,
 				    NULL /*new_name */,
 				    NULL /* old_name */,
 				    NULL, NULL,
-				    0, NULL, AA_MAY_PIVOTROOT, &nullperms, info,
+				    0, target->hname, AA_MAY_PIVOTROOT, &nullperms, info,
 				    error));
+	aa_put_label(target);
 	goto out;
 }
-- 
2.53.0



