Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793209674;
	b=D8iODOBK7efdoFCU2QUypEvIZ+KcGXKboXWD3zMlbLM+2zF1lKEE7l9s5GdNf6eSSUHF
	 9tCBJuWuTw7ApfeemO/qh+tcAa66JxswxtosaofmHuEAW5l+6F4GUem0BS5b6s/5iTq7t
	 cUig8Vsi/U/lSCjNdXdAm5vf8gpsrcKzpnFgLFDFjjfGKBWNOlfIA/D3/gcqRvacHsRfR
	 4DqCq/NVw3MXz0Jc3W6V0/o3XJO7EvzY4aTzJxp6eK954iXw07vLXFByFHd/cHzoVNavS
	 KxQqhn1uRYIl5/A+Bh561rTqfYwEuHEdvsSshW/0YVZQFUfW0wuxBGttFWd2BmMHQIg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793209674;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CLXBRHKRFUoRDXCELXt61yjy/3DEV8BLSJMS7CCaFSk=;
	b=Uh6YWNQ1AGR3HHBobvCvmlMVZpowwRHxiHmOVUGAiQoBrIMor73fGu1fPmHoztNILu7d
	 lekzkmE6rvEed28xmnkSa155Yzm6XKzmvWWDvsT0JZm1OWZVlRBxAwv7PYXxM/1eMW4MK
	 KRpfbj6m0qL2k6PoB49hqPPtTAHMcfAqy/72RDzTUmio8OX/ZnGMDcDM/i7LhiPHaEPD1
	 NPAfWnkOJFjcxSBmbO7wzrNo7WVsyMdkBpDmHCo1ceSi8i3/hK00IUtc3BTg7LHgUAJng
	 xTpuaUL2naS5UZst2NjnpbU8PSuaXIZZY7aY70zFSSusQiF9Ts8UmVdU8xa3YvjfoBQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUwbZ68N;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70023606A31E;
	Wed, 28 Oct 2026 17:47:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=dUwbZ68N
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7500E1F01825;
	Wed, 28 Oct 2026 17:47:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793209674;
	bh=CLXBRHKRFUoRDXCELXt61yjy/3DEV8BLSJMS7CCaFSk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dUwbZ68N2tLoelYolK6TZGzAfNZAzaCwzT6Z3wYKDx8mgKVaxU2rAqhRvGi2tMp4F
	 O6/LlU1EZzO8mFEgpAzAcPJMUmS3JjuWmZytAmoCEHTtkm7LE+B2Kl+LeHzzz3Vrvq
	 mGSHiUrKYYSpTvuiHsJBrZEuAAb2T7jga9O6PD2U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Carlier <devnexen@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 036/109] tracing: Hold trace_types_lock when resetting last boot data from readers
Date: Wed, 28 Oct 2026 18:00:20 +0100
Message-ID: <20261028165943.211524598@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028165942.357251485@linuxfoundation.org>
References: <20261028165942.357251485@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4847,6 +4847,7 @@ static int tracing_single_release_tr(str
 	return single_release(inode, file);
 }
 
+static bool __update_last_data_if_empty(struct trace_array *tr);
 static bool update_last_data_if_empty(struct trace_array *tr);
 
 static int tracing_open(struct inode *inode, struct file *file)
@@ -5916,7 +5917,7 @@ tracing_set_trace_read(struct file *filp
 int tracer_init(struct tracer *t, struct trace_array *tr)
 {
 	tracing_reset_online_cpus(&tr->array_buffer);
-	update_last_data_if_empty(tr);
+	__update_last_data_if_empty(tr);
 	return t->init(tr);
 }
 
@@ -6654,8 +6655,10 @@ static int tracing_wait_pipe(struct file
 	return 1;
 }
 
-static bool update_last_data_if_empty(struct trace_array *tr)
+static bool __update_last_data_if_empty(struct trace_array *tr)
 {
+	lockdep_assert_held(&trace_types_lock);
+
 	if (!(tr->flags & TRACE_ARRAY_FL_LAST_BOOT))
 		return false;
 
@@ -6670,6 +6673,16 @@ static bool update_last_data_if_empty(st
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
@@ -7599,7 +7612,7 @@ int tracing_set_clock(struct trace_array
 		ring_buffer_set_clock(tr->max_buffer.buffer, trace_clocks[i].func);
 	tracing_reset_online_cpus(&tr->max_buffer);
 #endif
-	update_last_data_if_empty(tr);
+	__update_last_data_if_empty(tr);
 
 	if (tr->scratch && !(tr->flags & TRACE_ARRAY_FL_LAST_BOOT)) {
 		struct trace_scratch *tscratch = tr->scratch;


