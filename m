Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11796129A63;
	Tue, 23 Jan 2024 00:12:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968736; cv=none; b=WwOuGWnP6FI47XbD1+wsWn4BRU6mvSZgjaVi0r7PLdOOchbMFpDcOblJ4eX77mzV9TiKuOmZuLhh/hrk8dUywrWb56b38eQ31wyj26kREB7DLeNYy/01Sc1v+eZQPEdpNhf3Q/z8yw0TgfMtVFff13wqAPbfmj4m1hxv5stBUJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968736; c=relaxed/simple;
	bh=LCkQceIrFQzqFycYP76IyWAlomnuPQfLXPziFKORa6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bhR2OTxEZQK92ywCqgZ2CZOg7m52u5hIiSBhIieBnD1utum0M3YMER5Inzkaykg47CN2CNX20wSbN/88+/cmcXayOV+vtVgpSsUIwWTVjHd9VInwtzC/VPR6ck1RpSAUbWyKWALOJinYMSGArmN9qFrIsSXmDS0yVoP5MXi0hRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HHeHqCRw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HHeHqCRw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52FDBC433F1;
	Tue, 23 Jan 2024 00:12:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968735;
	bh=LCkQceIrFQzqFycYP76IyWAlomnuPQfLXPziFKORa6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HHeHqCRwseeF59LmOrDpawXOQGtERsqjUy0WBXJgIgbfld9rKfXWlEV+FFNV2PBX5
	 UzLVes2JtesMFDUiO2/Grsowe2hB54O3CzbRrSmLlWI4TSX2CqR0SORj9qXMQzJCoj
	 AysIBfoigESQrEa+D/QE7ZpKAvQMO/Hg7PqLgpGU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/194] tracing: Add size check when printing trace_marker output
Date: Mon, 22 Jan 2024 15:55:51 -0800
Message-ID: <20240122235720.136162394@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt (Google) <rostedt@goodmis.org>

[ Upstream commit 60be76eeabb3d83858cc6577fc65c7d0f36ffd42 ]

If for some reason the trace_marker write does not have a nul byte for the
string, it will overflow the print:

  trace_seq_printf(s, ": %s", field->buf);

The field->buf could be missing the nul byte. To prevent overflow, add the
max size that the buf can be by using the event size and the field
location.

  int max = iter->ent_size - offsetof(struct print_entry, buf);

  trace_seq_printf(s, ": %*.s", max, field->buf);

Link: https://lore.kernel.org/linux-trace-kernel/20231212084444.4619b8ce@gandalf.local.home

Cc: Mark Rutland <mark.rutland@arm.com>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Reviewed-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_output.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/trace/trace_output.c b/kernel/trace/trace_output.c
index b194dd1c8420..9ffe54ff3edb 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1291,11 +1291,12 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
 {
 	struct print_entry *field;
 	struct trace_seq *s = &iter->seq;
+	int max = iter->ent_size - offsetof(struct print_entry, buf);
 
 	trace_assign_type(field, iter->ent);
 
 	seq_print_ip_sym(s, field->ip, flags);
-	trace_seq_printf(s, ": %s", field->buf);
+	trace_seq_printf(s, ": %.*s", max, field->buf);
 
 	return trace_handle_return(s);
 }
@@ -1304,10 +1305,11 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
 					 struct trace_event *event)
 {
 	struct print_entry *field;
+	int max = iter->ent_size - offsetof(struct print_entry, buf);
 
 	trace_assign_type(field, iter->ent);
 
-	trace_seq_printf(&iter->seq, "# %lx %s", field->ip, field->buf);
+	trace_seq_printf(&iter->seq, "# %lx %.*s", field->ip, max, field->buf);
 
 	return trace_handle_return(&iter->seq);
 }
-- 
2.43.0



