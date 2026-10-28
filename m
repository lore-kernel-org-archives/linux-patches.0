Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207139;
	b=xRnm9B0LKwgh+KVX8okSkCeo8L3ns1J2XnPyJ7fQKLdUgfmpgk2ByoP3SNhZDbBrTGja
	 O4OPI2uClMgovtjjnEy6g9ZVo0q1KWir20A6AdNAlrubXUYG76DukeuhtPUPqYrJENt1Z
	 KQwqjJE+yorSJsX3Vrd+XmtmAJ/dqKMVlrxxShti2F8aGhoVh4pWdN67t6EJMUUZXIkw0
	 sVRhEdMH5ZCmFk82wR5LsbiRsewxY6bDiy9Fa6jSvi40sD69PWPIc1dQfZgUxoTXss4mY
	 YIaw2+qnWgJwrxv7I65PsE87YyfviWPzK1O09A3ZcwRHbIMJ5XxCG3dDnqygHNtSTtg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=qczC8NT5iKEu0knEzNehkzwq+9Cuh2Tr4rOjtJtVXCE=;
	b=gqCJtK8dKCiu2DH4EygZoCF83akRigbSLiD8sxaf6nhLK6JQUI7LdU3UpYdT6KmzY6GX
	 nuBxmBy5zE7iK5eDhqov3ykqjs6hMF9Nm+oz7pjGgMK7b/CVNyCV2yNHrxwP5R/TQMuNm
	 8Niz7Qc5HmzMA9N4HMUylvtLzILS7P0X0g6A0Ocr6ewRLejhnadRKK9cslgP7X8xZqOnx
	 FQjMaZhA6BRBx/Iy3VKdprx9H+q+vQDEofSLkrUhLLSoD65qayX7IdFgIiKKRzfkbF1RS
	 AX4mi9kpDFTx4OFz8teOrjYZ8jgon8t2TdjKRnIJCj6R0GRGDLRebMLwE+tgs5L4gFA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9tLsKx2;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC71606A321;
	Wed, 28 Oct 2026 17:05:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=F9tLsKx2
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF4451F01825;
	Wed, 28 Oct 2026 17:05:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207139;
	bh=qczC8NT5iKEu0knEzNehkzwq+9Cuh2Tr4rOjtJtVXCE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=F9tLsKx2zj7zZe95DW5o9fnmp0jJkmB99mMfA+z/120E7AJge2eOJ4EGlfOuXc2Wq
	 bwlyPQ2Fpm4pHf0RSzK7c+r+ArDJkT3cmpI+38yFDiNvn+m+uB5+cvfrJsd8EewkHy
	 vjHl8pFZY7s5EECet89TaDHhgpj0rJeOCdFAkRHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.3 06/38] tracing: Hold trace_types_lock when resetting last boot data from readers
Date: Wed, 28 Oct 2026 17:59:53 +0100
Message-ID: <20261028165940.565184381@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165940.394092994@linuxfoundation.org>
References: <20261028165940.394092994@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Carlier <devnexen@gmail.com>

commit 5a6bd62f09147b49b31fd19d4eba122cb5f941a1 upstream.

update_last_data_if_empty() is called from tracing_open() with O_TRUNC,
tracing_read_pipe() and tracing_buffers_read() without trace_types_lock.
Two readers can both pass the LAST_BOOT test and free module_delta
twice, and a module notifier can update module_delta while it is being
freed.

Take trace_types_lock in those paths and keep the callers that already
hold it on an unlocked variant.

Cc: stable@vger.kernel.org
Fixes: 32dc0042528d ("tracing: Reset last-boot buffers when reading out all cpu buffers")
Link: https://patch.msgid.link/20261016061638.214847-2-devnexen@gmail.com
Signed-off-by: David Carlier <devnexen@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |   19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -3614,6 +3614,7 @@ static int tracing_single_release_tr(str
 	return single_release(inode, file);
 }
 
+static bool __update_last_data_if_empty(struct trace_array *tr);
 static bool update_last_data_if_empty(struct trace_array *tr);
 
 static int tracing_open(struct inode *inode, struct file *file)
@@ -4708,7 +4709,7 @@ tracing_set_trace_read(struct file *filp
 int tracer_init(struct tracer *t, struct trace_array *tr)
 {
 	tracing_reset_online_cpus(&tr->array_buffer);
-	update_last_data_if_empty(tr);
+	__update_last_data_if_empty(tr);
 	return t->init(tr);
 }
 
@@ -5387,8 +5388,10 @@ static int tracing_wait_pipe(struct file
 	return 1;
 }
 
-static bool update_last_data_if_empty(struct trace_array *tr)
+static bool __update_last_data_if_empty(struct trace_array *tr)
 {
+	lockdep_assert_held(&trace_types_lock);
+
 	if (!(tr->flags & TRACE_ARRAY_FL_LAST_BOOT))
 		return false;
 
@@ -5403,6 +5406,16 @@ static bool update_last_data_if_empty(st
 	return true;
 }
 
+static bool update_last_data_if_empty(struct trace_array *tr)
+{
+	/* Avoid the lock on the read path unless this is a last boot buffer */
+	if (!(tr->flags & TRACE_ARRAY_FL_LAST_BOOT))
+		return false;
+
+	guard(mutex)(&trace_types_lock);
+	return __update_last_data_if_empty(tr);
+}
+
 /*
  * Consumer reader.
  */
@@ -6495,7 +6508,7 @@ int tracing_set_clock(struct trace_array
 		ring_buffer_set_clock(tr->snapshot_buffer.buffer, trace_clocks[i].func);
 	tracing_reset_online_cpus(&tr->snapshot_buffer);
 #endif
-	update_last_data_if_empty(tr);
+	__update_last_data_if_empty(tr);
 
 	if (tr->scratch && !(tr->flags & TRACE_ARRAY_FL_LAST_BOOT)) {
 		struct trace_scratch *tscratch = tr->scratch;


