Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E89DB375243;
	Sat, 28 Feb 2026 17:59:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301563; cv=none; b=lONwAIzOPnSUArCMvjKHBzKk/Gb+QjUfa3B0hgUMFXxWuwwR2l2jc4ZsAgztnQ631KqU2WZv5YCDtsZv/18uVA+js7fyI5h/9cT8CBRtMo16IVhE1sXcnYonMAzKjeGLWTJdTwM5227LEYhhX/Gybv07ahwq9GScIQL0DdsFuYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301563; c=relaxed/simple;
	bh=z78OfDDXLzRhugJe5QpqpBOzFSylhjGdledkwr6jS54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=izm3ZfqfM60Cwkuvdr6WoUCJeHa/DFCWo6Zbk6mvAaNPEUo863DgP7ocH7iKl2fOQ8VX7qxX0Gy4QxkXT2n9h1ji8gBeOQLO8V03fVPjZHi4HoUp/Vi4lqBgeYjjsUHd7N9o2HKgwpePIvs3mQztTXjLXi26CQTkzCHtJYpFq38=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C2Eg1N+h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C2Eg1N+h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1B1CC19424;
	Sat, 28 Feb 2026 17:59:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301562;
	bh=z78OfDDXLzRhugJe5QpqpBOzFSylhjGdledkwr6jS54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C2Eg1N+hH9bY1zA9mzPnpgF+pOlzFmPrC02IS62w3qflxGdiUWB1tUsCihEXEyU6P
	 97WU3GFnDV1U7z+RQAQVoDnNGWOgPGaLIOMtvJO9ahofaSa5JJ32AEIRZIDRHHNM4O
	 mbWipUZe13YDUGarD5KxJIca/t5ciw88jUokvL679x+3H022mfi1kGtkNXCVNPt6JR
	 wdb66ThE+t1FVBTYTZsK9dsfMSEqizTuOIXGZynPxwYMJNhhYFrBxmApwmyo+jLJmi
	 DfRNI87/rovSk1FRP3exm6Bw75RHBfmeVBb1P+XC9oQBUoGVKPTwQOUne7sJidVoTx
	 j13OoHILXt1dw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Petr Pavlu <petr.pavlu@suse.com>,
	stable@vger.kernel.org,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 746/752] tracing: Fix checking of freed trace_event_file for hist files
Date: Sat, 28 Feb 2026 12:47:37 -0500
Message-ID: <20260228174750.1542406-746-sashal@kernel.org>
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

From: Petr Pavlu <petr.pavlu@suse.com>

[ Upstream commit f0a0da1f907e8488826d91c465f7967a56a95aca ]

The event_hist_open() and event_hist_poll() functions currently retrieve
a trace_event_file pointer from a file struct by invoking
event_file_data(), which simply returns file->f_inode->i_private. The
functions then check if the pointer is NULL to determine whether the event
is still valid. This approach is flawed because i_private is assigned when
an eventfs inode is allocated and remains set throughout its lifetime.
Instead, the code should call event_file_file(), which checks for
EVENT_FILE_FL_FREED. Using the incorrect access function may result in the
code potentially opening a hist file for an event that is being removed or
becoming stuck while polling on this file.

Correct the access method to event_file_file() in both functions.

Cc: stable@vger.kernel.org
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://patch.msgid.link/20260219162737.314231-2-petr.pavlu@suse.com
Fixes: 1bd13edbbed6 ("tracing/hist: Add poll(POLLIN) support on hist file")
Signed-off-by: Petr Pavlu <petr.pavlu@suse.com>
Acked-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 45727c4cf9545..2a0726e1bc97f 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -5778,7 +5778,7 @@ static __poll_t event_hist_poll(struct file *file, struct poll_table_struct *wai
 
 	guard(mutex)(&event_mutex);
 
-	event_file = event_file_data(file);
+	event_file = event_file_file(file);
 	if (!event_file)
 		return EPOLLERR;
 
@@ -5816,7 +5816,7 @@ static int event_hist_open(struct inode *inode, struct file *file)
 
 	guard(mutex)(&event_mutex);
 
-	event_file = event_file_data(file);
+	event_file = event_file_file(file);
 	if (!event_file) {
 		ret = -ENODEV;
 		goto err;
-- 
2.51.0

