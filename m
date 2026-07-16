Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C218B3161AD;
	Thu, 16 Jul 2026 14:19:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211575; cv=none; b=ppLoe+nUrrgO1M2zm7kg6tmmdFglRqhMEWHqOlQcbARrJbHtXCvfDauihALMt1qgqDFUYTf9Buho4DeQHJeDTgcF3a02RdR4uK9ZVjGiMIxJ0rh5FRK++rUUUU+ApUQu0hBnmpv1zb+mEa/4KDe09yzpdN+d2nopSZ47WzcdRgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211575; c=relaxed/simple;
	bh=EnXAKMP4Op5a1rc3T1zhd4/h60oLL2LtNk/046wPTMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HF7xx+zP6/PPIqXqHe09MU7bG6qR2kLhICE1vVF+AB9tXJtyr/N5wXnuwwYIgjJgF6fR+VzGJLWOFJpSTiO4z4P4vU1LJKXJk413xnZmewPYR62oCkD/KYe+pD9fFELklFcbmp/SvkpFpYC5u+5BTQGCqrpsc1vm+3RSS759qng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r03esnkD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r03esnkD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34C121F000E9;
	Thu, 16 Jul 2026 14:19:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211574;
	bh=gYXR22IUQCMR4g31ODs7Y5/0jLj/EQZts6yrz0PoEwA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r03esnkDGNTjPw/uXC/OOxEf/IwnyH836PC8qrqrBf3mF6qGZzJuzBWTvf+5G1tRZ
	 1CG0Jqe/lzudLjqDPnvbFs5rAgQpXlrF67FJesrSfDr5SjURRaKn0uOL60HgLRf6+N
	 UbJzdLdjGrFWkjPSqhDvJ/d8zRr4xXd8yP181tdc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Ruiz <aruiz@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.18 464/480] fuse: fix device node leak in cuse_process_init_reply()
Date: Thu, 16 Jul 2026 15:33:31 +0200
Message-ID: <20260716133054.860493447@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Alberto Ruiz <aruiz@redhat.com>

commit 9fa4f7a53406430ee9982f2f636a15b338185122 upstream.

If device_add() succeeds during CUSE initialization but a subsequent
step (cdev_alloc() or cdev_add()) fails, the error path calls
put_device() without first calling device_del().  This leaks the
devtmpfs entry created by device_add(), leaving a stale /dev/<name>
node that persists until reboot.

Since the cuse_conn is never linked into cuse_conntbl on the failure
path, cuse_channel_release() sees cc->dev == NULL and skips
device_unregister(), so no other code path cleans up the node.

This has several consequences:

 - The device name is permanently poisoned: any subsequent attempt to
   create a CUSE device with the same name hits the stale sysfs entry,
   device_add() fails, and the new device is aborted.

 - The collision manifests as ENODEV returned to userspace with no
   dmesg diagnostic, making it very difficult to debug.

 - The failure is self-perpetuating: once a name is leaked, all future
   attempts with that name fail identically.

Fix this by introducing an err_dev label that calls device_del() to
undo device_add() before falling through to err_unlock.  The existing
err_unlock path from a device_add() failure correctly skips device_del()
since the device was never added.

Testing instructions can be found at the lore link below.

Link: https://lore.kernel.org/all/20260408-wip-cuse-leak-fix-v1-0-1c028d575e97@redhat.com/
Signed-off-by: Alberto Ruiz <aruiz@redhat.com>
Fixes: 151060ac1314 ("CUSE: implement CUSE - Character device in Userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Miklos Szeredi <mszeredi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/fuse/cuse.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/fs/fuse/cuse.c
+++ b/fs/fuse/cuse.c
@@ -391,7 +391,7 @@ static void cuse_process_init_reply(stru
 	rc = -ENOMEM;
 	cdev = cdev_alloc();
 	if (!cdev)
-		goto err_unlock;
+		goto err_dev;
 
 	cdev->owner = THIS_MODULE;
 	cdev->ops = &cuse_frontend_fops;
@@ -417,6 +417,8 @@ out:
 
 err_cdev:
 	cdev_del(cdev);
+err_dev:
+	device_del(dev);
 err_unlock:
 	mutex_unlock(&cuse_lock);
 	put_device(dev);


