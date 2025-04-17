Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5464B26137F;
	Thu, 17 Apr 2025 18:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914685; cv=none; b=pvTerJ+dF4BmkrZVBR763Ary75cPtg8biMD47Ff/D0THsm3wEfSdIduElHOONjMxvdiRL1/xtCOttnnLddKx4MrIYqtY5xAZFoee6NWjaEsmJMWvd2nBNj6gKzLPg6MzHxeNdejkHDYkHIt56QLL+PHlGwLefN6hjhyN6Ny4eyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914685; c=relaxed/simple;
	bh=6P4Bdm95peDnwc8aleYAuj58SDkD8sjyE0wdR40zL6Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCON2m4Kv1GAgyzJMpWj+uDo1+9elaIvzVEaDriu8ujgC/GLCdImnj8MRLB6BLPOBaujLvCr1bk0CHCfV1HLXwyvxV0V3trrfAYVD6f21sXEhpx4mStrmB60kCrYAH+gfKM5wb+J1Rpv+rsRL379v8cB9cgx6MzxPRg+V35Y30E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ItIE9rfP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ItIE9rfP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D2D16C4CEE7;
	Thu, 17 Apr 2025 18:31:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914685;
	bh=6P4Bdm95peDnwc8aleYAuj58SDkD8sjyE0wdR40zL6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ItIE9rfPhTmYXNCi71QJEPNdC8A4zXuajCgHd3KT96BoY3TdC1B4DVqjIIKXOPfkz
	 hz3XP6YSoy/HEtZTWbsG0qyFxgY8GquspavYKlr3UHKTPt0X7kSU/TFXMAG2B1mB30
	 ZMQHL3t3sVwwKEBn4fpxs6ND45XNTVepFQeLmHow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6.13 297/414] locking/lockdep: Decrease nr_unused_locks if lock unused in zap_class()
Date: Thu, 17 Apr 2025 19:50:55 +0200
Message-ID: <20250417175123.374637040@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Boqun Feng <boqun.feng@gmail.com>

commit 495f53d5cca0f939eaed9dca90b67e7e6fb0e30c upstream.

Currently, when a lock class is allocated, nr_unused_locks will be
increased by 1, until it gets used: nr_unused_locks will be decreased by
1 in mark_lock(). However, one scenario is missed: a lock class may be
zapped without even being used once. This could result into a situation
that nr_unused_locks != 0 but no unused lock class is active in the
system, and when `cat /proc/lockdep_stats`, a WARN_ON() will
be triggered in a CONFIG_DEBUG_LOCKDEP=y kernel:

  [...] DEBUG_LOCKS_WARN_ON(debug_atomic_read(nr_unused_locks) != nr_unused)
  [...] WARNING: CPU: 41 PID: 1121 at kernel/locking/lockdep_proc.c:283 lockdep_stats_show+0xba9/0xbd0

And as a result, lockdep will be disabled after this.

Therefore, nr_unused_locks needs to be accounted correctly at
zap_class() time.

Signed-off-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20250326180831.510348-1-boqun.feng@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/locking/lockdep.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -6247,6 +6247,9 @@ static void zap_class(struct pending_fre
 		hlist_del_rcu(&class->hash_entry);
 		WRITE_ONCE(class->key, NULL);
 		WRITE_ONCE(class->name, NULL);
+		/* Class allocated but not used, -1 in nr_unused_locks */
+		if (class->usage_mask == 0)
+			debug_atomic_dec(nr_unused_locks);
 		nr_lock_classes--;
 		__clear_bit(class - lock_classes, lock_classes_in_use);
 		if (class - lock_classes == max_lock_class_idx)


