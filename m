Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1B2128937D;
	Wed, 23 Apr 2025 15:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420924; cv=none; b=h28Ye7gLTLNO6BO3fCi4Cb/K7+8IdFuaP2T2ss4kTYy6C41NlM8kn+OlxEXDvq+0xVNQGy43Z0znJ2yKEMGe0RbYyyrVtoR7tLdROqk1AHH2I0Vj6KmHGJ8STytQzm5yfr/JeKy3Zj6QtWn9SN8i45LgGgeskuCLdKVZ4yNy2UM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420924; c=relaxed/simple;
	bh=yQwoB6/5/rnj5FneJ/a/COmFI7GmdUSbh2UupQxD00g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=bU5Mw4jIOte8FgirwfOnncfq6VfReYKmOJFUYFn0iqeGM+2ZO99zaBdTY+bWIo1IYcasv4OzvPA19XZmoDSediz4z7SmsWk1DVFVTXUJtINW0obym42EzyF/g2xwdHDH53z85AoPYis0LS3OXYgtQzPprKFrpiTXZDPRpNhT614=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QsqUGgDR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QsqUGgDR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B847C4CEE2;
	Wed, 23 Apr 2025 15:08:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420923;
	bh=yQwoB6/5/rnj5FneJ/a/COmFI7GmdUSbh2UupQxD00g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QsqUGgDReBW7ybmvoDhsm6wOZvJU3D+Lu347uMwucPqyU3kAoF8ian/VPVKdBI0ww
	 3sugAQuGaCUEbbYEUxi42LhlZEcmVnsX8fiKY+oqt8+O81W8gkhYE8W2MY7VfX/fcR
	 ezKJCXui403Fc/fv6p259/edg5NH37ah/5NPai+U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.14 136/241] loop: properly send KOBJ_CHANGED uevent for disk device
Date: Wed, 23 Apr 2025 16:43:20 +0200
Message-ID: <20250423142626.119840318@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142620.525425242@linuxfoundation.org>
References: <20250423142620.525425242@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -577,8 +577,8 @@ static int loop_change_fd(struct loop_de
 
 	error = 0;
 done:
-	/* enable and uncork uevent now that we are done */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 	return error;
 
 out_err:
@@ -1038,8 +1038,8 @@ static int loop_configure(struct loop_de
 	if (partscan)
 		clear_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 
-	/* enable and uncork uevent now that we are done */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 
 	loop_global_unlock(lo, is_loop);
 	if (partscan)


