Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3358243964;
	Tue, 29 Apr 2025 17:48:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745948927; cv=none; b=G3g3tv3xpzhQJ/djpMUhrznwIJH0D9sjWj/yo1So2pdzwFyIJg5eQElfJ7vuED5963pzeAP84caspQ5MhNiFbF29283AqtkJRPl3MZ9XUGg0wDWzbAv3UYhlHvqyJUbdTCZl9gpg7PMkeI35u0ig/QWJEQlBnd1tpEJ2bwBVQXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745948927; c=relaxed/simple;
	bh=bB8WrG7umKEy22eDoO2VXxsqxBiCeFMThCK99Emfbt8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Otjf3i/MUdbZErtebnA6QFkD6IaLQ1Tjz+MRY/k/j7atMIs8MJhRcOd36BYpZLoCCgBF39PRXz6ruH3OWYj+TMAAmwSw4DkdcpplQsTNBECaadPlOeg0vmX+zHl+2gtKit87o8sd1uC685xhQJ0tYTzky4lmHIT81aWIfmUstto=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tZu4Jjlx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tZu4Jjlx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0C1AC4CEE9;
	Tue, 29 Apr 2025 17:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745948927;
	bh=bB8WrG7umKEy22eDoO2VXxsqxBiCeFMThCK99Emfbt8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tZu4Jjlx0g8P/14N1zYBCCrocZzuYskdpLKD/A39+2YgI7OJkZhqueUVntN+pAnRn
	 zONnU2XdP2959Yd3NuZJM40RMHUDkMxDwDzD3XLsUlcqKfAj/gyV1DTZOMYZIiUH9A
	 58jLUa1wWwsrHU1YNavEZiXD0PHE++jkuGffRRvc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 5.15 167/373] loop: properly send KOBJ_CHANGED uevent for disk device
Date: Tue, 29 Apr 2025 18:40:44 +0200
Message-ID: <20250429161130.044010280@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161123.119104857@linuxfoundation.org>
References: <20250429161123.119104857@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -797,8 +797,8 @@ static int loop_change_fd(struct loop_de
 
 	error = 0;
 done:
-	/* enable and uncork uevent now that we are done */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 	return error;
 
 out_err:
@@ -1316,8 +1316,8 @@ static int loop_configure(struct loop_de
 	if (partscan)
 		lo->lo_disk->flags &= ~GENHD_FL_NO_PART;
 
-	/* enable and uncork uevent now that we are done */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 
 	loop_global_unlock(lo, is_loop);
 	if (partscan)


