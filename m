Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DACCF3750C9;
	Sat, 12 Sep 2026 16:27:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230426; cv=none; b=YtybznRQD0KP6G67CTBg6kngD/mo/nB3S6v4yMGEOut3Od1P9AZV/p5dM8yQOOXlCjMuNCFVLlT2zmgvX2TNkVHggr55PcZdMty7asjk9Vd9WnZwAcNt6+DFeCsipsxrHSwuzUZmI1wY+i5VzP6BWXfoMc4LBBxrKDqFmMg7Zz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230426; c=relaxed/simple;
	bh=vCszGvx91ejGtnIGHr4BLPSXv8NSZSwTaYlvmhWKUIk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FYH6i1Ea6qXn2xlSC2JOsGJQ4C5X80OZtGFLHMV1aQRGBAPukQCtPltFLBjjUccGeVEnRgHOTQj8lx2dehh0Zy0pdy4CAOPgmHYwSZMsoTvAnw19lI5X9Rha5e4svejJ0VLOKVwNoMa1kR3ECTJexguDETeMH5PqJXiHobtRyYg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uDvdQFnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uDvdQFnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0FFA1F000FF;
	Sat, 12 Sep 2026 16:27:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230424;
	bh=49QnoERp1M1E88OnjMHL/AG1pY2nzkhuUzS8o55ZMk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uDvdQFnnm+OM1/IszXrz0cXnDGo7BE32jLUkojB0srhvCAk1y4/yStQAtbfKOVJPq
	 zj06j9h5Ix+X9hJfoKrKhM411w9+Nx2LHiOTE69mll7nAGYbwHAB9RhMizTb8huykd
	 nVJSxseBlkgLEf+6kxdTuNl7WEjOoKxax3cwi070=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0792/1191] locking/lockdep: Fix NULL pointer dereference in __lock_set_class()
Date: Sat, 12 Sep 2026 08:58:40 +0200
Message-ID: <20260912065606.062720893@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 463834778b4b0..a807773c84c3e 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5253,6 +5253,8 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 			      lock->wait_type_outer,
 			      lock->lock_type);
 	class = register_lock_class(lock, subclass, 0);
+	if (!class)
+		return 0;
 	hlock->class_idx = class - lock_classes;
 
 	curr->lockdep_depth = i;
-- 
2.53.0



