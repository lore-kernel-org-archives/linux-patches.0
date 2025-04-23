Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A713E26A082;
	Wed, 23 Apr 2025 14:57:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745420276; cv=none; b=WbSE1QJ1p4p8BJtXT0woD3EamWUIe9ovrmjYxOUZLewI/N26VmujCNS+MuHihNLP9YMJX7px2enRvP4AMbdwzOIOV9mFCu7w+5hk+VpYZikcgXvbW+qmx+A7zrdqnhyuVIuDnq0Hb62reba4ys2oSviOjRCwlcHeC+OBp6NQtUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745420276; c=relaxed/simple;
	bh=p+IelbYYNc+T0fInxWlk1P31FB3fw6NCCJ4LUff2Iuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FUxSTzBRmzEMF1dZWPjJFxuTfJ5gXxL/y4rT/DFV/k9aOBxXatYZvq1sLFG9L7Oxmp2PEly/vEmmux6j6d+uYLpiwiSn238++QqhCvxODb8JV47rslgwSSxgosGVeImHJ1mSMFq7vEZA3CVdqMLNYJwMbOvkAZTtl0ytI1Zs07w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f2Jg4aMv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f2Jg4aMv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39942C4CEE8;
	Wed, 23 Apr 2025 14:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745420276;
	bh=p+IelbYYNc+T0fInxWlk1P31FB3fw6NCCJ4LUff2Iuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f2Jg4aMvGpU0gd83nEIMGSITDW3Wo1J5pGDJhPn7BPRdR3M9XuMvr+NxPTaQ4f0ED
	 hsxdMxQiZP8FMxGJCCANKHEnqTnXE82FuWSi6xAWs3t/420sJHuJMpLnSOctXroqgX
	 Ge6JpAzE4sIcrtJIzOjJDo/fvUCuJ9y6JUcvBbiA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Jens Axboe <axboe@kernel.dk>
Subject: [PATCH 6.12 115/223] loop: properly send KOBJ_CHANGED uevent for disk device
Date: Wed, 23 Apr 2025 16:43:07 +0200
Message-ID: <20250423142621.794983088@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -573,8 +573,8 @@ static int loop_change_fd(struct loop_de
 
 	error = 0;
 done:
-	/* enable and uncork uevent now that we are done */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 	return error;
 
 out_err:
@@ -1034,8 +1034,8 @@ static int loop_configure(struct loop_de
 	if (partscan)
 		clear_bit(GD_SUPPRESS_PART_SCAN, &lo->lo_disk->state);
 
-	/* enable and uncork uevent now that we are done */
 	dev_set_uevent_suppress(disk_to_dev(lo->lo_disk), 0);
+	kobject_uevent(&disk_to_dev(lo->lo_disk)->kobj, KOBJ_CHANGE);
 
 	loop_global_unlock(lo, is_loop);
 	if (partscan)


