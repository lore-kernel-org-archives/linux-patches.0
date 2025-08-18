Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFC2C2E22A6;
	Mon, 18 Aug 2025 13:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522681; cv=none; b=chjtww51hplBXEz459uby4sJUdgEO3fVv3Yyir0Hvb48lBWs5oCLND3jqYRzSXsdPlktl9+0Ki2tNR6ORxv8xRAiRW883hZ6iPAc1nzXAu3UHpjrAUEMrr1tsQLIZ747yj2dreB3foUSOAXEpI7jHh6ikOOb7uItWH5ozz2iPOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522681; c=relaxed/simple;
	bh=rPLFd5/AYotzc8yK9fqOGyXcW6Q5pi7vFH8nc0GODzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c+ER1xaSzCL9RTJ5s8Nlpe64nXhjg67PQ6ZmyypssliVissYVh9jCy2r1cBmRZ1V+FWbB6/drP1E6JNjQLqn7garyGjAFJsrPzVjGKEzQnXjHCxQJuSwE63kEyaX+/k1m06IiV4uBD/cjbMT/BEeG5LnGTWnWkH1XrM4suxflUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=V147Mxjb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V147Mxjb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70E40C4CEEB;
	Mon, 18 Aug 2025 13:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522680;
	bh=rPLFd5/AYotzc8yK9fqOGyXcW6Q5pi7vFH8nc0GODzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V147MxjbUZyNjVVXoZ5vvZYgnv0m+qtDIktiTGCjsdxqOjvj8kNjH0dILgxOX6v1X
	 KXp0PYA9zbaFdanzofY5fjxSGa0XbZ2VQmLfVUey/6UHUU5pNvq/eK5yQ2l+lcB0cS
	 R4zQzAIsF/u934ixxzWngyC0+U1ABJ6xHSDDhpww=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com,
	Jens Axboe <axboe@kernel.dk>,
	Ian Abbott <abbotti@mev.co.uk>
Subject: [PATCH 6.12 388/444] comedi: fix race between polling and detaching
Date: Mon, 18 Aug 2025 14:46:54 +0200
Message-ID: <20250818124503.446435813@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ian Abbott <abbotti@mev.co.uk>

commit 35b6fc51c666fc96355be5cd633ed0fe4ccf68b2 upstream.

syzbot reports a use-after-free in comedi in the below link, which is
due to comedi gladly removing the allocated async area even though poll
requests are still active on the wait_queue_head inside of it. This can
cause a use-after-free when the poll entries are later triggered or
removed, as the memory for the wait_queue_head has been freed.  We need
to check there are no tasks queued on any of the subdevices' wait queues
before allowing the device to be detached by the `COMEDI_DEVCONFIG`
ioctl.

Tasks will read-lock `dev->attach_lock` before adding themselves to the
subdevice wait queue, so fix the problem in the `COMEDI_DEVCONFIG` ioctl
handler by write-locking `dev->attach_lock` before checking that all of
the subdevices are safe to be deleted.  This includes testing for any
sleepers on the subdevices' wait queues.  It remains locked until the
device has been detached.  This requires the `comedi_device_detach()`
function to be refactored slightly, moving the bulk of it into new
function `comedi_device_detach_locked()`.

Note that the refactor of `comedi_device_detach()` results in
`comedi_device_cancel_all()` now being called while `dev->attach_lock`
is write-locked, which wasn't the case previously, but that does not
matter.

Thanks to Jens Axboe for diagnosing the problem and co-developing this
patch.

Cc: stable <stable@kernel.org>
Fixes: 2f3fdcd7ce93 ("staging: comedi: add rw_semaphore to protect against device detachment")
Link: https://lore.kernel.org/all/687bd5fe.a70a0220.693ce.0091.GAE@google.com/
Reported-by: syzbot+01523a0ae5600aef5895@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=01523a0ae5600aef5895
Co-developed-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
Tested-by: Jens Axboe <axboe@kernel.dk>
Link: https://lore.kernel.org/r/20250722155316.27432-1-abbotti@mev.co.uk
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/comedi/comedi_fops.c     |   33 +++++++++++++++++++++++++--------
 drivers/comedi/comedi_internal.h |    1 +
 drivers/comedi/drivers.c         |   13 ++++++++++---
 3 files changed, 36 insertions(+), 11 deletions(-)

--- a/drivers/comedi/comedi_fops.c
+++ b/drivers/comedi/comedi_fops.c
@@ -787,6 +787,7 @@ static int is_device_busy(struct comedi_
 	struct comedi_subdevice *s;
 	int i;
 
+	lockdep_assert_held_write(&dev->attach_lock);
 	lockdep_assert_held(&dev->mutex);
 	if (!dev->attached)
 		return 0;
@@ -795,7 +796,16 @@ static int is_device_busy(struct comedi_
 		s = &dev->subdevices[i];
 		if (s->busy)
 			return 1;
-		if (s->async && comedi_buf_is_mmapped(s))
+		if (!s->async)
+			continue;
+		if (comedi_buf_is_mmapped(s))
+			return 1;
+		/*
+		 * There may be tasks still waiting on the subdevice's wait
+		 * queue, although they should already be about to be removed
+		 * from it since the subdevice has no active async command.
+		 */
+		if (wq_has_sleeper(&s->async->wait_head))
 			return 1;
 	}
 
@@ -825,15 +835,22 @@ static int do_devconfig_ioctl(struct com
 		return -EPERM;
 
 	if (!arg) {
-		if (is_device_busy(dev))
-			return -EBUSY;
-		if (dev->attached) {
-			struct module *driver_module = dev->driver->module;
+		int rc = 0;
 
-			comedi_device_detach(dev);
-			module_put(driver_module);
+		if (dev->attached) {
+			down_write(&dev->attach_lock);
+			if (is_device_busy(dev)) {
+				rc = -EBUSY;
+			} else {
+				struct module *driver_module =
+					dev->driver->module;
+
+				comedi_device_detach_locked(dev);
+				module_put(driver_module);
+			}
+			up_write(&dev->attach_lock);
 		}
-		return 0;
+		return rc;
 	}
 
 	if (copy_from_user(&it, arg, sizeof(it)))
--- a/drivers/comedi/comedi_internal.h
+++ b/drivers/comedi/comedi_internal.h
@@ -50,6 +50,7 @@ extern struct mutex comedi_drivers_list_
 int insn_inval(struct comedi_device *dev, struct comedi_subdevice *s,
 	       struct comedi_insn *insn, unsigned int *data);
 
+void comedi_device_detach_locked(struct comedi_device *dev);
 void comedi_device_detach(struct comedi_device *dev);
 int comedi_device_attach(struct comedi_device *dev,
 			 struct comedi_devconfig *it);
--- a/drivers/comedi/drivers.c
+++ b/drivers/comedi/drivers.c
@@ -158,7 +158,7 @@ static void comedi_device_detach_cleanup
 	int i;
 	struct comedi_subdevice *s;
 
-	lockdep_assert_held(&dev->attach_lock);
+	lockdep_assert_held_write(&dev->attach_lock);
 	lockdep_assert_held(&dev->mutex);
 	if (dev->subdevices) {
 		for (i = 0; i < dev->n_subdevices; i++) {
@@ -196,16 +196,23 @@ static void comedi_device_detach_cleanup
 	comedi_clear_hw_dev(dev);
 }
 
-void comedi_device_detach(struct comedi_device *dev)
+void comedi_device_detach_locked(struct comedi_device *dev)
 {
+	lockdep_assert_held_write(&dev->attach_lock);
 	lockdep_assert_held(&dev->mutex);
 	comedi_device_cancel_all(dev);
-	down_write(&dev->attach_lock);
 	dev->attached = false;
 	dev->detach_count++;
 	if (dev->driver)
 		dev->driver->detach(dev);
 	comedi_device_detach_cleanup(dev);
+}
+
+void comedi_device_detach(struct comedi_device *dev)
+{
+	lockdep_assert_held(&dev->mutex);
+	down_write(&dev->attach_lock);
+	comedi_device_detach_locked(dev);
 	up_write(&dev->attach_lock);
 }
 


