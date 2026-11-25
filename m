Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621983;
	b=qjd2NZCujPS53rTYwMNfOe/Y9Ov0sh7LHA+uoRHTaXYPNSuk0H8/+VQMFsNl2TdzQJRh
	 qHjinvS7MoIDqa2hw6+1YSg6/n43nwZENojmlc0C8n3sPoejqNLJRTcw/Y/uOck3lsYUx
	 VmEt7OIpv8XZfj2Nh1cZDFRyQeWOo4e1kV3RIbdhgz0l8Yhu0SZQLC+zzLZIJfZZWupGC
	 1DZAgjZ1fk+sHsg8oXQUfWa52s/0SU3AYUlwZFWM1l47jys75WTKFeZi/I1dlXeidA+b8
	 Al5pvtSMRGek10OamOjgK/I2e2uCfR4oAJ0E73M9CeS6AqUZluQ2MZeQRZeeJgEXBfA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621983;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Sl75g0c9/wXhcmfoBJVekKZyfq4XISi9andxPLwXDI0=;
	b=etzbs9WyOgaN6hp9F4TSNicRlM/voCHdYNF+GX2dky7VqgJVnfhPk16ChqKkpohrGO7N
	 cH26GmitTQcolY1fZtUCU/1JlAPkFzQSlNyz3K8F/cuDFoNEvx7ZN6VcqMA7u3HiWlKM3
	 fqp//90fYap1atNzQQiEGQ5XjblKl5EIQk43IWOXcnAB8JUvxHZH9cGct58PIADZ8Fwqf
	 FB+ZKQOY4qwAlsIh81wfT7SuAYWgjOeshbHDmQaMe6atW0mxiN3GCduaY/+nAMxLhMFAV
	 C/lqWseJagWZ7reCQDIl+098lkl6+NcnZAS9ZCyp+i1VHzKoGNX2wB4Z14vIiy/7ENw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Ab/y3uy6";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13A5C606A31E;
	Wed, 25 Nov 2026 15:53:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Ab/y3uy6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62A0A1F000C0;
	Wed, 25 Nov 2026 15:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621982;
	bh=Sl75g0c9/wXhcmfoBJVekKZyfq4XISi9andxPLwXDI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ab/y3uy6tcZ5PAKMD3g997TfX9Eb3PFF5GzfAAbh8feIc9G9qdR6C8Eb6+GW19f9J
	 zgDKLUIDE7e166l1WAMIu6VRzl+pvmtQ7Ltgptoq1eJZVhAIBol9ek9SxQvjipBLpw
	 dfknbqFEcG2W2oz8XyulqwFeH021vEnhIBdX8oVY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mark Korenberg <socketpair@gmail.com>,
	Ming Lei <tom.leiming@gmail.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 391/990] ublk: publish a new device by its id only once it is set up
Date: Wed, 25 Nov 2026 15:29:18 +0100
Message-ID: <20261125143831.255240385@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mark Korenberg <socketpair@gmail.com>

[ Upstream commit e5c463e5074a940c644d54d8fc29aba06709aab0 ]

ADD_DEV stores the device in ublk_index_idr when it allocates the id,
and control commands find it there as soon as ublk_add_chdev() has
initialized its struct device, before the char device is added. If
dev_set_name() or cdev_device_add() then fails, ublk_add_chdev() drops
the initial reference to free the device. A DEL_DEV that found the
device meanwhile waits for ublk_ctl_mutex, then calls ublk_remove():
cdev_device_del() of a device that was never added, and a second put of
the initial reference, which frees the device under the callers still
holding references.

Reserve the id with a NULL entry, which idr_find() and the idr iterators
skip, and store the device once ublk_add_chdev() succeeded.

Fixes: 71f28f3136af ("ublk_drv: add io_uring based userspace block driver")
Signed-off-by: Mark Korenberg <socketpair@gmail.com>
Reviewed-by: Ming Lei <tom.leiming@gmail.com>
Link: https://patch.msgid.link/20261105-ublk-del-gendisk-hang-v1-1-913a91a4314d@gmail.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index 8db1f9d9272c6..60bc10ca5ef2b 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -2905,14 +2905,18 @@ static int ublk_alloc_dev_number(struct ublk_device *ub, int idx)
 	int i = idx;
 	int err;
 
+	/*
+	 * Only reserve the id: the device is published by
+	 * ublk_publish_dev_number() once it is fully set up.
+	 */
 	spin_lock(&ublk_idr_lock);
 	/* allocate id, if @id >= 0, we're requesting that specific id */
 	if (i >= 0) {
-		err = idr_alloc(&ublk_index_idr, ub, i, i + 1, GFP_NOWAIT);
+		err = idr_alloc(&ublk_index_idr, NULL, i, i + 1, GFP_NOWAIT);
 		if (err == -ENOSPC)
 			err = -EEXIST;
 	} else {
-		err = idr_alloc(&ublk_index_idr, ub, 0, UBLK_MAX_UBLKS,
+		err = idr_alloc(&ublk_index_idr, NULL, 0, UBLK_MAX_UBLKS,
 				GFP_NOWAIT);
 	}
 	spin_unlock(&ublk_idr_lock);
@@ -2923,6 +2927,19 @@ static int ublk_alloc_dev_number(struct ublk_device *ub, int idx)
 	return err;
 }
 
+/*
+ * Make the device visible to control commands by its id. Before its char
+ * device is added, DEL_DEV could find it and remove a char device that was
+ * never added, and drop the reference that ublk_add_chdev() drops on
+ * failure.
+ */
+static void ublk_publish_dev_number(struct ublk_device *ub)
+{
+	spin_lock(&ublk_idr_lock);
+	WARN_ON_ONCE(idr_replace(&ublk_index_idr, ub, ub->ub_number) != NULL);
+	spin_unlock(&ublk_idr_lock);
+}
+
 static void ublk_free_dev_number(struct ublk_device *ub)
 {
 	spin_lock(&ublk_idr_lock);
@@ -3409,6 +3426,8 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 	 * ublk_add_chdev() will cleanup everything if it fails.
 	 */
 	ret = ublk_add_chdev(ub);
+	if (!ret)
+		ublk_publish_dev_number(ub);
 	goto out_unlock;
 
 out_deinit_queues:
-- 
2.53.0



