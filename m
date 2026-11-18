Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050789;
	b=t9aYpMbSK5pDsaeWm70m1OU+ZU+pYzJD6RV5q9MNLPRZIv7Nz4KTgdUsuN2Qi41TTYAf
	 6+suI1BASZrR8/A7Y1eYx3FAlcMt6VPI5PyfcFuBWY8nDq4EJlb/GN0YsJq347QoPx331
	 uLJ+ip4BaJuK/DNZ5hG6YFmUbcdnPvWK6VVuXDcvOGxQBwnLwqS0HxILi+C1ViV8fUBVD
	 n0ruLaxf1eluT4FguUT5XwsVHsr48c+D0CVBsPrIbs5U5k0+RNGnjNleSDC9/c8YnHrrl
	 aPmGI0Jvd2UHXzWNdIDhd9EXwWgnIxgXr3NjMZPH8pt1KwHgmv2H6Av6hJlRA71CNyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050789;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=J0Jf9BLugly002l4nsD4EtrukXP6VsCHYIlzsGcwoq4=;
	b=OpUs92e2YbBfiJqCotjXbl0DxXd2NGdQgh1P/NTkxlv7ng5UnAa+Sf06zwspAX1Syytd
	 yCjZn8jujnScYme2yVvT/u8HEu/bLGo1OG0MkfFIkePfOGP+vwO91Eh0ZeGu91BdeW7WS
	 o47qtP+eB3KkFhyuQUhWfqiTVCCbqvWmHDvW0wV5gJ3K97B8rLaIzULAAiyDj8QVB/EE+
	 QRLb7udN4BHrH4x/cAro4hbb0E5HjncWe/hxbPGMohgEbrVTIM/q5bEadMZec3ZGQGHh0
	 pTyeI85KRi26KgnJB3tuQ5eN7dpQY+rQwgf86c0JBjhqHzIGVJySA2B8S8WNrQU9/CQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VYMCKCQA;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EBAE606A31C;
	Thu, 19 Nov 2026 01:13:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=VYMCKCQA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88EC91F000C4;
	Thu, 19 Nov 2026 01:13:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050789;
	bh=J0Jf9BLugly002l4nsD4EtrukXP6VsCHYIlzsGcwoq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VYMCKCQACA4J8zXWpqx5NN88ZQjDJAuHTPYvQ8fOBgjYs3SfEuLnvda1WU4qaEJbj
	 CuK7uCu3nKv/pNyWgScBJ/9Lk0QpgKY3BhDRy5amDlE8SCjHNs2uTouNI6MmijHiM4
	 QFlEbNxdN0ZC+3RN5kbmv/d1cc2J1/XSrZKKzWAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2832/2857] fs_pin: do not trust the pin after a spurious wakeup in pin_kill()
Date: Wed, 18 Nov 2026 16:04:26 +0100
Message-ID: <20261118150343.547817203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nickolai Zeldovich <nickolai@csail.mit.edu>

[ Upstream commit f3a6dae67c9ca3d913cbb42fe324c9b47c8d9e53 ]

A task waiting in pin_kill() for another task's ->kill() can take
p->wait.lock after the pin has been freed, and can return with its
on-stack wait entry still on p->wait. With BSD process accounting this
is a use-after-free of the acct structure when umount() of the mount
holding the accounting file races with acct(2).

pin_kill() takes a still-queued entry as proof that pin_remove() has not
run, so p is alive. But autoremove_wake_function() dequeues only when
try_to_wake_up() succeeds: if the waiter was already woken spuriously,
pin_remove() leaves the entry queued, acct_pin_kill() frees the acct
with kfree_rcu(), and the grace period can end while the waiter sits
between schedule() and rcu_read_lock().

Dequeue the entry unconditionally in a private wake function;
pin_remove() is the only waker and sets p->done first.

Reproduced under QEMU with KASAN and test-only delays: a
slab-use-after-free in pin_kill() before the patch, no report after.

Fixes: 59eda0e07f43 ("new fs_pin killing logics")
Signed-off-by: Nickolai Zeldovich <nickolai@csail.mit.edu>
Link: https://patch.msgid.link/20261027015813.841821-1-nickolai@csail.mit.edu
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/fs_pin.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/fs_pin.c b/fs/fs_pin.c
index 1a508f2167e0a..a4e5a5a7aca8d 100644
--- a/fs/fs_pin.c
+++ b/fs/fs_pin.c
@@ -28,6 +28,19 @@ void pin_insert(struct fs_pin *pin, struct vfsmount *m)
 	spin_unlock(&pin_lock);
 }
 
+/*
+ * Unlike autoremove_wake_function(), dequeue even if the waiter was already
+ * running: pin_kill() trusts @p only while its entry is still queued.
+ */
+static int pin_kill_wake_function(struct wait_queue_entry *wait,
+				  unsigned int mode, int sync, void *key)
+{
+	int ret = default_wake_function(wait, mode, sync, key);
+
+	list_del_init_careful(&wait->entry);
+	return ret;
+}
+
 void pin_kill(struct fs_pin *p)
 {
 	wait_queue_entry_t wait;
@@ -36,7 +49,7 @@ void pin_kill(struct fs_pin *p)
 		rcu_read_unlock();
 		return;
 	}
-	init_wait(&wait);
+	init_wait_func(&wait, pin_kill_wake_function);
 	spin_lock_irq(&p->wait.lock);
 	if (likely(!p->done)) {
 		p->done = -1;
-- 
2.53.0



