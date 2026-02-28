Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73AD738F64D
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302204; cv=none; b=M39jcliHDaMywyE0TDNHovsXMkiDx+EK6odBWQ6S+FLREg0V6yK+mpjwhUF5jeJS1VWeorBawu/ROpZ1jDGduDapMGRuyUuMVLWSkN6Z1rIWRLHhY80n170Iw4rKVF5lcWhNA/ilCk8xtoUS7SN71ua+UEpV/I2CJZFXhHf3o+A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302204; c=relaxed/simple;
	bh=BC6ibreDRvqahPQkoAWi9QzFbMkHjcp9H0mMtzzT20U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K4pmyfFoc2KyVNnhzDwtsBqA8To3X0JJkyfbbkJ6ZYa/xpn05RI967otNVLyA/EmE7fJQgVBWttZsVRKl9VaZMu7RTlwyp14OSAMzbTC9IJjE8//u7biCUp8jcuflswWn8jxfQVejXdcsxZOH9V99tQt8J3NIx1Tw2WoSI/JsM8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gYAfmj0i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gYAfmj0i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 951D2C116D0;
	Sat, 28 Feb 2026 18:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302204;
	bh=BC6ibreDRvqahPQkoAWi9QzFbMkHjcp9H0mMtzzT20U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gYAfmj0iSodNphWv3coURBAl+3aY/U6J7Ijil9mT9B1HU/28HeKHO4e1xdrVTNpoo
	 1agkiakLRbbi5UaMM5qh10XITTGkKi/O1hh9kBiPIxfs3QCVKjFSrne7ShMTYTi0T2
	 ZSGXWq0zlMYoy6/CN10opLpn+1NynkYk4fpRZtqwzCwhISVqrHsYpJUHrCOrWy+fCU
	 VrgctVkFREjKGPGPbp+83Y3KISmxdfLnBQtkIP9jQAFdG3B1z7RSHUqXQlP1ITtrUo
	 YAuReSwjMVUvteKKO2xA+VsKJEfJ4TWf6dzmwxDX6Mh/atfdYeiKgK6fu8+j1cf0Zr
	 KF3fPwSHOZ+GA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miaoqian Lin <linmq006@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 209/283] tracing: Properly process error handling in event_hist_trigger_parse()
Date: Sat, 28 Feb 2026 13:05:51 -0500
Message-ID: <20260228180709.1583486-209-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index 99d1e8b57f85d..ad203155855a3 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6889,7 +6889,7 @@ static int event_hist_trigger_parse(struct event_command *cmd_ops,
 
 	remove_hist_vars(hist_data);
 
-	kfree(trigger_data);
+	trigger_data_free(trigger_data);
 
 	destroy_hist_data(hist_data);
 	goto out;
-- 
2.51.0

