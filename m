Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C004819CD04;
	Thu,  6 Jun 2024 14:17:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683433; cv=none; b=eDMnfBcI7fWZhatsWri5NlQsb3OE3RGuzuKKB9z2isiQqRGDMW6tUwAPVSXbEQLZJlDZRM6jIcCEunbXGot+EfjT++zQsBW/QZ3tSAo0dCnB0CA+0xnvuSWToT3Zf2ma/qzJXgDdOXRPBaoaUISmG2eR/OR3HzVa3Avgs64krhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683433; c=relaxed/simple;
	bh=0VLDQpJ3Jnps37ZgrYRGZqfauIsCJfEdhok9nsMdJAo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ry8Z8i1qiOfjev3b/9u4VIwmO9oDLmsWccDJYW85DXg0nhTCiAHlQ+sDp4yzSwcVqCTLbmeTNUmIe1jFItlfiDeDILm0bpM+8jMsFLbWxjtvskwZtYVqxbXHEX1ztqmz5md25gbGgRuZMKzMtWurSVPEsu1g8mWuVIxsYrZoy38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Fw0NNbmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Fw0NNbmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A10CDC32781;
	Thu,  6 Jun 2024 14:17:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683433;
	bh=0VLDQpJ3Jnps37ZgrYRGZqfauIsCJfEdhok9nsMdJAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Fw0NNbmdcfPnUM8ubOmg1LUlUM2Xj9Un/aRKLZ/8DwimfVNDIYPlsIuX15WfVRd6t
	 81K0XdxE/FwsVB3cwXfeuMS4VN9exp1Xaki3p5R+3QvfpDU/X4q7Uf1gadV/hXSHUG
	 vpoK5AwnDOZmkNPwoY4FYeYcXOsHaeI4MYjeAX1c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Beau Belgrave <beaub@linux.microsoft.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 378/744] tracing/user_events: Prepare find/delete for same name events
Date: Thu,  6 Jun 2024 16:00:50 +0200
Message-ID: <20240606131744.599661583@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131732.440653204@linuxfoundation.org>
References: <20240606131732.440653204@linuxfoundation.org>
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

From: Beau Belgrave <beaub@linux.microsoft.com>

[ Upstream commit 1e953de9e9b4ca77a9ce0fc17a0778eba3a4ca64 ]

The current code for finding and deleting events assumes that there will
never be cases when user_events are registered with the same name, but
different formats. Scenarios exist where programs want to use the same
name but have different formats. An example is multiple versions of a
program running side-by-side using the same event name, but with updated
formats in each version.

This change does not yet allow for multi-format events. If user_events
are registered with the same name but different arguments the programs
see the same return values as before. This change simply makes it
possible to easily accommodate for this.

Update find_user_event() to take in argument parameters and register
flags to accommodate future multi-format event scenarios. Have find
validate argument matching and return error pointers to cover when
an existing event has the same name but different format. Update
callers to handle error pointer logic.

Move delete_user_event() to use hash walking directly now that
find_user_event() has changed. Delete all events found that match the
register name, stop if an error occurs and report back to the user.

Update user_fields_match() to cover list_empty() scenarios now that
find_user_event() uses it directly. This makes the logic consistent
across several callsites.

Link: https://lore.kernel.org/linux-trace-kernel/20240222001807.1463-2-beaub@linux.microsoft.com

Signed-off-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: bd125a084091 ("tracing/user_events: Fix non-spaced field matching")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_user.c | 107 +++++++++++++++++--------------
 1 file changed, 59 insertions(+), 48 deletions(-)

diff --git a/kernel/trace/trace_events_user.c b/kernel/trace/trace_events_user.c
index 9365ce4074263..dda58681247e1 100644
--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -202,6 +202,8 @@ static struct user_event_mm *user_event_mm_get(struct user_event_mm *mm);
 static struct user_event_mm *user_event_mm_get_all(struct user_event *user);
 static void user_event_mm_put(struct user_event_mm *mm);
 static int destroy_user_event(struct user_event *user);
+static bool user_fields_match(struct user_event *user, int argc,
+			      const char **argv);
 
 static u32 user_event_key(char *name)
 {
@@ -1493,17 +1495,24 @@ static int destroy_user_event(struct user_event *user)
 }
 
 static struct user_event *find_user_event(struct user_event_group *group,
-					  char *name, u32 *outkey)
+					  char *name, int argc, const char **argv,
+					  u32 flags, u32 *outkey)
 {
 	struct user_event *user;
 	u32 key = user_event_key(name);
 
 	*outkey = key;
 
-	hash_for_each_possible(group->register_table, user, node, key)
-		if (!strcmp(EVENT_NAME(user), name))
+	hash_for_each_possible(group->register_table, user, node, key) {
+		if (strcmp(EVENT_NAME(user), name))
+			continue;
+
+		if (user_fields_match(user, argc, argv))
 			return user_event_get(user);
 
+		return ERR_PTR(-EADDRINUSE);
+	}
+
 	return NULL;
 }
 
@@ -1860,6 +1869,9 @@ static bool user_fields_match(struct user_event *user, int argc,
 	struct list_head *head = &user->fields;
 	int i = 0;
 
+	if (argc == 0)
+		return list_empty(head);
+
 	list_for_each_entry_reverse(field, head, link) {
 		if (!user_field_match(field, argc, argv, &i))
 			return false;
@@ -1880,10 +1892,8 @@ static bool user_event_match(const char *system, const char *event,
 	match = strcmp(EVENT_NAME(user), event) == 0 &&
 		(!system || strcmp(system, USER_EVENTS_SYSTEM) == 0);
 
-	if (match && argc > 0)
+	if (match)
 		match = user_fields_match(user, argc, argv);
-	else if (match && argc == 0)
-		match = list_empty(&user->fields);
 
 	return match;
 }
@@ -1922,11 +1932,11 @@ static int user_event_parse(struct user_event_group *group, char *name,
 			    char *args, char *flags,
 			    struct user_event **newuser, int reg_flags)
 {
-	int ret;
-	u32 key;
 	struct user_event *user;
+	char **argv = NULL;
 	int argc = 0;
-	char **argv;
+	int ret;
+	u32 key;
 
 	/* Currently don't support any text based flags */
 	if (flags != NULL)
@@ -1935,41 +1945,34 @@ static int user_event_parse(struct user_event_group *group, char *name,
 	if (!user_event_capable(reg_flags))
 		return -EPERM;
 
+	if (args) {
+		argv = argv_split(GFP_KERNEL, args, &argc);
+
+		if (!argv)
+			return -ENOMEM;
+	}
+
 	/* Prevent dyn_event from racing */
 	mutex_lock(&event_mutex);
-	user = find_user_event(group, name, &key);
+	user = find_user_event(group, name, argc, (const char **)argv,
+			       reg_flags, &key);
 	mutex_unlock(&event_mutex);
 
-	if (user) {
-		if (args) {
-			argv = argv_split(GFP_KERNEL, args, &argc);
-			if (!argv) {
-				ret = -ENOMEM;
-				goto error;
-			}
+	if (argv)
+		argv_free(argv);
 
-			ret = user_fields_match(user, argc, (const char **)argv);
-			argv_free(argv);
-
-		} else
-			ret = list_empty(&user->fields);
-
-		if (ret) {
-			*newuser = user;
-			/*
-			 * Name is allocated by caller, free it since it already exists.
-			 * Caller only worries about failure cases for freeing.
-			 */
-			kfree(name);
-		} else {
-			ret = -EADDRINUSE;
-			goto error;
-		}
+	if (IS_ERR(user))
+		return PTR_ERR(user);
+
+	if (user) {
+		*newuser = user;
+		/*
+		 * Name is allocated by caller, free it since it already exists.
+		 * Caller only worries about failure cases for freeing.
+		 */
+		kfree(name);
 
 		return 0;
-error:
-		user_event_put(user, false);
-		return ret;
 	}
 
 	user = kzalloc(sizeof(*user), GFP_KERNEL_ACCOUNT);
@@ -2052,25 +2055,33 @@ static int user_event_parse(struct user_event_group *group, char *name,
 }
 
 /*
- * Deletes a previously created event if it is no longer being used.
+ * Deletes previously created events if they are no longer being used.
  */
 static int delete_user_event(struct user_event_group *group, char *name)
 {
-	u32 key;
-	struct user_event *user = find_user_event(group, name, &key);
+	struct user_event *user;
+	struct hlist_node *tmp;
+	u32 key = user_event_key(name);
+	int ret = -ENOENT;
 
-	if (!user)
-		return -ENOENT;
+	/* Attempt to delete all event(s) with the name passed in */
+	hash_for_each_possible_safe(group->register_table, user, tmp, node, key) {
+		if (strcmp(EVENT_NAME(user), name))
+			continue;
 
-	user_event_put(user, true);
+		if (!user_event_last_ref(user))
+			return -EBUSY;
 
-	if (!user_event_last_ref(user))
-		return -EBUSY;
+		if (!user_event_capable(user->reg_flags))
+			return -EPERM;
 
-	if (!user_event_capable(user->reg_flags))
-		return -EPERM;
+		ret = destroy_user_event(user);
 
-	return destroy_user_event(user);
+		if (ret)
+			goto out;
+	}
+out:
+	return ret;
 }
 
 /*
-- 
2.43.0



