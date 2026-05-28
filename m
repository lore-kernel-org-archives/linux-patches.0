Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A4A72F9D85;
	Thu, 28 May 2026 20:18:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999512; cv=none; b=ReOGhOmMIw4pQyWdRtm9wKi6IQWTV/sQoDv9DykM8vEhUbA+NUrPG7zH7O92ufSl6jSik0BffDdPqdzklt6kVVDC3UVCDYd6eFjl3wA8s7T9wKXIFRY10tTjofF2W9amyshOBK1wLI7gVxSuo+u+vqNiIwASOunwLIvI3hC1B/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999512; c=relaxed/simple;
	bh=5gidi08P8WYAinSR+e8rda7e80dcMEv/bWVtx2J/xg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iRYHhTK4y+RmyRcDQPNv1kZiq32/mxaDLg3LmIEz2wq4Mr3/BWybXEc9/UUdb/mZaN3EkU9Akg2dP8fxOFgX70dDx2trd66UyEf7QdBiYV3l4/tV+45DrxFNlOXDGFAe24C5c5WbuYsSqC43EHnec0u0dyMvaNiGTKN8/xgYPBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ns3OiHlk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ns3OiHlk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B728C1F000E9;
	Thu, 28 May 2026 20:18:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999511;
	bh=0ug17m3FCVthyTyyK1Ekyw2gX0PCNCtmWj9531cNki4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ns3OiHlkVwVzy7ybTltAGdAv6HrrrpNnJlo7h9IrEvQ836c8EpiAy4vKbDZF8zj0d
	 wBapaYNMZ6RZ/r+gE7EYUAgLdWOe05I2IzvQmRI9t5QEKsEL5x4YF/TeQ3oXbqO8US
	 feLAF3kkNUjXTRXe6bZpc8938DyMuvsaX6iZ7ugY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Subject: [PATCH 6.18 093/377] rbd: eliminate a race in lock_dwork draining on unmap
Date: Thu, 28 May 2026 21:45:31 +0200
Message-ID: <20260528194641.051592262@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 9fc75b71fdd38465c76c6f6a884cdd4ae3c72d90 upstream.

Given how rbd_lock_add_request() and rbd_img_exclusive_lock() are
written, lock_dwork may be (re)queued more than it's actually needed:
for example in case a new I/O request comes in while we are in the
middle of rbd_acquire_lock() on behalf of another I/O request.  This is
expected and with rbd_release_lock() preemptively canceling lock_dwork
is benign under normal operation.

A more problematic example is maybe_kick_acquire():

    if (have_requests || delayed_work_pending(&rbd_dev->lock_dwork)) {
            dout("%s rbd_dev %p kicking lock_dwork\n", __func__, rbd_dev);
            mod_delayed_work(rbd_dev->task_wq, &rbd_dev->lock_dwork, 0);
    }

It's not unrealistic for lock_dwork to get canceled right after
delayed_work_pending() returns true and for mod_delayed_work() to
requeue it right there anyway.  This is a classic TOCTOU race.

When it comes to unmapping the image, there is an implicit assumption
of no self-initiated exclusive lock activity past the point of return
from rbd_dev_image_unlock() which unlocks the lock if it happens to be
held.  This unlock is assumed to be final and lock_dwork (as well as
all other exclusive lock tasks, really) isn't expected to get queued
again.  However, lock_dwork is canceled only in cancel_tasks_sync()
(i.e. later in the unmap sequence) and on top of that the cancellation
can get in effect nullified by maybe_kick_acquire().  This may result
in rbd_acquire_lock() executing after rbd_dev_device_release() and
rbd_dev_image_release() run and free and/or reset a bunch of things.
One of the possible failure modes then is a violated

    rbd_assert(rbd_image_format_valid(rbd_dev->image_format));

in rbd_dev_header_info() which is called via rbd_dev_refresh() from
rbd_post_acquire_action().

Redo exclusive lock task draining to provide saner semantics and try
to meet the assumptions around rbd_dev_image_unlock().

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Viacheslav Dubeyko <Slava.Dubeyko@ibm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   20 ++++++++------------
 1 file changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -4565,24 +4565,12 @@ out:
 	return ret;
 }
 
-static void cancel_tasks_sync(struct rbd_device *rbd_dev)
-{
-	dout("%s rbd_dev %p\n", __func__, rbd_dev);
-
-	cancel_work_sync(&rbd_dev->acquired_lock_work);
-	cancel_work_sync(&rbd_dev->released_lock_work);
-	cancel_delayed_work_sync(&rbd_dev->lock_dwork);
-	cancel_work_sync(&rbd_dev->unlock_work);
-}
-
 /*
  * header_rwsem must not be held to avoid a deadlock with
  * rbd_dev_refresh() when flushing notifies.
  */
 static void rbd_unregister_watch(struct rbd_device *rbd_dev)
 {
-	cancel_tasks_sync(rbd_dev);
-
 	mutex_lock(&rbd_dev->watch_mutex);
 	if (rbd_dev->watch_state == RBD_WATCH_STATE_REGISTERED)
 		__rbd_unregister_watch(rbd_dev);
@@ -6548,10 +6536,18 @@ out_err:
 
 static void rbd_dev_image_unlock(struct rbd_device *rbd_dev)
 {
+	dout("%s rbd_dev %p\n", __func__, rbd_dev);
+
+	disable_delayed_work_sync(&rbd_dev->lock_dwork);
+	disable_work_sync(&rbd_dev->unlock_work);
+
 	down_write(&rbd_dev->lock_rwsem);
 	if (__rbd_is_lock_owner(rbd_dev))
 		__rbd_release_lock(rbd_dev);
 	up_write(&rbd_dev->lock_rwsem);
+
+	flush_work(&rbd_dev->acquired_lock_work);
+	flush_work(&rbd_dev->released_lock_work);
 }
 
 /*


