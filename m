Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 76E922264A3;
	Fri,  4 Sep 2026 05:40:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500454; cv=none; b=XYTpL3dOMvJmpLGe23wHEZWfoMwESh60NDp5zr06ciDIqayy3bZ0UKiDtmWupBt42ldNpDra3026vLRCXpcOA5Mt7eP+DCfuZG41RcVnpRO5/2v7DIy3KnyT92qpwG5cjJQ3m50D6m5flvHCrYmyW7XUSxhKOrT071z88heMTFM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500454; c=relaxed/simple;
	bh=KMuechJitfz+EDbyO5p/gpuJrdJjZMzigO7Vn1VYRyU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ayiIz+AdBTz8l2tACuZ7tKPTOpenUPMbCxjoL+CVtChg1CIU9RaX8nD+YJSUT3A//devc40MlrIMiqkDWQu15VtnLJHaeOEEXFd8KPbiit3fRqNyAtwYGPW4RqW0aZ3RqiWxUFFaQihGm2dj/A/KS1UKKgxUf0Rv1ttb04YI98M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YTnKBEEH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YTnKBEEH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CED691F00A3D;
	Fri,  4 Sep 2026 05:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500453;
	bh=IzU4EG73ta2ql62Eua0LMdVj2N9uRhB4pYjRcOXqINs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YTnKBEEHTUf/8lJad2xrQY+6v0Jj7f0bAdc8Kp1PNwAx8cdkII+ZSxLxdjaBE0pA9
	 BRqXWBSSemdDIv+80obFIo/NY4LITf/pg7mWvj8Gkcik0v7oaTxbG5ddafpR5A4TPs
	 cZFlliKxJ22RWWznasIBT/OVtot60N3L3C28QyOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+685955db58555575fdd2@syzkaller.appspotmail.com,
	Bradley Morgan <include@grrlz.net>,
	Deepanshu Kartikey <kartikey406@gmail.com>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 6.18 061/552] tracing: Fix use-after-free in trace_pipe read on sub-buffer order change
Date: Fri,  4 Sep 2026 06:53:38 +0200
Message-ID: <20260904045749.230096447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Deepanshu Kartikey <kartikey406@gmail.com>

commit 372f8534244d632ad5118e8a87a11291b01712d3 upstream.

Writing to buffer_subbuf_size_kb calls ring_buffer_subbuf_order_set(),
which frees every sub-buffer of the ring buffer, including the reader
page, and replaces them with newly allocated ones.

Readers of trace_pipe hold pointers into those pages. ring_buffer_peek()
looks up an event under cpu_buffer->reader_lock but returns the event
pointer after dropping the lock, and peek_next_entry() then calls
ring_buffer_event_length() and ring_buffer_event_data() on it. If the
sub-buffer order is changed in that window, the reader dereferences
freed memory:

  BUG: KASAN: use-after-free in ring_buffer_peek+0x3e0/0x430
  Read of size 1 at addr ffff88802a4cf010 by task syz-executor989/6002

  Freed by:
   free_buffer_page kernel/trace/ring_buffer.c:398 [inline]
   ring_buffer_subbuf_order_set+0x1325/0x18e0 kernel/trace/ring_buffer.c:7444
   buffer_subbuf_size_write+0x182/0x280 kernel/trace/trace.c:8221

Take trace_access_lock(RING_BUFFER_ALL_CPUS) around the order change.
This is the lock trace_pipe readers already hold across their entire
peek-and-print loop, so the swap can no longer race with a reader that
is dereferencing a peeked event.

Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260817140655.5694-1-kartikey406@gmail.com
Fixes: f9b94daa542a ("ring-buffer: Set new size of the ring buffer sub page")
Reported-by: syzbot+685955db58555575fdd2@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=685955db58555575fdd2
Tested-by: syzbot+685955db58555575fdd2@syzkaller.appspotmail.com
Reviewed-by: Bradley Morgan <include@grrlz.net>
Signed-off-by: Deepanshu Kartikey <kartikey406@gmail.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -9699,6 +9699,8 @@ buffer_subbuf_size_write(struct file *fi
 	/* Do not allow tracing while changing the order of the ring buffer */
 	tracing_stop_tr(tr);
 
+	trace_access_lock(RING_BUFFER_ALL_CPUS);
+
 	old_order = ring_buffer_subbuf_order_get(tr->array_buffer.buffer);
 	if (old_order == order)
 		goto out;
@@ -9738,6 +9740,7 @@ buffer_subbuf_size_write(struct file *fi
 #endif
 	(*ppos)++;
  out:
+	trace_access_unlock(RING_BUFFER_ALL_CPUS);
 	if (ret)
 		cnt = ret;
 	tracing_start_tr(tr);


