Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A014288C01;
	Tue, 22 Jul 2025 13:58:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192685; cv=none; b=NTN1D6HyLhtOSJAI5nARWQOcZApfJVrBiyie+ykA4wiqCBC3d1U2t2yxxc6Rf9G0N5sC3G2pe7JHIFdHNA5dC49wF3uNzEx6ENHavQOwY9IAqZXzdeh4gAkqis43peD0A9MKhpAARh0jDjWtYmNIWTxKG4oHcvuAX6pi++G6jF4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192685; c=relaxed/simple;
	bh=V+z5rcyWEvjUSkg1wrUd3U5VSSRXCpn33ql9CR367Rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8t6Vw0tsxks7UHTF7dUj8a+vJjBra7jLnLRAFqNhUicgyZjF3FwLh5nGGesl2AHJDj4tIY8ECz04jga4/6F0UIspWEspya6hfn8azZie2gRHd4+NrGRSwEm/ry6tjjfzBNL+mngqF7kgUmvQh4lRdTGHLdzH5CWogDKNm+IDJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kjRIdvF5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kjRIdvF5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5261C4CEEB;
	Tue, 22 Jul 2025 13:58:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192685;
	bh=V+z5rcyWEvjUSkg1wrUd3U5VSSRXCpn33ql9CR367Rg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kjRIdvF5K0lrQEAUO2E3Tzpn1ZRFyef3znxOwBIq2zvuksCq5mumMOBkB2yarNQTu
	 Xxcc1Qwixpq+iokObCz0rpPpf93QpIrxez3T0mEy9YqwCn6O+to3+Q/umFesj+BxBK
	 UWkiymJ9p/h1LzgXDswCKSVn3po6It5PK+Ov+qpA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	John Kacur <jkacur@redhat.com>,
	Luis Goncalves <lgoncalv@redhat.com>,
	Attila Fazekas <afazekas@redhat.com>,
	Tomas Glozar <tglozar@redhat.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.12 027/158] tracing/osnoise: Fix crash in timerlat_dump_stack()
Date: Tue, 22 Jul 2025 15:43:31 +0200
Message-ID: <20250722134341.759727083@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134340.596340262@linuxfoundation.org>
References: <20250722134340.596340262@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Tomas Glozar <tglozar@redhat.com>

commit 85a3bce695b361d85fc528e6fbb33e4c8089c806 upstream.

We have observed kernel panics when using timerlat with stack saving,
with the following dmesg output:

memcpy: detected buffer overflow: 88 byte write of buffer size 0
WARNING: CPU: 2 PID: 8153 at lib/string_helpers.c:1032 __fortify_report+0x55/0xa0
CPU: 2 UID: 0 PID: 8153 Comm: timerlatu/2 Kdump: loaded Not tainted 6.15.3-200.fc42.x86_64 #1 PREEMPT(lazy)
Call Trace:
 <TASK>
 ? trace_buffer_lock_reserve+0x2a/0x60
 __fortify_panic+0xd/0xf
 __timerlat_dump_stack.cold+0xd/0xd
 timerlat_dump_stack.part.0+0x47/0x80
 timerlat_fd_read+0x36d/0x390
 vfs_read+0xe2/0x390
 ? syscall_exit_to_user_mode+0x1d5/0x210
 ksys_read+0x73/0xe0
 do_syscall_64+0x7b/0x160
 ? exc_page_fault+0x7e/0x1a0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

__timerlat_dump_stack() constructs the ftrace stack entry like this:

struct stack_entry *entry;
...
memcpy(&entry->caller, fstack->calls, size);
entry->size = fstack->nr_entries;

Since commit e7186af7fb26 ("tracing: Add back FORTIFY_SOURCE logic to
kernel_stack event structure"), struct stack_entry marks its caller
field with __counted_by(size). At the time of the memcpy, entry->size
contains garbage from the ringbuffer, which under some circumstances is
zero, triggering a kernel panic by buffer overflow.

Populate the size field before the memcpy so that the out-of-bounds
check knows the correct size. This is analogous to
__ftrace_trace_stack().

Cc: stable@vger.kernel.org
Cc: John Kacur <jkacur@redhat.com>
Cc: Luis Goncalves <lgoncalv@redhat.com>
Cc: Attila Fazekas <afazekas@redhat.com>
Link: https://lore.kernel.org/20250716143601.7313-1-tglozar@redhat.com
Fixes: e7186af7fb26 ("tracing: Add back FORTIFY_SOURCE logic to kernel_stack event structure")
Signed-off-by: Tomas Glozar <tglozar@redhat.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace_osnoise.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/kernel/trace/trace_osnoise.c
+++ b/kernel/trace/trace_osnoise.c
@@ -665,8 +665,8 @@ __timerlat_dump_stack(struct trace_buffe
 
 	entry = ring_buffer_event_data(event);
 
-	memcpy(&entry->caller, fstack->calls, size);
 	entry->size = fstack->nr_entries;
+	memcpy(&entry->caller, fstack->calls, size);
 
 	if (!call_filter_check_discard(call, entry, buffer, event))
 		trace_buffer_unlock_commit_nostack(buffer, event);


