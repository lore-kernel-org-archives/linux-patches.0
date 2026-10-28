Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216142;
	b=TwPntHyrr0xQpzGQE9AUczBe7L4T7fDwSlzk9+XuIdlXpfn3XD3e65FKUWSxncln4mBl
	 EvreiZFOlFtA2WdwyNAcJFVhfFhkXCdSwrNS5loq+n/fCa/ZBSeocjx9nX0zwO6OGPKe+
	 rNC5OjA8qpBIob42FrVWo44AUbNEO2kOv5yZpNT3QiXQyRrG/QO02GDx/D/xQvmNE9ROY
	 idKWR8BcxAefb40hwOy263VyieOpa/544rcobEg18dcE/da+D2wSk6u+K7gDQV692IKfa
	 JGVtfZBCWK/RMHtae2Tk43DUDrMfgh25ihIADhkKzStMZ1/NU4qy717Odw16Vr82M3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216142;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=uEKGsuD6ncQbJ2VBGENhE5uTvc7v9AvuUHnJQVAbwjo=;
	b=c/PRtT8/PsBeapeCfaD1uCwvy0+WBBf2Ny8qJcAgJpRccRZZhIN+uyzRV/+WGGpGbuch
	 4/FHU7Aiok1vO8YSXIWTO9B6qZekM9Eyfulyin7a6rMs/MfeU0xojyw+T0RvpzpMq4rTx
	 uFYVjX5oQ6nS3cdPPzza0Vbb2uiRIinYqEnVgpWsQwRazwKDcSUJw1tAzHvmkBu2HQuFK
	 /3jPQJMBVcVy5TOak+j4IFTJR7HG11ZcacpS/eP+iHsnir47kd92umwyUjmfshb8q2YUX
	 q67n5JViHFjv2WZSYcuTgq5yE4fNEVYkNrqDXYMUwiWsaQ22562oxBx8TD4BgQa3k4A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Vo778E/R";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38E08606A31E;
	Wed, 28 Oct 2026 19:35:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vo778E/R
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 874641F01825;
	Wed, 28 Oct 2026 19:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216142;
	bh=uEKGsuD6ncQbJ2VBGENhE5uTvc7v9AvuUHnJQVAbwjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vo778E/RIrJZ9yFLaT/hn8+LX5HCRO5/uPF57Cvog5o1uE16SqSSeIWmc2UaOOd5v
	 wGfdn/1Ej8M1JYRjCdFqsps9XaJEfsQrf0MFcITpFrIB0ZAPxgNdjbU6VVjEI7rYYd
	 A4f+sehz9n+I+S9tMv/1UzLoqA8Sx2AkcnDStyNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	=?UTF-8?q?Damien=20Ri=C3=A9gel?= <damien.riegel@silabs.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1453/1887] greybus: raw: fix use-after-free if write is called after disconnect
Date: Wed, 28 Oct 2026 17:59:09 +0100
Message-ID: <20261028170532.524838391@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index eb55b54d7d771..ade49fbe9978e 100644
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
@@ -197,6 +199,7 @@ static int gb_raw_probe(struct gb_bundle *bundle,
 
 	INIT_LIST_HEAD(&raw->list);
 	mutex_init(&raw->list_lock);
+	init_rwsem(&raw->disconnect_lock);
 
 	raw->connection = connection;
 	greybus_set_drvdata(bundle, raw);
@@ -232,6 +235,11 @@ static void gb_raw_disconnect(struct gb_bundle *bundle)
 	struct raw_data *temp;
 
 	cdev_device_del(&raw->cdev, &raw->dev);
+
+	down_write(&raw->disconnect_lock);
+	raw->disconnected = true;
+	up_write(&raw->disconnect_lock);
+
 	gb_connection_disable(connection);
 	gb_connection_destroy(connection);
 
@@ -274,11 +282,22 @@ static ssize_t raw_write(struct file *file, const char __user *buf,
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



