Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B723279345;
	Wed, 23 Apr 2025 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745422313; cv=none; b=YOcWEL1IvSm7gJ+WsEOOeg/g9gxAUDybL4yb+Nz1Unph6ZkYpt6TtZTZ2SPM36smks3e89bYn4sD8hO9HgyUs0Dna2q2CIM8thu6quWqsxR28kZR2fj5gIjxKCWGVTSYDcP6MrAI6TIeib09VlbW40BYIMpCx80bdjclg+vnR3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745422313; c=relaxed/simple;
	bh=Se2tV4GxNuphmIlPu2UFVBaKsGBW8QKScK5LjlKIN+U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=rZ31eglH5jgY/qWcGKeW9adJP7Q3giLOf4RnIEKVW4/dF5OkvmRQAFWFfzHPi7nnEocKFGJmWjnjYKOoz8dB/x7hNRYed0yf9aZQj8VpmV5emF2aPmQzEqkW0HJa7nBlJEGibUYfvj0WiJdBEBCwdLbuQy2LpUSvBkG9lB+2mng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wjOu5zkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wjOu5zkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86757C4CEE2;
	Wed, 23 Apr 2025 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745422311;
	bh=Se2tV4GxNuphmIlPu2UFVBaKsGBW8QKScK5LjlKIN+U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wjOu5zknhGWRap4QzvPCeGBkDIhEAm77Etsa/SBN7EwZ1Dw/sfyT3eyFmqE7izIDd
	 mQuV+k7fs0kcAPECXLhSl7yygdf9OOEx+T3ZWDaJhCAxcXt8HSxoWI3aTRXCAJOX9c
	 2KwgXcfFLjAX9egxKKr0mO+mng0fPoL7g3MvUFSo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.6 318/393] loop: properly send KOBJ_CHANGED uevent for disk device
Date: Wed, 23 Apr 2025 16:43:34 +0200
Message-ID: <20250423142656.474977139@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

commit e7bc0010ceb403d025100698586c8e760921d471 upstream.

The original commit message and the wording "uncork" in the code comment
indicate that it is expected that the suppressed event instances are
automatically sent after unsuppressing.
This is not the case, instead they are discarded.
In effect this means that no "changed" events are emitted on the device
itself by default.
While each discovered partition does trigger a changed event on the
device, devices without partitions don't have any event emitted.

This makes udev miss the device creation and prompted workarounds in
userspace. See the linked util-linux/losetup bug.

Explicitly emit the events and drop the confusingly worded comments.

Link: https://github.com/util-linux/util-linux/issues/2434
Fixes: 498ef5c777d9 ("loop: suppress uevents while reconfiguring the device")
Cc: stable@vger.kernel.org
Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://lore.kernel.org/r/20250415-loop-uevent-changed-v2-1-0c4e6a923b2a@linutronix.de
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/loop.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/block/loop.c
+++ b/drivers/block/loop.c
@@ -629,8 +629,8 @@ static int loop_change_fd(struct loop_de
 
 	error = 0;
 done:
-	/* enable and uncork uevent now that we are done */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 	return error;
 
 out_err:
@@ -1104,8 +1104,8 @@ static int loop_configure(struct loop_de
 	if (partscan)
 		clear_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 
-	/* enable and uncork uevent now that we are done */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 
 	loop_global_unlock(lo, is_loop);
 	if (partscan)


