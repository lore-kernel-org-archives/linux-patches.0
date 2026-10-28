Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793207207;
	b=u7OL+0+o6fy6aYffjcq9W1O17iUYQ8T4YMenWntrBvX6Ip/Cu1//ehYzaTCpHDcyJY2Q
	 dmzMDAmvX7xI4yOVA00ZREk0U40LKbeWpv84AhkX+ltXeBqWFxA8l+QOjjO04Usn8zTsM
	 aRp1IGt4KjOFAJ4n6G3SjzdkYV0f3guMM6W1uLH0gIAbkjd4xALqePMNbmFAqTQViMcs0
	 iMn6drAJjtrM6XT3XphBuJXHHnssUf41ShIRWkRwUaaq2Rpt9eoEuDi1GxS/iGK28O80L
	 F6DKxCM/0HO4WSSYBLE/pnR+MdLcTT0vfTpFc2EqhbN2EdHCyBposVd1oN0szxyf+Cw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793207207;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=TJUwJPuu66rbQhP29of1ez5YDFyA3F6o+DJlotKFMsQ=;
	b=N5KqiLWT0khPyJiWfb7NT/MTXfD5eIvOh0M2HUjHndaZM82drbroD4zPxQFOjQbk2952
	 fNfVKahbY2XoVq1B3LrI8v22sqjn2LVCe/7wLOWY10UkaXgddUlqTqinR/HL5xyrxHo9A
	 xRiEizqCJ2dEofoOAVHQbPzK4q0ZLU+zFPoHMeFvjq35H8SDsd50PBJvjTimVRVQ7FmkM
	 fpX1kyr9fTo87WaUQGUTH6DHGJiCFk1klIOl7n46GOe1eqRX4OzLW8bO8kwt0VwG2eByk
	 O7/pVzVAn0nIOljc61GVewH7aM0Uht037OiSigzaRwDNAWt5mzcsQzkpXIiwhv1KIrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzKJssHg;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EC3A606A31A;
	Wed, 28 Oct 2026 17:06:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bzKJssHg
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81A1A1F031E9;
	Wed, 28 Oct 2026 17:06:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793207207;
	bh=TJUwJPuu66rbQhP29of1ez5YDFyA3F6o+DJlotKFMsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bzKJssHg7/CdnCQ5/mrhRQ0iSkw58Pgb6gkzMp6UPtpnRBEuZ+cwYlX4L1N7WL2ch
	 LCuBP4Sh682qWMZHxwgs4I6d4CcX2JYBlZs18EMJNjKn1CVNBrWYDlvDJfIVQaMOa0
	 V639inUy8EUJDYChzSOedZudLmSYAOZ+t5xtcQBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.2 09/88] tracing: Hold trace_types_lock when resetting last boot data from readers
Date: Wed, 28 Oct 2026 17:59:17 +0100
Message-ID: <20261028165942.333827438@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.107695352@linuxfoundation.org>
References: <20261028165942.107695352@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4706,7 +4707,7 @@ tracing_set_trace_read(struct file *filp
 int tracer_init(struct tracer *t, struct trace_array *tr)
 {
 	tracing_reset_online_cpus(&tr->array_buffer);
-	update_last_data_if_empty(tr);
+	__update_last_data_if_empty(tr);
 	return t->init(tr);
 }
 
@@ -5385,8 +5386,10 @@ static int tracing_wait_pipe(struct file
 	return 1;
 }
 
-static bool update_last_data_if_empty(struct trace_array *tr)
+static bool __update_last_data_if_empty(struct trace_array *tr)
 {
+	lockdep_assert_held(&trace_types_lock);
+
 	if (!(tr->flags & TRACE_ARRAY_FL_LAST_BOOT))
 		return false;
 
@@ -5401,6 +5404,16 @@ static bool update_last_data_if_empty(st
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
@@ -6493,7 +6506,7 @@ int tracing_set_clock(struct trace_array
 		ring_buffer_set_clock(tr->snapshot_buffer.buffer, trace_clocks[i].func);
 	tracing_reset_online_cpus(&tr->snapshot_buffer);
 #endif
-	update_last_data_if_empty(tr);
+	__update_last_data_if_empty(tr);
 
 	if (tr->scratch && !(tr->flags & TRACE_ARRAY_FL_LAST_BOOT)) {
 		struct trace_scratch *tscratch = tr->scratch;


