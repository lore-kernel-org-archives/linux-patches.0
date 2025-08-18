Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04426318126;
	Mon, 18 Aug 2025 13:08:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522507; cv=none; b=Eid/ZYFKPl3skyVeDSawaNLwqYzeAFs++ekT223Cg0Cf83GHkytqOpQtBK88VZVdDhL5cCou/k5teW4DnO4y2d3N+PNhTka+eToKB7ZVVutrZWOLAf4laSWZRwgRM0mPjWhp+M0tC/PIpvdoiojSjFPg10r6glMfa7jH8JE41RA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522507; c=relaxed/simple;
	bh=iEVCDxueDqg6J19wCwqq2AfYCplWscwneI6AJefThGU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AlFtVEwq83MIdwVLhIUAtirg54gmtk0Izaj6WVNaTb7aVrPO6aPTYnpXL74GID+mNBB4jcjbm7VXc17VyiyLqJlMeGhfHSWzTbvFhxyT7ZoPL/6Wc8sFWhQq17wUKrUJtH1Ix4QBLmxMdIqOjs9Kmzc6XFtJx2LWU0S2B8xKEVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lq5s9+/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lq5s9+/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35C9EC4CEEB;
	Mon, 18 Aug 2025 13:08:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522506;
	bh=iEVCDxueDqg6J19wCwqq2AfYCplWscwneI6AJefThGU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lq5s9+/+8Xpa/EjnBL231IdNAZuz/9YD9bilIyY2jLw5kw55PSg3mJq0ReuFkEdhT
	 q4XEaFOWxh2PpeNzqLYWQGwfWTUobQg+WUCGLEhZSmARnIw6LSKksib/2t9IZwMJfZ
	 ogpz3jhYxdo+ns6yRTE7ThS+QGi74jVB4pVagJTs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Johansen <john.johansen@canonical.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 337/444] apparmor: fix x_table_lookup when stacking is not the first entry
Date: Mon, 18 Aug 2025 14:46:03 +0200
Message-ID: <20250818124501.567910637@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: John Johansen <john.johansen@canonical.com>

[ Upstream commit a9eb185be84e998aa9a99c7760534ccc06216705 ]

x_table_lookup currently does stacking during label_parse() if the
target specifies a stack but its only caller ensures that it will
never be used with stacking.

Refactor to slightly simplify the code in x_to_label(), this
also fixes a long standing problem where x_to_labels check on stacking
is only on the first element to the table option list, instead of
the element that is found and used.

Signed-off-by: John Johansen <john.johansen@canonical.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 security/apparmor/domain.c | 52 +++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 23 deletions(-)

diff --git a/security/apparmor/domain.c b/security/apparmor/domain.c
index 571158ec6188..cccd61cca509 100644
--- a/security/apparmor/domain.c
+++ b/security/apparmor/domain.c
@@ -509,6 +509,7 @@ static const char *next_name(int xtype, const char *name)
  * @name: returns: name tested to find label (NOT NULL)
  *
  * Returns: refcounted label, or NULL on failure (MAYBE NULL)
+ *          @name will always be set with the last name tried
  */
 struct aa_label *x_table_lookup(struct aa_profile *profile, u32 xindex,
 				const char **name)
@@ -518,6 +519,7 @@ struct aa_label *x_table_lookup(struct aa_profile *profile, u32 xindex,
 	struct aa_label *label = NULL;
 	u32 xtype = xindex & AA_X_TYPE_MASK;
 	int index = xindex & AA_X_INDEX_MASK;
+	const char *next;
 
 	AA_BUG(!name);
 
@@ -525,25 +527,27 @@ struct aa_label *x_table_lookup(struct aa_profile *profile, u32 xindex,
 	/* TODO: move lookup parsing to unpack time so this is a straight
 	 *       index into the resultant label
 	 */
-	for (*name = rules->file->trans.table[index]; !label && *name;
-	     *name = next_name(xtype, *name)) {
+	for (next = rules->file->trans.table[index]; next;
+	     next = next_name(xtype, next)) {
+		const char *lookup = (*next == '&') ? next + 1 : next;
+		*name = next;
 		if (xindex & AA_X_CHILD) {
-			struct aa_profile *new_profile;
-			/* release by caller */
-			new_profile = aa_find_child(profile, *name);
-			if (new_profile)
-				label = &new_profile->label;
+			/* TODO: switich to parse to get stack of child */
+			struct aa_profile *new = aa_find_child(profile, lookup);
+
+			if (new)
+				/* release by caller */
+				return &new->label;
 			continue;
 		}
-		label = aa_label_parse(&profile->label, *name, GFP_KERNEL,
+		label = aa_label_parse(&profile->label, lookup, GFP_KERNEL,
 				       true, false);
-		if (IS_ERR(label))
-			label = NULL;
+		if (!IS_ERR_OR_NULL(label))
+			/* release by caller */
+			return label;
 	}
 
-	/* released by caller */
-
-	return label;
+	return NULL;
 }
 
 /**
@@ -568,9 +572,9 @@ static struct aa_label *x_to_label(struct aa_profile *profile,
 	struct aa_ruleset *rules = list_first_entry(&profile->rules,
 						    typeof(*rules), list);
 	struct aa_label *new = NULL;
+	struct aa_label *stack = NULL;
 	struct aa_ns *ns = profile->ns;
 	u32 xtype = xindex & AA_X_TYPE_MASK;
-	const char *stack = NULL;
 
 	switch (xtype) {
 	case AA_X_NONE:
@@ -579,13 +583,14 @@ static struct aa_label *x_to_label(struct aa_profile *profile,
 		break;
 	case AA_X_TABLE:
 		/* TODO: fix when perm mapping done at unload */
-		stack = rules->file->trans.table[xindex & AA_X_INDEX_MASK];
-		if (*stack != '&') {
-			/* released by caller */
-			new = x_table_lookup(profile, xindex, lookupname);
-			stack = NULL;
+		/* released by caller
+		 * if null for both stack and direct want to try fallback
+		 */
+		new = x_table_lookup(profile, xindex, lookupname);
+		if (!new || **lookupname != '&')
 			break;
-		}
+		stack = new;
+		new = NULL;
 		fallthrough;	/* to X_NAME */
 	case AA_X_NAME:
 		if (xindex & AA_X_CHILD)
@@ -600,6 +605,7 @@ static struct aa_label *x_to_label(struct aa_profile *profile,
 		break;
 	}
 
+	/* fallback transition check */
 	if (!new) {
 		if (xindex & AA_X_INHERIT) {
 			/* (p|c|n)ix - don't change profile but do
@@ -618,12 +624,12 @@ static struct aa_label *x_to_label(struct aa_profile *profile,
 		/* base the stack on post domain transition */
 		struct aa_label *base = new;
 
-		new = aa_label_parse(base, stack, GFP_KERNEL, true, false);
-		if (IS_ERR(new))
-			new = NULL;
+		new = aa_label_merge(base, stack, GFP_KERNEL);
+		/* null on error */
 		aa_put_label(base);
 	}
 
+	aa_put_label(stack);
 	/* released by caller */
 	return new;
 }
-- 
2.39.5



