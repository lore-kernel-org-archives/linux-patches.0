Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C127352F86;
	Tue, 12 May 2026 18:10:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609458; cv=none; b=d/C62/XxrtZ70n9K2YNlZ4o7hYCUqXvTxpRuX3FScu3U8w244w5MlZiYEx7lAVbCoVnoZIhah3u8CqWwi1JkS6CZQZxyXgjw9hIFRk7vWYUetaDqhoT9Z6uJ9V+D1XFV0ONQdO4DEYNEILma+5IvqqFyrrBckQJhdVGZ5SYIYmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609458; c=relaxed/simple;
	bh=gz7eIuLJ8kacqfPNLZ+MOwTbIkWRgqW+0P6wkqWNWjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E5QW1LvWO30EAz7LvIDCHD31bqATfQlnnPaZpDcwVViKwsljicpUL7UeaUqEUEjqczppF55gTHMeB8Nvg4FweMudJNk9AfCJUMcEK8ovkSOFIhqh6cSVKo1lZ+f2M2qk8y+vFHuDZMhDHL2hA7nKlxsGveqjiYc1HMseHbuVHIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ycOhknJf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ycOhknJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3819C2BCF5;
	Tue, 12 May 2026 18:10:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609458;
	bh=gz7eIuLJ8kacqfPNLZ+MOwTbIkWRgqW+0P6wkqWNWjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ycOhknJfxPV6reM/QYzXW0q9xx2RS5Z6BiDejczu35VK9prIMETvAPNfP2CuxxiCk
	 lDn9eatSKyym6tcdzKNWIoQdTVXl8rJemOiJ7GOphhONhszl/t/3cHQmNaKkbsEAKG
	 I8YCuL8IyURKDsFi0Hk3UyS0BfGXH6tkVZO7UeU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>
Subject: [PATCH 7.0 162/307] tracing/fprobe: Unregister fprobe even if memory allocation fails
Date: Tue, 12 May 2026 19:39:17 +0200
Message-ID: <20260512173943.543431260@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 1aec9e5c3e31ce1e28f914427fb7f90b91d310df upstream.

unregister_fprobe() can fail under memory pressure because of memory
allocation failure, but this maybe called from module unloading, and
usually there is no way to retry it. Moreover. trace_fprobe does not
check the return value.

To fix this problem, unregister fprobe and fprobe_hash_node even if
working memory allocation fails.
Anyway, if the last fprobe is removed, the filter will be freed.

Link: https://lore.kernel.org/all/177669365629.132053.8433032896213721288.stgit@mhiramat.tok.corp.google.com/

Fixes: 4346ba160409 ("fprobe: Rewrite fprobe on function-graph tracer")
Cc: stable@vger.kernel.org
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/fprobe.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/kernel/trace/fprobe.c
+++ b/kernel/trace/fprobe.c
@@ -331,9 +331,10 @@ static void fprobe_ftrace_remove_ips(uns
 	lockdep_assert_held(&fprobe_mutex);
 
 	fprobe_ftrace_active--;
-	if (!fprobe_ftrace_active)
+	if (!fprobe_ftrace_active) {
 		unregister_ftrace_function(&fprobe_ftrace_ops);
-	if (num)
+		ftrace_free_filter(&fprobe_ftrace_ops);
+	} else if (num)
 		ftrace_set_filter_ips(&fprobe_ftrace_ops, addrs, num, 1, 0);
 }
 
@@ -532,10 +533,10 @@ static void fprobe_graph_remove_ips(unsi
 
 	fprobe_graph_active--;
 	/* Q: should we unregister it ? */
-	if (!fprobe_graph_active)
+	if (!fprobe_graph_active) {
 		unregister_ftrace_graph(&fprobe_graph_ops);
-
-	if (num)
+		ftrace_free_filter(&fprobe_graph_ops.ops);
+	} else if (num)
 		ftrace_set_filter_ips(&fprobe_graph_ops.ops, addrs, num, 1, 0);
 }
 
@@ -922,15 +923,19 @@ static int unregister_fprobe_nolock(stru
 	int i, count;
 
 	addrs = kcalloc(hlist_array->size, sizeof(unsigned long), GFP_KERNEL);
-	if (!addrs) {
-		ret = -ENOMEM;	/* TODO: Fallback to one-by-one loop */
-		goto out;
-	}
+	/*
+	 * This will remove fprobe_hash_node from the hash table even if
+	 * memory allocation fails. However, ftrace_ops will not be updated.
+	 * Anyway, when the last fprobe is unregistered, ftrace_ops is also
+	 * unregistered.
+	 */
+	if (!addrs)
+		pr_warn("Failed to allocate working array. ftrace_ops may not sync.\n");
 
 	/* Remove non-synonim ips from table and hash */
 	count = 0;
 	for (i = 0; i < hlist_array->size; i++) {
-		if (!delete_fprobe_node(&hlist_array->array[i]))
+		if (!delete_fprobe_node(&hlist_array->array[i]) && addrs)
 			addrs[count++] = hlist_array->array[i].addr;
 	}
 	del_fprobe_hash(fp);


