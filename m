Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 738E9477984;
	Wed,  9 Sep 2026 13:49:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961760; cv=none; b=A53qVnQbKbxVcwzq3U9scAEobC+Uu2BVMoJOBrTbPViGn2LPc8htEpw8ZZz3Mv9JxpJXWT5pVhZpDzXdymIoh3PNj0VEu3ItX/FobaYl5Cs3egXIQb1qPB1rXU1ssL6i3/yYyQuXYKdP8GLuOBEKiPMpe493zV8YVYjXh6Mw86o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961760; c=relaxed/simple;
	bh=PpD5Bajxan3jVboUc1TNnc/W7NGUfoJN206qqBZrQ7s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N5bCZjsTK+dltSUAgINnJaWuZ+hujIbCNUA0U9eiRAzzTYNISce7VY0PAUMrrf82TjfrOPQOilBXZZmG0W602SE8U5YvbEr7eFAqyH7KH85VALTH/8bF9nPk3Vn8sSOyBMpmg//dwX7uk5Jzd/dCdBy+r+QIMrPCuXxUK33CEH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Xm++Bn89; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Xm++Bn89"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD2D31F00A3A;
	Wed,  9 Sep 2026 13:49:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961759;
	bh=b8PW2QxwYxQzi5eaRX1GKoshcqffpaWTD6OVfTazbcY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xm++Bn89nOyYZvW2oxBrhsvHf5QZG1EwZwigWAYTImGMBkOX0JGldQhIGNaG0VJlz
	 wf7GM1IDvoFu6JD+q5RIv5dXKISHbaloV13V3oqcoFM1E1UKBjSmHR4D6sDLzI74va
	 3p+KEopA4GnB9zjDUviReBP8bo7IpcJnJO/mjByg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	sashiko-bot@kernel.org,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 058/556] tracing: Take trace_array reference when opening options file
Date: Wed,  9 Sep 2026 15:35:38 +0200
Message-ID: <20260909134232.510992079@linuxfoundation.org>
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

commit f2951ebd15c36a1ea4820a7f0cbb0b5f1c028b73 upstream.

The options files do not take the trace_array reference for the options
they represent. This could cause a use-after-free kernel crash if one of
these files is opened by one task and another task removes the instance
that the option is for. Because it doesn't take a reference upon opening,
it will not stop the removal which will free the options descriptor that
is being used.

As the options are somewhat dynamic in their creation at boot up, each
file represents a flag in the trace_array. The trace_array has an array of
indexes to represent each of these flags that is stored in the
trace_flags_index array. The address of the index array element is used to
pass to the inode->i_private pointer. Then that element is read which
holds the index (which represents the flag) and then the index is used to
calculate the trace_array descriptor from its trace_flags_index array.

One issue is that the index element can not be referenced until the
trace_array's reference is taken. To handle this, create a new helper
function called: trace_array_options_get() that will iterate all the
existing trace_arrays in the ftrace_trace_arrays list (under the
trace_types_lock), and compare the passed in address of the index element
with the entire array of the trace_array's trace_flags_index array.
If it matches, then up the corresponding trace_array's reference and
return.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260902121918.5a9e9d1b@gandalf.local.home
Fixes: 577b785f55168 ("tracing: add tracer dependent options to options directory")
Reported-by: sashiko-bot@kernel.org
Closes: https://lore.kernel.org/linux-trace-kernel/20260828135858.2AC501F000E9@smtp.kernel.org/
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   67 +++++++++++++++++++++++++++++++++++++++++++++++----
 1 file changed, 63 insertions(+), 4 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7840,11 +7840,70 @@ trace_options_core_write(struct file *fi
 	return cnt;
 }
 
+/*
+ * The tr_index is the address of a trace_array->trace_flags_index[]
+ * element that holds the index of the trace flag. But since the
+ * trace_array reference has not been taken yet, it cannot be referenced
+ * as it could have been freed by a rmdir of the instance the trace_array
+ * represents.
+ *
+ * Search the list of trace_arrays and compare the tr_index to the
+ * address of the entire trace_array trace_flags_index array for each
+ * trace_array in the list. If one is matched, then take the reference
+ * and return it. If not, the trace_array no longer exits.
+ */
+static int trace_array_options_get(void *tr_index)
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
+		if (tr_index >= (void *)&tr->trace_flags_index[0] &&
+		    tr_index < (void *)&tr->trace_flags_index[TRACE_FLAGS_MAX_SIZE])
+			return __trace_array_get(tr);
+	}
+	return -ENODEV;
+}
+
+static int trace_options_open(struct inode *inode, struct file *filp)
+{
+	void *tr_index = inode->i_private;
+
+	if (trace_array_options_get(tr_index) < 0)
+		return -ENODEV;
+
+	filp->private_data = tr_index;
+
+	return 0;
+}
+
+static int trace_options_release(struct inode *inode, struct file *filp)
+{
+	void *tr_index = filp->private_data;
+	struct trace_array *tr;
+	unsigned int index;
+
+	get_tr_index(tr_index, &tr, &index);
+
+	trace_array_put(tr);
+
+	return 0;
+}
+
 static const struct file_operations trace_options_core_fops = {
-	.open = tracing_open_generic,
-	.read = trace_options_core_read,
-	.write = trace_options_core_write,
-	.llseek = generic_file_llseek,
+	.open		= trace_options_open,
+	.read		= trace_options_core_read,
+	.write		= trace_options_core_write,
+	.llseek		= generic_file_llseek,
+	.release	= trace_options_release,
 };
 
 struct dentry *trace_create_file(const char *name,


