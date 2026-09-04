Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B5E4378838;
	Fri,  4 Sep 2026 06:06:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502006; cv=none; b=qHVhYrjNOLToQ72lXG6dYuKqtIcwQqdvklTEaxpUfF1OxSp5pG2Y6gb+4teIx4IOZtH2JYT0HMqSltl5BNTzFXDiq7GEHGVQXBODrWjdEasdaKzlRW5Gqbq3yRHVIvDW+Rz7qTYPQKZ8BLRq/2hH8SIvRQACBhsJGouA0NhDego=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502006; c=relaxed/simple;
	bh=6iaRMazscpkg/9ZwtaZnwMR8Np+gWejpm7aApaBNL9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S4p7PPBXw0wBkG26PGHTalnBU5KToSuS8sEyPg8m7105pIz84rW+T1fTR0gAEpN76mznqNs+cGWVzYtwIHUTLHo5q9xlHcWE2l81pEnFOpUJP1OJ8e5M1aoKrQMtH3S6nekSDa+gOMJAPpBfA6ReEDMawETyXPi+iBlGGlTIP9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pc1A6mkn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pc1A6mkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4A7C1F00A3D;
	Fri,  4 Sep 2026 06:06:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502005;
	bh=NOnEpmeS2+/sP703PR8pYOejIXO5GNDc+rBkfnwRp/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pc1A6mknM1UX7w05ylT0nvQSSGbdEryWKJzvrlsur09eXu1IuFhGFzKyojvTj+EGu
	 +CPTTr8smFGwY8rwQnDhQnHgzCxpodr9nLVOzqeqm8uwPusnBql79bMh2Ys5fFAB/q
	 wKdj14D9t1cBE+KmOxOLL3xQNpKjDTgzH0nSH2AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Neill Kapron <nkapron@google.com>
Subject: [PATCH 6.12 057/403] usb: gadget: f_fs: Prevent deadlock during ep0 read loop
Date: Fri,  4 Sep 2026 06:57:40 +0200
Message-ID: <20260904045736.127647183@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -551,6 +551,7 @@ static ssize_t ffs_ep0_read(struct file
 	if (ffs_setup_state_clear_cancelled(ffs) == FFS_SETUP_CANCELLED)
 		return -EIDRM;
 
+retry:
 	/* Acquire mutex */
 	ret = ffs_mutex_lock(&ffs->mutex, file->f_flags & O_NONBLOCK);
 	if (ret < 0)
@@ -585,10 +586,15 @@ static ssize_t ffs_ep0_read(struct file
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


