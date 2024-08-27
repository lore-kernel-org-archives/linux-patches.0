Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F1041C6F65;
	Tue, 27 Aug 2024 15:17:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724771854; cv=none; b=LUf9+4M3QgQ1Y1Rz8WxGbXHBM4y4zdsMRD5KdlY4MK7gfvfIwjLXv1qHm+52NdcPrrmI8uIEIMaVGNDvYgBSuxRuWVkf7xhZ8iAULli6gMIQJnK6zOZNQqOzC1GFtQSGgEbi73SN/aLyz+31Zg0O/Z29aqzDBLoBy5kbmVnmrW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724771854; c=relaxed/simple;
	bh=A1UGIdtskHirueZ2AkZUieyBWTPngsvdlvxaOrNwCrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s3rSZ5xM5+zbHI2sFPiObmrTrsjHn4NSvnDFexnMv68HE6NIZb6pZgLpz037MCZBmcKDJ1d5+4EiAw5SD6BScMuYwiwjji9VHzrFnW+p4Im10VYGpOMDrBo/kW8cKgnR4aBQ/H4gYXVNFoe3y9/SyUEU5msSCJMKWlXXyFpp2zA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bdfm+abX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bdfm+abX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C319C61040;
	Tue, 27 Aug 2024 15:17:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724771854;
	bh=A1UGIdtskHirueZ2AkZUieyBWTPngsvdlvxaOrNwCrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bdfm+abXMqW4DsXVdr4tJnV0xQO3jW4DIIbQb+yvGXaod8ZuHMdKmXV/2VeoKsl40
	 nQLZKVLQyqV9YxuATTkEwhwNopfcr1EGhkb/yrtynWzQyfkfZJuoHD+wXy1Lzmu/hv
	 wrSO10oAplkcxwqgvoncgUxotA+FkNyfqGBiLvXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christian Brauner <brauner@kernel.org>,
	Jan Kara <jack@suse.cz>,
	Jeff Xu <jeffxu@google.com>,
	Andreas Gruenbacher <agruenba@redhat.com>,
	Daniel Verkamp <dverkamp@chromium.org>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Frederic Weisbecker <frederic@kernel.org>,
	syzbot+ac3b41786a2d0565b6d5@syzkaller.appspotmail.com,
	Kees Cook <keescook@chromium.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 041/321] pid: Replace struct pid 1-element array with flex-array
Date: Tue, 27 Aug 2024 16:35:49 +0200
Message-ID: <20240827143839.790192652@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143838.192435816@linuxfoundation.org>
References: <20240827143838.192435816@linuxfoundation.org>
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

From: Kees Cook <keescook@chromium.org>

[ Upstream commit b69f0aeb068980af983d399deafc7477cec8bc04 ]

For pid namespaces, struct pid uses a dynamically sized array member,
"numbers".  This was implemented using the ancient 1-element fake
flexible array, which has been deprecated for decades.

Replace it with a C99 flexible array, refactor the array size
calculations to use struct_size(), and address elements via indexes.
Note that the static initializer (which defines a single element) works
as-is, and requires no special handling.

Without this, CONFIG_UBSAN_BOUNDS (and potentially
CONFIG_FORTIFY_SOURCE) will trigger bounds checks:

  https://lore.kernel.org/lkml/20230517-bushaltestelle-super-e223978c1ba6@brauner

Cc: Christian Brauner <brauner@kernel.org>
Cc: Jan Kara <jack@suse.cz>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Andreas Gruenbacher <agruenba@redhat.com>
Cc: Daniel Verkamp <dverkamp@chromium.org>
Cc: "Paul E. McKenney" <paulmck@kernel.org>
Cc: Jeff Xu <jeffxu@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: Boqun Feng <boqun.feng@gmail.com>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Frederic Weisbecker <frederic@kernel.org>
Reported-by: syzbot+ac3b41786a2d0565b6d5@syzkaller.appspotmail.com
[brauner: dropped unrelated changes and remove 0 with NULL cast]
Signed-off-by: Kees Cook <keescook@chromium.org>
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/pid.h    | 2 +-
 kernel/pid.c           | 7 +++++--
 kernel/pid_namespace.c | 2 +-
 3 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/include/linux/pid.h b/include/linux/pid.h
index 343abf22092e6..bf3af54de6165 100644
--- a/include/linux/pid.h
+++ b/include/linux/pid.h
@@ -67,7 +67,7 @@ struct pid
 	/* wait queue for pidfd notifications */
 	wait_queue_head_t wait_pidfd;
 	struct rcu_head rcu;
-	struct upid numbers[1];
+	struct upid numbers[];
 };
 
 extern struct pid init_struct_pid;
diff --git a/kernel/pid.c b/kernel/pid.c
index 3fbc5e46b7217..74834c04a0818 100644
--- a/kernel/pid.c
+++ b/kernel/pid.c
@@ -661,8 +661,11 @@ void __init pid_idr_init(void)
 
 	idr_init(&init_pid_ns.idr);
 
-	init_pid_ns.pid_cachep = KMEM_CACHE(pid,
-			SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT);
+	init_pid_ns.pid_cachep = kmem_cache_create("pid",
+			struct_size((struct pid *)NULL, numbers, 1),
+			__alignof__(struct pid),
+			SLAB_HWCACHE_ALIGN | SLAB_PANIC | SLAB_ACCOUNT,
+			NULL);
 }
 
 static struct file *__pidfd_fget(struct task_struct *task, int fd)
diff --git a/kernel/pid_namespace.c b/kernel/pid_namespace.c
index 1daadbefcee3a..a575fabf697eb 100644
--- a/kernel/pid_namespace.c
+++ b/kernel/pid_namespace.c
@@ -47,7 +47,7 @@ static struct kmem_cache *create_pid_cachep(unsigned int level)
 		return kc;
 
 	snprintf(name, sizeof(name), "pid_%u", level + 1);
-	len = sizeof(struct pid) + level * sizeof(struct upid);
+	len = struct_size((struct pid *)NULL, numbers, level + 1);
 	mutex_lock(&pid_caches_mutex);
 	/* Name collision forces to do allocation under mutex. */
 	if (!*pkc)
-- 
2.43.0



