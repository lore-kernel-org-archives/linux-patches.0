Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA85E60274;
	Tue, 23 Jan 2024 00:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970835; cv=none; b=WRoz/hB6BtmHHKF7ht9xMDSSd5WAjDs4LCdxgAnKsg7M5lLqKqE1UGg5qqj8gBAbqq6fIuluVWmM2toj7M/YrmJK3DUVBN4TVSvivjjTPoltgkEzepH9RfimQnRIMxrtkOO/hRtKIMx/jJXyPtZJNbL3B0JnJI2XuUxkMXlsbWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970835; c=relaxed/simple;
	bh=78dWvsdk2o6Vz+Gms379Aj1pMcGY7a+IH8497zG8js0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EcKj4r5sNasJQlK2113QlWcIG+y9s/aLUHvl3IBOAj4qIDTJ74SwuYFvgFjxyW8eQ2eWezya8d1Gre/QTSufRJMnpF24qe3VMIubwStm+PQJAoIc5y8vQjpIR023kIECn3YfU7a5GNyLwR7TppZ9UkPPk6iZsYNmMqI8JQ9NptY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IbksKzuH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IbksKzuH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B903C433C7;
	Tue, 23 Jan 2024 00:47:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970835;
	bh=78dWvsdk2o6Vz+Gms379Aj1pMcGY7a+IH8497zG8js0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IbksKzuHcLS0ZfAmmRW0A6VwJi6f2/lGg/TNh8xMZ4flfOBMb4cH53fR718MpPzfO
	 uuDmCOO94qLxOL62YvgD1MNhYovS1vxridMMybjyoZbZZyUuNm6P8sGCrnSDMb1u8l
	 00K/ooIDTMGeihDw5V9ciHFwWZVDfbU8gXGSGERw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Rutland <mark.rutland@arm.com>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 027/286] tracing: Add size check when printing trace_marker output
Date: Mon, 22 Jan 2024 15:55:33 -0800
Message-ID: <20240122235733.060244389@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 94b0991717b6..753b84c50848 100644
--- a/kernel/trace/trace_output.c
+++ b/kernel/trace/trace_output.c
@@ -1313,11 +1313,12 @@ static enum print_line_t trace_print_print(struct trace_iterator *iter,
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
@@ -1326,10 +1327,11 @@ static enum print_line_t trace_print_raw(struct trace_iterator *iter, int flags,
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



