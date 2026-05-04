Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 126273DD53E;
	Mon,  4 May 2026 14:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903429; cv=none; b=EoDGQGO8TlzzpPHjBWhVJEnCQ4Q/2HmcaShPz46d0NnaocXoUOReuhoeqX8hfo0P8KYBE/xr34D2E3M2sxWf0dSRJVwLtJerAJwxVe4JQw0q6eFBBZ2J5SWD6XBVFDYmF9/FvLEKQqBMMzYcvR7KUT8Jw28bnl8bFZtP0vTXmrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903429; c=relaxed/simple;
	bh=ubEN3fhI/mIZJt+ovUGIp5cqeww/Ura16hJTv/27YNw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=paRG+dzk1Y7LcIbkvT2fCrJcMRsTwD1EaayYuO6euj4UVGVGBG4jHMB54X2esVXB5Q6Nov9R433ZrS6YsdWhZHmPUQPivrzraV03CgjkpKkTuHe61qwQ1h4uWrNNe8DCnIC0p/EYR7HYQJJqU/tM6FyDCWC5SBfd2hq6OXHqoeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cokwcoD6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cokwcoD6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91D89C2BCB8;
	Mon,  4 May 2026 14:03:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903428;
	bh=ubEN3fhI/mIZJt+ovUGIp5cqeww/Ura16hJTv/27YNw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cokwcoD6HZvGzSp36WZulf8jWtTFiwEneQfdlhROixBlmX9Yu/r56y5FErUkQlQBd
	 CQKONfUgCkE1PefYoT8gno0kdjiZBkqCNBlYUBzMse60mP7NMf6JLqkTeeLRoug/IA
	 Iv+b9UZBjaiRCrWNJnqj9rharVCaQ8pfCgf/b5rM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Catalin Marinas <catalin.marinas@arm.com>,
	Will Deacon <will@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Ian Rogers <irogers@google.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 7.0 230/307] ring-buffer: Do not double count the reader_page
Date: Mon,  4 May 2026 15:51:55 +0200
Message-ID: <20260504135151.507179278@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

commit 92d5a606721f759ebebf448b3bd2b7a781d50bd0 upstream.

Since the cpu_buffer->reader_page is updated if there are unwound
pages. After that update, we should skip the page if it is the
original reader_page, because the original reader_page is already
checked.

Cc: stable@vger.kernel.org
Cc: Catalin Marinas <catalin.marinas@arm.com>
Cc: Will Deacon <will@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Ian Rogers <irogers@google.com>
Link: https://patch.msgid.link/177701353063.2223789.1471163147644103306.stgit@mhiramat.tok.corp.google.com
Fixes: ca296d32ece3 ("tracing: ring_buffer: Rewind persistent ring buffer on reboot")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ring_buffer.c |   13 +++++++------
 1 file changed, 7 insertions(+), 6 deletions(-)

--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1913,7 +1913,7 @@ static int rb_validate_buffer(struct buf
 static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct ring_buffer_cpu_meta *meta = cpu_buffer->ring_meta;
-	struct buffer_page *head_page, *orig_head;
+	struct buffer_page *head_page, *orig_head, *orig_reader;
 	unsigned long entry_bytes = 0;
 	unsigned long entries = 0;
 	int ret;
@@ -1924,16 +1924,17 @@ static void rb_meta_validate_events(stru
 		return;
 
 	orig_head = head_page = cpu_buffer->head_page;
+	orig_reader = cpu_buffer->reader_page;
 
 	/* Do the reader page first */
-	ret = rb_validate_buffer(cpu_buffer->reader_page->page, cpu_buffer->cpu);
+	ret = rb_validate_buffer(orig_reader->page, cpu_buffer->cpu);
 	if (ret < 0) {
 		pr_info("Ring buffer reader page is invalid\n");
 		goto invalid;
 	}
 	entries += ret;
-	entry_bytes += local_read(&cpu_buffer->reader_page->page->commit);
-	local_set(&cpu_buffer->reader_page->entries, ret);
+	entry_bytes += local_read(&orig_reader->page->commit);
+	local_set(&orig_reader->entries, ret);
 
 	ts = head_page->page->time_stamp;
 
@@ -2036,8 +2037,8 @@ static void rb_meta_validate_events(stru
 	/* Iterate until finding the commit page */
 	for (i = 0; i < meta->nr_subbufs + 1; i++, rb_inc_page(&head_page)) {
 
-		/* Reader page has already been done */
-		if (head_page == cpu_buffer->reader_page)
+		/* The original reader page has already been checked/counted. */
+		if (head_page == orig_reader)
 			continue;
 
 		ret = rb_validate_buffer(head_page->page, cpu_buffer->cpu);


