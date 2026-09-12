Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E93D03AFD15;
	Sat, 12 Sep 2026 09:05:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789203943; cv=none; b=WPevTWBxak3y0gkl5815hGJMspWtZktVPgivlks1tf0En5Kx8DPA72oQmRrwv6nMAr2/z9bdXG4rXJWmp8qHwe87HH+j8TScxZnfjGDsH/+i1IvwNae9sVBUy2UlpgLatykVA1r9rTjD80krDshd6W9kdWIcs5KWnOlm1/DvWNI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789203943; c=relaxed/simple;
	bh=Ggiit/t4om6x0W5/diudaDwUV7pNjXPUFHsN+U6fzQE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R9pSKF2fVJuHB/RK+w2nXwzPX3ZTu7+aILIO0wn9IKu1fNksa6jOs+zWJHF+bL/BxhY0EYNaZb9022OxU4ay8+IHfFVKimXIorm6C8tqTlaNbZw4uYFucg4HV/JGXfk9pbeuwDx6OnxJpBcRoGZHCLLIEFUC325nWNtsmqc74wI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ArWjiHHF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ArWjiHHF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E18EC1F000FF;
	Sat, 12 Sep 2026 09:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789203941;
	bh=XuIU358v15hlbHI4lA0AE6k+KW/4mmghQHW1IgkJny8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ArWjiHHFQJykz/9UaI/ZEzdo6q/OXs7EyvCS+ZTuBOqoVLQE4fk59A0YFQDNJ+s3a
	 KWGtMj/35/8axUj+xA1kx7aQWp7JjCKM3TluXfuQYAnrjED2rKa/RWSAkTFX5EmoVc
	 lRseBiReHGMfcGtAd5VWQM17+cnAS/84gWNxXVb4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tejun Heo <tj@kernel.org>,
	Changwoo Min <changwoo@igalia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1468/1815] sched_ext: Drop unlocked scx_rq_clock_invalidate() from scx_root_disable()
Date: Sat, 12 Sep 2026 08:53:38 +0200
Message-ID: <20260912065723.469982049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Tejun Heo <tj@kernel.org>

[ Upstream commit d44093323131a42a85184315bb9b6da4813cc39b ]

scx_root_disable() invalidates each rq's clock before taking the rq lock.
scx_rq_clock_invalidate() is a plain read-modify-write of rq->scx.flags and
every other writer of the word runs under the rq lock, so the unlocked
update can race a concurrent flags update and lose one side's bits.

The invalidation doesn't matter in the first place. The cached clock is read
only by scx_bpf_now() from a loaded scheduler's BPF programs, nothing can
re-validate the clock while sched_ext is disabled as scx_rq_clock_update()
is gated on scx_enabled() too, and the usual rq lock cycles under the next
scheduler refresh or invalidate it before it's practically observable. Drop
the invalidation instead of fixing the locking.

v2: Description and comment updated - the invalidation is unnecessary rather
    than subsumed by the rq lock cycle below.

Fixes: 3a9910b5904d ("sched_ext: Implement scx_bpf_now()")
Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Changwoo Min <changwoo@igalia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/ext/ext.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/kernel/sched/ext/ext.c b/kernel/sched/ext/ext.c
index c6cfb162abbdc..558be0cdebef8 100644
--- a/kernel/sched/ext/ext.c
+++ b/kernel/sched/ext/ext.c
@@ -6294,12 +6294,9 @@ static void scx_root_disable(struct scx_sched *sch)
 	percpu_up_write(&scx_fork_rwsem);
 
 	/*
-	 * Invalidate all the rq clocks to prevent getting outdated
-	 * rq clocks from a previous scx scheduler.
-	 *
-	 * Also re-balance the dl_server bandwidth reservations: detach
-	 * ext_server (no more sched_ext tasks) and reinstate fair_server if it
-	 * was previously detached because we were running in full mode.
+	 * Re-balance the dl_server bandwidth reservations: detach ext_server
+	 * (no more sched_ext tasks) and reinstate fair_server if it was
+	 * previously detached because we were running in full mode.
 	 *
 	 * Unlike the enable path, this runs on a recovery path that cannot
 	 * fail, so we use dl_server_swap_bw() to atomically free ext_server's
@@ -6312,8 +6309,6 @@ static void scx_root_disable(struct scx_sched *sch)
 	for_each_possible_cpu(cpu) {
 		struct rq *rq = cpu_rq(cpu);
 
-		scx_rq_clock_invalidate(rq);
-
 		scoped_guard(rq_lock_irqsave, rq) {
 			update_rq_clock(rq);
 			if (was_switched_all) {
-- 
2.53.0



