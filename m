Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 882C2381AEC;
	Thu, 20 Aug 2026 17:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787247219; cv=none; b=tS6K4o+JO1W+jqXzn8hbvN0ngXOvyzuNe9m53VbZi1Qdq+I9+Q4ba7JHMuFEWTjZjkyHJSpAjyehcE3s9eH5eVL/Q3vYdS5bqoJVA6OTN9G4nNxrmSnAUZjCflLnhNbAZ/0YheQqR4e8hvsj+6Byt5VLpftavuhm5KokfHAAP8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787247219; c=relaxed/simple;
	bh=cQsMx37wDqoDgsCw2yrOuiGkQ22aZl5q0GQCwADPgYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bXhet8eDAvUOi4ieOLslXwtjrym0eST+Ul8Y3PZtrV9syiJKegMd/aH+QFgBDce0ofprCbCGCr9GyJ+s84CtlA6sWvAlydqV9yvF7gWIVCcuOUZ96iW0W6VGPCQKoZSeeC4qfulf+htv3oTu+wwaW8XNJpNNxa1Xpe9xa1yVXM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vK45Ibsp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vK45Ibsp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E64F51F000E9;
	Thu, 20 Aug 2026 17:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787247218;
	bh=7fy8odT8O5JNhYhT6dX5iiicXFJa5ld/lQVFujiFqvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vK45IbspORUPHgbL/igZhoT7k7XR2TQJDh0AD7LHq4883x1FQYafFJDvGr/i/9Jyu
	 aADVtQNgQgVLGZpEwfyeDNYSo4ooDnWTEPc/aKHpZs4PYrAVyTYMGv4t5Naen6MFNM
	 My3LHOJ/jNMyk8eOMvErzGUScx+etzoMu8NLpZ9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 183/220] ring-buffer: Simplify ring_buffer_read_page() with guard()
Date: Thu, 20 Aug 2026 16:56:13 +0200
Message-ID: <20260820145228.993737811@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260820145223.480031205@linuxfoundation.org>
References: <20260820145223.480031205@linuxfoundation.org>
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

[ Upstream commit b2e7c6ed26e90fab1e5e626071e54e3b9ec9cb5a ]

The function ring_buffer_read_page() had two gotos. One was simply
returning "ret" and the other was unlocking the reader_lock.

There's no reason to use goto to simply return the "ret" variable. Instead
just return the value.

The jump to the unlocking of the reader_lock can be replaced by
guard(raw_spinlock_irqsave)(&cpu_buffer->reader_lock).

With these two changes the "ret" variable is no longer used and can be
removed. The return value on non-error is what was read and is stored in
the "read" variable.

Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Link: https://lore.kernel.org/20250527145216.0187cf36@gandalf.local.home
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Stable-dep-of: 7c727dfce6be ("ring-buffer: Prevent resizing of persistent ring buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   28 +++++++++++-----------------
 1 file changed, 11 insertions(+), 17 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -6480,38 +6480,37 @@ int ring_buffer_read_page(struct trace_b
 	struct buffer_data_page *bpage;
 	struct buffer_page *reader;
 	unsigned long missed_events;
-	unsigned long flags;
 	unsigned int commit;
 	unsigned int read;
 	u64 save_timestamp;
-	int ret = -1;
 
 	if (!cpumask_test_cpu(cpu, buffer->cpumask))
-		goto out;
+		return -1;
 
 	/*
 	 * If len is not big enough to hold the page header, then
 	 * we can not copy anything.
 	 */
 	if (len <= BUF_PAGE_HDR_SIZE)
-		goto out;
+		return -1;
 
 	len -= BUF_PAGE_HDR_SIZE;
 
 	if (!data_page || !data_page->data)
-		goto out;
+		return -1;
+
 	if (data_page->order != buffer->subbuf_order)
-		goto out;
+		return -1;
 
 	bpage = data_page->data;
 	if (!bpage)
-		goto out;
+		return -1;
 
-	raw_spin_lock_irqsave(&cpu_buffer->reader_lock, flags);
+	guard(raw_spinlock_irqsave)(&cpu_buffer->reader_lock);
 
 	reader = rb_get_reader_page(cpu_buffer);
 	if (!reader)
-		goto out_unlock;
+		return -1;
 
 	event = rb_reader_event(cpu_buffer);
 
@@ -6545,7 +6544,7 @@ int ring_buffer_read_page(struct trace_b
 		if (full &&
 		    (!read || (len < (commit - read)) ||
 		     cpu_buffer->reader_page == cpu_buffer->commit_page))
-			goto out_unlock;
+			return -1;
 
 		if (len > (commit - read))
 			len = (commit - read);
@@ -6554,7 +6553,7 @@ int ring_buffer_read_page(struct trace_b
 		size = rb_event_ts_length(event);
 
 		if (len < size)
-			goto out_unlock;
+			return -1;
 
 		/* save the current timestamp, since the user will need it */
 		save_timestamp = cpu_buffer->read_stamp;
@@ -6612,7 +6611,6 @@ int ring_buffer_read_page(struct trace_b
 		if (reader->real_end)
 			local_set(&bpage->commit, reader->real_end);
 	}
-	ret = read;
 
 	cpu_buffer->lost_events = 0;
 
@@ -6639,11 +6637,7 @@ int ring_buffer_read_page(struct trace_b
 	if (commit < buffer->subbuf_size)
 		memset(&bpage->data[commit], 0, buffer->subbuf_size - commit);
 
- out_unlock:
-	raw_spin_unlock_irqrestore(&cpu_buffer->reader_lock, flags);
-
- out:
-	return ret;
+	return read;
 }
 EXPORT_SYMBOL_GPL(ring_buffer_read_page);
 


