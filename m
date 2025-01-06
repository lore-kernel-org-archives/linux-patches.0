Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B93641DE3B1;
	Mon,  6 Jan 2025 15:45:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736178352; cv=none; b=Y5KHc1scH6nlKxt7MPTTrEnqrGLo/CWs0oplm2nj43PgqVC+819jyZPUBmUuxjd1UilkAyCDZnM4HrKR12ftHXsVYSwdz9KElQRYLrC9lnEqKmJzpiBvDDuDyUxHb3UoJl0gNU9bU4NHF9ugjpu3KL+Ko2T0idT6DEalhxTv0OQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736178352; c=relaxed/simple;
	bh=spGbcoeNoyJkWW1kzw5AYEWYt4xymtpWTfJQJVN+5pg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HhbFWPvkbDsZJ/G0uVIbZpT2is6Xae9jEK6QDYTQt0RBUsWkCiJRE4j28Xt43mcj1sZQT6HISA9RDvzXbpl/Jc4NYjjqxgKcpJjuEv78YwheuJrhmna4o7eef0NrvsqJQmRuOYeeJZ7ErVZmlU55aLDk3EfOTkvEw8PsP7OTV9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqHc+ho5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqHc+ho5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39E6AC4CED2;
	Mon,  6 Jan 2025 15:45:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736178352;
	bh=spGbcoeNoyJkWW1kzw5AYEWYt4xymtpWTfJQJVN+5pg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqHc+ho5nmElAhhGT29+vtvHnWs12G6Z9OIbRLwclJ5YBBV/ueQAn55tTfFGjIwxh
	 0VWlL6bbsIQdl1/j1R7b/20PQDYhwzwnjmlyukdgqIk/c8LlxI45b8quMcWVoepgkg
	 +U+TOuwaVWJfBXWvx+x0YlwdeCkCC++2Rd6SPXyM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 058/138] tracing/kprobe: Make trace_kprobes module callback called after jump_label update
Date: Mon,  6 Jan 2025 16:16:22 +0100
Message-ID: <20250106151135.432295023@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151133.209718681@linuxfoundation.org>
References: <20250106151133.209718681@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

[ Upstream commit d685d55dfc86b1a4bdcec77c3c1f8a83f181264e ]

Make sure the trace_kprobe's module notifer callback function is called
after jump_label's callback is called. Since the trace_kprobe's callback
eventually checks jump_label address during registering new kprobe on
the loading module, jump_label must be updated before this registration
happens.

Link: https://lore.kernel.org/all/173387585556.995044.3157941002975446119.stgit@devnote2/

Fixes: 614243181050 ("tracing/kprobes: Support module init function probing")
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/trace_kprobe.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_kprobe.c b/kernel/trace/trace_kprobe.c
index 164779c6d133..646109d389e9 100644
--- a/kernel/trace/trace_kprobe.c
+++ b/kernel/trace/trace_kprobe.c
@@ -704,7 +704,7 @@ static int trace_kprobe_module_callback(struct notifier_block *nb,
 
 static struct notifier_block trace_kprobe_module_nb = {
 	.notifier_call = trace_kprobe_module_callback,
-	.priority = 1	/* Invoked after kprobe module callback */
+	.priority = 2	/* Invoked after kprobe and jump_label module callback */
 };
 
 /* Convert certain expected symbols into '_' when generating event names */
-- 
2.39.5



