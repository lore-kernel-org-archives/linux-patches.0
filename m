Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C46F9183CC3;
	Sun,  1 Sep 2024 16:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207950; cv=none; b=gaZ2/9EbEKQSc34CS7CZZDoWgQ1mH+osoFR50iA0vIhoWCqlg8ikK9WhgFIU6Fmp4ZVwHcPD3PifcaVjSjuEsB3edr1y+F6K7D6JIq5np2vNJh7dmzO5mJpJV5x545PxonCPQtpcKXDmpDPfyFKpMzvh76pmri29s2EqomS7FBE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207950; c=relaxed/simple;
	bh=C4tt2PVwcelmBVA2844PM9Pn1Cbcm5T8EW2Zjy/VhQg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=otG4zKDkMuL/mlMC6cFz59um+jdBMV4Qcy20+flv804BnpvDjgqpmDEeAob4mCLuQMmwWAbEZrc/BxthLltw17fEn/RMZNsZQKtrw738gCp+O5HVkqfxAnYhmzko0Im86XXUQmJMhVIeBYX/U0bmS/2fOi9iaQooZzCaTB7vDNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D0veiN30; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D0veiN30"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04169C4CEC3;
	Sun,  1 Sep 2024 16:25:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207950;
	bh=C4tt2PVwcelmBVA2844PM9Pn1Cbcm5T8EW2Zjy/VhQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D0veiN30XxyVSkoI/3bYglc++c/m1DgCZUP9ZbyiD1mXlKFPbTReYrd6WdTPm30Hj
	 r0Sai5xjFzJfYwxKwS6A6xuDt6xs1z2xab2Wvbvri5j83V7XE9DemJGVvpZKoRT3zk
	 5Ur+4KAPEq8kWo2j2PWobk6m3n+eEydR88pZhkXU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ajay Kaher <ajay.kaher@broadcom.com>,
	=?UTF-8?q?Ilkka=20Naulap=C3=A4=C3=A4?= <digirigawa@gmail.com>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Al Viro <viro@zeniv.linux.org.uk>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Beau Belgrave <beaub@linux.microsoft.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Alexey Makhalov <alexey.makhalov@broadcom.com>,
	Vasavi Sirnapalli <vasavi.sirnapalli@broadcom.com>,
	Mathias Krause <minipli@grsecurity.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Zheng Yejian <zhengyejian@huaweicloud.com>
Subject: [PATCH 6.6 27/93] tracing: Have format file honor EVENT_FILE_FL_FREED
Date: Sun,  1 Sep 2024 18:16:14 +0200
Message-ID: <20240901160808.381776761@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160807.346406833@linuxfoundation.org>
References: <20240901160807.346406833@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit b1560408692cd0ab0370cfbe9deb03ce97ab3f6d upstream.

When eventfs was introduced, special care had to be done to coordinate the
freeing of the file meta data with the files that are exposed to user
space. The file meta data would have a ref count that is set when the file
is created and would be decremented and freed after the last user that
opened the file closed it. When the file meta data was to be freed, it
would set a flag (EVENT_FILE_FL_FREED) to denote that the file is freed,
and any new references made (like new opens or reads) would fail as it is
marked freed. This allowed other meta data to be freed after this flag was
set (under the event_mutex).

All the files that were dynamically created in the events directory had a
pointer to the file meta data and would call event_release() when the last
reference to the user space file was closed. This would be the time that it
is safe to free the file meta data.

A shortcut was made for the "format" file. It's i_private would point to
the "call" entry directly and not point to the file's meta data. This is
because all format files are the same for the same "call", so it was
thought there was no reason to differentiate them.  The other files
maintain state (like the "enable", "trigger", etc). But this meant if the
file were to disappear, the "format" file would be unaware of it.

This caused a race that could be trigger via the user_events test (that
would create dynamic events and free them), and running a loop that would
read the user_events format files:

In one console run:

 # cd tools/testing/selftests/user_events
 # while true; do ./ftrace_test; done

And in another console run:

 # cd /sys/kernel/tracing/
 # while true; do cat events/user_events/__test_event/format; done 2>/dev/null

With KASAN memory checking, it would trigger a use-after-free bug report
(which was a real bug). This was because the format file was not checking
the file's meta data flag "EVENT_FILE_FL_FREED", so it would access the
event that the file meta data pointed to after the event was freed.

After inspection, there are other locations that were found to not check
the EVENT_FILE_FL_FREED flag when accessing the trace_event_file. Add a
new helper function: event_file_file() that will make sure that the
event_mutex is held, and will return NULL if the trace_event_file has the
EVENT_FILE_FL_FREED flag set. Have the first reference of the struct file
pointer use event_file_file() and check for NULL. Later uses can still use
the event_file_data() helper function if the event_mutex is still held and
was not released since the event_file_file() call.

Link: https://lore.kernel.org/all/20240719204701.1605950-1-minipli@grsecurity.net/

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers   <mathieu.desnoyers@efficios.com>
Cc: Ajay Kaher <ajay.kaher@broadcom.com>
Cc: Ilkka Naulapää    <digirigawa@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Al   Viro <viro@zeniv.linux.org.uk>
Cc: Dan Carpenter   <dan.carpenter@linaro.org>
Cc: Beau Belgrave <beaub@linux.microsoft.com>
Cc: Florian Fainelli  <florian.fainelli@broadcom.com>
Cc: Alexey Makhalov    <alexey.makhalov@broadcom.com>
Cc: Vasavi Sirnapalli    <vasavi.sirnapalli@broadcom.com>
Link: https://lore.kernel.org/20240730110657.3b69d3c1@gandalf.local.home
Fixes: b63db58e2fa5d ("eventfs/tracing: Add callback for release of an eventfs_inode")
Reported-by: Mathias Krause <minipli@grsecurity.net>
Tested-by: Mathias Krause <minipli@grsecurity.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[Resolve conflict due to lack of commit a1f157c7a3bb ("tracing: Expand all
 ring buffers individually") which add tracing_update_buffers() in
event_enable_write(), that commit is more of a feature than a bugfix
and is not related to the problem fixed by this patch]
Signed-off-by: Zheng Yejian <zhengyejian@huaweicloud.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.h                |   23 +++++++++++++++++++++++
 kernel/trace/trace_events.c         |   33 ++++++++++++++++++++-------------
 kernel/trace/trace_events_hist.c    |    4 ++--
 kernel/trace/trace_events_inject.c  |    2 +-
 kernel/trace/trace_events_trigger.c |    6 +++---
 5 files changed, 49 insertions(+), 19 deletions(-)

--- a/kernel/trace/trace.h
+++ b/kernel/trace/trace.h
@@ -1555,6 +1555,29 @@ static inline void *event_file_data(stru
 extern struct mutex event_mutex;
 extern struct list_head ftrace_events;
 
+/*
+ * When the trace_event_file is the filp->i_private pointer,
+ * it must be taken under the event_mutex lock, and then checked
+ * if the EVENT_FILE_FL_FREED flag is set. If it is, then the
+ * data pointed to by the trace_event_file can not be trusted.
+ *
+ * Use the event_file_file() to access the trace_event_file from
+ * the filp the first time under the event_mutex and check for
+ * NULL. If it is needed to be retrieved again and the event_mutex
+ * is still held, then the event_file_data() can be used and it
+ * is guaranteed to be valid.
+ */
+static inline struct trace_event_file *event_file_file(struct file *filp)
+{
+	struct trace_event_file *file;
+
+	lockdep_assert_held(&event_mutex);
+	file = READ_ONCE(file_inode(filp)->i_private);
+	if (!file || file->flags & EVENT_FILE_FL_FREED)
+		return NULL;
+	return file;
+}
+
 extern const struct file_operations event_trigger_fops;
 extern const struct file_operations event_hist_fops;
 extern const struct file_operations event_hist_debug_fops;
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -1386,12 +1386,12 @@ event_enable_read(struct file *filp, cha
 	char buf[4] = "0";
 
 	mutex_lock(&event_mutex);
-	file = event_file_data(filp);
+	file = event_file_file(filp);
 	if (likely(file))
 		flags = file->flags;
 	mutex_unlock(&event_mutex);
 
-	if (!file || flags & EVENT_FILE_FL_FREED)
+	if (!file)
 		return -ENODEV;
 
 	if (flags & EVENT_FILE_FL_ENABLED &&
@@ -1428,8 +1428,8 @@ event_enable_write(struct file *filp, co
 	case 1:
 		ret = -ENODEV;
 		mutex_lock(&event_mutex);
-		file = event_file_data(filp);
-		if (likely(file && !(file->flags & EVENT_FILE_FL_FREED)))
+		file = event_file_file(filp);
+		if (likely(file))
 			ret = ftrace_event_enable_disable(file, val);
 		mutex_unlock(&event_mutex);
 		break;
@@ -1538,7 +1538,8 @@ enum {
 
 static void *f_next(struct seq_file *m, void *v, loff_t *pos)
 {
-	struct trace_event_call *call = event_file_data(m->private);
+	struct trace_event_file *file = event_file_data(m->private);
+	struct trace_event_call *call = file->event_call;
 	struct list_head *common_head = &ftrace_common_fields;
 	struct list_head *head = trace_get_fields(call);
 	struct list_head *node = v;
@@ -1570,7 +1571,8 @@ static void *f_next(struct seq_file *m,
 
 static int f_show(struct seq_file *m, void *v)
 {
-	struct trace_event_call *call = event_file_data(m->private);
+	struct trace_event_file *file = event_file_data(m->private);
+	struct trace_event_call *call = file->event_call;
 	struct ftrace_event_field *field;
 	const char *array_descriptor;
 
@@ -1625,12 +1627,14 @@ static int f_show(struct seq_file *m, vo
 
 static void *f_start(struct seq_file *m, loff_t *pos)
 {
+	struct trace_event_file *file;
 	void *p = (void *)FORMAT_HEADER;
 	loff_t l = 0;
 
 	/* ->stop() is called even if ->start() fails */
 	mutex_lock(&event_mutex);
-	if (!event_file_data(m->private))
+	file = event_file_file(m->private);
+	if (!file)
 		return ERR_PTR(-ENODEV);
 
 	while (l < *pos && p)
@@ -1704,8 +1708,8 @@ event_filter_read(struct file *filp, cha
 	trace_seq_init(s);
 
 	mutex_lock(&event_mutex);
-	file = event_file_data(filp);
-	if (file && !(file->flags & EVENT_FILE_FL_FREED))
+	file = event_file_file(filp);
+	if (file)
 		print_event_filter(file, s);
 	mutex_unlock(&event_mutex);
 
@@ -1734,9 +1738,13 @@ event_filter_write(struct file *filp, co
 		return PTR_ERR(buf);
 
 	mutex_lock(&event_mutex);
-	file = event_file_data(filp);
-	if (file)
-		err = apply_event_filter(file, buf);
+	file = event_file_file(filp);
+	if (file) {
+		if (file->flags & EVENT_FILE_FL_FREED)
+			err = -ENODEV;
+		else
+			err = apply_event_filter(file, buf);
+	}
 	mutex_unlock(&event_mutex);
 
 	kfree(buf);
@@ -2451,7 +2459,6 @@ static int event_callback(const char *na
 	if (strcmp(name, "format") == 0) {
 		*mode = TRACE_MODE_READ;
 		*fops = &ftrace_event_format_fops;
-		*data = call;
 		return 1;
 	}
 
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5609,7 +5609,7 @@ static int hist_show(struct seq_file *m,
 
 	mutex_lock(&event_mutex);
 
-	event_file = event_file_data(m->private);
+	event_file = event_file_file(m->private);
 	if (unlikely(!event_file)) {
 		ret = -ENODEV;
 		goto out_unlock;
@@ -5888,7 +5888,7 @@ static int hist_debug_show(struct seq_fi
 
 	mutex_lock(&event_mutex);
 
-	event_file = event_file_data(m->private);
+	event_file = event_file_file(m->private);
 	if (unlikely(!event_file)) {
 		ret = -ENODEV;
 		goto out_unlock;
--- a/kernel/trace/trace_events_inject.c
+++ b/kernel/trace/trace_events_inject.c
@@ -299,7 +299,7 @@ event_inject_write(struct file *filp, co
 	strim(buf);
 
 	mutex_lock(&event_mutex);
-	file = event_file_data(filp);
+	file = event_file_file(filp);
 	if (file) {
 		call = file->event_call;
 		size = parse_entry(buf, call, &entry);
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -159,7 +159,7 @@ static void *trigger_start(struct seq_fi
 
 	/* ->stop() is called even if ->start() fails */
 	mutex_lock(&event_mutex);
-	event_file = event_file_data(m->private);
+	event_file = event_file_file(m->private);
 	if (unlikely(!event_file))
 		return ERR_PTR(-ENODEV);
 
@@ -213,7 +213,7 @@ static int event_trigger_regex_open(stru
 
 	mutex_lock(&event_mutex);
 
-	if (unlikely(!event_file_data(file))) {
+	if (unlikely(!event_file_file(file))) {
 		mutex_unlock(&event_mutex);
 		return -ENODEV;
 	}
@@ -293,7 +293,7 @@ static ssize_t event_trigger_regex_write
 	strim(buf);
 
 	mutex_lock(&event_mutex);
-	event_file = event_file_data(file);
+	event_file = event_file_file(file);
 	if (unlikely(!event_file)) {
 		mutex_unlock(&event_mutex);
 		kfree(buf);


