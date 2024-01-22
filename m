Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8372648CCD;
	Tue, 23 Jan 2024 00:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705969859; cv=none; b=NoAZm5CkezIC9S3/WGOTeuVLpooLUx/rFPnkcX5O0Adr5B1hOfowuMUXi5//yuqXQv2ptQBbLnQiYj9wX7ADFjFlD5duGSIyRdJVToFLjWepLJqTc4bKsPb1kZ7cxX9zEL/0+NYpe8P48qL0wfSCqByjUjELwqwcuvayG6bzJyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705969859; c=relaxed/simple;
	bh=MlQsXGJzNiSfhQDSceC9dHDeEXezFYRXoGSnyqYm7OQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TczoF+WUWXfqBQWb4UYo/bQ5mhX1DGEOiXvjqfNliIah6nIk0UlY8cBjtUDckxAvaV3Cyx8ZRyYdB2HuP2N0Qh/f3CkuWeKVViS+fY227KSSWvyePJvUnLiUB5diwvcNFOg/GnOT5pLfoN3EGUrSfpfOu9s5/DyfYSr37OSRDSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fbbL9mba; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fbbL9mba"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2F0F1C43390;
	Tue, 23 Jan 2024 00:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705969859;
	bh=MlQsXGJzNiSfhQDSceC9dHDeEXezFYRXoGSnyqYm7OQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fbbL9mbac/H8yqtqksfkmjtB6UTOs+7Nz5/cgjQwGXXO5PysHGStsIVeOXh9siyCZ
	 dhsYCpo3uYrBtNTn4fkTvIGfVWegxAj22NquL0KhjekWfO+trN29NQ8fP7tMxoLgNe
	 cZoUKmQdxHvWl/knp5mLWKQ7TDkk7jZWppZpjqJI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Boqun Feng <boqun.feng@gmail.com>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	"Paul E. McKenney" <paulmck@kernel.org>,
	"Neeraj Upadhyay (AMD)" <neeraj.iitr10@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 490/641] srcu: Use try-lock lockdep annotation for NMI-safe access.
Date: Mon, 22 Jan 2024 15:56:34 -0800
Message-ID: <20240122235833.405376758@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235818.091081209@linuxfoundation.org>
References: <20240122235818.091081209@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index f7206b2623c9..31d523c4e089 100644
--- a/include/linux/rcupdate.h
+++ b/include/linux/rcupdate.h
@@ -301,6 +301,11 @@ static inline void rcu_lock_acquire(struct lockdep_map *map)
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
@@ -315,6 +320,7 @@ int rcu_read_lock_any_held(void);
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



