Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9264A221FB6;
	Fri, 31 Oct 2025 14:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919422; cv=none; b=q84X1ICO1RrEvFagyWtpHLJZEPptodzfCjclZLmt94wP1GtMCSX6Haq7SkFvlTiBgjDYfQ/CwXK3C1TJHnwAXysvU5SMBvVLnMu4hAVYPYRKkwlI6+OwZAFnLvKEiALGb101RCOKiA57XkN13FGy0Fp+3VCXJtCP8bnL/1IyYQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919422; c=relaxed/simple;
	bh=ibKcD0jOjNtwjwmdJz5P7QbIL7ZNKaYwJLLVk79XIzU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FdsG1FjvXhE42rvFgEpL6scFMhv6gx5jZ63WHXmVH0/NuBRb9yANy0udmZr/x9hoKj/5bAMKRggM68eXgCz3WN0BvwAydqkC+mojnEwJkvwJdSYegGB5ybNLGQ0pG9vs23V1tintJzCJuBVQIF6JwmUAwqkqGudUnpCvG9F28dI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RAre7Gb3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RAre7Gb3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16AF2C116B1;
	Fri, 31 Oct 2025 14:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919422;
	bh=ibKcD0jOjNtwjwmdJz5P7QbIL7ZNKaYwJLLVk79XIzU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RAre7Gb3lY8a6muo51qd6m0Etdxj5ASFvcyG7FzLoyDKqx7qbeWNX8caq7bLAGHvE
	 o2X1s8EYnUphwSOXaXMmOBSG8af+nMxJ/CqHxM7ebbm30sMdy0NUW5AeZC6OCsCOWv
	 9BaTlQe97hftjqlA7yF7rmkAWfn1n93Akca2nH0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Josh Poimboeuf <jpoimboe@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 05/40] perf: Have get_perf_callchain() return NULL if crosstask and user are set
Date: Fri, 31 Oct 2025 15:00:58 +0100
Message-ID: <20251031140044.074428414@linuxfoundation.org>
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
index d1a09e6f514c9..49d87e6db553f 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -223,6 +223,10 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 	struct perf_callchain_entry_ctx ctx;
 	int rctx, start_entry_idx;
 
+	/* crosstask is not supported for user stacks */
+	if (crosstask && user && !kernel)
+		return NULL;
+
 	entry = get_callchain_entry(&rctx);
 	if (!entry)
 		return NULL;
@@ -239,7 +243,7 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 		perf_callchain_kernel(&ctx, regs);
 	}
 
-	if (user) {
+	if (user && !crosstask) {
 		if (!user_mode(regs)) {
 			if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
 				regs = NULL;
@@ -248,9 +252,6 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 		}
 
 		if (regs) {
-			if (crosstask)
-				goto exit_put;
-
 			if (add_mark)
 				perf_callchain_store_context(&ctx, PERF_CONTEXT_USER);
 
@@ -260,7 +261,6 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 		}
 	}
 
-exit_put:
 	put_callchain_entry(rctx);
 
 	return entry;
-- 
2.51.0



