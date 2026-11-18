Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795033284;
	b=TsOWeYalXuhrx3nmI78vFXukGkQTze7Htwolfxgk6shCl2jtTUmPnXQPgSExpz4ZcSfL
	 QvAxQAJyciRyYnocdhdm4rd6dB//yJOp4yZNHtVWBYeffKosUn18670CHNwllyAblfpKm
	 sSpoKBFwBw6kS6pAP3campGGEMMaYVEqkFwTW0sc/lLGnPHr+COobmcJ8rkjWXQvBxP/9
	 cUVoVpUmM3i3Y/qd+IWqcEaiiLmRsaP3agcVfXu31jQqoVMvdCNgQlYe+/xSeTqKDbmRY
	 IGtyvx2qLRYBxI3uDMZH1yB3tsBhxSynnWtmAFRsVPvItOmyi4f1RaFCOfxPsAW8GiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795033284;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nE9mjZvzPpfHxzPQVllTZ/s4uRUgKNO7KoZk35HreiE=;
	b=0JS1J0/1QYu3dJemDhBfoVEUWwS6HUAOYoOso3gTztSD2Hw6RCYnUrCVJ9CgQJl/7QtZ
	 SekMAw9efxjFNsk9rU3OBHk+v2sD/SOLxkCa9tUqg8+LHP03jLCeQKH74CKWiYYQg1xza
	 wGHXmtM/MahLonNc/DdPrCyv5ztx3BCpjAJclOGDPc4OMv5TAU7hoA23YQFtHyuHyFfap
	 zi18V7ixPVc1evMz3MskEhWcEJ3BlSKt9IOKMHwfZE+eSoR20K1JQkiwV0iy7Hhm7Gj0L
	 BmJgcfjYPICtJzuGsssO6Xxq/tgl5OIe+yge++nlZ/YUNyOP9kXKZAi+ZBRp/cRtMDw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rfBdujQc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CE7B606A31C;
	Wed, 18 Nov 2026 20:21:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=rfBdujQc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D29B11F000C4;
	Wed, 18 Nov 2026 20:21:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795033284;
	bh=nE9mjZvzPpfHxzPQVllTZ/s4uRUgKNO7KoZk35HreiE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rfBdujQc8m+jSYG24JboZVWaPtc1lfIQlG5AsHWMLlpKtktU5AvI0j6aE8XwAtqcA
	 SnjlUF78Is6LYmwzPcHSSwrSVNEMb4KTW06cgmEWcrrLoEuw2FaZNP16dwNa1Wun5Q
	 5xe92wS8CgI+9dhpIz7lZr5+IrtjIwlXjfH1W254=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1714/1756] fs_pin: do not trust the pin after a spurious wakeup in pin_kill()
Date: Wed, 18 Nov 2026 16:04:01 +0100
Message-ID: <20261118150117.846437038@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



