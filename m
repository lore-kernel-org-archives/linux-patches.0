Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A105421FF4C;
	Wed,  4 Feb 2026 15:27:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218855; cv=none; b=ceVX5DLxbxkyfewr6y0co9cXXe1pDeij8semPGqoZlAdgK9WYIaMTL5Fc0Bgeyq/D+ahfcVLIvS0cdYDG5Rhbf+POLPF0dKuCqfY9jUe0l9AiXzSGRwfpqGdzPNvARAtBTJo3uYG9rLjWcoKFcTjIXYmnfruSLXHPFzEllkzI6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218855; c=relaxed/simple;
	bh=/kQ6QmIdkugjZKN5V7eG16jMg60pfux8ZRd2p8aHH5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XhNJjdJTgc35rLMzdhMEIfkzExExNjhBXfN+UllvLsbRaStjANOBLvPQoqwhmH2a40kikxycw73EQeehjeCXwSCn6bXbGw4SIl1KQ/lwxFKCNzTP6cg2NSO/9F1T7wkkUVJLfPDIobWnLG5xPxwHlGW4giXkKrWEcsQvcNC+1PU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1CiiXDGM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1CiiXDGM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1DA3C4CEF7;
	Wed,  4 Feb 2026 15:27:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218855;
	bh=/kQ6QmIdkugjZKN5V7eG16jMg60pfux8ZRd2p8aHH5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1CiiXDGMQvDh9efBMsnNrnDW2gRDApLangHemZE5bWLw89vMPpJ6VL63M38pliHCZ
	 6vxvyXr4v4fr4p+lwKuu9gUCJWrxPNwTLKkrpg9G4TYOSVF7rKDQAzfPrVPXgE1S/L
	 ezcvT1MIF7IOu+0vylQPpIcD5fOo7qLG6Q9k1fmA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Namhyung Kim <namhyung@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 80/87] perf: Simplify get_perf_callchain() user logic
Date: Wed,  4 Feb 2026 15:41:18 +0100
Message-ID: <20260204143849.802154433@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

[ Upstream commit d77e3319e31098a6cb97b7ce4e71ba676e327fd7 ]

Simplify the get_perf_callchain() user logic a bit.  task_pt_regs()
should never be NULL.

Signed-off-by: Josh Poimboeuf <jpoimboe@kernel.org>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: https://lore.kernel.org/r/20250820180428.760066227@kernel.org
Stable-dep-of: 76ed27608f7d ("perf: sched: Fix perf crash with new is_user_task() helper")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/events/callchain.c |   18 ++++++++----------
 1 file changed, 8 insertions(+), 10 deletions(-)

--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -246,21 +246,19 @@ get_perf_callchain(struct pt_regs *regs,
 	if (user && !crosstask) {
 		if (!user_mode(regs)) {
 			if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
-				regs = NULL;
-			else
-				regs = task_pt_regs(current);
+				goto exit_put;
+			regs = task_pt_regs(current);
 		}
 
-		if (regs) {
-			if (add_mark)
-				perf_callchain_store_context(&ctx, PERF_CONTEXT_USER);
+		if (add_mark)
+			perf_callchain_store_context(&ctx, PERF_CONTEXT_USER);
 
-			start_entry_idx = entry->nr;
-			perf_callchain_user(&ctx, regs);
-			fixup_uretprobe_trampoline_entries(entry, start_entry_idx);
-		}
+		start_entry_idx = entry->nr;
+		perf_callchain_user(&ctx, regs);
+		fixup_uretprobe_trampoline_entries(entry, start_entry_idx);
 	}
 
+exit_put:
 	put_callchain_entry(rctx);
 
 	return entry;


