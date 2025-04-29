Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BA6821ABC1;
	Tue, 29 Apr 2025 17:46:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948807; cv=none; b=A0zJDBKMXN91YCDyal4rGiMz78N9HBgAePoJAgiK5NwQ4VaP3EO76eAyA5mapJEj0h1eDtPm/Q0PGlAbIYIaXHf5y7IO5xUhFFy0mxHjc9pXq5jUWWUPn+bbjTUjRuMVGJQag3Rh8FUyboQjUApf7ipaNi2xVqY2m79J3vv/k58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948807; c=relaxed/simple;
	bh=G098tH7J2Ed9UNpRZp1w7HZ2SuZR1KDzXliGxCCCi5E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fE+ns6pLf1fHcE4pp7w4AaHLMbgJuCTnI9HdMtoemp8ggB7oHsL+pMNZIMAatcDZOuXXWxOTTsm7vxZs1ZE9Oq7V/0bEmX+ULsr9N1yISXtlN6hitTPK0fAR/mr1if1LyzssRwWJk+crKxSZ5NuwVlRYpT8NzpC2Dt76EHnxPsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZR1zr4I4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZR1zr4I4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3C95C4CEE3;
	Tue, 29 Apr 2025 17:46:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948807;
	bh=G098tH7J2Ed9UNpRZp1w7HZ2SuZR1KDzXliGxCCCi5E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZR1zr4I45HDxIBUGIx/RHijl3S3Nzc/DhvsR9MRWLXdvLgyRaSk9C+u70ups2uDFB
	 6voWyYIML457lZsHwlLFvqNYnvK74uBrk0ankaCUFDRJBNDB0iQdTPnVEv471i+IWu
	 nq6zlW+rxt12eEQwCYUT9t9tp6CCxpFjnimMFUIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 5.15 092/373] locking/lockdep: Decrease nr_unused_locks if lock unused in zap_class()
Date: Tue, 29 Apr 2025 18:39:29 +0200
Message-ID: <20250429161126.945027696@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -5982,6 +5982,9 @@ static void zap_class(struct pending_fre
 		hlist_del_rcu(&class->hash_entry);
 		WRITE_ONCE(class->key, NULL);
 		WRITE_ONCE(class->name, NULL);
+		/* Class allocated but not used, -1 in nr_unused_locks */
+		if (class->usage_mask == 0)
+			debug_atomic_dec(nr_unused_locks);
 		nr_lock_classes--;
 		__clear_bit(class - lock_classes, lock_classes_in_use);
 		if (class - lock_classes == max_lock_class_idx)


