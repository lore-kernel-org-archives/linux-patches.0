Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A40A836167B;
	Sat, 12 Sep 2026 17:01:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789232497; cv=none; b=jkRTE5dyU6engP6BKQOAbdsxQysdoQIqI8n3DSGVJkO2WyiM3AA7zRrpGuYDCDQ0Bp8npIwdy0CWG0m5WOrU+2vhXVLDbu3f/wDoNwlS16JfqaT4SuxbgRk03eInyYR+trvHmyQYZIYixzr6yDRT/j+m84752po9xg41lvCUX2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789232497; c=relaxed/simple;
	bh=cdMn1y647X25mvLaBcv9jEMFnnS10TW7mFNipEUwZ8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XTpyvgEPU2Xglr9CKaOXPTUff6Ac0F9mlk8xpb3XgJMx+Kb5ovNbHUrVfJYvUSWqG/VNF7RK/OLsOtxrWh/yKsfX+zldG85gqJ9d63HEllQC3AA0M4qq4rXeqwKENJP0Iw4RpLJxnSVz+2BLCdbe6R12Kx9lKMmjw2sKu4NizMg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JoxaXHex; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JoxaXHex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44D3C1F000FF;
	Sat, 12 Sep 2026 17:01:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789232496;
	bh=LqK6rJSuJRLfOkKpM4T8GZpX7cd+a+uQassc6vXnWuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JoxaXHexw0GR1duT39VD+CAsU9+4YGtgKZZ7Su3QrLQMLt8idLquVEuolvINV7piF
	 CtgmqoAueiEF0CFyLCi88ERbkVcNBQrpndyx9MARhcnwVN55fWMaFcU5WtT9fRSCpn
	 LPHluYk41BrHklSmRTJTD3ZPYF35RDfKsy9QJZDo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neill Kapron <nkapron@google.com>
Subject: [PATCH 5.15 022/935] usb: gadget: f_fs: Prevent deadlock during ep0 read loop
Date: Sat, 12 Sep 2026 08:50:52 +0200
Message-ID: <20260912065527.348124660@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Neill Kapron <nkapron@google.com>

commit 569dd7e5dcffe1e1c6b26ca2cd3be57eb433e082 upstream.

Currently, ffs_ep0_read() holds ffs->mutex when it prepares to go to
sleep waiting for an event. When no setup events are pending, it calls
wait_event_interruptible_exclusive_locked_irq() with the mutex still
held. The wait macro deliberately drops the waitqueue spinlock before
sleeping but does not drop the mutex.

If a userspace daemon is polling ep0 via read() and the gadget is
asynchronously torn down via configfs (e.g., echo "" > UDC), a
deadlock can occur:

1. The configfs teardown calls functionfs_unbind(), which queues a
   FUNCTIONFS_UNBIND event.
2. The daemon wakes up, consumes the event, and drops the mutex.
3. However, if the daemon loops and immediately issues another read()
   before exiting, it reacquires ffs->mutex and again goes into an
   interruptible sleep.
4. Meanwhile, functionfs_unbind() continues execution and attempts to
   acquire ffs->mutex to tear down ep0req.
5. The kernel deadlocks because the configfs thread is stuck in an
   uninterruptible sleep waiting for the mutex, while the userspace
   daemon is in an interruptible sleep holding the mutex forever
   because no more events will arrive.

To fix this, we drop both the waitqueue spinlock and ffs->mutex before
going to sleep, and use wait_event_interruptible_exclusive() instead.
Upon waking up, we jump back to the `retry` label to safely reacquire
the mutex and re-evaluate the state machine. By not sleeping with
ffs->mutex held, we natively decouple gadget teardowns (which require
the mutex) from userspace polling.

Fixes: ddf8abd25994 ("USB: f_fs: the FunctionFS driver")
Cc: stable@vger.kernel.org
Assisted-by: Antigravity:gemini-3.1-pro
Signed-off-by: Neill Kapron <nkapron@google.com>
Link: https://patch.msgid.link/20260724204117.4036015-1-nkapron@google.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/function/f_fs.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/usb/gadget/function/f_fs.c
+++ b/drivers/usb/gadget/function/f_fs.c
@@ -519,6 +519,7 @@ static ssize_t ffs_ep0_read(struct file
 	if (ffs_setup_state_clear_cancelled(ffs) == FFS_SETUP_CANCELLED)
 		return -EIDRM;
 
+retry:
 	/* Acquire mutex */
 	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
 	if (ret < 0)
@@ -553,10 +554,15 @@ static ssize_t ffs_ep0_read(struct file
 			break;
 		}
 
-		if (wait_event_interruptible_exclusive_locked_irq(ffs->ev.waitq,
-							ffs->ev.count)) {
-			ret = -EINTR;
-			break;
+		if (!ffs->ev.count) {
+			spin_unlock_irq(&ffs->ev.waitq.lock);
+			mutex_unlock(&ffs->mutex);
+
+			if (wait_event_interruptible_exclusive(ffs->ev.waitq,
+							       ffs->ev.count))
+				return -EINTR;
+
+			goto retry;
 		}
 
 		/* unlocks spinlock */


