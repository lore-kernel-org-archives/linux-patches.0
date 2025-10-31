Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1819022A4D6;
	Fri, 31 Oct 2025 14:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919544; cv=none; b=HAlbDsFLJZLSVF9wnLUr/K/vKnElk5azzij/uElwi19pkffpLdOGxiKa26Qp0mhMdrZ2GoSaCzW3DEifI4Ll32EAgI29NGWJy3PqbB3ugx4sRe3eGrUJqxn9oXtAL8SuJo0cDRuCn6hovjR4nzW3bGJBzh22RlPqB3EBdHg83wM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919544; c=relaxed/simple;
	bh=Ep8ttPbCAdYc8+RFZ7M94sPSuZGu1VwsK+EpeDQ7APM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NgG7A9QsUvkrlfQ8fNb8PFSLLmiNV9n4JaSw7cM8wOCNGxz6vOroD5UjMa9L9XHFSGN2y6B40DgE27Dq2Mez8eXZxhZMaZAIkB3VY9B3R13UVqIKCH+1hI+86B/+AEQsD1JaGeTQHxE1U9SKQKgFiuzjQenO7R9eLeupEiiKG/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KZB2QWUV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KZB2QWUV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B1D5C4CEE7;
	Fri, 31 Oct 2025 14:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919544;
	bh=Ep8ttPbCAdYc8+RFZ7M94sPSuZGu1VwsK+EpeDQ7APM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KZB2QWUVCzO4D3UpgCWynI2zpm7nd7/a6c8YswH9Gh7EYrObnoo8VE5eAkqTRjFV+
	 8BoTaQZIZUI7Uh/CBlLlTxtgKlBnOmas/3msiMu5QIaLVQ2M9HJSGx6CdhLzHLF6Pz
	 Y/ukjrB2SJawEfkNRLX6MaSPHzYgW8ZBc0M5ucp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 14/35] perf: Have get_perf_callchain() return NULL if crosstask and user are set
Date: Fri, 31 Oct 2025 15:01:22 +0100
Message-ID: <20251031140043.901751352@linuxfoundation.org>
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
index decff7266cfbd..2609998ca07f1 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -224,6 +224,10 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 	struct perf_callchain_entry_ctx ctx;
 	int rctx, start_entry_idx;
 
+	/* crosstask is not supported for user stacks */
+	if (crosstask && user && !kernel)
+		return NULL;
+
 	entry = get_callchain_entry(&rctx);
 	if (!entry)
 		return NULL;
@@ -240,7 +244,7 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 		perf_callchain_kernel(&ctx, regs);
 	}
 
-	if (user) {
+	if (user && !crosstask) {
 		if (!user_mode(regs)) {
 			if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
 				regs = NULL;
@@ -249,9 +253,6 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 		}
 
 		if (regs) {
-			if (crosstask)
-				goto exit_put;
-
 			if (add_mark)
 				perf_callchain_store_context(&ctx, PERF_CONTEXT_USER);
 
@@ -261,7 +262,6 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 		}
 	}
 
-exit_put:
 	put_callchain_entry(rctx);
 
 	return entry;
-- 
2.51.0



