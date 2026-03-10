Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DD53876AD;
	Tue, 10 Mar 2026 11:15:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141305; cv=none; b=KTySN5MZJ2vfKIXXRwPgdylHDt8gJInTf58XJaSarOmi1DtxAcpnNTn9+tDEXrCY+R8sVer1iUdRRLzqZ3TZBgOP6vsjTmbOUiUPJS9Luor2YJ09TTOcIB5jugv5FxZdw4r6lZwHqdUVOf6AP6fy5/CiCazoKKqCwdhgUS8nXUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141305; c=relaxed/simple;
	bh=SG2cV+fdaj4EnHloYnS92e5sz70oYSxx/1A34LPwLKY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DkXkc2EhNLzB1TipMIjH7IIwRDXSLhdsB+CGEqFhgyp1GRS0C8eovzpjgwkxz7hiqz0xighwpG84r1o07GlbYYiKZGk2hqAb5ARxJWIYRTM9cpiqFYvLjEod1JlCuSa/KtEyxiww1ADQ67iwNXPHNSNxuRdNwUjUg52y1FvlWdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S3omRwJ9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S3omRwJ9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F036CC2BCB1;
	Tue, 10 Mar 2026 11:15:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141304;
	bh=SG2cV+fdaj4EnHloYnS92e5sz70oYSxx/1A34LPwLKY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S3omRwJ9WuVZqcz8ZGNI0gvwOHzczvnv4WvQVR7dI2D1dajDCru0hKKyU5dU50Dg1
	 1MEYDaEJhTVcyIC+JYj2wLPBMkIckzyAWpwZlpzDkKWeaDy2QnwDc3ZWlw3lw2UA8z
	 gEB3NQ5Ayg1bc7rvf0oZXs7ageR3yVeUNaRA0Vi6PKrm4YK3tbV2Fa5b9AEk1gOVNv
	 JRI1FDYWkO15dp52mbLQOVPynFMWeq6LGxGKo5zIKrggxSfWGzevIkgn5Qi8UJ5JjY
	 HjlXedKGUesEx0U43/I3SWQ9q4ublvZMdSvqiJNNE2SrrzK0iyFdiji2NspcNfpv3y
	 Bubr55IMUXFSg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Guenter Roeck <linux@roeck-us.net>,
	Miaoqian Lin <linmq006@gmail.com>,
	Masami Hiramatsu <mhiramat@kernel.org>,
	Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 309/311] tracing: Add NULL pointer check to trigger_data_free()
Date: Tue, 10 Mar 2026 07:05:56 -0400
Message-ID: <6a2ce0cdaa8454340634c4ea115de5832df19d72.1773140656.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

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
index 06b75bcfc7b8b..871e7a99d03cb 100644
--- a/kernel/trace/trace_events_trigger.c
+++ b/kernel/trace/trace_events_trigger.c
@@ -50,6 +50,9 @@ static int trigger_kthread_fn(void *ignore)
 
 void trigger_data_free(struct event_trigger_data *data)
 {
+	if (!data)
+		return;
+
 	if (data->cmd_ops->set_filter)
 		data->cmd_ops->set_filter(NULL, data, NULL);
 
-- 
2.51.0

