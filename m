Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB27F32F770;
	Sat, 30 May 2026 18:36:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166183; cv=none; b=gcombI6cDBRqmatUDuwep4K4dEoF7ZpJCjHcOr//h5t8tPjWIyuk/8payUFHvihdqqPAUKGHbSs1PKXXjnBQKz4EUk956sozb8R2tje8j4pqDqXfWGQ4lHQBSyVj/Ck5pdJKjX+SEGB9pZ6YgLc7bFeZw3QROo9IFbE5wakWUMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166183; c=relaxed/simple;
	bh=0e/54nhLfQrUsCUPEug3RozNbLHHG0o5bmA073OjIE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uKdhWLOL9xHVihKYc8S3Mz8kSSFooK9GSzZ4cR0kJr0zrOc9cSrWVLmXVcXuabUyu7tyF3uYSkgzMk0it2tg8BkZ2UuqySHn4K7L9eD2Oc2YnAtq2mbZ6NbD1E4NZ6HfZeaSw8ay0VxI02TEwbQFnh7XsVQ6CDHP7aweiu4OM5c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opwZgvcm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opwZgvcm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E89CD1F00893;
	Sat, 30 May 2026 18:36:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166182;
	bh=QjBRePMqksVOW2eXBc664vvqNrTbp2tCN87a6nJmY7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opwZgvcmozwwSlarQfP3JD/hPOh8TFZqwqvZfQI87n7yLC8DrvO1nSFAD9et++pkv
	 vPpkpW3c3PPRks/XqClTyePfm4uRigzox0u0lBAIrKGayiFU5BsSALHZ+iTNwdtpxw
	 OepgghKJtlmOQvv36dY3txEF9qTWFfjldH7IPQUw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 298/589] locking: Fix rwlock support in <linux/spinlock_up.h>
Date: Sat, 30 May 2026 18:02:59 +0200
Message-ID: <20260530160232.799987636@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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
index 0ac9112c1bbe3..a406655c1fbd1 100644
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
@@ -69,4 +59,14 @@ static inline void arch_spin_unlock(arch_spinlock_t *lock)
 
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



