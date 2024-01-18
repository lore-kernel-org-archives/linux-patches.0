Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC03F1B96D;
	Thu, 18 Jan 2024 10:54:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575293; cv=none; b=B90Gp7uID5JhzbYqUp/AsVZ0gOfvV444/Z39aApFjCVEJBursOlD13BT7co82QPAnMcq0Zm9s4HjvbNts11dpR3uDNyxTle9dVC/ST6PreNUCZIX9Wy2nKAKw6YGZwY0SfyDGAeu3aqgO/aMSz0/OKmoWrod4/S3gLVmXe65Grg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575293; c=relaxed/simple;
	bh=5sF5uXPsHrsCrRvlpL0ihnyIOt1maYIwOT7ekzWMz7U=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=irlmaP65hwRuWpSrfjIj8+qwoB6oHeyKNBsz3M3xxPbqR51m4njEwoN7Uzr8kql193RkSeRuJZv626BcB35IWK/2tmcHAfSxLO+lDyMCcMSUw6lOaKUaw+APVDaJFVy/mco6v+ib9Za2KTACmvpZgr8RU7JYzxsdeJ9pMS+vsNM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZBVQHz7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZBVQHz7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44114C433C7;
	Thu, 18 Jan 2024 10:54:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575293;
	bh=5sF5uXPsHrsCrRvlpL0ihnyIOt1maYIwOT7ekzWMz7U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZBVQHz7czuZY1p+U6NyYCNjJMzdRSJjp5jKrIPUwqDGBgCIimfVN7sd5gjWkxbFZH
	 +pstqY2bwKP/rlyXAROICDSWC9/0wBfB44mN+TCWaPzw4CnvPBvZsOQFLRlDcJ+3tL
	 qQ2Q/9Q11VuF5XE8Zd+G0dKXeMbHfGPWL+qH6E8Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 080/150] tracing: Add size check when printing trace_marker output
Date: Thu, 18 Jan 2024 11:48:22 +0100
Message-ID: <20240118104323.667410401@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index db575094c498..3b7d3e9eb6ea 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1587,11 +1587,12 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
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
@@ -1600,10 +1601,11 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
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



