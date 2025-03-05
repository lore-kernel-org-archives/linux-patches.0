Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8150E2512D6;
	Wed,  5 Mar 2025 18:19:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741198743; cv=none; b=Sv1JRd6v2L5lY1l0V2iHCU81XV+JIH8tOkVpp1HZidhMBW099Cqvjd76bhoR+rvUdtnL6qJ5o0zIXQzSDRUXnBgqaxKhIBZiIxoNin0S0KzxcrGNOetjOthNlXITPl4xHkIOv16SabSncHleBcVfMLXPZu+7dLRZLUJsjBMLils=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741198743; c=relaxed/simple;
	bh=sZpMhMmyqDBAN35nJE3ZTOnGhAloXKvD+YLjB/k1elQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owBpn/oYdBBvuFyyEYyCt3i/pFNrGY7ok8uHfGlUqxn5DcMRL5iV0EBKTGcQ0Np37gpJFU1ZGAo3jmI2Mor8iW27ZN8oOEzWPuI9vOgRdZHyLF9LyXc26jKUWq/wI7j67aRLR7XMu6wp6tFnISR8HJBdEglKrpzUzUQ5z1dhXWw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxHsRa2m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxHsRa2m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97A1FC4CED1;
	Wed,  5 Mar 2025 18:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741198743;
	bh=sZpMhMmyqDBAN35nJE3ZTOnGhAloXKvD+YLjB/k1elQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KxHsRa2mXl2jYlXij4cIU2Cvc12mjHBWKzLFlub9ROwsoZAYfXUJ4nrziYFbFulTw
	 tC6kk6shoZeScIHEy+GD5j8C2r/QD+CV2Okgono+bfPYy8qFygtIIXxFK9i+Dt8OxR
	 JWsHofw9OOVUVZA8xD2zT82aaN8tdoA6L973MaI4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <oliver.sang@intel.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [PATCH 6.13 133/157] rcuref: Plug slowpath race in rcuref_put()
Date: Wed,  5 Mar 2025 18:49:29 +0100
Message-ID: <20250305174510.648364273@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250305174505.268725418@linuxfoundation.org>
References: <20250305174505.268725418@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Gleixner <tglx@linutronix.de>

commit b9a49520679e98700d3d89689cc91c08a1c88c1d upstream.

Kernel test robot reported an "imbalanced put" in the rcuref_put() slow
path, which turned out to be a false positive. Consider the following race:

            ref  = 0 (via rcuref_init(ref, 1))
 T1                                      T2
 rcuref_put(ref)
 -> atomic_add_negative_release(-1, ref)                                         # ref -> 0xffffffff
 -> rcuref_put_slowpath(ref)
                                         rcuref_get(ref)
                                         -> atomic_add_negative_relaxed(1, &ref->refcnt)
                                           -> return true;                       # ref -> 0

                                         rcuref_put(ref)
                                         -> atomic_add_negative_release(-1, ref) # ref -> 0xffffffff
                                         -> rcuref_put_slowpath()

    -> cnt = atomic_read(&ref->refcnt);                                          # cnt -> 0xffffffff / RCUREF_NOREF
    -> atomic_try_cmpxchg_release(&ref->refcnt, &cnt, RCUREF_DEAD))              # ref -> 0xe0000000 / RCUREF_DEAD
       -> return true
                                           -> cnt = atomic_read(&ref->refcnt);   # cnt -> 0xe0000000 / RCUREF_DEAD
                                           -> if (cnt > RCUREF_RELEASED)         # 0xe0000000 > 0xc0000000
                                             -> WARN_ONCE(cnt >= RCUREF_RELEASED, "rcuref - imbalanced put()")

The problem is the additional read in the slow path (after it
decremented to RCUREF_NOREF) which can happen after the counter has been
marked RCUREF_DEAD.

Prevent this by reusing the return value of the decrement. Now every "final"
put uses RCUREF_NOREF in the slow path and attempts the final cmpxchg() to
RCUREF_DEAD.

[ bigeasy: Add changelog ]

Fixes: ee1ee6db07795 ("atomics: Provide rcuref - scalable reference counting")
Reported-by: kernel test robot <oliver.sang@intel.com>
Debugged-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Reviewed-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: stable@vger.kernel.org
Closes: https://lore.kernel.org/oe-lkp/202412311453.9d7636a2-lkp@intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/rcuref.h |    9 ++++++---
 lib/rcuref.c           |    5 ++---
 2 files changed, 8 insertions(+), 6 deletions(-)

--- a/include/linux/rcuref.h
+++ b/include/linux/rcuref.h
@@ -71,27 +71,30 @@ static inline __must_check bool rcuref_g
 	return rcuref_get_slowpath(ref);
 }
 
-extern __must_check bool rcuref_put_slowpath(rcuref_t *ref);
+extern __must_check bool rcuref_put_slowpath(rcuref_t *ref, unsigned int cnt);
 
 /*
  * Internal helper. Do not invoke directly.
  */
 static __always_inline __must_check bool __rcuref_put(rcuref_t *ref)
 {
+	int cnt;
+
 	RCU_LOCKDEP_WARN(!rcu_read_lock_held() && preemptible(),
 			 "suspicious rcuref_put_rcusafe() usage");
 	/*
 	 * Unconditionally decrease the reference count. The saturation and
 	 * dead zones provide enough tolerance for this.
 	 */
-	if (likely(!atomic_add_negative_release(-1, &ref->refcnt)))
+	cnt = atomic_sub_return_release(1, &ref->refcnt);
+	if (likely(cnt >= 0))
 		return false;
 
 	/*
 	 * Handle the last reference drop and cases inside the saturation
 	 * and dead zones.
 	 */
-	return rcuref_put_slowpath(ref);
+	return rcuref_put_slowpath(ref, cnt);
 }
 
 /**
--- a/lib/rcuref.c
+++ b/lib/rcuref.c
@@ -220,6 +220,7 @@ EXPORT_SYMBOL_GPL(rcuref_get_slowpath);
 /**
  * rcuref_put_slowpath - Slowpath of __rcuref_put()
  * @ref:	Pointer to the reference count
+ * @cnt:	The resulting value of the fastpath decrement
  *
  * Invoked when the reference count is outside of the valid zone.
  *
@@ -233,10 +234,8 @@ EXPORT_SYMBOL_GPL(rcuref_get_slowpath);
  *	with a concurrent get()/put() pair. Caller is not allowed to
  *	deconstruct the protected object.
  */
-bool rcuref_put_slowpath(rcuref_t *ref)
+bool rcuref_put_slowpath(rcuref_t *ref, unsigned int cnt)
 {
-	unsigned int cnt = atomic_read(&ref->refcnt);
-
 	/* Did this drop the last reference? */
 	if (likely(cnt == RCUREF_NOREF)) {
 		/*


