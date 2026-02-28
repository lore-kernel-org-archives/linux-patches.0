Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C389F375241;
	Sat, 28 Feb 2026 17:59:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301560; cv=none; b=nuIQOSZKjrRzYMpOH69f0+3gd1pc3VuFIaSn6/KAYRTcRu2KTYJhzz2kvFqCxYkUzC0iwa83IhpyvuaSfPQSFmsXoOXRX+d8q39rgLsmmNIz/ixmWdI6QUCWf9cTwJjKY141GboESxFAYuPBWitrUBCQZfAcDcGvbz4k0k49TxU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301560; c=relaxed/simple;
	bh=sJfuBX6VYbPqMzLg2pC8OYm4UGV1OA4OKUuxO8jfG+4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TuSo/6RXoKDtTl+xEWqdn4zMJlgRbdTzaUPzrQOzHb/arnqFHaJQXdkX6zC360GaNOPwGlAQ5GmRLhCO5qdPB4hC+SIw1B6QTsvMCLbz/yVp011TYiMm9WKnFmCagJDwtQkwnrYU5/i0TQT6Zs7zXj12M+zoCXY9gai3SUUamYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=szh/88JX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="szh/88JX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08CCBC116D0;
	Sat, 28 Feb 2026 17:59:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301560;
	bh=sJfuBX6VYbPqMzLg2pC8OYm4UGV1OA4OKUuxO8jfG+4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=szh/88JXv7ig/NghYji6VG078MOqKFeev3Pq92CXsQ1q2hPCL5KLV6K8n2qvuZ+jd
	 60xK0So9rCsv/WS8c9sC/jbAP1lI4f0P5djiZEOcMI96UNDvPgZqpHRHKpaSdVWCTk
	 9DILfMenqWA9a9EwJcU9tGgSGhynbOKaUFkqPJc2edLB/mYx/0qOQU9nHUpU01wQHp
	 qvl+UEq0sUX7aib4uf9qf/203CSVal3TqtXDwob8AAAnljz5wMr8I8r0Hi4u6WFWR8
	 xRyHXh8zshEnrn4ih6g9YuoyfeEutTj5yCCNKE8P55XO9f934RLFHdnv24TIu6XyUG
	 XxI5xLltwPdpQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	stable@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 744/752] tracing: ring-buffer: Fix to check event length before using
Date: Sat, 28 Feb 2026 12:47:35 -0500
Message-ID: <20260228174750.1542406-744-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: "Masami Hiramatsu (Google)" <mhiramat@kernel.org>

[ Upstream commit 912b0ee248c529a4f45d1e7f568dc1adddbf2a4a ]

Check the event length before adding it for accessing next index in
rb_read_data_buffer(). Since this function is used for validating
possibly broken ring buffers, the length of the event could be broken.
In that case, the new event (e + len) can point a wrong address.
To avoid invalid memory access at boot, check whether the length of
each event is in the possible range before using it.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Fixes: 5f3b6e839f3c ("ring-buffer: Validate boot range memory events")
Link: https://patch.msgid.link/177123421541.142205.9414352170164678966.stgit@devnote2
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ring_buffer.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index fdb3153bbf487..54d70bd0a3cb9 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -1813,6 +1813,7 @@ static int rb_read_data_buffer(struct buffer_data_page *dpage, int tail, int cpu
 	struct ring_buffer_event *event;
 	u64 ts, delta;
 	int events = 0;
+	int len;
 	int e;
 
 	*delta_ptr = 0;
@@ -1820,9 +1821,12 @@ static int rb_read_data_buffer(struct buffer_data_page *dpage, int tail, int cpu
 
 	ts = dpage->time_stamp;
 
-	for (e = 0; e < tail; e += rb_event_length(event)) {
+	for (e = 0; e < tail; e += len) {
 
 		event = (struct ring_buffer_event *)(dpage->data + e);
+		len = rb_event_length(event);
+		if (len <= 0 || len > tail - e)
+			return -1;
 
 		switch (event->type_len) {
 
-- 
2.51.0

