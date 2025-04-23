Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0BD40285417;
	Wed, 23 Apr 2025 15:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421260; cv=none; b=b+mHKeIlf1Ceu3UnBQaaAAj3Ynjt4YK1zujd7Ip2yjCfWu5tJwh6zLWtjjJZga9nWu5Jq78uhl7F6LH3tmQIqR5E3q9a0BuoVJ6gMkZJSH0z0/Ia9BM34l66iO/E9pH8FLZZWE+u2g6l9Q8S3Jy8l6yY0tn8lH7EO+cbNtMNRis=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421260; c=relaxed/simple;
	bh=+jHBv/EYgoKRjimDo6bW9302MSPrTJc391DAbVhOViU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CqNj+EqFy3EAyftH2e/QuNxlZU03A38WQ3mK5KUEm8AwTQout/HFgR5mx4x82EspLaJAc23kVpj0950maBvyD0WOd1a2ssAru0RrkX+CSQgtZYppFk2T9mAtUbZUSxuyEA/Yz5jcQJCVtAnOx6y2txjZcN4xN1tJQ9BK9yb0Ty0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zt1ZvpKV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zt1ZvpKV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0CAB7C4CEE2;
	Wed, 23 Apr 2025 15:14:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421259;
	bh=+jHBv/EYgoKRjimDo6bW9302MSPrTJc391DAbVhOViU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zt1ZvpKVGjBYWFaauFMgKyAlR+iBWOlvw0t6b8HrXTm9cWdPx+1WvOGVrFB5hoeqb
	 zjQCwHii0M0F3QXn+GrHRKcUc3KmCd1llkKzUBt411ur7rorPnJuoIPD8h4Wh1V+qp
	 h0cRoFjAURnnansREKp3LigxxXTS+4RhRablLwT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6.1 121/291] locking/lockdep: Decrease nr_unused_locks if lock unused in zap_class()
Date: Wed, 23 Apr 2025 16:41:50 +0200
Message-ID: <20250423142629.345889492@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6021,6 +6021,9 @@ static void zap_class(struct pending_fre
 		hlist_del_rcu(&class->hash_entry);
 		WRITE_ONCE(class->key, NULL);
 		WRITE_ONCE(class->name, NULL);
+		/* Class allocated but not used, -1 in nr_unused_locks */
+		if (class->usage_mask == 0)
+			debug_atomic_dec(nr_unused_locks);
 		nr_lock_classes--;
 		__clear_bit(class - lock_classes, lock_classes_in_use);
 		if (class - lock_classes == max_lock_class_idx)


