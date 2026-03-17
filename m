Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94C4B2E62B7;
	Tue, 17 Mar 2026 16:49:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773766181; cv=none; b=ueXc6GDu+DaxBYpAD6/il9hthct/xme0SijtspJ6mZl1WuOYGQ/4bE8XlzXYkIzAAao182luyAwIFC63I4EWCA+h6lCyR7PMfDMwAyubilqasvQKrqqvN/wkD7lmn9UFHZEvKpx8ZA3qGIDTsaGtezEc6KoMxaBSsAZvC95bCoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773766181; c=relaxed/simple;
	bh=mVgR5mWFb048iZnlTf3frKl9HQrKoAJ76BLx7cK3dmg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jG+7ySwcvWq2pkribju1pgUrHVmInzPsQFQgsdLkL+mlKxMbqttMBr+qXrJ8PoGvJBrM5r8HRdMM+ubyHvpUQoffw+iOx1f0nB5FTNrCZJan/x6QA1ezY7aPhDWQ600V7Rn6DDchEVH48ENF2LXbdrDpY9y9h8eHSXRZdaM6hdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2V9GrW+H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2V9GrW+H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1BCFC4CEF7;
	Tue, 17 Mar 2026 16:49:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773766181;
	bh=mVgR5mWFb048iZnlTf3frKl9HQrKoAJ76BLx7cK3dmg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2V9GrW+H8wtnvbRIXybhf9tdc7NFrwtxcDA2rzSeIQEMGBEnMgIpGZPgKBxT3IsCg
	 Hwb3+XReP7DoVJPhr9TRiN9jDruGI/jUReEii1fllnsdS7MhPm/MefiKSiu+rUIT31
	 rSrQTSI0g0AtTpNZBq8jmtqhGgBf+EHtVSsSXv4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@kernel.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	"Matthieu Baerts (NGI0)" <matttbe@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 187/378] sched/mmcid: Remove pointless preempt guard
Date: Tue, 17 Mar 2026 17:32:24 +0100
Message-ID: <20260317163013.886179410@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317163006.959177102@linuxfoundation.org>
References: <20260317163006.959177102@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@kernel.org>

[ Upstream commit 7574ac6e49789ddee1b1be9b2afb42b4a1b4b1f4 ]

This is a leftover from the early versions of this function where it could
be invoked without mm::mm_cid::lock held.

Remove it and add lockdep asserts instead.

Fixes: 653fda7ae73d ("sched/mmcid: Switch over to the new mechanism")
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Tested-by: Matthieu Baerts (NGI0) <matttbe@kernel.org>
Link: https://patch.msgid.link/20260310202526.116363613@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/sched/core.c | 12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 24d607c78f119..c80076fcd78f2 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -10632,6 +10632,8 @@ static void mm_cid_fixup_tasks_to_cpus(void)
 
 static bool sched_mm_cid_add_user(struct task_struct *t, struct mm_struct *mm)
 {
+	lockdep_assert_held(&mm->mm_cid.lock);
+
 	t->mm_cid.active = 1;
 	mm->mm_cid.users++;
 	return mm_update_max_cids(mm);
@@ -10684,12 +10686,12 @@ static void sched_mm_cid_fork(struct task_struct *t)
 
 static bool sched_mm_cid_remove_user(struct task_struct *t)
 {
+	lockdep_assert_held(&t->mm->mm_cid.lock);
+
 	t->mm_cid.active = 0;
-	scoped_guard(preempt) {
-		/* Clear the transition bit */
-		t->mm_cid.cid = cid_from_transit_cid(t->mm_cid.cid);
-		mm_unset_cid_on_task(t);
-	}
+	/* Clear the transition bit */
+	t->mm_cid.cid = cid_from_transit_cid(t->mm_cid.cid);
+	mm_unset_cid_on_task(t);
 	t->mm->mm_cid.users--;
 	return mm_update_max_cids(t->mm);
 }
-- 
2.51.0



