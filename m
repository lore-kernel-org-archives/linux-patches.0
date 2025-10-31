Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B734AAD4B;
	Fri, 31 Oct 2025 14:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919351; cv=none; b=o33dZFkaQagS1svDp+JVBfZ92TRFAdyTLz6SzN1L+IzWEbge3y+aN7mXhCVy+XwQzU9uPWwAID+C1R3FgwqzJ2tMXT3PU6BGG63utolLhGy6bE4BJ0hIl0uZBLqlf9Iv/2hLEHASeyHMqBVyodDH5LtEgFKKqDPdofJwBtVY7+Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919351; c=relaxed/simple;
	bh=3EAesYVxahiBBKN/HoSMAhQcXDbXnXZDY0Y8tGsOiqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6jeiSfpAyKFjkd5wAaC6TH37WkeMi1n6AHgVbvOl7ntKfIVKL7b9VJa4dI7F+gSktFfYxIDsgnx2rgdmyziXDmcywNcvPL1KM4JgbUyaJpVBAB49EDU0NluKlCuqWOHwzQMWcBG314s6iHEQvfFA5ZbEYQs+unTzRrBGGDDZcs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sYpv6F/Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sYpv6F/Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3362CC4CEE7;
	Fri, 31 Oct 2025 14:02:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919351;
	bh=3EAesYVxahiBBKN/HoSMAhQcXDbXnXZDY0Y8tGsOiqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sYpv6F/QSsL0xYwcoFDfIxo2U+AmanGCQBeVvdl1tHtafdjNBUGgntet1yQ7Zn3Fg
	 zwofxSAuHvp3aOXG9UlaqD126mwlOTSyIiv63BKWl9ohIdUv0kBLKT4whF+JD1Aspr
	 h5yRVcQ8nWD5oajjIntXoTr851Ts5aQNrziWTxzk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 04/32] perf: Have get_perf_callchain() return NULL if crosstask and user are set
Date: Fri, 31 Oct 2025 15:00:58 +0100
Message-ID: <20251031140042.501287346@linuxfoundation.org>
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
index 65fea424874c5..ee01cfcc35064 100644
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
 			if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
 				regs = NULL;
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



