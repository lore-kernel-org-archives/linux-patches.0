Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3CEC35C6AC;
	Tue, 21 Jul 2026 21:17:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668630; cv=none; b=WTQziPtpr/j/Fitdk0SFpCLTQt3XWDVgRc1cshiY1hI5eDA/queE2kZcI5DDm+MXaP7JZSBQoRSdUjueMmfYIuhEdwkmq3K9UWxG5RPkJtw7rcunGiyikFfeLbGnLzj2IhtH023gmE0+8aTG5vTrBUmXlUzx8YNpW0Icyied9DI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668630; c=relaxed/simple;
	bh=NSDg9qQ9P8uRAsL4FY+/FHZ3ZVLsYpwVJgo865iRDN0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GDpcONMBNp1jDN10kNqxvdvpfrD+n6uACrlXo09TGJ7NK/l4YbNlLIp1S102tehigTjGuNIlxDVnzUTXGQlhsLAYfBJPOkGWiUjnb0wltNq9camTCj9dcvPeLkjwoUrB9UDL7P7OE2JAQNBGWWuyZBU9li3BqORl5UxcovtcRJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RK4SEys9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RK4SEys9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 492BB1F000E9;
	Tue, 21 Jul 2026 21:17:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668625;
	bh=0gbGlVcQlkXRzt9GMziosJ17phRCWISXn3dZa88mhP4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RK4SEys92wDU2i8DkPlwlQe3EBBhVuFSjrNwzXLKIQ9hrdTFTZxsdGqUSC0tSfeQt
	 +eZuvnjpDyvnSGDD8rVseJ6eJ8Onq+byWiP1ca8PAX05hK5yGnjJizaj1kF80u+ML6
	 ZuAiqyPZGZQzBH8+4Kj0ZqGd2ZtPA6bvA9AUiYQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Ruiz <aruiz@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.1 0248/1067] fuse: fix device node leak in cuse_process_init_reply()
Date: Tue, 21 Jul 2026 17:14:09 +0200
Message-ID: <20260721152430.146427232@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -386,7 +386,7 @@ static void cuse_process_init_reply(stru
 	rc = -ENOMEM;
 	cdev = cdev_alloc();
 	if (!cdev)
-		goto err_unlock;
+		goto err_dev;
 
 	cdev->owner = THIS_MODULE;
 	cdev->ops = &cuse_frontend_fops;
@@ -412,6 +412,8 @@ out:
 
 err_cdev:
 	cdev_del(cdev);
+err_dev:
+	device_del(dev);
 err_unlock:
 	mutex_unlock(&cuse_lock);
 	put_device(dev);


