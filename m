Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623841;
	b=Uu54fc1+qrkgHieu0f4widZ6bTV/DUval2+Vuorw1ej1nFalzN0du3QhffGZVNUBz270
	 4USZRcIimrOn1UoPoO1qy9WH5ZsLQmJI92M/I9F+ELDUiLDifEtxMIddBW26yS22tfngp
	 TgN0cFZoOH+Zx+tj0eWzNzcoDaf6FTlS37pquid9Ey5aU5yg0sa0ekFCsOs+ZumNFfVzv
	 Mvzy7CMqvIsUGXB6UhNKqtOFhMRPww2fKTJCtoLEBBlgG6RApJAydx0op+gTVT8Zz+GDm
	 Qcp97Fl5BPHJ+WJCwz7s3K+bX8TERq2ANaxr7bHxmyuqG4PNOORo1od5+lDo70UB/Vw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623841;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=jbLprxZX6kws4HsycHZWyYoKFNiL91sny9kG+lssRsU=;
	b=h60FBb/Ku4RCO5PfeeQl2w3dVX6EppxAQMrDbI5H3p8PtQ9Nj/+bBn2NJSAxLXn6z5Br
	 vY9mM99FVz8aQwIY/rPCBq+FbWzxKwHdahmPY5tLSjJPvTZ9ZSCW0qzLKBGjIakSPAkUf
	 6J3qzNaDi97HWQ9Tpgy21YYrgNfm0PkzgpvF8oGMRadDuOG68qBVyaf+SMc+AXUShpmO6
	 ZgD5wo9dr0igwXt7HB2dWkJtYfn38dT+F0c0/GpI7z7UEOEzAJgmxVFEI1M1KMqrOzAo0
	 mZ4j7DU6hjvoh4qyE1KBPn84fheAzGq98wijF0pizsi9qtbYXXTdrTRhNV1Dto//z5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5zL9Re+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1428606A31E;
	Wed, 25 Nov 2026 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Z5zL9Re+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F24EC1F000C4;
	Wed, 25 Nov 2026 16:24:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623841;
	bh=jbLprxZX6kws4HsycHZWyYoKFNiL91sny9kG+lssRsU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z5zL9Re+NNPumALoF6kvmKIakw8f6h+Dct/80MNQHiO4ddy//i+KRKjGwxjOWefYR
	 e+OZimJV6q2Jt1T1VyDbIXrEtzYweCliD12+d50T05lQUmKnhY3qyDIaSgzFjeBRe5
	 VafrZ/ZK0mRIC5R7eA7Xg2NsCClOZxTOezA4oAL8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	=?UTF-8?q?Damien=20Ri=C3=A9gel?= <damien.riegel@silabs.com>
Subject: [PATCH 6.18 990/990] greybus: raw: fix use-after-free if write is called after disconnect
Date: Wed, 25 Nov 2026 15:39:17 +0100
Message-ID: <20261125143845.165631446@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Damien Riégel <damien.riegel@silabs.com>

commit 84265cbd96b97058ef67e3f8be3933667a000835 upstream.

If a user writes to the chardev after disconnect has been called, the
kernel panics with the following trace (with
CONFIG_INIT_ON_FREE_DEFAULT_ON=y):

        BUG: kernel NULL pointer dereference, address: 0000000000000218
         ...
        Call Trace:
         <TASK>
         gb_operation_create_common+0x61/0x180
         gb_operation_create_flags+0x28/0xa0
         gb_operation_sync_timeout+0x6f/0x100
         raw_write+0x7b/0xc7 [gb_raw]
         vfs_write+0xcf/0x420
         ? task_mm_cid_work+0x136/0x220
         ksys_write+0x63/0xe0
         do_syscall_64+0xa4/0x290
         entry_SYSCALL_64_after_hwframe+0x77/0x7f

Disconnect calls gb_connection_destroy, which ends up freeing the
connection object. When gb_operation_sync is called in the write file
operations, its gets a freed connection as parameter and the kernel
panics.

The gb_connection_destroy cannot be moved out of the disconnect
function, as the Greybus subsystem expect all connections belonging to a
bundle to be destroyed when disconnect returns.

To prevent this bug, use a rw lock to synchronize access between write
and disconnect. This guarantees that the write function doesn't try
to use a disconnected connection.

Fixes: e806c7fb8e9b ("greybus: raw: add raw greybus kernel driver")
Reviewed-by: Johan Hovold <johan@kernel.org>
Signed-off-by: Damien Riégel <damien.riegel@silabs.com>
Link: https://patch.msgid.link/20260324140039.40001-2-damien.riegel@silabs.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/staging/greybus/raw.c |   23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

--- a/drivers/staging/greybus/raw.c
+++ b/drivers/staging/greybus/raw.c
@@ -21,6 +21,8 @@ struct gb_raw {
 	struct list_head list;
 	int list_data;
 	struct mutex list_lock;
+	struct rw_semaphore disconnect_lock;
+	bool disconnected;
 	struct cdev cdev;
 	struct device dev;
 };
@@ -200,6 +202,7 @@ static int gb_raw_probe(struct gb_bundle
 
 	INIT_LIST_HEAD(&raw->list);
 	mutex_init(&raw->list_lock);
+	init_rwsem(&raw->disconnect_lock);
 
 	raw->connection = connection;
 	greybus_set_drvdata(bundle, raw);
@@ -235,6 +238,11 @@ static void gb_raw_disconnect(struct gb_
 	struct raw_data *temp;
 
 	cdev_device_del(&raw->cdev, &raw->dev);
+
+	down_write(&raw->disconnect_lock);
+	raw->disconnected = true;
+	up_write(&raw->disconnect_lock);
+
 	gb_connection_disable(connection);
 	gb_connection_destroy(connection);
 
@@ -277,11 +285,22 @@ static ssize_t raw_write(struct file *fi
 	if (count > MAX_PACKET_SIZE)
 		return -E2BIG;
 
+	down_read(&raw->disconnect_lock);
+
+	if (raw->disconnected) {
+		retval = -ENODEV;
+		goto exit;
+	}
+
 	retval = gb_raw_send(raw, count, buf);
 	if (retval)
-		return retval;
+		goto exit;
 
-	return count;
+	retval = count;
+exit:
+	up_read(&raw->disconnect_lock);
+
+	return retval;
 }
 
 static ssize_t raw_read(struct file *file, char __user *buf, size_t count,


