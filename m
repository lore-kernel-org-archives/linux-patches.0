Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8483B38FB0;
	Tue, 29 Apr 2025 17:13:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946813; cv=none; b=cWsX7laRTSCWeMF3kkAJ27+ZWFAJs8ItQK8WlVW+X1ZlfQ2zPprVu3VRhXl9fo59sQ/qwcRk8OP9F2eSOdnR46KdMJIqYtbG03WVVjFB7VHGNjCDowiSxDtC53DUAF5/gPp+VAHiTtbMXNchb0RJsEKuoO6RP74+cg6Es1XVhhk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946813; c=relaxed/simple;
	bh=qerGBQMCrFr04Pt8LyljZ3JIVfsr4BQysnN15Lr4++E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CU8ZyKTN7pELkpRhO1qO2NQ3TW0arGaL2aPBwGWiazN2QAbBg23tgT7L54QN7KrEgqqsb34v2pkYt+fUHMIqRm9SwUwgwdbj/Kh0ABWWqnU+NNVWlEIeo92VA8lH8mgpQBCveFqVnQG9D7N+LrndvqEViMZ+RrwcuxFSYT/tEiM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JeAuVeJ8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JeAuVeJ8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3ABBC4CEE3;
	Tue, 29 Apr 2025 17:13:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946813;
	bh=qerGBQMCrFr04Pt8LyljZ3JIVfsr4BQysnN15Lr4++E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JeAuVeJ8iAvXeRA6tYLndMuANzzrfjNgUn3WoTlcep5FBmmlsz7SXzmWmEs6z7Kyr
	 3e7BZHM2ehTQQ/6Gjb8M37EzlNS+uH1bOwnr8WNsaISRd8lPH7kUnYL7h6wJA8yPzs
	 7nsOZKTPU39ZH65YzExDaqSI4AGwVhBpXMhPnE3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 5.10 078/286] locking/lockdep: Decrease nr_unused_locks if lock unused in zap_class()
Date: Tue, 29 Apr 2025 18:39:42 +0200
Message-ID: <20250429161111.058445111@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5921,6 +5921,9 @@ static void zap_class(struct pending_fre
 		hlist_del_rcu(&class->hash_entry);
 		WRITE_ONCE(class->key, NULL);
 		WRITE_ONCE(class->name, NULL);
+		/* Class allocated but not used, -1 in nr_unused_locks */
+		if (class->usage_mask == 0)
+			debug_atomic_dec(nr_unused_locks);
 		nr_lock_classes--;
 		__clear_bit(class - lock_classes, lock_classes_in_use);
 		if (class - lock_classes == max_lock_class_idx)


