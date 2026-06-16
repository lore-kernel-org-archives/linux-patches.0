Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C503CEBBD;
	Tue, 16 Jun 2026 18:59:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636341; cv=none; b=ErQMckNih4uqeWj4BJaKzE5yNqlZC9822T1iI4FswuhRrqtkpVA3QmfTsnERWd7wwZCBs9c8gw3BTeQyiBvuPRT7aJjdP7Bg0JekR0SzVzZLeNVn9tO+QG9u1VMw/0MJJmGBWyGDk+HrBjqGO0KdhKjXvcLsHG14oH4bi0bSSCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636341; c=relaxed/simple;
	bh=R/YZi5BD7pb6aKkzpzRQzW54VQvMVnSXP6jKN1r/J20=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UC+kFzpDWoqEAtTWL1CRGNCKUUUIgZAivR6c693n8vjmTvi/2chlF/86j3cVuUv+2qNGtGU31pE6a0JkczEigKVM59EcONxzUnLihIgM43Wumg1gFb3eusdh9MbPB5lowk5/7sDCDXC3ywg0TU/87X3J/r2TGP4q5yWx2ZSsXfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hfeUk6hy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hfeUk6hy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1F401F000E9;
	Tue, 16 Jun 2026 18:58:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636340;
	bh=UrD+hxBd1XRMO8s4TSkaNMv+edQGG7P4Oo7W6RrjXc4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hfeUk6hySmV2vDBlOdYdBsi0t3eNPvtHKdjjMpCHksMFgUuH2v9CIpcob6PPir9iT
	 K/suc7LGaIg75yjixHGd1FDZTzYS5EkoVJxmgmKct/y5DAIECn2bJwoONP5RsXSlzi
	 m4iK4S+pl3P9rjtL5oOTyb2YWkyzhyFb2btaV9j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Mingyu Wang <25181214217@stu.xidian.edu.cn>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>
Subject: [PATCH 5.10 213/342] fs/fcntl: fix SOFTIRQ-unsafe lock order in fasync signaling
Date: Tue, 16 Jun 2026 20:28:29 +0530
Message-ID: <20260616145058.104592959@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

From: Mingyu Wang <25181214217@stu.xidian.edu.cn>

commit 00633c4683828acd5256fa8d5163f440d74bbe71 upstream.

A SOFTIRQ-safe to SOFTIRQ-unsafe lock order deadlock can occur in
send_sigio() and send_sigurg() when a process group receives a signal.

When FASYNC is configured for a process group (PIDTYPE_PGID), both
functions use read_lock(&tasklist_lock) to traverse the task list.
However, they are frequently called from softirq context:
- send_sigio() via input_inject_event -> kill_fasync
- send_sigurg() via tcp_check_urg -> sk_send_sigurg (NET_RX_SOFTIRQ)

The deadlock is caused by the rwlock writer fairness mechanism:
1. CPU 0 (process context) holds read_lock(&tasklist_lock) in do_wait().
2. CPU 1 (process context) attempts write_lock(&tasklist_lock) in
   fork() or exit() and spins, which blocks all new readers.
3. CPU 0 is interrupted by a softirq (e.g., TCP URG packet reception).
4. The softirq calls send_sigurg() and attempts to acquire
   read_lock(&tasklist_lock), deadlocking because CPU 1 is waiting.

Since PID hashing and do_each_pid_task() traversals are already
RCU-protected, the read_lock on tasklist_lock is no longer strictly
required for safe traversal. Fix this by replacing tasklist_lock with
rcu_read_lock(), aligning the process group signaling path with the
single-PID path. This also mitigates a potential remote denial of
service vector via TCP URG packets.

Lockdep splat:
=====================================================
WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
[...]
Chain exists of:
  &dev->event_lock --> &f_owner->lock --> tasklist_lock

Possible interrupt unsafe locking scenario:
       CPU0                    CPU1
       ----                    ----
  lock(tasklist_lock);
                           local_irq_disable();
                           lock(&dev->event_lock);
                           lock(&f_owner->lock);
  <Interrupt>
    lock(&dev->event_lock);

*** DEADLOCK ***

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Mingyu Wang <25181214217@stu.xidian.edu.cn>
Link: https://patch.msgid.link/20260523135210.590928-1-w15303746062@163.com
Signed-off-by: Christian Brauner (Amutable) <brauner@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fcntl.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/fs/fcntl.c
+++ b/fs/fcntl.c
@@ -800,11 +800,11 @@ void send_sigio(struct fown_struct *fown
 			send_sigio_to_task(p, fown, fd, band, type);
 		rcu_read_unlock();
 	} else {
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		do_each_pid_task(pid, type, p) {
 			send_sigio_to_task(p, fown, fd, band, type);
 		} while_each_pid_task(pid, type, p);
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 	}
  out_unlock_fown:
 	read_unlock_irqrestore(&fown->lock, flags);
@@ -841,11 +841,11 @@ int send_sigurg(struct fown_struct *fown
 			send_sigurg_to_task(p, fown, type);
 		rcu_read_unlock();
 	} else {
-		read_lock(&tasklist_lock);
+		rcu_read_lock();
 		do_each_pid_task(pid, type, p) {
 			send_sigurg_to_task(p, fown, type);
 		} while_each_pid_task(pid, type, p);
-		read_unlock(&tasklist_lock);
+		rcu_read_unlock();
 	}
  out_unlock_fown:
 	read_unlock_irqrestore(&fown->lock, flags);


