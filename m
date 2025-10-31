Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB7CC34D387;
	Fri, 31 Oct 2025 14:02:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919348; cv=none; b=AJmYFHScWiko9tTXILY8zHBgSDHlXrofd8Gzo6O2VmfLhezHf4iwyS/beCxcW7R04LSAOj9vM+v7QlJIeTxws2SmaKvTKvC346dad8XsNTz+VWamPMCLHyHtcsbc6KoOt6Lla47IN/UWr16YkKQwxaK7bOlXbBoTK9EtI7GlW/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919348; c=relaxed/simple;
	bh=xzEBATsw5oAtI/jmTRdY04ojLvJMZzltWEQaG0jG8pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/qHxD3RG/bl0ms9zQoysLdrZ+k/dgzyRSXVh32wL6kmv5Hgett3n3IwvDhGuUM24RFnozNhYW1sJ+3HCGwslNm8dz0OnS/XK26exDoCNmfmex0/lr2PsS6egjiguAAi8B79nBCrU9kZJ7dFbp+9nBmE07EJGDS9YVyLnvsuOXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PL4xwCmd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PL4xwCmd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37157C4CEE7;
	Fri, 31 Oct 2025 14:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919348;
	bh=xzEBATsw5oAtI/jmTRdY04ojLvJMZzltWEQaG0jG8pI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PL4xwCmdQKMpwGgR9ZAOTtM7C44j3KfHiZfxpX+AcVAvXYiJBsIwKJDoa89CYAtQb
	 dMyuUBpR7WVLrn1EBIHD3cuYQFu5VKYMFKjefcGczfhoMblqU4EQ1pjsiOPmIexOVB
	 g4ImL3YnH6CcgV3zK51qSMAQflI8uXDYawen1wl4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 03/32] perf: Use current->flags & PF_KTHREAD|PF_USER_WORKER instead of current->mm == NULL
Date: Fri, 31 Oct 2025 15:00:57 +0100
Message-ID: <20251031140042.475708285@linuxfoundation.org>
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

From: Steven Rostedt <rostedt@goodmis.org>

[ Upstream commit 90942f9fac05702065ff82ed0bade0d08168d4ea ]

To determine if a task is a kernel thread or not, it is more reliable to
use (current->flags & (PF_KTHREAD|PF_USER_WORKERi)) than to rely on
current->mm being NULL.  That is because some kernel tasks (io_uring
helpers) may have a mm field.

Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lore.kernel.org/r/20250820180428.592367294@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/callchain.c | 6 +++---
 kernel/events/core.c      | 4 ++--
 2 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/kernel/events/callchain.c b/kernel/events/callchain.c
index 1273be84392cf..65fea424874c5 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -202,10 +202,10 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 
 	if (user) {
 		if (!user_mode(regs)) {
-			if  (current->mm)
-				regs = task_pt_regs(current);
-			else
+			if (current->flags & (PF_KTHREAD | PF_USER_WORKER))
 				regs = NULL;
+			else
+				regs = task_pt_regs(current);
 		}
 
 		if (regs) {
diff --git a/kernel/events/core.c b/kernel/events/core.c
index b73f5c44113d6..3eb9125431b43 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6985,7 +6985,7 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
 	if (user_mode(regs)) {
 		regs_user->abi = perf_reg_abi(current);
 		regs_user->regs = regs;
-	} else if (!(current->flags & PF_KTHREAD)) {
+	} else if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
 		perf_get_regs_user(regs_user, regs);
 	} else {
 		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
@@ -7612,7 +7612,7 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * Try IRQ-safe get_user_page_fast_only first.
 		 * If failed, leave phys_addr as 0.
 		 */
-		if (current->mm != NULL) {
+		if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
 			struct page *p;
 
 			pagefault_disable();
-- 
2.51.0



