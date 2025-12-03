Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66750355814;
	Wed,  3 Dec 2025 16:17:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764778656; cv=none; b=eHwLEsj3l4lDLDV10+RWbjwK798R6jndBqe/goalhK/LZCBw0h8kBnfhOLNJ4pndd5AD6gQglI5qrNk4dmBGuABfJ3HGCcglUiVgQGusNuwzQv23ovwmWVnjYXSuiN3xSP4CgHJ0q/XSC1h60+5VAnt52ARyemXiEhGTxfQC2Q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764778656; c=relaxed/simple;
	bh=ds24TMXuDgOLmtxMu7lJ+vMFUIuMPtAADTiobxtM+iI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PrZvLsTOsW9NlFoGKxnUXXhri8+WM6Sm9huNLkNWGcYadZd1DxrCaYgnCH+5V+TKJ9cryA6QrzhRERf1cNznE4Vjmax2MDeZ6xGS+9eaCIjLf+UZOBC3hcNsPy9SNFG6OWeVriF70Y7NkBg4yfsdXbbX7jhWSKjHvCStFid75e0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VOvGZV6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VOvGZV6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54BDCC4CEF5;
	Wed,  3 Dec 2025 16:17:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764778655;
	bh=ds24TMXuDgOLmtxMu7lJ+vMFUIuMPtAADTiobxtM+iI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VOvGZV6UKWZIFq5hwibYnN44bTodwNso5JzebMFD9bvXMSjAXv12K8CwA3O3CxmzU
	 Ou0HED3C0ACGCv/mVji1I1+JZnutyk54R8YPcBDUKiUuRdtLD0ZviRzjw5rdQaj3gJ
	 sh8Nox5J4m8RBUIsHiNz6nHIgBT8+mDJFQYk9mBQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 002/568] perf: Have get_perf_callchain() return NULL if crosstask and user are set
Date: Wed,  3 Dec 2025 16:20:04 +0100
Message-ID: <20251203152440.743546086@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Josh Poimboeuf <jpoimboe@kernel.org>

[ Upstream commit 153f9e74dec230f2e070e16fa061bc7adfd2c450 ]

get_perf_callchain() doesn't support cross-task unwinding for user space
stacks, have it return NULL if both the crosstask and user arguments are
set.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250820180428.426423415@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/callchain.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 1273be84392cf..ce5534c97cd1d 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -184,6 +184,10 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 	struct perf_callchain_entry_ctx ctx;
 	int rctx;
 
+	/* crosstask is not supported for user stacks */
+	if (crosstask && user && !kernel)
+		return NULL;
+
 	entry = get_callchain_entry(&rctx);
 	if (!entry)
 		return NULL;
@@ -200,7 +204,7 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 		perf_callchain_kernel(&ctx, regs);
 	}
 
-	if (user) {
+	if (user && !crosstask) {
 		if (!user_mode(regs)) {
 			if  (current->mm)
 				regs = task_pt_regs(current);
@@ -209,9 +213,6 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 		}
 
 		if (regs) {
-			if (crosstask)
-				goto exit_put;
-
 			if (add_mark)
 				perf_callchain_store_context(&ctx, PERF_CONTEXT_USER);
 
@@ -219,7 +220,6 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 		}
 	}
 
-exit_put:
 	put_callchain_entry(rctx);
 
 	return entry;
-- 
2.51.0



