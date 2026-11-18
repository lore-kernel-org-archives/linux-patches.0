Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795042869;
	b=clKY2rO4tSF/MsQz9eJR/6IWgJqeu5tkG2HEY3UZ1cdb7q3Y2xwy/BKRg8AvH3lDfCrY
	 gyLnhYgCi/Xr0GCKK+p2oD7hy77dwKGylKvWfQXOA5Q44YYqYRmdLUkOGILnbpRPiFUzu
	 IHGvp2MaWBKjyGKyqQ3OR7qaiFMgB6t2AgmA+OIISByZfGF9ibFhC/v9QRyUbjL5dSAkz
	 Py1UsQxo1X+iuFOpFe4/X/eiKqC2T7nwA9T7qNkoppRFSd3uuf9dKDNs2U0LjJe6nD3hP
	 PZnBdjiAjlD14unCNEL5nyfAt0sV+2VjuLxS64yvCcKKErQlCBLvzbrJcrKnIfLzNzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795042869;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m9AoDkMZ6RJOO+y5FCnR2/oT4N1j2cn2fCXalgxbZw8=;
	b=Hj5YMzIoxlwusr1tz8YKj3UgXwC4D8W4Mx/Bw/EYRNq4I3RyaEQu6M2stk0UQEGV7i8A
	 OOCyakRvpo9zw7lEYz9LcB3XYQLLukyc1kqR9bdvwm9AQ7t58WmYlZ9Z0pRbXRhIMQG5E
	 pMx21tjqSkUiAIipZKBrgwiRAFnghz3R99oa+EBDLBYRTmDIFoSStJU7s+/VJXpbDroCV
	 s7IMf+pKYPckh1PoosyqFD+OA6Mx0tl+HH+JKHAB7FqYivrVunzPB8SeW3tBu7Ep7wO1j
	 QJdgmcJAthj36MHz36IqBvHk/ZZJ1TxI5hhptq7hRtlLumoGReFrKChEsLuD1QR8vTg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSs9I6wc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5875E606A330;
	Wed, 18 Nov 2026 23:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TSs9I6wc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84DA31F000CE;
	Wed, 18 Nov 2026 23:01:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795042869;
	bh=m9AoDkMZ6RJOO+y5FCnR2/oT4N1j2cn2fCXalgxbZw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TSs9I6wcJiy0YT/ML5491fB1/F4FZ/TC3nSYkVB0eFf6GjDXWYlPPxlIvHXkR2kA7
	 5OGkWvJkuU815bLy0fsI9O3Z0RJSSbUrUe5FNzT5AKe5hi7ytkZ76QhzcsPQ8XdcHO
	 l/4jbX8vx0TCRaT3Vt951uUzMeZvd3SRafS1Viwg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nickolai Zeldovich <nickolai@csail.mit.edu>,
	"Christian Brauner (Amutable)" <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 3293/3318] fs_pin: do not trust the pin after a spurious wakeup in pin_kill()
Date: Wed, 18 Nov 2026 16:05:15 +0100
Message-ID: <20261118150458.385957540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



