Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA30325DAEA;
	Fri, 31 Oct 2025 14:03:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919425; cv=none; b=ZjMz18unxHJv+H3QVbyg0KoCNsGfKsuiM+7B9HlkiKN88v5f9W3MLpSsRwps1tQubhsXUyYfjZ2lsQ/sWah5/qLxKRRxXTIpfdIiPpgZEtTH0GTntHBJTRCi2I7FU5O8RA0P3AWG+GJ7DZNmjnqy7frVEGydvb6kDgb1dYOJe+w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919425; c=relaxed/simple;
	bh=rYMbFgfaG3kZEMt1PqMBm49Dgv9UQUChKnyqOWEHAUE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DRRoOqX4rQdkI1u6AykY84JpqNvqKZlpXHbpAEGRAekq0GFsihP+vkmPIY6niNqeVrvnPqvN5xmtwFBRDNxcD5cVRUbNBIyBXFGxUfKEFgo7bQNVW9meyFD7d4owG3H04TmPX9zT+2o5Wpih2dR7janJk/8dx2dVSHVP97rTSCM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cwZKjaKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cwZKjaKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC51AC4CEE7;
	Fri, 31 Oct 2025 14:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919425;
	bh=rYMbFgfaG3kZEMt1PqMBm49Dgv9UQUChKnyqOWEHAUE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cwZKjaKA5qe6lhfXUHWeGu3n5odgR+RJAdpd5WSFfekvzhacRvm8itWxVghPKSNky
	 ExHinarA5SqEaME3giTTOOBgObz2+n0hckwqmH2KejifeNGQDf6OAt4IYTVEAFhZQQ
	 wrGxPb17hht0Lh7uqznPLcwD0/Atei6AZzCo/YMI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 06/40] perf: Skip user unwind if the task is a kernel thread
Date: Fri, 31 Oct 2025 15:00:59 +0100
Message-ID: <20251031140044.099222721@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.939381518@linuxfoundation.org>
References: <20251031140043.939381518@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 16ed389227651330879e17bd83d43bd234006722 ]

If the task is not a user thread, there's no user stack to unwind.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250820180428.930791978@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 0339f60e34981..d6a86d8e9e59b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7847,7 +7847,8 @@ struct perf_callchain_entry *
 perf_callchain(struct perf_event *event, struct pt_regs *regs)
 {
 	bool kernel = !event->attr.exclude_callchain_kernel;
-	bool user   = !event->attr.exclude_callchain_user;
+	bool user   = !event->attr.exclude_callchain_user &&
+		!(current->flags & (PF_KTHREAD | PF_USER_WORKER));
 	/* Disallow cross-task user callchains. */
 	bool crosstask = event->ctx->task && event->ctx->task != current;
 	const u32 max_stack = event->attr.sample_max_stack;
-- 
2.51.0



