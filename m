Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 420EF1DFE37;
	Wed,  6 Nov 2024 12:35:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896552; cv=none; b=GbzyBjeahvgznL4QvFGivf2t64BbXyFlv4OT964l0YZmv5+tJju8alHkT5GSVHI2ZwaFqQlkQ7FJYpl1YGB+nLgw0eMWO2iDomNIznzSRwuvuw42Qc4qhWmEKZEtbbJ5YvJs9LzGH9/GhwzWwJOC3RZC8tnY9wIaKLNRYnIQaho=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896552; c=relaxed/simple;
	bh=jKreSrZN+EWUBLugMkZ7Fvk26s0hqeidc7W+UeAu/lY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HJG3TFyUaivHGIXsgbM4NzNJMt0I3sN/NqguD04IqCQ1Qj8aii0/yUQI2ckrbzyEWg9G3EILrv5w9jl19nxAetmVUWpEaZvUZQAOWzH6R5czf/QTq+Y+XSIgR/VWplLWZD4DLK8TJPcjTG3u1PF11ZxbGIYSuf10crHJZZGE/pI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uj+Whzso; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uj+Whzso"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA64CC4CED3;
	Wed,  6 Nov 2024 12:35:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896552;
	bh=jKreSrZN+EWUBLugMkZ7Fvk26s0hqeidc7W+UeAu/lY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uj+WhzsoQ5hrx/nKpWImLiOcAKf0xBAb17xqbs7gQiQHaAbOSRGNPwYG3VPsQn36l
	 ZTbNoIMVz7QqsDYeVTknZYsQROw5Pwc5mpzIVPuXsfltRqVLyK8jKDdbqS8uH/1MYa
	 YgYkhoLDBFyyiIpvnNVPxlbw+KbUuFsyyHdZAqJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Ned T. Crigler" <crigler@gmail.com>,
	Christian Heusel <christian@heusel.eu>,
	Peter Seiderer <ps.report@gmx.net>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 204/245] Input: fix regression when re-registering input handlers
Date: Wed,  6 Nov 2024 13:04:17 +0100
Message-ID: <20241106120324.267321488@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dmitry Torokhov <dmitry.torokhov@gmail.com>

[ Upstream commit 071b24b54d2d05fbf39ddbb27dee08abd1d713f3 ]

Commit d469647bafd9 ("Input: simplify event handling logic") introduced
code that would set handler->events() method to either
input_handler_events_filter() or input_handler_events_default() or
input_handler_events_null(), depending on the kind of input handler
(a filter or a regular one) we are dealing with. Unfortunately this
breaks cases when we try to re-register the same filter (as is the case
with sysrq handler): after initial registration the handler will have 2
event handling methods defined, and will run afoul of the check in
input_handler_check_methods():

	input: input_handler_check_methods: only one event processing method can be defined (sysrq)
	sysrq: Failed to register input handler, error -22

Fix this by adding handle_events() method to input_handle structure and
setting it up when registering a new input handle according to event
handling methods defined in associated input_handler structure, thus
avoiding modifying the input_handler structure.

Reported-by: "Ned T. Crigler" <crigler@gmail.com>
Reported-by: Christian Heusel <christian@heusel.eu>
Tested-by: "Ned T. Crigler" <crigler@gmail.com>
Tested-by: Peter Seiderer <ps.report@gmx.net>
Fixes: d469647bafd9 ("Input: simplify event handling logic")
Link: https://lore.kernel.org/r/Zx2iQp6csn42PJA7@xavtug
Cc: stable@vger.kernel.org
Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/input/input.c | 134 +++++++++++++++++++++++-------------------
 include/linux/input.h |  10 +++-
 2 files changed, 82 insertions(+), 62 deletions(-)

diff --git a/drivers/input/input.c b/drivers/input/input.c
index 54c57b267b25f..865d3f8e97a66 100644
--- a/drivers/input/input.c
+++ b/drivers/input/input.c
@@ -119,12 +119,12 @@ static void input_pass_values(struct input_dev *dev,
 
 	handle = rcu_dereference(dev->grab);
 	if (handle) {
-		count = handle->handler->events(handle, vals, count);
+		count = handle->handle_events(handle, vals, count);
 	} else {
 		list_for_each_entry_rcu(handle, &dev->h_list, d_node)
 			if (handle->open) {
-				count = handle->handler->events(handle, vals,
-								count);
+				count = handle->handle_events(handle, vals,
+							      count);
 				if (!count)
 					break;
 			}
@@ -2537,57 +2537,6 @@ static int input_handler_check_methods(const struct input_handler *handler)
 	return 0;
 }
 
-/*
- * An implementation of input_handler's events() method that simply
- * invokes handler->event() method for each event one by one.
- */
-static unsigned int input_handler_events_default(struct input_handle *handle,
-						 struct input_value *vals,
-						 unsigned int count)
-{
-	struct input_handler *handler = handle->handler;
-	struct input_value *v;
-
-	for (v = vals; v != vals + count; v++)
-		handler->event(handle, v->type, v->code, v->value);
-
-	return count;
-}
-
-/*
- * An implementation of input_handler's events() method that invokes
- * handler->filter() method for each event one by one and removes events
- * that were filtered out from the "vals" array.
- */
-static unsigned int input_handler_events_filter(struct input_handle *handle,
-						struct input_value *vals,
-						unsigned int count)
-{
-	struct input_handler *handler = handle->handler;
-	struct input_value *end = vals;
-	struct input_value *v;
-
-	for (v = vals; v != vals + count; v++) {
-		if (handler->filter(handle, v->type, v->code, v->value))
-			continue;
-		if (end != v)
-			*end = *v;
-		end++;
-	}
-
-	return end - vals;
-}
-
-/*
- * An implementation of input_handler's events() method that does nothing.
- */
-static unsigned int input_handler_events_null(struct input_handle *handle,
-					      struct input_value *vals,
-					      unsigned int count)
-{
-	return count;
-}
-
 /**
  * input_register_handler - register a new input handler
  * @handler: handler to be registered
@@ -2607,13 +2556,6 @@ int input_register_handler(struct input_handler *handler)
 
 	INIT_LIST_HEAD(&handler->h_list);
 
-	if (handler->filter)
-		handler->events = input_handler_events_filter;
-	else if (handler->event)
-		handler->events = input_handler_events_default;
-	else if (!handler->events)
-		handler->events = input_handler_events_null;
-
 	error = mutex_lock_interruptible(&input_mutex);
 	if (error)
 		return error;
@@ -2687,6 +2629,75 @@ int input_handler_for_each_handle(struct input_handler *handler, void *data,
 }
 EXPORT_SYMBOL(input_handler_for_each_handle);
 
+/*
+ * An implementation of input_handle's handle_events() method that simply
+ * invokes handler->event() method for each event one by one.
+ */
+static unsigned int input_handle_events_default(struct input_handle *handle,
+						struct input_value *vals,
+						unsigned int count)
+{
+	struct input_handler *handler = handle->handler;
+	struct input_value *v;
+
+	for (v = vals; v != vals + count; v++)
+		handler->event(handle, v->type, v->code, v->value);
+
+	return count;
+}
+
+/*
+ * An implementation of input_handle's handle_events() method that invokes
+ * handler->filter() method for each event one by one and removes events
+ * that were filtered out from the "vals" array.
+ */
+static unsigned int input_handle_events_filter(struct input_handle *handle,
+					       struct input_value *vals,
+					       unsigned int count)
+{
+	struct input_handler *handler = handle->handler;
+	struct input_value *end = vals;
+	struct input_value *v;
+
+	for (v = vals; v != vals + count; v++) {
+		if (handler->filter(handle, v->type, v->code, v->value))
+			continue;
+		if (end != v)
+			*end = *v;
+		end++;
+	}
+
+	return end - vals;
+}
+
+/*
+ * An implementation of input_handle's handle_events() method that does nothing.
+ */
+static unsigned int input_handle_events_null(struct input_handle *handle,
+					     struct input_value *vals,
+					     unsigned int count)
+{
+	return count;
+}
+
+/*
+ * Sets up appropriate handle->event_handler based on the input_handler
+ * associated with the handle.
+ */
+static void input_handle_setup_event_handler(struct input_handle *handle)
+{
+	struct input_handler *handler = handle->handler;
+
+	if (handler->filter)
+		handle->handle_events = input_handle_events_filter;
+	else if (handler->event)
+		handle->handle_events = input_handle_events_default;
+	else if (handler->events)
+		handle->handle_events = handler->events;
+	else
+		handle->handle_events = input_handle_events_null;
+}
+
 /**
  * input_register_handle - register a new input handle
  * @handle: handle to register
@@ -2704,6 +2715,7 @@ int input_register_handle(struct input_handle *handle)
 	struct input_dev *dev = handle->dev;
 	int error;
 
+	input_handle_setup_event_handler(handle);
 	/*
 	 * We take dev->mutex here to prevent race with
 	 * input_release_device().
diff --git a/include/linux/input.h b/include/linux/input.h
index 89a0be6ee0e23..cd866b020a01d 100644
--- a/include/linux/input.h
+++ b/include/linux/input.h
@@ -339,12 +339,16 @@ struct input_handler {
  * @name: name given to the handle by handler that created it
  * @dev: input device the handle is attached to
  * @handler: handler that works with the device through this handle
+ * @handle_events: event sequence handler. It is set up by the input core
+ *	according to event handling method specified in the @handler. See
+ *	input_handle_setup_event_handler().
+ *	This method is being called by the input core with interrupts disabled
+ *	and dev->event_lock spinlock held and so it may not sleep.
  * @d_node: used to put the handle on device's list of attached handles
  * @h_node: used to put the handle on handler's list of handles from which
  *	it gets events
  */
 struct input_handle {
-
 	void *private;
 
 	int open;
@@ -353,6 +357,10 @@ struct input_handle {
 	struct input_dev *dev;
 	struct input_handler *handler;
 
+	unsigned int (*handle_events)(struct input_handle *handle,
+				      struct input_value *vals,
+				      unsigned int count);
+
 	struct list_head	d_node;
 	struct list_head	h_node;
 };
-- 
2.43.0



