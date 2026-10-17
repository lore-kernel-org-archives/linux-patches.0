Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 131C33ACEE0;
	Sat, 17 Oct 2026 16:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255529; cv=none; b=HJmGlynefterZx0UXw5RYx7fwpqTBWqfzAuQ2ZJlRW+QfuSF8AhZ8lT0q1F+1ktwLZSZaC2prilLb66x154OJ+6/4NMct4xoEKLF99pUyZOtzEv7rnRyDD57N3qw5FMck6ymtvDb4dV7+gNK2rc959HrEi9HlAvVrDNKUkJ62p8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255529; c=relaxed/simple;
	bh=48CNgmiyMLTkWD9+nVWuwcZl3RIp4QcplnBOaaK4XsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OPU/F6xtND/zIJSiVJpV95Zq0yz7jkZcFt/rxLg9gE7r1q9RWU06oGrj9pjXKG0aHr9RG+FNnOsH48zYVL8tRvx72i/Xb9/95kO8FZsPehSETWtxkH5U8uaxnDOC39PD/ouyJp5FmEBFMNNsZMu1x++olykPKK7Bh8raf0aS7OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=smCMfZ22; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="smCMfZ22"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 242611F000C4;
	Sat, 17 Oct 2026 16:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255527;
	bh=GhO3Ivfh2Y64PgzItKAxcZ5TSVKPQn5DjH+fecM6MIU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=smCMfZ22Ty413khLYUNIlbaLo6bEngdmKQbXKyd2Jl9NVGyWZU0gOxFBWsh8JAmB8
	 5zYcBArbrAW16pS0xXoqU9FSa2AmDrlpa0G9tD0aP9fw1ehcb+7OR8H/WhcaPbk9iX
	 hTZUuEyQ8iAse/gRTZIGSHjdeJ/PgRU4fR1+vkZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	=?UTF-8?q?Damien=20Ri=C3=A9gel?= <damien.riegel@silabs.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 807/869] greybus: raw: fix use-after-free if write is called after disconnect
Date: Sat, 17 Oct 2026 18:00:48 +0200
Message-ID: <20261017160057.589153946@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Damien Riégel <damien.riegel@silabs.com>

[ Upstream commit 84265cbd96b97058ef67e3f8be3933667a000835 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/greybus/raw.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/greybus/raw.c b/drivers/staging/greybus/raw.c
index e668438e1a2c4..d0fd15af22baa 100644
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
@@ -200,6 +202,7 @@ static int gb_raw_probe(struct gb_bundle *bundle,
 
 	INIT_LIST_HEAD(&raw->list);
 	mutex_init(&raw->list_lock);
+	init_rwsem(&raw->disconnect_lock);
 
 	raw->connection = connection;
 	greybus_set_drvdata(bundle, raw);
@@ -235,6 +238,11 @@ static void gb_raw_disconnect(struct gb_bundle *bundle)
 	struct raw_data *temp;
 
 	cdev_device_del(&raw->cdev, &raw->dev);
+
+	down_write(&raw->disconnect_lock);
+	raw->disconnected = true;
+	up_write(&raw->disconnect_lock);
+
 	gb_connection_disable(connection);
 	gb_connection_destroy(connection);
 
@@ -277,11 +285,22 @@ static ssize_t raw_write(struct file *file, const char __user *buf,
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
-- 
2.53.0



