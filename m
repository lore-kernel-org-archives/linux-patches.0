Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEB18369211;
	Wed, 20 May 2026 16:28:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294489; cv=none; b=aJ//3XsQvJ5z8k6O4ioZTqf7elGUESijUPcdS/akdfei90Z0Esg9vz5AKKGBR8vsTqDX8zZcj1Zc+eeSBeMXiHOBFnNfhAVxFm+AsZqwQ5QpJs8o/noYUAqo7gbyqvLYnz+4Vhexm5oWSPbhygUMA57cwgW0ItQFYIjk3e9KdPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294489; c=relaxed/simple;
	bh=1UNRkjpj8lbFr9Jgr8tfIh/nKV8z2b0zXMRYG2h9gb0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gyXRnEpXsDJW3tO0NGOieyALBDQMH5zm9wtBSSZq/Jz95sS22E7HPHeCVrWft7umHg6823UqOtGAyxA0Qr79VDKn0hFCzFzgVYtpo8vkPhVdjYvY8k9j54ve4Julg7ivL/3HtQOLARM9syybFw5iBmLvFRZUr4CJzwlR6Pk6n6g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IdCkSB6v; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IdCkSB6v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 099191F000E9;
	Wed, 20 May 2026 16:28:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294487;
	bh=/WyQzxgkQVgX9+ZCkHH/jWBeAguvRJT7ltNJ3biSAZg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IdCkSB6vJyOgK5/lV8DiySsWpTX+Lphio0zAcldzKgqpz6UTB9x3gOV3RB7zd+dBB
	 3lpIld9BispcCYcCbeIlOBiMREn0ZCc5pLEwo0CYTw1EKxstl5C3vcZF3+NWBzPaHY
	 gix1qMZgv3f5Mma28oxHY9+uhk78Mjc4GsSM5fbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0058/1146] locking: Fix rwlock support in <linux/spinlock_up.h>
Date: Wed, 20 May 2026 18:05:08 +0200
Message-ID: <20260520162149.685680167@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 756a0e011cfca0b45a48464aa25b05d9a9c2fb0b ]

Architecture support for rwlocks must be available whether or not
CONFIG_DEBUG_SPINLOCK has been defined. Move the definitions of the
arch_{read,write}_{lock,trylock,unlock}() macros such that these become
visbile if CONFIG_DEBUG_SPINLOCK=n.

This patch prepares for converting do_raw_{read,write}_trylock() into
inline functions. Without this patch that conversion triggers a build
failure for UP architectures, e.g. arm-ep93xx. I used the following
kernel configuration to build the kernel for that architecture:

	CONFIG_ARCH_MULTIPLATFORM=y
	CONFIG_ARCH_MULTI_V7=n
	CONFIG_ATAGS=y
	CONFIG_MMU=y
	CONFIG_ARCH_MULTI_V4T=y
	CONFIG_CPU_LITTLE_ENDIAN=y
	CONFIG_ARCH_EP93XX=y

Fixes: fb1c8f93d869 ("[PATCH] spinlock consolidation")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Link: https://patch.msgid.link/20260313171510.230998-2-bvanassche@acm.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/spinlock_up.h | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/include/linux/spinlock_up.h b/include/linux/spinlock_up.h
index 1e84e71ca495e..3a50976471d71 100644
--- a/include/linux/spinlock_up.h
+++ b/include/linux/spinlock_up.h
@@ -48,16 +48,6 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
 	lock->slock = 1;
 }
 
-/*
- * Read-write spinlocks. No debug version.
- */
-#define arch_read_lock(lock)		do { barrier(); (void)(lock); } while (0)
-#define arch_write_lock(lock)		do { barrier(); (void)(lock); } while (0)
-#define arch_read_trylock(lock)	({ barrier(); (void)(lock); 1; })
-#define arch_write_trylock(lock)	({ barrier(); (void)(lock); 1; })
-#define arch_read_unlock(lock)		do { barrier(); (void)(lock); } while (0)
-#define arch_write_unlock(lock)	do { barrier(); (void)(lock); } while (0)
-
 #else /* DEBUG_SPINLOCK */
 #define arch_spin_is_locked(lock)	((void)(lock), 0)
 /* for sched/core.c and kernel_lock.c: */
@@ -68,4 +58,14 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
 
 #define arch_spin_is_contended(lock)	(((void)(lock), 0))
 
+/*
+ * Read-write spinlocks. No debug version.
+ */
+#define arch_read_lock(lock)		do { barrier(); (void)(lock); } while (0)
+#define arch_write_lock(lock)		do { barrier(); (void)(lock); } while (0)
+#define arch_read_trylock(lock)	({ barrier(); (void)(lock); 1; })
+#define arch_write_trylock(lock)	({ barrier(); (void)(lock); 1; })
+#define arch_read_unlock(lock)		do { barrier(); (void)(lock); } while (0)
+#define arch_write_unlock(lock)	do { barrier(); (void)(lock); } while (0)
+
 #endif /* __LINUX_SPINLOCK_UP_H */
-- 
2.53.0



