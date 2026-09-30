Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00B465304CD;
	Wed, 30 Sep 2026 17:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790790143; cv=none; b=Z3i7WgKFzBt/CkJCgk1Os7vMbg8suRR58royeAyLPzm1xoQhummZD8Dt6KPFkmJd2BSq8VIii563YW2cu5OvxKhhwXZrMobvgJw/6km09pYk8SfbdWx+N4HctHhj1E2uWQmetPVmzGJs22tAQyXZzxuDxiwxaHFhwC5diKjWH0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790790143; c=relaxed/simple;
	bh=v8nD4LTMGmnZyaPA7UPL9CKC3picNlYj33GS/jZHNOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lFxTB7Vd3gJyAHSOvWbXQnUEJLce4nQbZfOkEJwojD4dBnMGfGGYCB1Fx+mboW75WdEhe/u4H8bFdsk1rRIF2u2fnYMDZhNtdzmbFtyf2FwVHI9WufKabWrIt7V39yMRduBeBNhEkBkeeAa0TG9lr/DAVf9cs1ZujPCbNgAkLkQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YtENefY/; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YtENefY/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B98D1F000FF;
	Wed, 30 Sep 2026 17:42:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790790141;
	bh=REE0HRUIA6zSBW74lurz9O+KzrS4JGd/ol9Qn+h4/6o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YtENefY/67c9mcxt8adT9EY6EEozp2xPLm909nx2HQCeHVwZoz0qB1C3821nj8jOX
	 yFArauOHH49Y52FtVV5svQX4937CN2bRHJONbPeaK46Na0IsP2PwiSzMfImU/izFI6
	 hdcnInEQqlfk7hX5ilaMVUbB0S5B099oWQVjrGqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Steven Rostedt <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 724/877] tracing: Take trace_array reference when opening a tracer options file
Date: Wed, 30 Sep 2026 17:27:15 +0200
Message-ID: <20260930152430.311187480@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152414.738996857@linuxfoundation.org>
References: <20260930152414.738996857@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit ed0aff60f83a9bdc2f6556376ac79c96b3ce7e80 ]

When a tracer option file is opened, it is passed a descriptor that points
to an element on the trace_array's topts array. This element has
information to find the trace array and other information. It uses this
element to take a reference of the trace_array so that the trace_array
does not get removed while this file is opened.

Unfortunately, there's a race condition where the element itself could be
freed by the removal of the instance the trace_array represents causing a
use-after-free as this element that is used to find the trace_array to
increment its reference counter is also freed when the instance is
removed.

To solve this, add a trace_array_tracer_options_get() helper function that
will take the address of the element that is passed to the open function
by the inode->i_private pointer and search all the trace_arrays under a
lock to find the one that the element's address is in the range of the
trace_arrays topts array elements. When a match happens, that trace_array's
reference would be increased.

Note, there's a race where if an admin was deleting and creating trace
instances at the same time and the memory of the old trace_array's array
matched the memory of the new trace_array that it could in theory open the
option from the wrong trace array. But we do not care because it would be
stupid to perform that kind of action. As long as the only thing that can
happen is that the option from the wrong trace array is used and doesn't
crash the kernel it will only make the user confused. But if they are
doing something stupid like this, they are already confused, so no harm
done.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260910221209.62dad8d3@robin
Fixes: 7e2cfbd2d3c86 ("tracing: Have option files inc the trace array ref count")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-trace-kernel/20260902121918.5a9e9d1b@gandalf.local.home/
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
[ replaced missing __trace_array_get() with tr->ref++ and return 0 under trace_types_lock. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   48 +++++++++++++++++++++++++++++++++++++++++++++++-
 kernel/trace/trace.h |    1 +
 2 files changed, 48 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -8737,12 +8737,57 @@ trace_options_write(struct file *filp, c
 	return cnt;
 }
 
+static bool tr_option_match(struct trace_array *tr, void *topt)
+{
+	for (int i = 0; i < tr->nr_topts; i++) {
+		struct trace_options *tr_topts = &tr->topts[i];
+
+		if (topt >= (void *)&tr_topts->topts[0] &&
+		    topt < (void *)&tr_topts->topts[tr_topts->nr_topts])
+			return true;
+	}
+	return false;
+}
+
+/*
+ * The topt is the address of a trace_array->topts[] element that holds the
+ * the tracer options descriptor. But since the trace_array reference has not
+ * been taken yet, it cannot be dereferenced as it could have been freed by
+ * a rmdir of the instance the trace_array represents.
+ *
+ * Search the list of trace_arrays and compare the topt to the address of
+ * the entire trace_array topts array for each trace_array in the list.
+ * If one is matched, then take the reference and return it. If not, the
+ * trace_array no longer exits.
+ */
+static int trace_array_tracer_options_get(void *topt)
+{
+	struct trace_array *tr;
+	int ret;
+
+	ret = security_locked_down(LOCKDOWN_TRACEFS);
+	if (ret)
+		return ret;
+
+	if (tracing_disabled)
+		return -ENODEV;
+
+	guard(mutex)(&trace_types_lock);
+	list_for_each_entry(tr, &ftrace_trace_arrays, list) {
+		if (tr_option_match(tr, topt)) {
+			tr->ref++;
+			return 0;
+		}
+	}
+	return -ENODEV;
+}
+
 static int tracing_open_options(struct inode *inode, struct file *filp)
 {
 	struct trace_option_dentry *topt = inode->i_private;
 	int ret;
 
-	ret = tracing_check_open_get_tr(topt->tr);
+	ret = trace_array_tracer_options_get(topt);
 	if (ret)
 		return ret;
 
@@ -9026,6 +9071,7 @@ create_trace_option_files(struct trace_a
 	tr->topts = tr_topts;
 	tr->topts[tr->nr_topts].tracer = tracer;
 	tr->topts[tr->nr_topts].topts = topts;
+	tr->topts[tr->nr_topts].nr_topts = cnt;
 	tr->nr_topts++;
 
 	for (cnt = 0; opts[cnt].name; cnt++) {
--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -223,6 +223,7 @@ struct array_buffer {
 struct trace_options {
 	struct tracer			*tracer;
 	struct trace_option_dentry	*topts;
+	int				nr_topts;
 };
 
 struct trace_pid_list *trace_pid_list_alloc(void);


