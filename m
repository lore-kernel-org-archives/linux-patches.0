Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 275DF42D76F;
	Thu, 16 Jul 2026 14:34:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784212485; cv=none; b=k36iofozcgby8AgUE/JKQMF7x4GlIB2CZvcieuA0O+cvARyXluut1Zvfwi6AdP0oL3CL78qJkaxgYJUbyDoaf/FktbhIEJmX7El9mTiQbusjkm76LN5GB1MOs0q4MTrwN3ojNz1Pn7+Wn3YnplMNxbRHFxQmS829yvnY+Dr28/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784212485; c=relaxed/simple;
	bh=FZjKhVagkArLY3HbBbIXx2TYyXNm90obJHYnsC/Djrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FGEpHJa0Tb9qj921eTzpCJaCFGcJ3RAfT2gVw6fChikzy2x6NdgM3fdFfPsveiKrmXmlwFEknZwhGCccNji4RtNgzvxEiXRTQ0ZVZaAAQkZPjKrUWipmCqzezg4mL2tKxjXJIrg5pBXChpaA1oy8rkgsqofTddx8gJt0CuQ42D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rCJ9U1ZA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rCJ9U1ZA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D28B1F000E9;
	Thu, 16 Jul 2026 14:34:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784212484;
	bh=UqeFJvBSxVaRJyFYrPPLlnQp3Bs6YrQFm6jb3gwXC1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rCJ9U1ZA/jaIsbiQCCBqDI5Sppt15hfmHZyqZ0IdXhZaUWqwYHCxsHi0uFJ0+sKCO
	 ohuumbbHKiI9OFCorq7DeBx/KRn00w/Wd755FjXys2ofTsQon3bEopJrVK/WO9Qf3+
	 qPaebcf48AfOdtpwcIL7XbqB5F+RORVtcW6YfY8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alberto Ruiz <aruiz@redhat.com>,
	Miklos Szeredi <mszeredi@redhat.com>
Subject: [PATCH 6.12 346/349] fuse: fix device node leak in cuse_process_init_reply()
Date: Thu, 16 Jul 2026 15:34:40 +0200
Message-ID: <20260716133041.047587550@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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
@@ -390,7 +390,7 @@ static void cuse_process_init_reply(stru
 	rc = -ENOMEM;
 	cdev = cdev_alloc();
 	if (!cdev)
-		goto err_unlock;
+		goto err_dev;
 
 	cdev->owner = THIS_MODULE;
 	cdev->ops = &cuse_frontend_fops;
@@ -416,6 +416,8 @@ out:
 
 err_cdev:
 	cdev_del(cdev);
+err_dev:
+	device_del(dev);
 err_unlock:
 	mutex_unlock(&cuse_lock);
 	put_device(dev);


