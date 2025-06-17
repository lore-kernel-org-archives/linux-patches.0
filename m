Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9CF2F234A;
	Tue, 17 Jun 2025 15:59:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175943; cv=none; b=He1/ZtQObOMmSa5AAj4/ot0oV2wF922+jg9rztF/ZpNPU/YU+8KHydYtBS1SuSwyJldkBf0IeMx2BwNwIrSf+0US/SIZgfcIuUDBbruJpFpmQV2o5nfmjplzfmR4sEMQrOM1xzJjgThaeA9xZM1kG+eaSp/SFn2xnDLmd1DBbv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175943; c=relaxed/simple;
	bh=5ZI0DD5IVI0CJdQHQql7c9mFg8yrzPVn7L+bSQg0Zco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JmWMCMtc5cflr+e1sOH1iH4aiRtubrXncnAyC0psQDPEw6/ZHzSVC48vMqmLfO8gI5QT9/ZpyqpAN+rfPCc8kNgbZNRuK7Rq/PjQwCVRn0P4ufQPCGzzD1kr5uMTUVi3jd02crnPaS7C0y3D3zv3tgeLXaUxyVc5uk7Ts1JMgMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0NJiiL56; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0NJiiL56"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE4D2C4CEE3;
	Tue, 17 Jun 2025 15:59:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175943;
	bh=5ZI0DD5IVI0CJdQHQql7c9mFg8yrzPVn7L+bSQg0Zco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0NJiiL5660vcbvCAl3rUX3F71W/GIYIt0JODeHNAQXcUHXxYKfFpGuyY1a1EjYZlT
	 4h6766vUW5OvYnjT/JBZLaHo2nNT4yNeLEURLsAYkvCKqjqMau9qOTuChZonaNbqE1
	 Zq+eQIEf3mYwk4VzEmAcquaG/Ls9rcp+kRa1jDr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ridong <chenridong@huawei.com>,
	=?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>,
	Tejun Heo <tj@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 181/512] kernfs: Relax constraint in draining guard
Date: Tue, 17 Jun 2025 17:22:27 +0200
Message-ID: <20250617152426.985671634@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Koutný <mkoutny@suse.com>

[ Upstream commit 071d8e4c2a3b0999a9b822e2eb8854784a350f8a ]

The active reference lifecycle provides the break/unbreak mechanism but
the active reference is not truly active after unbreak -- callers don't
use it afterwards but it's important for proper pairing of kn->active
counting. Assuming this mechanism is in place, the WARN check in
kernfs_should_drain_open_files() is too sensitive -- it may transiently
catch those (rightful) callers between
kernfs_unbreak_active_protection() and kernfs_put_active() as found out by Chen
Ridong:

	kernfs_remove_by_name_ns	kernfs_get_active // active=1
	__kernfs_remove					  // active=0x80000002
	kernfs_drain			...
	wait_event
	//waiting (active == 0x80000001)
					kernfs_break_active_protection
					// active = 0x80000001
	// continue
					kernfs_unbreak_active_protection
					// active = 0x80000002
	...
	kernfs_should_drain_open_files
	// warning occurs
					kernfs_put_active

To avoid the false positives (mind panic_on_warn) remove the check altogether.
(This is meant as quick fix, I think active reference break/unbreak may be
simplified with larger rework.)

Fixes: bdb2fd7fc56e1 ("kernfs: Skip kernfs_drain_open_files() more aggressively")
Link: https://lore.kernel.org/r/kmmrseckjctb4gxcx2rdminrjnq2b4ipf7562nvfd432ld5v5m@2byj5eedkb2o/

Cc: Chen Ridong <chenridong@huawei.com>
Signed-off-by: Michal Koutný <mkoutny@suse.com>
Acked-by: Tejun Heo <tj@kernel.org>
Link: https://lore.kernel.org/r/20250505121201.879823-1-mkoutny@suse.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/kernfs/dir.c  | 5 +++--
 fs/kernfs/file.c | 3 ++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 458519e416fe7..5dc90a498e75d 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -1560,8 +1560,9 @@ void kernfs_break_active_protection(struct kernfs_node *kn)
  * invoked before finishing the kernfs operation.  Note that while this
  * function restores the active reference, it doesn't and can't actually
  * restore the active protection - @kn may already or be in the process of
- * being removed.  Once kernfs_break_active_protection() is invoked, that
- * protection is irreversibly gone for the kernfs operation instance.
+ * being drained and removed.  Once kernfs_break_active_protection() is
+ * invoked, that protection is irreversibly gone for the kernfs operation
+ * instance.
  *
  * While this function may be called at any point after
  * kernfs_break_active_protection() is invoked, its most useful location
diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
index 8502ef68459b9..1943c8bd479bf 100644
--- a/fs/kernfs/file.c
+++ b/fs/kernfs/file.c
@@ -778,8 +778,9 @@ bool kernfs_should_drain_open_files(struct kernfs_node *kn)
 	/*
 	 * @kn being deactivated guarantees that @kn->attr.open can't change
 	 * beneath us making the lockless test below safe.
+	 * Callers post kernfs_unbreak_active_protection may be counted in
+	 * kn->active by now, do not WARN_ON because of them.
 	 */
-	WARN_ON_ONCE(atomic_read(&kn->active) != KN_DEACTIVATED_BIAS);
 
 	rcu_read_lock();
 	on = rcu_dereference(kn->attr.open);
-- 
2.39.5



