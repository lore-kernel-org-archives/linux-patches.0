Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 932582DB79F;
	Wed, 30 Sep 2026 19:15:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790795740; cv=none; b=kXY+64VpqZcu92yz4SNlArD9UE8Brvr42SKA8UvPih6QYN08+TSlFgwPYAvocdFczBEaHc3TgwxY9LeFH+hesn7yTVuQak6SCt6JjB5q1X/6Azq6V1px5PTFuOXj+ZwlmtWOwuK4Nh8Du2b6ByKPrAt7V5Pd6kGoRMxoBl1sCxM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790795740; c=relaxed/simple;
	bh=mDoFqlnR/14gr/qmwY5IJHzA1Xf+20q7m3XqEOSCf0o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjTmO7Lb1DZlNW1nHtXgfADr8U3ieAQ3bsDykJCXIcqTYcc8M+MB40n+CJNrR2KgTjAyAID7hntKYcYFyF5eacZrTDd/EtEWSeweqrszB+hhsTuEOgWbJEc2F9vZsB+zqBUvjJnQBjtnSrg1OJnsYYr4wiAFsOJfytWyOjvzRDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Q6Fc2ouI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q6Fc2ouI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE5411F000FF;
	Wed, 30 Sep 2026 19:15:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790795739;
	bh=vbc0H+hCrsEdJ16/SQgmt3dJgWfAUKM4jTRiQObj+X0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Q6Fc2ouIIiN2ZlYn4+DjMXBlcCZO3z/YyGWn8IkDyovf1jiZuHROqHEDibsUzv1Sn
	 f5otEPUpMou1x3uPBQEqc/CGCJYdkjDGz6u+xbk4q5wr0rVJ6cuMnzWQqXw6JN4k88
	 qu1Et9UmEpCBUzh4Ds2jJFgoVbVdP6F/BsgCA3pA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.6 0611/1193] tracing/user_events: Dont destroy fields when event removal fails
Date: Wed, 30 Sep 2026 17:21:35 +0200
Message-ID: <20260930152447.820305158@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

From: Henry Martin <bsdhenrymartin@gmail.com>

commit 2deb753127d7b7035e893955c5e91875e767d1f8 upstream.

destroy_user_event() destroys the event's fields before attempting to
remove the trace event call. If user_event_set_call_visible() fails,
e.g. because the event is still enabled and trace_remove_event_call()
returns -EBUSY, the event is left registered with an irreversibly
destroyed field list. Any subsequent interaction with the event then
operates on an empty field list while it is still fully visible in
tracefs.

Move the field destruction after the call removal, and splice the
field list back onto the event when the removal fails so the event
remains in a consistent state.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260904115223.2976446-1-bsdhenrymartin@gmail.com
Fixes: 7f5a08c79df35 ("user_events: Add minimal support for trace_event into ftrace")
Signed-off-by: Henry Martin <bsdhenrymartin@gmail.com>
Reviewed-by: Beau Belgrave <beaub@linux.microsoft.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events_user.c |   26 ++++++++++++++++++++------
 1 file changed, 20 insertions(+), 6 deletions(-)

--- a/kernel/trace/trace_events_user.c
+++ b/kernel/trace/trace_events_user.c
@@ -1104,10 +1104,9 @@ static void user_event_destroy_validator
 	}
 }
 
-static void user_event_destroy_fields(struct user_event *user)
+static void user_event_destroy_fields(struct list_head *head)
 {
 	struct ftrace_event_field *field, *next;
-	struct list_head *head = &user->fields;
 
 	list_for_each_entry_safe(field, next, head, link) {
 		list_del(&field->link);
@@ -1494,17 +1493,32 @@ static int user_event_set_call_visible(s
 
 static int destroy_user_event(struct user_event *user)
 {
+	LIST_HEAD(fields);
 	int ret = 0;
 
 	lockdep_assert_held(&event_mutex);
 
-	/* Must destroy fields before call removal */
-	user_event_destroy_fields(user);
+	/*
+	 * Detach the fields before removing the call. Removing the event
+	 * frees the field list memory (trace_destroy_fields() is run on
+	 * successful removal and kmem_cache_free()s the fields), but the
+	 * fields here are allocated and owned by user_events. Destroy
+	 * them separately once removal has succeeded.
+	 */
+	list_splice_init(&user->fields, &fields);
 
 	ret = user_event_set_call_visible(user, false);
 
-	if (ret)
+	if (ret) {
+		/*
+		 * Removal failed and the event stays registered, recover
+		 * the fields so it is left in a consistent state.
+		 */
+		list_splice(&fields, &user->fields);
 		return ret;
+	}
+
+	user_event_destroy_fields(&fields);
 
 	dyn_event_remove(&user->devent);
 	hash_del(&user->node);
@@ -2149,7 +2163,7 @@ static int user_event_parse(struct user_
 put_user_lock:
 	mutex_unlock(&event_mutex);
 put_user:
-	user_event_destroy_fields(user);
+	user_event_destroy_fields(&user->fields);
 	user_event_destroy_validators(user);
 	kfree(user->call.print_fmt);
 	kfree(user);


