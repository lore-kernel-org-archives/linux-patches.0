Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D9EF2580F2;
	Mon, 13 Oct 2025 15:45:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370338; cv=none; b=rOF0kmuvt5Ff7hNclvd19tvLFugTs2JihV0RuCEqm8lBLCu+fJR7Awci/t/9giztoVhwrV5xNNyzvzyi/e31POZqHMhk+FflPOa8KbAuQ4H58CcHZREYbMT++y9ncjCKCHEtV2BUTMJlxumO/BCpHhmZiyCiRnssC9R6yncWtt8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370338; c=relaxed/simple;
	bh=npcsgPvZqHifpS0KfVHdmyZ34zASEmagy0IvJd6/yT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UXfJjLoAk5riVWztUmyvaLNDLqXO+qIUtXh9lUzdV70EtZplVp4BHUbVIwiOczyLzDIYuJAcBqs/uaZOmrOqdWQbm6wjG9SDq63GOWqnybkPJ7tJMc1cO7/nvxS8Dww8zzyMSPGb/9z5Ju5eMZDwgoG1Ten5beOTTZuE/JwJen4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Co3GsAbW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Co3GsAbW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A56ACC4CEE7;
	Mon, 13 Oct 2025 15:45:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370338;
	bh=npcsgPvZqHifpS0KfVHdmyZ34zASEmagy0IvJd6/yT8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Co3GsAbWfk2756GiHMRVDp5K7a1ZfMOWHDVqbbx3bjMqk5Gxj41EcFvuTcJ71TYfj
	 XqUCp2S0bD6ixfUi8L6raZSCq1327o9fKp/gED8PeCYq8BSO8z2Ltt0U8vOfAkjztN
	 30CJ9T5KJkZEV9UNzI0jvutP+ww4HUxOqKIFcIGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	syzbot+9a2ede1643175f350105@syzkaller.appspotmail.com,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>
Subject: [PATCH 6.17 518/563] tracing: Stop fortify-string from warning in tracing_mark_raw_write()
Date: Mon, 13 Oct 2025 16:46:19 +0200
Message-ID: <20251013144430.079695940@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 54b91e54b113d4f15ab023a44f508251db6e22e7 upstream.

The way tracing_mark_raw_write() records its data is that it has the
following structure:

  struct {
	struct trace_entry;
	int id;
	char buf[];
  };

But memcpy(&entry->id, buf, size) triggers the following warning when the
size is greater than the id:

 ------------[ cut here ]------------
 memcpy: detected field-spanning write (size 6) of single field "&entry->id" at kernel/trace/trace.c:7458 (size 4)
 WARNING: CPU: 7 PID: 995 at kernel/trace/trace.c:7458 write_raw_marker_to_buffer.isra.0+0x1f9/0x2e0
 Modules linked in:
 CPU: 7 UID: 0 PID: 995 Comm: bash Not tainted 6.17.0-test-00007-g60b82183e78a-dirty #211 PREEMPT(voluntary)
 Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.17.0-debian-1.17.0-1 04/01/2014
 RIP: 0010:write_raw_marker_to_buffer.isra.0+0x1f9/0x2e0
 Code: 04 00 75 a7 b9 04 00 00 00 48 89 de 48 89 04 24 48 c7 c2 e0 b1 d1 b2 48 c7 c7 40 b2 d1 b2 c6 05 2d 88 6a 04 01 e8 f7 e8 bd ff <0f> 0b 48 8b 04 24 e9 76 ff ff ff 49 8d 7c 24 04 49 8d 5c 24 08 48
 RSP: 0018:ffff888104c3fc78 EFLAGS: 00010292
 RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000000000
 RDX: 0000000000000000 RSI: 1ffffffff6b363b4 RDI: 0000000000000001
 RBP: ffff888100058a00 R08: ffffffffb041d459 R09: ffffed1020987f40
 R10: 0000000000000007 R11: 0000000000000001 R12: ffff888100bb9010
 R13: 0000000000000000 R14: 00000000000003e3 R15: ffff888134800000
 FS:  00007fa61d286740(0000) GS:ffff888286cad000(0000) knlGS:0000000000000000
 CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
 CR2: 0000560d28d509f1 CR3: 00000001047a4006 CR4: 0000000000172ef0
 Call Trace:
  <TASK>
  tracing_mark_raw_write+0x1fe/0x290
  ? __pfx_tracing_mark_raw_write+0x10/0x10
  ? security_file_permission+0x50/0xf0
  ? rw_verify_area+0x6f/0x4b0
  vfs_write+0x1d8/0xdd0
  ? __pfx_vfs_write+0x10/0x10
  ? __pfx_css_rstat_updated+0x10/0x10
  ? count_memcg_events+0xd9/0x410
  ? fdget_pos+0x53/0x5e0
  ksys_write+0x182/0x200
  ? __pfx_ksys_write+0x10/0x10
  ? do_user_addr_fault+0x4af/0xa30
  do_syscall_64+0x63/0x350
  entry_SYSCALL_64_after_hwframe+0x76/0x7e
 RIP: 0033:0x7fa61d318687
 Code: 48 89 fa 4c 89 df e8 58 b3 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 fc 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
 RSP: 002b:00007ffd87fe0120 EFLAGS: 00000202 ORIG_RAX: 0000000000000001
 RAX: ffffffffffffffda RBX: 00007fa61d286740 RCX: 00007fa61d318687
 RDX: 0000000000000006 RSI: 0000560d28d509f0 RDI: 0000000000000001
 RBP: 0000560d28d509f0 R08: 0000000000000000 R09: 0000000000000000
 R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000006
 R13: 00007fa61d4715c0 R14: 00007fa61d46ee80 R15: 0000000000000000
  </TASK>
 ---[ end trace 0000000000000000 ]---

This is because fortify string sees that the size of entry->id is only 4
bytes, but it is writing more than that. But this is OK as the
dynamic_array is allocated to handle that copy.

The size allocated on the ring buffer was actually a bit too big:

  size = sizeof(*entry) + cnt;

But cnt includes the 'id' and the buffer data, so adding cnt to the size
of *entry actually allocates too much on the ring buffer.

Change the allocation to:

  size = struct_size(entry, buf, cnt - sizeof(entry->id));

and the memcpy() to unsafe_memcpy() with an added justification.

Cc: stable@vger.kernel.org
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Link: https://lore.kernel.org/20251011112032.77be18e4@gandalf.local.home
Fixes: 64cf7d058a00 ("tracing: Have trace_marker use per-cpu data to read user space")
Reported-by: syzbot+9a2ede1643175f350105@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/68e973f5.050a0220.1186a4.0010.GAE@google.com/
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/trace.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/kernel/trace/trace.c
+++ b/kernel/trace/trace.c
@@ -7441,7 +7441,8 @@ static ssize_t write_raw_marker_to_buffe
 	ssize_t written;
 	size_t size;
 
-	size = sizeof(*entry) + cnt;
+	/* cnt includes both the entry->id and the data behind it. */
+	size = struct_size(entry, buf, cnt - sizeof(entry->id));
 
 	buffer = tr->array_buffer.buffer;
 
@@ -7455,7 +7456,10 @@ static ssize_t write_raw_marker_to_buffe
 		return -EBADF;
 
 	entry = ring_buffer_event_data(event);
-	memcpy(&entry->id, buf, cnt);
+	unsafe_memcpy(&entry->id, buf, cnt,
+		      "id and content already reserved on ring buffer"
+		      "'buf' includes the 'id' and the data."
+		      "'entry' was allocated with cnt from 'id'.");
 	written = cnt;
 
 	__buffer_unlock_commit(buffer, event);


