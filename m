Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30B79274650;
	Thu, 17 Sep 2026 15:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789660271; cv=none; b=L1nRzvQHNAeSbHuQI8EEHZXxWm7Lu3jzIHuSZ5vmsYhJ1NIyjseLRLwSZDBG/RIOr5Ls0r250ActvCaT/Ht2UtWzhdQbCA+nUQ+ClhFlIBWGE0RY6K89ysUPwb/Rm5dOKR6MchuAhFAFW/kNS47RP3kV2P4ha7+2Ezh3oB4t30k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789660271; c=relaxed/simple;
	bh=AYK+4SvFphxYrU0Vt9HW3GFjrvixxaVUWuL5n/3Zonw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nAfhLXdQSkrA+Oad7WXRWoS873LE6D7z8a0ptVomKjgTigivcysI0mofCxNqa/5+oHZi/2tQ/15CgBPZ18al/yBVqKSjfpYkxIhS78/4wylkYl6TrEwqTSD/9MmwbdJ3GHEV1dlZg97cJJdH1Jn5uiAfsTlMXwivnP5QRTi1Kig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bfdr7Byl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bfdr7Byl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D92B1F00898;
	Thu, 17 Sep 2026 15:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789660262;
	bh=LlXlGoQdxugs28UAeZbn/eKCbLuFko2zuvgc/ykKBGo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Bfdr7BylZGjlRzV+WSNKG77gF+I6Y/pIDasEHP933FIJaIEceLor9FA764LnYpoWe
	 grUJ5x/SzvnvqoiDL5Gqrndy9waQZag+SbYGGMWAxyP9bwjWyEYOg1eLBYzYb8dikE
	 zWDVAU5DhMAPb6qsq9wBOMKaFIC3ZxYCRRTf7OpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Henry Martin <bsdhenrymartin@gmail.com>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 496/733] tracing/user_events: Dont destroy fields when event removal fails
Date: Thu, 17 Sep 2026 16:13:24 +0100
Message-ID: <20260917151404.436858147@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1122,10 +1122,9 @@ static void user_event_destroy_validator
 	}
 }
 
-static void user_event_destroy_fields(struct user_event *user)
+static void user_event_destroy_fields(struct list_head *head)
 {
 	struct ftrace_event_field *field, *next;
-	struct list_head *head = &user->fields;
 
 	list_for_each_entry_safe(field, next, head, link) {
 		list_del(&field->link);
@@ -1502,17 +1501,32 @@ static int user_event_set_call_visible(s
 
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
@@ -2212,7 +2226,7 @@ static int user_event_parse(struct user_
 put_user_lock:
 	mutex_unlock(&event_mutex);
 put_user:
-	user_event_destroy_fields(user);
+	user_event_destroy_fields(&user->fields);
 	user_event_destroy_validators(user);
 	kfree(user->call.print_fmt);
 


