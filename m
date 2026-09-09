Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 949B1477984;
	Wed,  9 Sep 2026 13:49:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961757; cv=none; b=o/VK1Cno31WJF716kQvq9SSz9BjP3LsenYkp9S9x7RKSg54PaOZTJQ1vvM33QZ5ZrNWiGVtaZwBZc1bOmYbKJxWneAfiyOyPcXhKAcvvlyEQztbt0BSABQdrR6gl36mkdYSZB4ZdZfGfchBeNjPBU7rBiPDQT/56Btx7F+sWh/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961757; c=relaxed/simple;
	bh=hzdJqHOU63TzP/jBeT7bOJO3ZpvjTZLArK1Z6ZlHDzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VFullJjwNA2xNQJn8ap4bSa/uffIedyjH+oBF3xz7f6/T61BEtzvp4m6NZmEeOwHnN8VigCZoGqNDfuEwUpE1lKhS6OxWMV0h5jNFZV/OGYZ7oX3XUGo3Dn3IHPgiwnNv2AV4dsFRARPDBH4+VgcnhpeeK3ayb7wPISqMz7xLkI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m2V1a0qQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m2V1a0qQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EECC71F00A3A;
	Wed,  9 Sep 2026 13:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961756;
	bh=/1p1cY5ESO2LcyUtkjlzAICfpWd/dcMproYXdW8GXRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=m2V1a0qQx4VS0i8v+oj2OushGfb/AhjPZiQV6UbYWxLMKP+bsylphtKbFsjofMmmt
	 hQSUaR3u6+hqD58ho6TEva3vAGmoQP0cWP3+qZ5zUK83PyvnqcemCG9mhwh89cc/Ut
	 UcIH9zozAplP9h6CsPRYMxoopiGoN+OHWthSJv9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Farhad Alemi <farhad.alemi@berkeley.edu>,
	Aaron Tomlin <atomlin@atomlin.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 057/556] tracing: Have show_event_filters/triggers files take trace array ref
Date: Wed,  9 Sep 2026 15:35:37 +0200
Message-ID: <20260909134232.477505417@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

commit f4a771cc684c7354b6200147f7252c58d17408ff upstream.

The newly added files show_event_filters and show_event_triggers that show
all filters or triggers that are set within the trace array do not take a
reference for the trace array it is showing. Without taking a reference,
the trace_array may be freed via "rmdir" while a task is reading one of
theses files. Those files iterate all the events within an instance
(trace_array) and nothing prevents that instance from being freed while
its data is being read. This causes a use-after-free crash.

Have the open of both those files take the trace_array reference via the
trace_array_get() that prevents the trace_array from being freed while the
files are opened.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260828094153.17b95037@gandalf.local.home
Fixes: 729757b96a662 ("tracing: Add show_event_filters to expose active event filters")
Fixes: 6a80838814eea ("tracing: Add show_event_triggers to expose active event triggers")
Reported-by: Farhad Alemi <farhad.alemi@berkeley.edu>
Closes: https://lore.kernel.org/all/CA+0ovCjerKZJLwXScM9bF2ga2rLi4_XOpUfK41NDbENpeu98jA@mail.gmail.com/
Reviewed-by: Aaron Tomlin <atomlin@atomlin.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_events.c |   28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2654,14 +2654,14 @@ static const struct file_operations ftra
 	.open = ftrace_event_show_filters_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = seq_release,
+	.release = ftrace_event_release,
 };
 
 static const struct file_operations ftrace_show_event_triggers_fops = {
 	.open = ftrace_event_show_triggers_open,
 	.read = seq_read,
 	.llseek = seq_lseek,
-	.release = seq_release,
+	.release = ftrace_event_release,
 };
 
 static const struct file_operations ftrace_set_event_pid_fops = {
@@ -2819,7 +2819,17 @@ ftrace_event_set_open(struct inode *inod
 static int
 ftrace_event_show_filters_open(struct inode *inode, struct file *file)
 {
-	return ftrace_event_open(inode, file, &show_show_event_filters_seq_ops);
+	struct trace_array *tr = inode->i_private;
+	int ret;
+
+	ret = tracing_check_open_get_tr(tr);
+	if (ret)
+		return ret;
+
+	ret = ftrace_event_open(inode, file, &show_show_event_filters_seq_ops);
+	if (ret < 0)
+		trace_array_put(tr);
+	return ret;
 }
 
 /**
@@ -2833,7 +2843,17 @@ ftrace_event_show_filters_open(struct in
 static int
 ftrace_event_show_triggers_open(struct inode *inode, struct file *file)
 {
-	return ftrace_event_open(inode, file, &show_show_event_triggers_seq_ops);
+	struct trace_array *tr = inode->i_private;
+	int ret;
+
+	ret = tracing_check_open_get_tr(tr);
+	if (ret)
+		return ret;
+
+	ret = ftrace_event_open(inode, file, &show_show_event_triggers_seq_ops);
+	if (ret < 0)
+		trace_array_put(tr);
+	return ret;
 }
 
 static int


