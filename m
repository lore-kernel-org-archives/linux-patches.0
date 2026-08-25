Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 947C333A6F7;
	Tue, 25 Aug 2026 13:42:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787665375; cv=none; b=AiAINkMdAbCSHc5D4fdSz5isX0fI5L6kP4wAtVogGhRSnfkNd1oCwL0vF5Zwz67W6hECY/HIxUmzOGuyImot3Q53SzuaEUiSEjByBtYODPOKXnVUPKpz1IO2NbfbJugeePs9vZLCCUY/GieudCfQSJoSxI/hh6lj7EMtAkGFFSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787665375; c=relaxed/simple;
	bh=rHlm8y+dnTxfdi7pHLJ0Du7CE1ywXUqWRADxnB3dr3o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PiPVyRA6tqTLl//YajfYL7zZg2rHhdIBh8oYoqtmJhWbHqEJaHAEcKtEWe+ilOn+Hj27h08tUdNzM/UDLe0xk3VDyXgowpb2HOHUZs8o3+KKwHo5HbvwmzvJnxUC9hgtIuZKk76VQ715Z755UXcyHsoqHlM83FPyx24dmN4hWIs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t5uYq6zC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t5uYq6zC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DCBC71F000E9;
	Tue, 25 Aug 2026 13:42:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787665374;
	bh=widz+8+8P09NTBiuDrXZnkXfjJslI6DmPJ60uAmTK3c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t5uYq6zCbdssYDowDhb6D0kQDKxRa/B3R8MvK5OGlypihkUoCJ8FQlQ6lMPXDxZaq
	 EpZW7CC6uuwAkvSV45Lq5zMTUWD2uMTALRb5Z+59zRHmc9JfeNlmJLkjMLqBAHOzTi
	 M9uqsE6os2g/y4KYRRIO2/ouIaLpoinhv+Je+F5I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunwoo Kim <imv4bel@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Thomas Gleixner <tglx@kernel.org>
Subject: [PATCH 6.18 78/94] futex: Fix race on the initial mm->futex.phash.ref allocation
Date: Tue, 25 Aug 2026 15:26:14 +0200
Message-ID: <20260825132544.927386180@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.887883084@linuxfoundation.org>
References: <20260825132541.887883084@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunwoo Kim <imv4bel@gmail.com>

commit bde0238083647381d4747355c5a19115a3422b96 upstream.

futex_hash_allocate() allocates mm->futex.phash.ref without any locking.
Commit d9b05321e21e ("futex: Move futex_hash_free() back to __mmput()")
moved the allocation here and assumed that the process has just a single
thread at this point.

Commit ee9dce44362b ("futex: Drop CLONE_THREAD requirement for private
default hash alloc") widened need_futex_hash_allocate_default() to cover
any CLONE_VM clone, but left out vfork because the parent is suspended and
cannot race.

That no longer holds once vfork is nested. If a vfork child calls vfork
again and is then killed with SIGKILL, the parent is released from its
vfork wait and runs concurrently with the grandchild in the same mm.
Neither of them went through futex_hash_allocate_default().

When both call prctl(PR_FUTEX_HASH, PR_FUTEX_HASH_SET_SLOTS) at the same
time, each one sees mm->futex.phash.ref as NULL and stores its own percpu
counter. Only the last store survives. The counter stored first is no
longer reachable from the mm, so the references on it are not seen by
__futex_ref_atomic_end(). A private hash that still has references is then
considered dead and freed, and a task that still holds one of its buckets
writes into freed memory in futex_q_lock().

Store the counter once with cmpxchg() and let the loser free_percpu() its
own. The initial reference has to be taken before the store, otherwise
another task can install a private hash while the counter is still 0.

Fixes: d9b05321e21e ("futex: Move futex_hash_free() back to __mmput()")
Signed-off-by: Hyunwoo Kim <imv4bel@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/ansrpP4ImE1MaBY9@v4bel
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/futex/core.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
--- a/kernel/futex/core.c
+++ b/kernel/futex/core.c
@@ -1839,14 +1839,18 @@ static int futex_hash_allocate(unsigned
 	}
 
 	if (!mm->futex_ref) {
+		unsigned int __percpu *ref = alloc_percpu(unsigned int);
+
+		if (!ref)
+			return -ENOMEM;
+
 		/*
-		 * This will always be allocated by the first thread and
-		 * therefore requires no locking.
+		 * Tasks sharing the mm can run this concurrently, so take the
+		 * initial reference before publishing the counter.
 		 */
-		mm->futex_ref = alloc_percpu(unsigned int);
-		if (!mm->futex_ref)
-			return -ENOMEM;
-		this_cpu_inc(*mm->futex_ref); /* 0 -> 1 */
+		this_cpu_inc(*ref); /* 0 -> 1 */
+		if (cmpxchg(&mm->futex_ref, NULL, ref))
+			free_percpu(ref);
 	}
 
 	fph = kvzalloc(struct_size(fph, queues, hash_slots),


