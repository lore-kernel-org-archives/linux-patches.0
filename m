Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ABC0288C22;
	Wed, 28 Jan 2026 15:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615414; cv=none; b=awVh4ZxG8RDY/6xFWyUvdhpNI1HsO4SKKMHK8pKlTZ46IpeBNZVBMi6fWHtn7qjw0XwjP+2wkQXAeN2KkuH+cYcD3yUOBXP9jpNeWMkr6AHz4Q9Lz7+bfJmCjBtxuNS20UEKb8wUfh34aA90oS9sRQypbXp/GkGGMq9UOjfp3OY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615414; c=relaxed/simple;
	bh=FS6H52q/AClE2NIoiREK1rbyGc9rHD/rG72BR2zVb9Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRa2QzceAjuVk7TiMtdB2u44aarNUdcM1XXn8OXaeRZs6sb6quG5wCEMpcyINUal2eTrbQJoHhjEyUssmEeqqtHqzAwflAUTvMTxPxJDSiprOBAS4j3p/cD20yKnXkPJKDAZtQpjob6wRPKb87DpVtzyScS6NWo4xe7wcL890MY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UCDtFaQn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UCDtFaQn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01485C4CEF1;
	Wed, 28 Jan 2026 15:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615414;
	bh=FS6H52q/AClE2NIoiREK1rbyGc9rHD/rG72BR2zVb9Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UCDtFaQn6FnarPxyDh2E41chsIxb6vwpQqqTHpS3hexS47RntOhmow3JXSLcIb1kk
	 2hrR/gKNjlqJFAs7rxeCOeSDz0w3I2rxKnmvnxJUo0432BcoVsysvg1d8Cw0ikPcRf
	 F9A/CKnvY+buN11fs6HuVbH/8Ln5/iV1MMeMqbpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rasmus Villemoes <ravi@prevas.dk>,
	Peter Rosin <peda@axentia.se>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 154/169] iio: core: add separate lockdep class for info_exist_lock
Date: Wed, 28 Jan 2026 16:23:57 +0100
Message-ID: <20260128145339.551456129@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145334.006287341@linuxfoundation.org>
References: <20260128145334.006287341@linuxfoundation.org>
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

From: Rasmus Villemoes <ravi@prevas.dk>

[ Upstream commit 9910159f06590c17df4fbddedaabb4c0201cc4cb ]

When one iio device is a consumer of another, it is possible that
the ->info_exist_lock of both ends up being taken when reading the
value of the consumer device.

Since they currently belong to the same lockdep class (being
initialized in a single location with mutex_init()), that results in a
lockdep warning

         CPU0
         ----
    lock(&iio_dev_opaque->info_exist_lock);
    lock(&iio_dev_opaque->info_exist_lock);

   *** DEADLOCK ***

   May be due to missing lock nesting notation

  4 locks held by sensors/414:
   #0: c31fd6dc (&p->lock){+.+.}-{3:3}, at: seq_read_iter+0x44/0x4e4
   #1: c4f5a1c4 (&of->mutex){+.+.}-{3:3}, at: kernfs_seq_start+0x1c/0xac
   #2: c2827548 (kn->active#34){.+.+}-{0:0}, at: kernfs_seq_start+0x30/0xac
   #3: c1dd2b68 (&iio_dev_opaque->info_exist_lock){+.+.}-{3:3}, at: iio_read_channel_processed_scale+0x24/0xd8

  stack backtrace:
  CPU: 0 UID: 0 PID: 414 Comm: sensors Not tainted 6.17.11 #5 NONE
  Hardware name: Generic AM33XX (Flattened Device Tree)
  Call trace:
   unwind_backtrace from show_stack+0x10/0x14
   show_stack from dump_stack_lvl+0x44/0x60
   dump_stack_lvl from print_deadlock_bug+0x2b8/0x334
   print_deadlock_bug from __lock_acquire+0x13a4/0x2ab0
   __lock_acquire from lock_acquire+0xd0/0x2c0
   lock_acquire from __mutex_lock+0xa0/0xe8c
   __mutex_lock from mutex_lock_nested+0x1c/0x24
   mutex_lock_nested from iio_read_channel_raw+0x20/0x6c
   iio_read_channel_raw from rescale_read_raw+0x128/0x1c4
   rescale_read_raw from iio_channel_read+0xe4/0xf4
   iio_channel_read from iio_read_channel_processed_scale+0x6c/0xd8
   iio_read_channel_processed_scale from iio_hwmon_read_val+0x68/0xbc
   iio_hwmon_read_val from dev_attr_show+0x18/0x48
   dev_attr_show from sysfs_kf_seq_show+0x80/0x110
   sysfs_kf_seq_show from seq_read_iter+0xdc/0x4e4
   seq_read_iter from vfs_read+0x238/0x2e4
   vfs_read from ksys_read+0x6c/0xec
   ksys_read from ret_fast_syscall+0x0/0x1c

Just as the mlock_key already has its own lockdep class, add a
lock_class_key for the info_exist mutex.

Note that this has in theory been a problem since before IIO first
left staging, but it only occurs when a chain of consumers is in use
and that is not often done.

Fixes: ac917a81117c ("staging:iio:core set the iio_dev.info pointer to null on unregister under lock.")
Signed-off-by: Rasmus Villemoes <ravi@prevas.dk>
Reviewed-by: Peter Rosin <peda@axentia.se>
Cc: <stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/industrialio-core.c |    4 +++-
 include/linux/iio/iio-opaque.h  |    2 ++
 2 files changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/iio/industrialio-core.c
+++ b/drivers/iio/industrialio-core.c
@@ -1631,6 +1631,7 @@ static void iio_dev_release(struct devic
 	mutex_destroy(&iio_dev_opaque->info_exist_lock);
 	mutex_destroy(&iio_dev_opaque->mlock);
 
+	lockdep_unregister_key(&iio_dev_opaque->info_exist_key);
 	lockdep_unregister_key(&iio_dev_opaque->mlock_key);
 
 	ida_free(&iio_ida, iio_dev_opaque->id);
@@ -1696,9 +1697,10 @@ struct iio_dev *iio_device_alloc(struct
 	INIT_LIST_HEAD(&iio_dev_opaque->ioctl_handlers);
 
 	lockdep_register_key(&iio_dev_opaque->mlock_key);
+	lockdep_register_key(&iio_dev_opaque->info_exist_key);
 
 	mutex_init_with_key(&iio_dev_opaque->mlock, &iio_dev_opaque->mlock_key);
-	mutex_init(&iio_dev_opaque->info_exist_lock);
+	mutex_init_with_key(&iio_dev_opaque->info_exist_lock, &iio_dev_opaque->info_exist_key);
 
 	return indio_dev;
 }
--- a/include/linux/iio/iio-opaque.h
+++ b/include/linux/iio/iio-opaque.h
@@ -14,6 +14,7 @@
  * @mlock:			lock used to prevent simultaneous device state changes
  * @mlock_key:			lockdep class for iio_dev lock
  * @info_exist_lock:		lock to prevent use during removal
+ * @info_exist_key:		lockdep class for info_exist lock
  * @trig_readonly:		mark the current trigger immutable
  * @event_interface:		event chrdevs associated with interrupt lines
  * @attached_buffers:		array of buffers statically attached by the driver
@@ -47,6 +48,7 @@ struct iio_dev_opaque {
 	struct mutex			mlock;
 	struct lock_class_key		mlock_key;
 	struct mutex			info_exist_lock;
+	struct lock_class_key		info_exist_key;
 	bool				trig_readonly;
 	struct iio_event_interface	*event_interface;
 	struct iio_buffer		**attached_buffers;


