Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795022364;
	b=4XUUc5eU/6nhc42oSkYa4ayxcqqu3oX7+v62cjv5snf025Ooma8MFqa87WAZEUWWbM2A
	 PRKoTILgbMRWLsAT4seCe2eoxWnn1y5+FQCoEfGJylCFPFPpWtKNv+2S3OHV6E3U/jywI
	 g9PX5cPtV178Llrp9fkRqZin6ykhAg3I5wxF1lfi0FdlBAt9QrFXwrXQDuZhYSqEfNhZw
	 fXDamo5ml6N1aUsZlsOuMe4rqcgojhKXCJhK8hgJS/yVjUHl3HBgEWxfXRYXZ3SiGqCSC
	 Yms0vm1dukS0nhHkdfMgtgEG5wYUh1WXedczsyTtAIHHq2A4LpsS1ag0BQrSeWzBQfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795022364;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iUzpPmSw6h9HvOJASlYv0/8OiidV7v7ToxdM0tI6JNA=;
	b=TlfqJQdAh+PlueDyKSrLeL69GsL7SKDcUVVGyi5gwY3v+KuWH1EHbGLRHNPh0J6/yF/m
	 LOZx5mJLjl6UmFyA2xYVWlH8I/Z8iufebDx2+ILCM/8ED2wxATis0NTonkr2qMD8J6/wI
	 snxYr/e4ThZdWIOGHx0yUbhrm5HC5/+QThGXQ6w2NB0OuWfJxyMC3EaS0V9QijiP55nGV
	 IwMfSB0AffM1OXD4O453hxR2wqSfJgAkC/5DnBfaWjsGIMuUR7zWcH2FI0paTVeSRm3wQ
	 hOjmmKykGlXiy5pTA0VYXTXJUeXZdeK5mB7uDQTNEElf1/lHiHe6n6tgGiMbZx7pMtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="AACeU/0U";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D2D8606A31C;
	Wed, 18 Nov 2026 17:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=AACeU/0U
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6305E1F000C5;
	Wed, 18 Nov 2026 17:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795022363;
	bh=iUzpPmSw6h9HvOJASlYv0/8OiidV7v7ToxdM0tI6JNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AACeU/0UNyGeVGDsE5wj9OyqBafyKJLPpEHD5lwSYJPLQK7QFEWWwiZCjXrBBPAF/
	 RwAHMA8lT0cYP1jksq1O5bmQo7F/GWvDMN11UMWfvCJqjTvUKmcJ4ruC9KjGJtcNJQ
	 KZIivpRB8EIEmT2UUb5ykaZD2jlU0uTCG8SrlKjU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2636/2651] fs_pin: do not trust the pin after a spurious wakeup in pin_kill()
Date: Wed, 18 Nov 2026 16:04:36 +0100
Message-ID: <20261118150419.040567312@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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



