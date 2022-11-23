Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA191C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:17:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F1E0C433C1;
	Wed, 23 Nov 2022 09:17:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195073;
	bh=pjO5Ww3TUWclnNzgmIcwDjcDLFimvtMGdN2hlruu62Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cMuZo9uA5XC2HL8J5SK0kK2jZLP8cn2jPNYw8hiS5a17044wbmHRz0Hoviwf/LZZC
	 SKS8vQfBq0q6FO/GrP6JQ2D3CcRPDmes1JsmsL/FInuvhuHIIUzkIbpMqVqde9AwgH
	 QNeIIicTVPx8mCSIhsv9dEFpjxbhD15NcRkr8Mv8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 140/156] ring-buffer: Include dropped pages in counting dirty patches
Date: Wed, 23 Nov 2022 09:51:37 +0100
Message-Id: <20221123084602.956479864@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 31029a8b2c7e656a0289194ef16415050ae4c4ac ]

The function ring_buffer_nr_dirty_pages() was created to find out how many
pages are filled in the ring buffer. There's two running counters. One is
incremented whenever a new page is touched (pages_touched) and the other
is whenever a page is read (pages_read). The dirty count is the number
touched minus the number read. This is used to determine if a blocked task
should be woken up if the percentage of the ring buffer it is waiting for
is hit.

The problem is that it does not take into account dropped pages (when the
new writes overwrite pages that were not read). And then the dirty pages
will always be greater than the percentage.

This makes the "buffer_percent" file inaccurate, as the number of dirty
pages end up always being larger than the percentage, event when it's not
and this causes user space to be woken up more than it wants to be.

Add a new counter to keep track of lost pages, and include that in the
accounting of dirty pages so that it is actually accurate.

Link: https://lkml.kernel.org/r/20221021123013.55fb6055@gandalf.local.home

Fixes: 2c2b0a78b3739 ("ring-buffer: Add percentage of ring buffer full to wake up reader")
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index f1dd405b98a5..c4234430afea 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -477,6 +477,7 @@ struct ring_buffer_per_cpu {
 	local_t				committing;
 	local_t				commits;
 	local_t				pages_touched;
+	local_t				pages_lost;
 	local_t				pages_read;
 	long				last_pages_touch;
 	size_t				shortest_full;
@@ -544,10 +545,18 @@ size_t ring_buffer_nr_pages(struct ring_buffer *buffer, int cpu)
 size_t ring_buffer_nr_dirty_pages(struct ring_buffer *buffer, int cpu)
 {
 	size_t read;
+	size_t lost;
 	size_t cnt;
 
 	read = local_read(&buffer->buffers[cpu]->pages_read);
+	lost = local_read(&buffer->buffers[cpu]->pages_lost);
 	cnt = local_read(&buffer->buffers[cpu]->pages_touched);
+
+	if (WARN_ON_ONCE(cnt < lost))
+		return 0;
+
+	cnt -= lost;
+
 	/* The reader can read an empty page, but not more than that */
 	if (cnt < read) {
 		WARN_ON_ONCE(read > cnt + 1);
@@ -1599,6 +1608,7 @@ rb_remove_pages(struct ring_buffer_per_cpu *cpu_buffer, unsigned long nr_pages)
 			 */
 			local_add(page_entries, &cpu_buffer->overrun);
 			local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+			local_inc(&cpu_buffer->pages_lost);
 		}
 
 		/*
@@ -2023,6 +2033,7 @@ rb_handle_head_page(struct ring_buffer_per_cpu *cpu_buffer,
 		 */
 		local_add(entries, &cpu_buffer->overrun);
 		local_sub(BUF_PAGE_SIZE, &cpu_buffer->entries_bytes);
+		local_inc(&cpu_buffer->pages_lost);
 
 		/*
 		 * The entries will be zeroed out when we move the
@@ -4475,6 +4486,7 @@ rb_reset_cpu(struct ring_buffer_per_cpu *cpu_buffer)
 	local_set(&cpu_buffer->committing, 0);
 	local_set(&cpu_buffer->commits, 0);
 	local_set(&cpu_buffer->pages_touched, 0);
+	local_set(&cpu_buffer->pages_lost, 0);
 	local_set(&cpu_buffer->pages_read, 0);
 	cpu_buffer->last_pages_touch = 0;
 	cpu_buffer->shortest_full = 0;
-- 
2.35.1



