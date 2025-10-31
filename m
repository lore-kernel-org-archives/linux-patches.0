Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82D8DAD4B;
	Fri, 31 Oct 2025 14:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919354; cv=none; b=astu+/u/A+LU1DlYPnF25sKqD5Kz2FQp07VM5hHBN9wDj7/c26xcOHKQxKYa/MPr9kGdBxngslI1y49U7xuxx7QW9tuZpKSUigqIBPoD8lVwbmtBmKJ+pettFVXNgt8l1BAIX42dYlGjdJNVdp/EJRJ6Gs2qF/UxPwvPxP9gUd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919354; c=relaxed/simple;
	bh=JX+5Pwk+Ap45tM2AI6zlx2eKiMnqR9aPSJwL8Y0NEfc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R3C9nvynjEO627GTXg7cycksLeDE/ierOXeLPLS1zXBG2k/SySc2dKwoIn9RW/mmE1ZFYeeXj70Zt1pPcbAHjfPXYXadFPFjZqJRsMzfZ0lkYucluy3wEG/duPjz2OSSxMXTZfnp++QGJytV5dgz01aV+1Qxh5BLIJUndv68IwI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jn6Tq11k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jn6Tq11k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E337C4CEFB;
	Fri, 31 Oct 2025 14:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919354;
	bh=JX+5Pwk+Ap45tM2AI6zlx2eKiMnqR9aPSJwL8Y0NEfc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jn6Tq11kTWva2FNC+G6HPWwUATb6nj01kFrgA9N7mjoIANvTe7UBRWKeueV9j/O6c
	 znWHL8vzu3i7MAbAD5oLovVUCBWxGxjs9I9ax4neUWgC7tqjsFWGSOCL6zkyER1qG4
	 B6QaEcthMUYfhzHmiSaUYRgQopuTpoMrfXbQNVG0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 05/32] perf: Skip user unwind if the task is a kernel thread
Date: Fri, 31 Oct 2025 15:00:59 +0100
Message-ID: <20251031140042.529430263@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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
index 3eb9125431b43..c9a3fb6fdb2f6 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7724,7 +7724,8 @@ struct perf_callchain_entry *
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



