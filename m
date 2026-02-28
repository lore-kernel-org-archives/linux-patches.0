Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A84F33A9DA
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302430; cv=none; b=tgdCAtO5aH6toPV2f/oVoKoB5PcZZXrTwVQpTfNMxmjHOJ2Aj74bzJbx/JnjLV24hx0BeTiH+UAo5K1wMc2g58UGiiQL2CM9MPGQEEHz7UbA60y5EmyGo2oeZ6oUHMj7DH4DUkTB15jB+z51MFsETDUBM7fMckZ+/R+HvAAs8Mw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302430; c=relaxed/simple;
	bh=GZ4D13ahFpDBrVf5kBSOuXKr98arjVrQOObRyOFjJP8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hTB5R33OBK7RRlANJHNI8TmZrkMBMScyJhxDdz+DXjHts0FR3vaPe+1Yd4zdPzl/nxucsFuox+OqlACOyDQdO3ax0Z2rWCE/xUgqzvzh9za6QTFOWGR2AoYJp2Cg48MJsbROKQ5c+8AIgBEW9X/kfUQXm1zVnORu0YsX7g5/31M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=slS3PvYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="slS3PvYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A06C116D0;
	Sat, 28 Feb 2026 18:13:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302430;
	bh=GZ4D13ahFpDBrVf5kBSOuXKr98arjVrQOObRyOFjJP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=slS3PvYuIEbLUPaTPAVlGmSa7NVf9O96830ysj6bwnplWzJoDJNWlYxpgFMRrmaie
	 B+Y5gTkL8Yc0yeKOxIRSTe+i+jm+h7VKmzgr+dmCR70DcMuKEbbPjFptfFYemj6M9e
	 X19EDTBF7aPV3n/+XjoAH8uP8QuiqK6+QN4aZIOcg/81xvR8bi5Q1P+dU0mqEvV4po
	 rQvi4g3hanuWsXne037AhsgSlGn56X1Wv/NrZGid5MZpSBNXwRSO4aZPGDf+eQyec7
	 WjTjCaFEOTH4YBje2A+uHax88S3XyAI/puBe9J1H57N/A3fDGNerb/s/jm6iAso9mS
	 WlQhs0H60UsFQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Miaoqian Lin <linmq006@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	Tom Zanussi <zanussi@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 167/232] tracing: Properly process error handling in event_hist_trigger_parse()
Date: Sat, 28 Feb 2026 13:10:20 -0500
Message-ID: <20260228181127.1592657-167-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 31d60758053d1..356360e75f9a7 100644
--- a/kernel/trace/trace_events_hist.c
+++ b/kernel/trace/trace_events_hist.c
@@ -6594,7 +6594,7 @@ static int event_hist_trigger_parse(struct event_command *cmd_ops,
 
 	remove_hist_vars(hist_data);
 
-	kfree(trigger_data);
+	trigger_data_free(trigger_data);
 
 	destroy_hist_data(hist_data);
 	goto out;
-- 
2.51.0

