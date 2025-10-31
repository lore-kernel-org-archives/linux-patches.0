Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08618210F59;
	Fri, 31 Oct 2025 14:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919420; cv=none; b=bnPxtmIiNEouexaae95Rj63BbqLMICXMal5QPXHZpFiDZki1AVgkuCBYK1OzWy+jO1omvwhC/ZIv6qME2N4LvWM8NOdqUsFVUf+EyiB2elog/DmSWDaVmmRXM7n2oyRde6f2NktYK55V+JeQq31MoQ0RK7UVHItmkTJK4ksMHLQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919420; c=relaxed/simple;
	bh=vOVC5KEK2PLlaSupxjzzWbwual4jveKrLbIVlmgz710=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAfFLIK8cRJy00VNOODcQV9/ekRZbXAbv0bZ9iN9IJ8QMFcK/HttROvNnV+8eihyxj911qYR6dHGaQnYK+7X4sBZZjk2+OLQa3TKiGlMU+9geBNHhbxepVKLUdvIDalp0ACXSa7WqOLP4Algyipj52Uq8vBR41zdl6LsiL2MRLg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eFehfMB2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eFehfMB2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 380B2C4CEE7;
	Fri, 31 Oct 2025 14:03:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919419;
	bh=vOVC5KEK2PLlaSupxjzzWbwual4jveKrLbIVlmgz710=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eFehfMB2d43kRCKHg2B9YocAyLE2gzOvMzumuuf1xu8ag64ll9xIdXV+/Ldyzd17w
	 rLQAcaQBA8Y6Ki024neCaSnMWhanyuAafkVmLIgusdGszAVIX1jmeEHgtLf5Tqc/k5
	 pKcr5Okm7Uf0w7vEvVfOZHOLy1emLSX7acbgsekM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 04/40] perf: Use current->flags & PF_KTHREAD|PF_USER_WORKER instead of current->mm == NULL
Date: Fri, 31 Oct 2025 15:00:57 +0100
Message-ID: <20251031140044.050062176@linuxfoundation.org>
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
index 8a47e52a454f4..d1a09e6f514c9 100644
--- a/kernel/events/callchain.c
+++ b/kernel/events/callchain.c
@@ -241,10 +241,10 @@ get_perf_callchain(struct pt_regs *regs, u32 init_nr, bool kernel, bool user,
 
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
index d60d48d482b01..0339f60e34981 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7095,7 +7095,7 @@ static void perf_sample_regs_user(struct perf_regs *regs_user,
 	if (user_mode(regs)) {
 		regs_user->abi = perf_reg_abi(current);
 		regs_user->regs = regs;
-	} else if (!(current->flags & PF_KTHREAD)) {
+	} else if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
 		perf_get_regs_user(regs_user, regs);
 	} else {
 		regs_user->abi = PERF_SAMPLE_REGS_ABI_NONE;
@@ -7735,7 +7735,7 @@ static u64 perf_virt_to_phys(u64 virt)
 		 * Try IRQ-safe get_user_page_fast_only first.
 		 * If failed, leave phys_addr as 0.
 		 */
-		if (current->mm != NULL) {
+		if (!(current->flags & (PF_KTHREAD | PF_USER_WORKER))) {
 			struct page *p;
 
 			pagefault_disable();
-- 
2.51.0



