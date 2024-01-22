Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BB5A1FBF;
	Tue, 23 Jan 2024 01:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705972160; cv=none; b=TUCKNf3nspU/OfEIypp47+jRyIDE0u21b8fYNclxoVtvkPfWkeWlm6u3Ae3t+rgO1nJX6uzJ7bspyBX0kniZOwM4QeoL4yPl1oLmoB6GEj+7ZW4tEXWOlzSHP41Wzf8QrtuLYe0GUSHInnwj2IIkiAnm36N6wLRwvnT/9KE4jzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705972160; c=relaxed/simple;
	bh=gIhuVS1TjYikEiSNocD8pZ3G1ITzq7kFVNaNayNmZdo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kD9tQkJOYkDWc5Z/RPDFj90xg4Q4A6gfOAdM7HjHwg4/84ToIyxfAJg1xvCNK0iOZ9rpZ8SNSQdh/Rw4LiXfOusiLplgtigiMwxKeYguozLdd17ppsZNA9zHszRxLYagjHk0OfxCe2u6Vqs8MRSDtIHOrCUnNi7Fin0J1DFjxl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n7Q4lUoH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n7Q4lUoH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01027C43390;
	Tue, 23 Jan 2024 01:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705972160;
	bh=gIhuVS1TjYikEiSNocD8pZ3G1ITzq7kFVNaNayNmZdo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=n7Q4lUoHvExsvny9UhdKSRNcWA5X9jQzlz+PlsEYRJ6dHnp/tUrY27G+ydeerpAwD
	 1fmaJnaZfVUEvY5IsMJKqxecpdsBMtaImHY49ZpI6Csxrh9C8gEcN3NCdqqMJewyCS
	 JWo2XP0tMBN0jyu9MQDHHIwworoo14p+mfkpItik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pengfei Xu <pengfei.xu@intel.com>,
	"Masami Hiramatsu (Google)" <mhiramat@kernel.org>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Fedor Pchelkin <pchelkin@ispras.ru>
Subject: [PATCH 5.15 053/374] kprobes: Fix to handle forcibly unoptimized kprobes on freeing_list
Date: Mon, 22 Jan 2024 15:55:09 -0800
Message-ID: <20240122235746.447726038@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235744.598274724@linuxfoundation.org>
References: <20240122235744.598274724@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Masami Hiramatsu (Google) <mhiramat@kernel.org>

commit 4fbd2f83fda0ca44a2ec6421ca3508b355b31858 upstream.

Since forcibly unoptimized kprobes will be put on the freeing_list directly
in the unoptimize_kprobe(), do_unoptimize_kprobes() must continue to check
the freeing_list even if unoptimizing_list is empty.

This bug can happen if a kprobe is put in an instruction which is in the
middle of the jump-replaced instruction sequence of an optprobe, *and* the
optprobe is recently unregistered and queued on unoptimizing_list.
In this case, the optprobe will be unoptimized forcibly (means immediately)
and put it into the freeing_list, expecting the optprobe will be handled in
do_unoptimize_kprobe().
But if there is no other optprobes on the unoptimizing_list, current code
returns from the do_unoptimize_kprobe() soon and does not handle the
optprobe which is on the freeing_list. Then the optprobe will hit the
WARN_ON_ONCE() in the do_free_cleaned_kprobes(), because it is not handled
in the latter loop of the do_unoptimize_kprobe().

To solve this issue, do not return from do_unoptimize_kprobes() immediately
even if unoptimizing_list is empty.

Moreover, this change affects another case. kill_optimized_kprobes() expects
kprobe_optimizer() will just free the optprobe on freeing_list.
So I changed it to just do list_move() to freeing_list if optprobes are on
unoptimizing list. And the do_unoptimize_kprobe() will skip
arch_disarm_kprobe() if the probe on freeing_list has gone flag.

Link: https://lore.kernel.org/all/Y8URdIfVr3pq2X8w@xpf.sh.intel.com/
Link: https://lore.kernel.org/all/167448024501.3253718.13037333683110512967.stgit@devnote3/

Fixes: e4add247789e ("kprobes: Fix optimize_kprobe()/unoptimize_kprobe() cancellation logic")
Reported-by: Pengfei Xu <pengfei.xu@intel.com>
Signed-off-by: Masami Hiramatsu (Google) <mhiramat@kernel.org>
Cc: stable@vger.kernel.org
Acked-by: Steven Rostedt (Google) <rostedt@goodmis.org>
[fp: adjust comment conflict regarding commit 223a76b268c9 ("kprobes: Fix
 coding style issues")]
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/kprobes.c |   23 ++++++++++-------------
 1 file changed, 10 insertions(+), 13 deletions(-)

--- a/kernel/kprobes.c
+++ b/kernel/kprobes.c
@@ -549,17 +549,15 @@ static void do_unoptimize_kprobes(void)
 	/* See comment in do_optimize_kprobes() */
 	lockdep_assert_cpus_held();
 
-	/* Unoptimization must be done anytime */
-	if (list_empty(&unoptimizing_list))
-		return;
+	if (!list_empty(&unoptimizing_list))
+		arch_unoptimize_kprobes(&unoptimizing_list, &freeing_list);
 
-	arch_unoptimize_kprobes(&unoptimizing_list, &freeing_list);
-	/* Loop free_list for disarming */
+	/* Loop on 'freeing_list' for disarming and removing from kprobe hash list */
 	list_for_each_entry_safe(op, tmp, &freeing_list, list) {
 		/* Switching from detour code to origin */
 		op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
-		/* Disarm probes if marked disabled */
-		if (kprobe_disabled(&op->kp))
+		/* Disarm probes if marked disabled and not gone */
+		if (kprobe_disabled(&op->kp) && !kprobe_gone(&op->kp))
 			arch_disarm_kprobe(&op->kp);
 		if (kprobe_unused(&op->kp)) {
 			/*
@@ -788,14 +786,13 @@ static void kill_optimized_kprobe(struct
 	op->kp.flags &= ~KPROBE_FLAG_OPTIMIZED;
 
 	if (kprobe_unused(p)) {
-		/* Enqueue if it is unused */
-		list_add(&op->list, &freeing_list);
 		/*
-		 * Remove unused probes from the hash list. After waiting
-		 * for synchronization, this probe is reclaimed.
-		 * (reclaiming is done by do_free_cleaned_kprobes().)
+		 * Unused kprobe is on unoptimizing or freeing list. We move it
+		 * to freeing_list and let the kprobe_optimizer() remove it from
+		 * the kprobe hash list and free it.
 		 */
-		hlist_del_rcu(&op->kp.hlist);
+		if (optprobe_queued_unopt(op))
+			list_move(&op->list, &freeing_list);
 	}
 
 	/* Don't touch the code, because it is already freed. */


