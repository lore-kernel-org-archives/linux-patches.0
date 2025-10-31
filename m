Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1973822A4D6;
	Fri, 31 Oct 2025 14:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919541; cv=none; b=FsEbin4aqYofd7trmwK6XLTWLPyziuWsLXUfzYW97kO20iVFLUBeBlEXQ9MEvxbCetB2+ey+bbByhs0GnnPOEgVNo8OflIA02y8yxSAYoZbMN/+Qz6dTvMB5nwVj6Na7XOvwe3POvQB0V47EcWOxRmL4nvGdh60fEajAxRhXCik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919541; c=relaxed/simple;
	bh=H0BTvXIHfv54WGbD/a0VKztSIOcJNQi+mQgVpsnfRRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rsu9cJKIDQRXIlhaRVgvtaCkHkvbtx83O7l0RAGu+q8kqe98R9OGDslJ2L0WhiOS9OktW/jbfgTjI3L+h7Dmwrph4eZmyD9V7UMSCV/71oxg5e3qEKf/zaJPH4dE9WirWSFefh7bGabV+YHmW16PUVYU3NVr4kBhqAN0o7fhsyQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0YQBptRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0YQBptRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8CA18C4CEE7;
	Fri, 31 Oct 2025 14:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919541;
	bh=H0BTvXIHfv54WGbD/a0VKztSIOcJNQi+mQgVpsnfRRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0YQBptRmOq5b0VpOD8jPGqEr6I/bbKlrcB8J+5Cv/8sRM6/6WqNH4wEjao8y4F9P1
	 4o2qr1hPX4AxjbS5kWJu7Ii0dv+0DF09azjCJ0ufvkiUghH+bYvlswKStFOXDgxlEJ
	 kelhhkrUArlPGi4f2XdFygTkZ5/o74fr5FWc5Kxw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 13/35] perf: Use current->flags & PF_KTHREAD|PF_USER_WORKER instead of current->mm == NULL
Date: Fri, 31 Oct 2025 15:01:21 +0100
Message-ID: <20251031140043.876231714@linuxfoundation.org>
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
index 6c83ad674d010..decff7266cfbd 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -242,10 +242,10 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 
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
index 6e9427c4aaff7..a3dc79ec6f879 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7440,7 +7440,7 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
 	if (user_mode(regs)) {
 		regs_user->abi = perf_reg_abi(current);
 		regs_user->regs = regs;
-	} else if (!(current->flags & PF_KTHREAD)) {
+	} else if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
 		perf_get_regs_user(regs_user, regs);
 	} else {
 		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
@@ -8080,7 +8080,7 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * Try IRQ-safe get_user_page_fast_only first.
 		 * If failed, leave phys_addr as 0.
 		 */
-		if (current->mm != NULL) {
+		if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
 			struct page *p;
 
 			pagefault_disable();
-- 
2.51.0



