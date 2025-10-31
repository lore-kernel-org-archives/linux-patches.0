Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1609623F417;
	Fri, 31 Oct 2025 14:05:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919547; cv=none; b=YI2FR9pkufm+1VyCnwkj8lmyCWk0HZzS6+WOg3BkMCnIisfzGL88hAhRS9tQtUpsEwe3jyOrdJiZe9C1uUAsgDnmOXUKBlXVCPIUY46vhZ4gdgy8GF71DqERpimUsd8l598bZW025NnM72GuBz01EErxP4seb41n+/BVXARFM+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919547; c=relaxed/simple;
	bh=c/eSBskDaW9/xGd3jpPtsmUdxiagTiuye/FLSVptZFc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m0cZMt/by3lbCfx5et0yMJzfUAQAhl1iG+4tlaJ+mmvsszEYYKGbMeFCYKXxvxQ1l07qgihFS5UCdPIYaG2EfGnuRGG+vWdIQH7jxHSqaSoEkd6VReaclZ4Re2y6JQngSEWOgrM5slj5LtFLia8gbkDzUhIAgyN6NsO8moMlhHQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CEuRXeuz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CEuRXeuz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 860A1C4CEE7;
	Fri, 31 Oct 2025 14:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919546;
	bh=c/eSBskDaW9/xGd3jpPtsmUdxiagTiuye/FLSVptZFc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CEuRXeuz4KI8J0UF90XFvvc3fNLW8BxaLP4qLKrPBru/rTTOWdf/IqHWGiIY+WAxu
	 VyxZIUAI7pED1kqoqoofEC0YNLJV9dPlJAzky3Xap44k1sg/D208FkOAjsFTY9sb+B
	 EpZFtULdh1AYTAP1KMbK4OBtCKbZKuICNbYn5y0s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 15/35] perf: Skip user unwind if the task is a kernel thread
Date: Fri, 31 Oct 2025 15:01:23 +0100
Message-ID: <20251031140043.925804178@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140043.564670400@linuxfoundation.org>
References: <20251031140043.564670400@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index a3dc79ec6f879..c0e938d28758f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -8192,7 +8192,8 @@ struct perf_callchain_entry *
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



