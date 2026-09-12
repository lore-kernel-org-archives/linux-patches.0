Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94A7737AA97;
	Sat, 12 Sep 2026 08:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789200720; cv=none; b=OEIjG7ThXqDk3gwJv8x5mbUrytxHxpJEfrQCMbuLW0V7q/iSXjMtMN4g15vT4odSPG5NGiSbY6nCJDeE12FGraECY5O6ZAiZ2oOTaM34JlNb5TAcZr/IKFo6RTIxQoaOhJv0Z5dwic4+bJ1DQAqAq9aAAbdkAncFpHsOiM27kgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789200720; c=relaxed/simple;
	bh=Wk3vV6y7wENdaSgdo0LLBcpnKmG2QlMDTj5RVVN1uGw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GagLdbM0LyWS+5JtG9PX6AMN4OBmjjz+ThO3XPhNSLEhMhuNb+rTMzAqkiim3HwQJOIbSPZ6wj95SGh04DuNfloHaLIbhjQC4sAQeAx334tJNC6sDdrsitEu3x6iS1bVwFVfOUq4vBkfuXWr2caL2+u1711j23XUxAsSbFEJE0s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hDpCDUkN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hDpCDUkN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4EB191F000FF;
	Sat, 12 Sep 2026 08:11:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789200719;
	bh=iorvhniXs+fPIgV30HchORzBiYq52q2saSMLdAoR0vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hDpCDUkNyNsDEH/pmfilZ/c+gk3pQ25RMRxuoGCMpEh6EZFIIhj3wCPkDvzyHes+L
	 XuZdtTpelO37Y6A9aNAeobcsE23g8UxVROhcmPUAZTUkG3OLFCp+CbQfpZ93t7HJh5
	 KlRsMtuduEsfBPxw1hk6ma3rB4sNFzEoCr3uC7iA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Naveen Kumar Chaudhary <naveen.osdev@gmail.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Waiman Long <longman@redhat.com>,
	Dmitry Ilvokhin <d@ilvokhin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 0848/1815] locking/lockdep: Fix NULL pointer dereference in __lock_set_class()
Date: Sat, 12 Sep 2026 08:43:18 +0200
Message-ID: <20260912065708.826791153@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 2d4c5bab5af88..e0de811148242 100644
--- a/kernel/locking/lockdep.c
+++ b/kernel/locking/lockdep.c
@@ -5437,6 +5437,8 @@ __lock_set_class(struct lockdep_map *lock, const char *name,
 			      lock->wait_type_outer,
 			      lock->lock_type);
 	class = register_lock_class(lock, subclass, 0);
+	if (!class)
+		return 0;
 	hlock->class_idx = class - lock_classes;
 
 	curr->lockdep_depth = i;
-- 
2.53.0



