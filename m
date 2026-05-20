Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DEEC340A57;
	Wed, 20 May 2026 18:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300133; cv=none; b=T/wR66/fGmB1bTKPMsZRYKYQfU3NJoif3vMVya1/nT2H/tFyEXAEk0E10PTSEvnEv1I9+tIgHPJOIO0n+k4e/blfnTo5FzOumwe3iEviPKcp+TVfdY1WwmwcxtVqicn/Wceidf6rRV7BVFLNiM5ngDCMca1Lg5Vx0NKCYK9vo8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300133; c=relaxed/simple;
	bh=iu3jBR5gpuarm5VDPybVfUsehpc7wgWcpVj2cHnPqiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nQoOBhcIX31K00QH69ZKC9i/Aex/q2/mbpoZaTe3evu9c8XxL9PhZVrrB8y8IHhqWHCKW2jKZFlQ4oYISW9uwQFzS8QpMtHrdEFbIXpvskiMnHJmII2cYULh0Lf7f6OlVxna+c4/HASpI92AJ4BtnpEBch85o4s9VnDa69pgp1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oLesDluB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oLesDluB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C01BB1F000E9;
	Wed, 20 May 2026 18:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300132;
	bh=3MRalDC0MgJ7pXsdrBwaQZ9M6anFYxFLhj2blt5P2kM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oLesDluBxU+t+IEo+WuHMhoMWwCNT5WNXjP3b4I5YlKVhgDGgagm227NNMZA8VL1f
	 riYbpOono3gN0rApydA+D2MnKosGIBAP8BrEtkP7aIsW61yWXmslYYiRBZXfekhSqL
	 R7y0q6r81FZrDhDNLxdYroB+3tozRUbxbmx/kkvw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bart Van Assche <bvanassche@acm.org>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 032/666] locking: Fix rwlock support in <linux/spinlock_up.h>
Date: Wed, 20 May 2026 18:14:03 +0200
Message-ID: <20260520162111.930433043@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index c87204247592f..a132fc562297a 100644
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



