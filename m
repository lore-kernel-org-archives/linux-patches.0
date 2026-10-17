Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B4737DEA8;
	Sat, 17 Oct 2026 16:36:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255016; cv=none; b=KLw6gTMaU2m5i5LrpnZa8JSKdxfQkAFE/hdWo4gsya6k4j1SDwoiX9kKmEEHOsN8fnWrAoCU76ER8ImzOLcX1o7KiomVhLXLdHy4khaufEykfx3EhxGQQRtLwnXuzfZ/Qgf/Je8pS0tWs148azKTFwQZfziTR3jYgsR0vSsgPwk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255016; c=relaxed/simple;
	bh=Eljh4mrIFjrUjc+eagmf/Fs9e2GAI8rcFpbPGpKReDA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rnbgnHTlE+OohJNhiLvN3VP/QGC7qhU3gYLFxRFTrZ4TGog4DRSy8+Hbvdye1qMUgESM0hrAA4UrBvEU+WPUJjmKxbChyga4scx+z7sMdFbqcvaQUpe9Z9p/1mvXmK9AZ+aXHMs5iYpjnZMzMYClp0mIVmwkTeicH9SHTN1eIRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r4klunQZ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r4klunQZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB7831F000C4;
	Sat, 17 Oct 2026 16:36:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255015;
	bh=vEwZ7t/JurhcvLupzs0Tp0H6GYX6W+cwfeBu4f8anJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r4klunQZZTOckUkk8NG8TqpSWj5E0ASQ3Z7GZTMzosLoRU7H5Bli4zgyBovAOADMK
	 rpi1yvsuxAPad7Tiufa2BwKT64K3pjxVWJrpVh0Y8yMz6PcWrFlXwGzCkSwgV7h00O
	 PdwCu1dqMwtvmUTn1Tm2UE2hhlci9jkgf+SaOqvE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 636/869] apparmor: fix unconfined user namespace restriction forced stack
Date: Sat, 17 Oct 2026 17:57:57 +0200
Message-ID: <20261017160053.328911001@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 91879bda56b9a..8685c10e6754c 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -812,6 +812,52 @@ static int profile_onexec(const struct cred *subj_cred,
 
 /* ensure none ns domain transitions are correctly applied with onexec */
 
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
+	struct aa_label *target = aa_label_merge(&profile->label,
+						   transition, gfp);
+	if (!target)
+		return ERR_PTR(-ENOMEM);
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
@@ -835,7 +881,10 @@ static struct aa_label *handle_onexec(const struct cred *subj_cred,
 		if (error)
 			return ERR_PTR(error);
 		new = fn_label_build_in_ns(label, profile, GFP_KERNEL,
-				aa_get_newest_label(onexec),
+				priv_restricted_transition(subj_cred, profile,
+						OP_CHANGE_ONEXEC, AA_MAY_ONEXEC,
+						bprm->filename, onexec,
+						GFP_KERNEL),
 				profile_transition(subj_cred, profile, bprm,
 						   buffer,
 						   cond, unsafe));
@@ -1354,8 +1403,6 @@ static int change_profile_perms_wrapper(const char *op, const char *name,
 	return error;
 }
 
-static const char *stack_msg = "change_profile unprivileged unconfined converted to stacking";
-
 /**
  * aa_change_profile - perform a one-way profile transition
  * @fqname: name of profile may include namespace (NOT NULL)
@@ -1415,28 +1462,6 @@ int aa_change_profile(const char *fqname, int flags)
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
-		(void) fn_for_each_in_ns(label, profile,
-				aa_audit_file(subj_cred, profile, &perms, op,
-					      request, auditname, NULL, target,
-					      GLOBAL_ROOT_UID, stack_msg, 0));
-		perms.audit = 0;
-	}
-
 	if (*fqname == '&') {
 		stack = true;
 		/* don't have label_parse() do stacking */
@@ -1507,7 +1532,10 @@ int aa_change_profile(const char *fqname, int flags)
 	/* stacking is always a subset, so only check the nonstack case */
 	if (!stack) {
 		new = fn_label_build_in_ns(label, profile, GFP_KERNEL,
-					   aa_get_label(target),
+				priv_restricted_transition(subj_cred, profile,
+							   op, request,
+							   auditname, target,
+							   GFP_KERNEL),
 					   aa_get_label(&profile->label));
 		if (IS_ERR_OR_NULL(new))
 			goto build_fail;
-- 
2.53.0



