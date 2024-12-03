Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00CFE1F75BB;
	Tue,  3 Dec 2024 15:38:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240310; cv=none; b=utHMxXMhKWoP5v77po+BT4y3xtfJtijGpEUmHHwO7DcoUY3+hSaRODAlbcrLdDlPfZQeS5xoc0X/IktVtvRpzqY1I7QIE+hUhyTosyjsjKmNTpzBwB8g2Gx6pINiqUAEV4HHktc8DRQT2cfrtdosQNfDiIOMU7qyDuSR2OmDp0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240310; c=relaxed/simple;
	bh=s1YNYW/fLp+knmiI8YEkokoc4ovIRFXtzneL9n86CBk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAm6J/tR6awIZRjBVcavjgeb6eQX0z0uaF2KEALpd0StXygfmeh0nMmH6dbxCLgzlZyvF7yv2oNH+TAmg8W+ftc1nQ5ASXD5uDlJtZaAEwBkJDDkEa42NIrQMIxh7F+X97QpwcpG5jt75zKkH12YJlAO+cIrteBiCRFU4KGfpM4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OZLh4HCa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OZLh4HCa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C20DC4CECF;
	Tue,  3 Dec 2024 15:38:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240309;
	bh=s1YNYW/fLp+knmiI8YEkokoc4ovIRFXtzneL9n86CBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OZLh4HCawyVbWO64eA4hA5agAN95BGlt3wLZQVa7QAv28xEJpEmkbXH2DbX1j+/cv
	 skauKf8yopa3gnAQgJZHGhjeIw6m3NfeQ5fHWHK0Ves0pPWQ++64DjaJ+v7KibJYaV
	 Y+nhxAtJ4qmv02TFRM6eRhYRZTJ586euN357rdEM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Eder Zulian <ezulian@redhat.com>,
	"Peter Zijlstra (Intel)" <peterz@infradead.org>,
	Boqun Feng <boqun.feng@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 095/826] rust: helpers: Avoid raw_spin_lock initialization for PREEMPT_RT
Date: Tue,  3 Dec 2024 15:37:02 +0100
Message-ID: <20241203144747.437570172@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eder Zulian <ezulian@redhat.com>

[ Upstream commit 5c2e7736e20d9b348a44cafbfa639fe2653fbc34 ]

When PREEMPT_RT=y, spin locks are mapped to rt_mutex types, so using
spinlock_check() + __raw_spin_lock_init() to initialize spin locks is
incorrect, and would cause build errors.

Introduce __spin_lock_init() to initialize a spin lock with lockdep
rquired information for PREEMPT_RT builds, and use it in the Rust
helper.

Fixes: d2d6422f8bd1 ("x86: Allow to enable PREEMPT_RT.")
Closes: https://lore.kernel.org/oe-kbuild-all/202409251238.vetlgXE9-lkp@intel.com/
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Eder Zulian <ezulian@redhat.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Tested-by: Boqun Feng <boqun.feng@gmail.com>
Link: https://lore.kernel.org/r/20241107163223.2092690-2-ezulian@redhat.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/spinlock_rt.h | 15 +++++++--------
 rust/helpers/spinlock.c     |  8 ++++++--
 2 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/include/linux/spinlock_rt.h b/include/linux/spinlock_rt.h
index babc3e0287791..6175cd682ca0d 100644
--- a/include/linux/spinlock_rt.h
+++ b/include/linux/spinlock_rt.h
@@ -16,22 +16,21 @@ static inline void __rt_spin_lock_init(spinlock_t *lock, const char *name,
 }
 #endif
 
-#define spin_lock_init(slock)					\
+#define __spin_lock_init(slock, name, key, percpu)		\
 do {								\
-	static struct lock_class_key __key;			\
-								\
 	rt_mutex_base_init(&(slock)->lock);			\
-	__rt_spin_lock_init(slock, #slock, &__key, false);	\
+	__rt_spin_lock_init(slock, name, key, percpu);		\
 } while (0)
 
-#define local_spin_lock_init(slock)				\
+#define _spin_lock_init(slock, percpu)				\
 do {								\
 	static struct lock_class_key __key;			\
-								\
-	rt_mutex_base_init(&(slock)->lock);			\
-	__rt_spin_lock_init(slock, #slock, &__key, true);	\
+	__spin_lock_init(slock, #slock, &__key, percpu);	\
 } while (0)
 
+#define spin_lock_init(slock)		_spin_lock_init(slock, false)
+#define local_spin_lock_init(slock)	_spin_lock_init(slock, true)
+
 extern void rt_spin_lock(spinlock_t *lock) __acquires(lock);
 extern void rt_spin_lock_nested(spinlock_t *lock, int subclass)	__acquires(lock);
 extern void rt_spin_lock_nest_lock(spinlock_t *lock, struct lockdep_map *nest_lock) __acquires(lock);
diff --git a/rust/helpers/spinlock.c b/rust/helpers/spinlock.c
index acc1376b833c7..92f7fc4184253 100644
--- a/rust/helpers/spinlock.c
+++ b/rust/helpers/spinlock.c
@@ -7,10 +7,14 @@ void rust_helper___spin_lock_init(spinlock_t *lock, const char *name,
 				  struct lock_class_key *key)
 {
 #ifdef CONFIG_DEBUG_SPINLOCK
+# if defined(CONFIG_PREEMPT_RT)
+	__spin_lock_init(lock, name, key, false);
+# else /*!CONFIG_PREEMPT_RT */
 	__raw_spin_lock_init(spinlock_check(lock), name, key, LD_WAIT_CONFIG);
-#else
+# endif /* CONFIG_PREEMPT_RT */
+#else /* !CONFIG_DEBUG_SPINLOCK */
 	spin_lock_init(lock);
-#endif
+#endif /* CONFIG_DEBUG_SPINLOCK */
 }
 
 void rust_helper_spin_lock(spinlock_t *lock)
-- 
2.43.0



