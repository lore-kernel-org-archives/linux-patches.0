Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47FCE352001;
	Tue, 13 Oct 2026 12:34:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791894882; cv=none; b=snHJgfNo/sppqnTB78nxyyBTfncG8iulG0GnnCfQ8X9W1sK6KxzE2J45b5SnyF3ihN3xEJJnWJZecyQdpFhQfYU8Z4SVjwZA/F+M65vGx2S3hnPwjrh5C6mAcisMMD8iFlRpkZbdl8Xd0DjvlVeSRUUQ85V2Sbn4TDOhNE/uGnw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791894882; c=relaxed/simple;
	bh=WEf8I89HFcyEIf1Ypc3nO6AQZJa/xD6i1ht4JdFNfJU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rEqglTN/O08iXvm6JyWoFq+3A4BwjYobFFEJfhHeiMO5OVPGzHD5VGA+EvbQ6nsgpkwI99/sCcCBEVewFV8jfFTsHni9ZXSlIl3wjQB5NTiG0xWUlpPLUMSCsBAuEQGCeJuXhTWXT29riLsPCr8mNOB677BopsgKl6kGNRZpAWc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D6jMbOBz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D6jMbOBz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC7A1F00893;
	Tue, 13 Oct 2026 12:34:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791894881;
	bh=CR3gW6vX4rrz1QHJQ/g0r7V+hq20mvY8QJRqZfFlR4I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D6jMbOBzqav4M8Q91MKlezWGqxLk9kMawcIBrrNCLpC1ecHKQMMKLR/1O/OtYQWqM
	 mdIhtVm0FkUIxkS403fEVmr4EoEQBicdErw+TFuzTjKRaO46aptsplvgzyFTFgnMAB
	 x5ey3tpsLCRek0YtC4ksOZdRsgcolCSe74VFJFgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot <syzbot+2fe61cb2a86066be6985@syzkaller.appspotmail.com>,
	Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 044/497] perf/core: Fix WARN in perf_sigtrap()
Date: Tue, 13 Oct 2026 13:33:31 +0200
Message-ID: <20261013112908.934316448@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>

[ Upstream commit 3da6bb419750f3ad834786d6ba7c9d5d062c770b ]

Since exit_task_work() runs after perf_event_exit_task_context() updated
ctx->task to TASK_TOMBSTONE, perf_sigtrap() from perf_pending_task() might
observe event->ctx->task == TASK_TOMBSTONE.

Swap the early exit tests in order not to hit WARN_ON_ONCE().

Closes: https://syzkaller.appspot.com/bug?extid=2fe61cb2a86066be6985
Reported-by: syzbot <syzbot+2fe61cb2a86066be6985@syzkaller.appspotmail.com>
Signed-off-by: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/b1c224bd-97f9-462c-a3e3-125d5e19c983@I-love.SAKURA.ne.jp
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/events/core.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index dfbd217fd20c0..ab18d02dd959c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -6907,18 +6907,18 @@ void perf_event_wakeup(struct perf_event *event)
 static void perf_sigtrap(struct perf_event *event)
 {
 	/*
-	 * We'd expect this to only occur if the irq_work is delayed and either
-	 * ctx->task or current has changed in the meantime. This can be the
-	 * case on architectures that do not implement arch_irq_work_raise().
+	 * Both perf_pending_task() and perf_pending_irq() can race with the
+	 * task exiting.
 	 */
-	if (WARN_ON_ONCE(event->ctx->task != current))
+	if (current->flags & PF_EXITING)
 		return;
 
 	/*
-	 * Both perf_pending_task() and perf_pending_irq() can race with the
-	 * task exiting.
+	 * We'd expect this to only occur if the irq_work is delayed and either
+	 * ctx->task or current has changed in the meantime. This can be the
+	 * case on architectures that do not implement arch_irq_work_raise().
 	 */
-	if (current->flags & PF_EXITING)
+	if (WARN_ON_ONCE(event->ctx->task != current))
 		return;
 
 	send_sig_perf((void __user *)event->pending_addr,
-- 
2.53.0



