Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E49518801C;
	Tue, 30 Jul 2024 16:04:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722355465; cv=none; b=dgpzlXmpown/bE5Ha3YaJ5+0jhufQ+tGawQljwOge67gUtwH6YuPaGzHVZaJEzRdEZRDGj6/h/+h3oVB/HLmlFs2n+5GWmiqBbBaoKAXf0VX36pnMUlOdqd5Um7+qp41/KiWJP90OTw2Hcli1NRHWKzSeRpmeZo2K29crNP83ns=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722355465; c=relaxed/simple;
	bh=k5BOQjM9IJ+ljKQETDty/Ji3BtwTfGkVQHytqECe0Ls=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Tk2N2SyAsSEMG9qSfxg8z3JVXlJWAvB1JQbIobSntX29YtcA5qb3t1LaF93f2soUFBON5zenjDDa6Mt0tRwjupXEYpSuHfAJe42EGDzSq5fYGqlKfFiv0+FndickjDbL/f08P/o90mOSbEgZKW5AmCG/wOlu6Zu32zRIta4l+vM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zqlqd0jl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zqlqd0jl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD6D6C4AF0A;
	Tue, 30 Jul 2024 16:04:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722355465;
	bh=k5BOQjM9IJ+ljKQETDty/Ji3BtwTfGkVQHytqECe0Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zqlqd0jlPmb/CTxaJd6LH4QtzS8x7yQ9GTHLhbUUua46oyNLXoxO4FODt7tDORjN6
	 QGXPUGaoAW4Cb2nhY3revJUEqMUS2FAnFNJV+FVdsB9yWyJVBX5lJLwd6cLK4tfoEI
	 7H4eb+rQ5XwflOZlXqrK1TXzrIUbg1RKoYfIx788=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Uros Bizjak <ubizjak@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/440] jump_label: Use atomic_try_cmpxchg() in static_key_slow_inc_cpuslocked()
Date: Tue, 30 Jul 2024 17:45:30 +0200
Message-ID: <20240730151619.674992121@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151615.753688326@linuxfoundation.org>
References: <20240730151615.753688326@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Uros Bizjak <ubizjak@gmail.com>

[ Upstream commit d0c006402e7941558e5283ae434e2847c7999378 ]

Use atomic_try_cmpxchg() instead of atomic_cmpxchg (*ptr, old, new) ==
old in static_key_slow_inc_cpuslocked().  x86 CMPXCHG instruction
returns success in ZF flag, so this change saves a compare after
cmpxchg (and related move instruction in front of cmpxchg).

Also, atomic_try_cmpxchg() implicitly assigns old *ptr value to "old" when
cmpxchg fails, enabling further code simplifications.

No functional change intended.

Signed-off-by: Uros Bizjak <ubizjak@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://lkml.kernel.org/r/20221019140850.3395-1-ubizjak@gmail.com
Stable-dep-of: 83ab38ef0a0b ("jump_label: Fix concurrency issues in static_key_slow_dec()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/jump_label.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/kernel/jump_label.c b/kernel/jump_label.c
index 714ac4c3b556d..4d6c6f5f60db8 100644
--- a/kernel/jump_label.c
+++ b/kernel/jump_label.c
@@ -115,8 +115,6 @@ EXPORT_SYMBOL_GPL(static_key_count);
 
 void static_key_slow_inc_cpuslocked(struct static_key *key)
 {
-	int v, v1;
-
 	STATIC_KEY_CHECK_USE(key);
 	lockdep_assert_cpus_held();
 
@@ -132,11 +130,9 @@ void static_key_slow_inc_cpuslocked(struct static_key *key)
 	 * so it counts as "enabled" in jump_label_update().  Note that
 	 * atomic_inc_unless_negative() checks >= 0, so roll our own.
 	 */
-	for (v = atomic_read(&key->enabled); v > 0; v = v1) {
-		v1 = atomic_cmpxchg(&key->enabled, v, v + 1);
-		if (likely(v1 == v))
+	for (int v = atomic_read(&key->enabled); v > 0; )
+		if (likely(atomic_try_cmpxchg(&key->enabled, &v, v + 1)))
 			return;
-	}
 
 	jump_label_lock();
 	if (atomic_read(&key->enabled) == 0) {
-- 
2.43.0



