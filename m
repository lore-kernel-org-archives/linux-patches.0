Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F0A25525C;
	Thu, 17 Apr 2025 18:51:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915905; cv=none; b=MNDyJPjERtDeJC+LAfSGR+WbaMbs+eq19vRikcOYsnJPuiSA3BdftQO2daAwBrkREaSETL5Hb7G9gN3BCijaioeDynKumdlACnR8asflF7hoeEqW8YmrB/IFq66ROSDThY6QmZd89o3cuEv//M+Baj2qIn7v8gBneAWvt7BRJ34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915905; c=relaxed/simple;
	bh=ItF+ole/2C2yIz546BP5na7eBWvQf83YE8ij0FlUIbI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPosBF5fCEvp1dyao6DQKUSIZO1ZvpSq5GUZ+hTMaqw9ZyOBCuNJDsIfoQSuzJe2UF1VHB7sgOQmkip8VzV7iWbgqZK/QRdY/ccWbvu59ywbRwkcp3wKaPlzL/N3j74Dyyb0kDNgH14bOg87KDs5cZ9AdOssonxF8OJTMQ/SiVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dTnzhQdF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dTnzhQdF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB7FC4CEE4;
	Thu, 17 Apr 2025 18:51:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915904;
	bh=ItF+ole/2C2yIz546BP5na7eBWvQf83YE8ij0FlUIbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dTnzhQdF8ml81LhlSmMoPjOouYNZoTiC18RvOAxzqGUbFB7NyFGYjbXaHcuvAjOmv
	 P63IUnAA8QqDVYb0wbnKbPlBUdn5DESoRt0Ed30SWb5pmO3aX6J7AvF/Ipl5a87ZXj
	 wmZKkMJkV+sW+uy+nVtsMKDw0NUFHZH5FVR/tIVI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Ingo Molnar <mingo@kernel.org>,
	Waiman Long <longman@redhat.com>
Subject: [PATCH 6.12 278/393] locking/lockdep: Decrease nr_unused_locks if lock unused in zap_class()
Date: Thu, 17 Apr 2025 19:51:27 +0200
Message-ID: <20250417175118.792098689@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6223,6 +6223,9 @@ static void zap_class(struct pending_fre
 		hlist_del_rcu(&class->hash_entry);
 		WRITE_ONCE(class->key, NULL);
 		WRITE_ONCE(class->name, NULL);
+		/* Class allocated but not used, -1 in nr_unused_locks */
+		if (class->usage_mask == 0)
+			debug_atomic_dec(nr_unused_locks);
 		nr_lock_classes--;
 		__clear_bit(class - lock_classes, lock_classes_in_use);
 		if (class - lock_classes == max_lock_class_idx)


