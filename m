Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44E733DE45B;
	Mon,  4 May 2026 14:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904203; cv=none; b=rMgaW49OZl7lPz4CBc2766zxOnCwOnonBzIE9X4GjqGb1dmW0RxBT84Gn+/d7F2mh7Siz/ve3C0eXXuLZ1aV/tSnFOIEMp6Ue8fBJJmfb/TxBQ9G1Z2vUYqXHK+h7ZbCEhFyb574wkLqLb5E1LRSQQwW1HcIb8fnlvOS47Gsq9c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904203; c=relaxed/simple;
	bh=zDBt1Yqdj2ID3OrVZN6Nd+leuu6XdpNQVnG+KRycaKc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pswhilBhCgw3YoZtTQVMj5IsS0vKsXXhSIOwsOZJnlYYe001ZUl/O6IavuMJb3BtXkoYne7UifI13Sa8U9nnofpZSJ8luH/8YBlSn+SOxiEuTPp6GDCvOH0e2I0vIoVO8rcUhTZQ5eTftTaBNfIMKHt8oOgkvk0OM421sEFs2xE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=scnqU2vf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="scnqU2vf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0271C2BCB8;
	Mon,  4 May 2026 14:16:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904203;
	bh=zDBt1Yqdj2ID3OrVZN6Nd+leuu6XdpNQVnG+KRycaKc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=scnqU2vf8/IkmHuSOaesxgc2wpwbtClGmHK/Kw7CDSGakK5NMRluZ1X+iCh1MSLN8
	 e5VoUGponGDHjnA9k45PbSquDvMoYQNnlwx5scN8/WHr6KwlVIiNRL1s7gYCQohvzZ
	 rQ/b0S96ElgIkatO08Wfhu7crs2hj+M4KgidaAKY=
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
Subject: [PATCH 6.18 196/275] ring-buffer: Do not double count the reader_page
Date: Mon,  4 May 2026 15:52:16 +0200
Message-ID: <20260504135150.357881312@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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
@@ -1877,7 +1877,7 @@ static int rb_validate_buffer(struct buf
 static void rb_meta_validate_events(struct ring_buffer_per_cpu *cpu_buffer)
 {
 	struct ring_buffer_cpu_meta *meta = cpu_buffer->ring_meta;
-	struct buffer_page *head_page, *orig_head;
+	struct buffer_page *head_page, *orig_head, *orig_reader;
 	unsigned long entry_bytes = 0;
 	unsigned long entries = 0;
 	int ret;
@@ -1888,16 +1888,17 @@ static void rb_meta_validate_events(stru
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
 
@@ -2000,8 +2001,8 @@ static void rb_meta_validate_events(stru
 	/* Iterate until finding the commit page */
 	for (i = 0; i < meta->nr_subbufs + 1; i++, rb_inc_page(&head_page)) {
 
-		/* Reader page has already been done */
-		if (head_page == cpu_buffer->reader_page)
+		/* The original reader page has already been checked/counted. */
+		if (head_page == orig_reader)
 			continue;
 
 		ret = rb_validate_buffer(head_page->page, cpu_buffer->cpu);


