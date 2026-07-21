Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96E5E471435;
	Tue, 21 Jul 2026 20:25:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784665555; cv=none; b=hmL1ZRHoCkefb+GkdyWLa2OFVEbxpj1iyfna6vX88yNuik3EqgO7SnAGuC7I1ommhEHJvAy8OjNeJIwP3nlwxFq78EZn5z6lXMKQW0bHpcxHocQk3m7rPO4Gq7ya7XoY/EEgzW6kF124/kDD6yLL8919C3RFNGo6ZuwYsjRv6U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784665555; c=relaxed/simple;
	bh=ETMSNonKVKM30csmytFK5XUxQ0Xpvn7J/GINXJyc61E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Bqic8aANgHZYyGmGeZzp/Bs1Q0y3KP/3BEdyYGQHKgKUY5CriW3TrapMH4mvjcl3V5BZEu/+PV3xUsJ2YIdWasg+unL6W2r5ikJ/zf/klgTvc3GqdLT7EVawIO4WUHbX2S6tr1a44fRIGEp0NbPCN1TjzIuqaOCK6PfeRr/I56I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aQZB3W/C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aQZB3W/C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07DF11F000E9;
	Tue, 21 Jul 2026 20:25:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784665554;
	bh=8UUyjBP/jwTkKotJ7t4Wjc0opAO23JRLX/99fRUrEPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aQZB3W/Cq1Hta+mYTz6i4Yi+fWeLc5KW1ELMdCe6DzZWef9MsH9k6yQnjLkg/LLaH
	 G7Hm+ocuysKtURYxNnAr6z3+gc0wN+IU58a3/DITvdvz4eY+zZh6RB4VrEc4e9rrZq
	 O5LIuuAFb9lqI/QeVjnJyRUi9OnH7arBExXgE7gg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Ruiz <aruiz@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.6 0321/1266] fuse: fix device node leak in cuse_process_init_reply()
Date: Tue, 21 Jul 2026 17:12:38 +0200
Message-ID: <20260721152449.020373760@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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


