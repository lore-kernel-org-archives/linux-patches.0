Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C8A077636;
	Tue, 23 Jan 2024 02:05:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705975519; cv=none; b=mHg6CEueZnIGbVxhOG5Y8C6zAp0f/cR2wzRqnvfn25hOwaZcOv5Y7P/vID1BSH+vLzevAOGFFQHwkccWXKcxRMogBEebLFSJ/DKP97A+7QrKTJO1dSIWA3+bOLYQa43BJE2dw/qj+w+1tPufhbu+cyDTRWU7VfOq6Yu2WvVOYzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705975519; c=relaxed/simple;
	bh=bVs6zFNNFdx23bi7LawmFzDlMC81TXfQg81xkW4xP9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p9bGJKNPr8D8/dfRFs8DJx8L98x7OCkGUDFQY32WMuGeeT7F7pIPylzET91hUYXyVLQ3bYz7zz4RDNOsLmUrybidGm2tvmc96fdLd7QgjOx/sVRhebl6Tk7cPFp1ic0LdAOMh2FYKuZ8eyNpySZfpmymCEG3KlrLaFUjxcWk6n4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z5WTEpaD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z5WTEpaD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3CCEC433A6;
	Tue, 23 Jan 2024 02:05:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705975518;
	bh=bVs6zFNNFdx23bi7LawmFzDlMC81TXfQg81xkW4xP9A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z5WTEpaDz+PjV3QQUhhr8mfrGXug8dXvbQATir9uN/ZMY+KAcv8CeIlELZ4yKwvUy
	 3VUx+DQPuatckMgVJXw1kexzZY5WQND7gnqLyESaWLh4OlNkNMq7SNzr+Y7kcwpk36
	 nsfKGw7XMcmoiZ6E+L2CZS81M9JffxX+mkrTb4IU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.iitr10@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 445/583] srcu: Use try-lock lockdep annotation for NMI-safe access.
Date: Mon, 22 Jan 2024 15:58:16 -0800
Message-ID: <20240122235825.592044639@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235812.238724226@linuxfoundation.org>
References: <20240122235812.238724226@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

[ Upstream commit 3c6b0c1c28184038d90dffe8eb542bedcb8ccf98 ]

It is claimed that srcu_read_lock_nmisafe() NMI-safe. However it
triggers a lockdep if used from NMI because lockdep expects a deadlock
since nothing disables NMIs while the lock is acquired.

This is because commit f0f44752f5f61 ("rcu: Annotate SRCU's update-side
lockdep dependencies") annotates synchronize_srcu() as a write lock
usage. This helps to detect a deadlocks such as
	srcu_read_lock();
	synchronize_srcu();
	srcu_read_unlock();

The side effect is that the lock srcu_struct now has a USED usage in normal
contexts, so it conflicts with a USED_READ usage in NMI. But this shouldn't
cause a real deadlock because the write lock usage from synchronize_srcu()
is a fake one and only used for read/write deadlock detection.

Use a try-lock annotation for srcu_read_lock_nmisafe() to avoid lockdep
complains if used from NMI.

Fixes: f0f44752f5f6 ("rcu: Annotate SRCU's update-side lockdep dependencies")
Link: https://lore.kernel.org/r/20230927160231.XRCDDSK4@linutronix.de
Reviewed-by: Boqun Feng <boqun.feng@gmail.com>
Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Signed-off-by: Paul E. McKenney <paulmck@kernel.org>
Signed-off-by: Neeraj Upadhyay (AMD) <neeraj.iitr10@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/rcupdate.h | 6 ++++++
 include/linux/srcu.h     | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/rcupdate.h b/include/linux/rcupdate.h
index 5e5f920ade90..44aab5c0bd2c 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -303,6 +303,11 @@ static inline void rcu_lock_acquire(struct lockdep_map *map)
 	lock_acquire(map, 0, 0, 2, 0, NULL, _THIS_IP_);
 }
 
+static inline void rcu_try_lock_acquire(struct lockdep_map *map)
+{
+	lock_acquire(map, 0, 1, 2, 0, NULL, _THIS_IP_);
+}
+
 static inline void rcu_lock_release(struct lockdep_map *map)
 {
 	lock_release(map, _THIS_IP_);
@@ -317,6 +322,7 @@ int rcu_read_lock_any_held(void);
 #else /* #ifdef CONFIG_DEBUG_LOCK_ALLOC */
 
 # define rcu_lock_acquire(a)		do { } while (0)
+# define rcu_try_lock_acquire(a)	do { } while (0)
 # define rcu_lock_release(a)		do { } while (0)
 
 static inline int rcu_read_lock_held(void)
diff --git a/include/linux/srcu.h b/include/linux/srcu.h
index 127ef3b2e607..236610e4a8fa 100644
--- a/include/linux/srcu.h
+++ b/include/linux/srcu.h
@@ -229,7 +229,7 @@ static inline int srcu_read_lock_nmisafe(struct srcu_struct *ssp) __acquires(ssp
 
 	srcu_check_nmi_safety(ssp, true);
 	retval = __srcu_read_lock_nmisafe(ssp);
-	rcu_lock_acquire(&ssp->dep_map);
+	rcu_try_lock_acquire(&ssp->dep_map);
 	return retval;
 }
 
-- 
2.43.0



