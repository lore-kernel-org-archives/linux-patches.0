Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11946282F26;
	Mon, 23 Mar 2026 15:03:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278216; cv=none; b=d5HbHFsMkWzYp90A8ZkKRRTwfbfvSjcYoomqkPOtOBckOpJOmz+I9CZcNx0a1i3c2S+nbDhzXvm0/0xi26gRiKQbzXE0v9xxJ79TlbpUHnh6PhMokdb6RoHslLpK4PLve2kn+5aIS+Xi/GE1klhg15aylGHgpjTy577PdnKMmNg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278216; c=relaxed/simple;
	bh=l8qk98T3va4nd57oVH33YDIrDdMAKqwOrrl1NFhwnTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tf32QWN1895rfjE6CeHrlivqv7zmBBYTOvnqFdz2ZobQwVg1V+8o4p7e0B8+zjxCW2BwM6alHZZ7NmVWGNJ/E7iazbx+leIHD9y65pswXurloG9Ntqox1Qif4mqzDk0FAyJmTe2uBOpCjT/jLoZ1ZGFxoCDKfgj04kzPnUg+1xg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dYI4W0Sr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dYI4W0Sr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FA9DC4CEF7;
	Mon, 23 Mar 2026 15:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278216;
	bh=l8qk98T3va4nd57oVH33YDIrDdMAKqwOrrl1NFhwnTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dYI4W0SrIyGgvIYsGCjVV03UndwDoyEUBBoEVvJBiGvqy8UOBPUECJoDmwmozbRGT
	 m+cILFWTXDVTkGMzAEoNLXCjaykX788kiNiORjKN0G4uhcJ9FZnxnvL4TYaDSlbv6Y
	 a3wbZBpMkY4FuvhwAwZmDWIcUwtN3HafKnjslW9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miaoqian Lin <linmq006@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 184/567] tracing: Add NULL pointer check to trigger_data_free()
Date: Mon, 23 Mar 2026 14:41:44 +0100
Message-ID: <20260323134538.406638433@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 457965c13f0837a289c9164b842d0860133f6274 ]

If trigger_data_alloc() fails and returns NULL, event_hist_trigger_parse()
jumps to the out_free error path. While kfree() safely handles a NULL
pointer, trigger_data_free() does not. This causes a NULL pointer
dereference in trigger_data_free() when evaluating
data->cmd_ops->set_filter.

Fix the problem by adding a NULL pointer check to trigger_data_free().

The problem was found by an experimental code review agent based on
gemini-3.1-pro while reviewing backports into v6.18.y.

Cc: Miaoqian Lin <linmq006@gmail.com>
Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Link: https://patch.msgid.link/20260305193339.2810953-1-linux@roeck-us.net
Fixes: 0550069cc25f ("tracing: Properly process error handling in event_hist_trigger_parse()")
Assisted-by: Gemini:gemini-3.1-pro
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_trigger.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/trace/trace_events_trigger.c b/kernel/trace/trace_events_trigger.c
index fe079ff82ef1b..3ef1fe15493d3 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -19,6 +19,9 @@ static DEFINE_MUTEX(trigger_cmd_mutex);
 
 void trigger_data_free(struct event_trigger_data *data)
 {
+	if (!data)
+		return;
+
 	if (data->cmd_ops->set_filter)
 		data->cmd_ops->set_filter(NULL, data, NULL);
 
-- 
2.51.0



