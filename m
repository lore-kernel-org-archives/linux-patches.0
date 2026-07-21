Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CC9298CC4;
	Tue, 21 Jul 2026 22:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784671304; cv=none; b=PPHkCYbFuYrd6/9RrrN7Q9SHPYeOLOkQp0tMrxBxfOu8/UC1B1XzYwkhC/Ow3RPUAPupK+pYA0oYaeWSCihSSJT6N9isKD0veOI/y8+906IxsIKAcEHu4nfWEIX2E+SE1NCnC2Ylj+YYxrWr5+NLrPONmL3+sHzDegLmqYcYbPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784671304; c=relaxed/simple;
	bh=KaHj/h7AN7F6YKLD/eCHOYN5Upx7zVY6qGpj9x4MObU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ftgrbW3tVwV/OD4p3hMeLdtOg+SMK7XYrhRoVZ1gPRKpZhVLkL5jD+jKMWvjABZiuq9iicmsxKXcesl77l7DK2gfmvJQ9AQfqwKHu036OKvieoegGOU9RuA6c7N+w13o6rvWezWx9QDj5ow/siPEWfccXO3ILLcgSmjnyAtT2Lw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFMD0kc5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFMD0kc5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C18F1F000E9;
	Tue, 21 Jul 2026 22:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784671302;
	bh=yOKEYZMtEO5zzHXMb5Xco1VH6OwNOuxlxGwdcyQg0Ls=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sFMD0kc50VszbqKfnj0bPNj1sQRcVGGFBjx52k5nTt11Wh8pi/TrVSHVJd4RcBTCr
	 tHmMEL48Qwj1zhaXips9LLVhMyJ4C9rVymVXTUKRyVpZXlWIZ7vx2mYvu4S1013q8B
	 hnfETTy+XNs1A1s/OLAS8RQ9t4w/7kMeztHxrqpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Ruiz <aruiz@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 5.15 195/843] fuse: fix device node leak in cuse_process_init_reply()
Date: Tue, 21 Jul 2026 17:17:10 +0200
Message-ID: <20260721152410.401504833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


