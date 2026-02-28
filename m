Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DDCD2DB7B2
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:04:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301871; cv=none; b=WIBxiaMLKr41ZdVt7r75rl7Ba0MB05UB9d4bjuiWQ+WRGjscBJaZ35+QD6LwxBFGSbscEV2UdnnGad0LpRwS/WlQj7co/DVlw0RLEQfo6P40u8I7OFE0U39QKbZDM2yulwhFoBMrNyRGYPes39Hks/+fT58L9dGD0XJbmMz5TlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301871; c=relaxed/simple;
	bh=mMR1+OrrvkCCO2wR2cBrqkH59I2dLRBaS5olTOxICME=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Dlk5TuiJ8wv/vxBG0L851ggIobYx3DE4xZfh6C6yChaWKC8EELero6amtp+/NeQhNtucxiJj5i6hwBAj2yXpPib50gjEicozOBnLqGGOjPnj9W+zapoD1n8I3aFWWOBuj4YPXZT/U4N7MrKwORxJpQIbO3wyzxNaYUYEHYG0krg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JxXBs3Y2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JxXBs3Y2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5DA85C19423;
	Sat, 28 Feb 2026 18:04:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301871;
	bh=mMR1+OrrvkCCO2wR2cBrqkH59I2dLRBaS5olTOxICME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JxXBs3Y2eVOmd0RDjFI82ov5MAjO3hn6AV6qOre2aV7eDRzrZmWW6kFinIGizuysd
	 MRxwtdE/vrni43aEAwM5a9f6Jq5ycTLaLoR94ZSAUR78pl0Lgv4XAQ6JJe4MY+TJPy
	 yGwbG0HoCGgnx0WFKK+bpFuSJNkiEeSAlSgv/H2fPcELe2zb4lGXoN81ozGeN0yvBp
	 EokJG2cEi9YQrHp1jooMADWyCk1jBWmmCS6E9dI3MlkNetZX7fWbI35B58beOPrYCH
	 sBZBNy6UQlum7pNJJW6b6j3JKjY7T7jvDP4ALnOs+T2zxiB+7T2Q1F4I0KLzlVFmX8
	 cneEPVPLGuYLA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miaoqian Lin <linmq006@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 295/385] tracing: Properly process error handling in event_hist_trigger_parse()
Date: Sat, 28 Feb 2026 12:58:37 -0500
Message-ID: <20260228180011.1568201-295-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Miaoqian Lin <linmq006@gmail.com>

[ Upstream commit 0550069cc25f513ce1f109c88f7c1f01d63297db ]

Memory allocated with trigger_data_alloc() requires trigger_data_free()
for proper cleanup.

Replace kfree() with trigger_data_free() to fix this.

Found via static analysis and code review.

This isn't a real bug due to the current code basically being an open
coded version of trigger_data_free() without the synchronization. The
synchronization isn't needed as this is the error path of creation and
there's nothing to synchronize against yet. Replace the kfree() to be
consistent with the allocation.

Cc: Masami Hiramatsu <mhiramat@kernel.org>
Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
Cc: Tom Zanussi <zanussi@kernel.org>
Link: https://patch.msgid.link/20251211100058.2381268-1-linmq006@gmail.com
Fixes: e1f187d09e11 ("tracing: Have existing event_command.parse() implementations use helpers")
Signed-off-by: Miaoqian Lin <linmq006@gmail.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_events_hist.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events_hist.c b/kernel/trace/trace_events_hist.c
index 761d56ed9b8e5..c51c07b2f774f 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6881,7 +6881,7 @@ static int event_hist_trigger_parse(struct event_command *cmd_ops,
 
 	remove_hist_vars(hist_data);
 
-	kfree(trigger_data);
+	trigger_data_free(trigger_data);
 
 	destroy_hist_data(hist_data);
 	goto out;
-- 
2.51.0

