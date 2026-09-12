Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C5703815F8;
	Sat, 12 Sep 2026 19:54:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789242863; cv=none; b=k2PQMYcaPj+f0rHC7Co+Jq7NWGIyvGrR5BixjlqPbJwetehVTHsQcMniAggeQPLBwOLY0Axm2w2hR65Bq8IvvStWa1+9KfjO3CNxrF73k4+WIVrCEGzGdpMCrbuzOokhJX9tQULzxNwElBB7H+P4f3u4vu9CP7zHXg7iNkRiUHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789242863; c=relaxed/simple;
	bh=oVd1bbUVTEaDUMYZ88GTLVAhpRB59uNRPUuF+wN1XTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CgDBaGdC4ZfDXvXEchBcTkghBcF/22EP/K64cUct52+zOUKLLEqvvoIam6YAPrjEEhpj31F2j06NADmm3b7M4Vfwh31J6TCpSwUymWqUaSlIORp8Fly6JB6JmkkhrYd53ewpkRmv/A4Wjwr2NckckJTod86kxuDFqHrHj5Kjs1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qu5HzMJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qu5HzMJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 650F01F000FF;
	Sat, 12 Sep 2026 19:54:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789242861;
	bh=UBVTZkJkgUjYrjCXOu5fvMu4UqxD145GigEYSZJFQIk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qu5HzMJlYv60anR6p1VdTUGDpXGFkeM4QM6zjyHXPYSH6chDuXxRSk/ETolhUfozt
	 WrBqQPv8HE+uqI6yCTpbxzaGZqj80xoSP2PChnZOWD//NAaoYyCq1KBLo5YqR1fc14
	 mHVNgHPGQCANEPrj7O+xPiQWMZ5v7bootO5RGiAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 552/798] locking/lockdep: Fix NULL pointer dereference in __lock_set_class()
Date: Sat, 12 Sep 2026 09:03:00 +0200
Message-ID: <20260912065529.781370024@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>

[ Upstream commit 7577e00b9ab506202b9f1a33de3cc8cc6413a4db ]

register_lock_class() can return NULL when the lock class pool is
exhausted, graph_lock() fails, or key validation fails. However,
__lock_set_class() uses the return value directly in pointer arithmetic
without a NULL check:

  class = register_lock_class(lock, subclass, 0);
  hlock->class_idx = class - lock_classes;

If class is NULL, this computes a wild offset that corrupts
hlock->class_idx. The subsequent reacquire_held_locks() call will
invoke hlock_class() with this corrupted index, leading to a NULL or
out-of-bounds pointer dereference.

Add the missing NULL check, consistent with how __lock_acquire() already
handles this case at the same call site.

Fixes: 64aa348edc61 ("lockdep: lock_set_subclass - reset a held lock's subclass")
Signed-off-by: Naveen Kumar Chaudhary <naveen.osdev@gmail.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Waiman Long <longman@redhat.com>
Reviewed-by: Dmitry Ilvokhin <d@ilvokhin.com>
Link: https://patch.msgid.link/h2kfw43n4527x6mgi2lwpz2rieqnfzgictpv4wr5nyfjkc47co@2r5vz4uz44db
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/locking/lockdep.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/locking/lockdep.c b/kernel/locking/lockdep.c
index 47d939a0373d5..dad39321e8123 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5145,6 +5145,8 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 			      lock->wait_type_outer,
 			      lock->lock_type);
 	class = register_lock_class(lock, subclass, 0);
+	if (!class)
+		return 0;
 	hlock->class_idx = class - lock_classes;
 
 	curr->lockdep_depth = i;
-- 
2.53.0



