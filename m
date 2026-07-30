Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE00037A85D;
	Thu, 30 Jul 2026 15:31:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425513; cv=none; b=dGJshFHQvQHy1ghgyyqIYi4T5CExCAeEK9PpLkywrYNFJrygdmUk2/YtlIdgCUB9jxWdd8cwIFMHiwRraUgmfWfUsJ7UpXt3CLGlnXmlrSWMj/EpfIW+U4I/fVVW7Xq2fV6PSvexUUUa+Mo+5Z6M3QUg85V6WEuTbvFTkhQ3pi4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425513; c=relaxed/simple;
	bh=buSVuCLFkqlwgqIvbZ99TF4aP6WgDjZcsyKdIS8XcLU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XKGZOvcZwy5p5e8XkkaY+x4M+vuKdqdrChLej9+lhvPwRXoYPCl/CdTSKv7o6Dk6331jcMqFDUKdRL4/rOSc/euUnn0BUWT96JJKGsUmEy6FA2+nJYWZ4UCz27c5kmcVKJ6++DZKeeExdnOu5NtFUZWm4rhdeFDaewxoCcu3pIc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f5cHbhoa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f5cHbhoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44BD81F000E9;
	Thu, 30 Jul 2026 15:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425511;
	bh=K7xt8Tf3lYbG21xiz++4nIS0pTn5L6yGxQEz9dA5HMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f5cHbhoaCtc1XMQv8mZhV6LITvY0lczt57SqJqukRYPMgoSKb60l5IAL/+nNLxtGV
	 xlFo8/56xGB4oQRqr+KYp4NxMOWcN8W9LPB1lqRdSgGgAVAAXmJeHVKqbB0QnZXCCV
	 qXKkzuRkEqBgHSXbXVGYhsvnhaAqrgJcsta12770=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e9c76b56dc05023b8117@syzkaller.appspotmail.com,
	Xue Lei <Xue.Lei@windriver.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/602] mtd: fix double free and WARN_ON in add_mtd_device() error paths
Date: Thu, 30 Jul 2026 16:07:22 +0200
Message-ID: <20260730141437.056256317@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

From: Xue Lei <Xue.Lei@windriver.com>

[ Upstream commit 9d4af746af8ce27eefc2338b2feaa1e01f28b6c3 ]

When device_register() or mtd_nvmem_add() fails inside
add_mtd_device() for a partition, the error handling triggers
mtd_release() via put_device() or device_unregister(). mtd_release()
calls release_mtd_partition() which frees the mtd_info structure.
However, callers such as mtd_add_partition() and add_mtd_partitions()
also call free_partition() in their error paths, resulting in a double
free.

Additionally, release_mtd_partition() hits WARN_ON(!list_empty(
&mtd->part.node)) because the partition node is still linked in the
parent's partitions list when the release callback fires from the
add_mtd_device() error path.

Fix this by overriding dev->type and dev->release before put_device()
in the error paths, so that device_release() invokes a no-op function
instead of mtd_release(). For the mtd_nvmem_add() failure case,
device_unregister() is replaced with device_del() to separate the
device removal from the final kobject reference drop, allowing the
override to take effect before put_device() is called.

The callers' error paths (list_del + free_partition) remain the sole
owners of mtd_info lifetime on add_mtd_device() failure, which is the
expected contract.

The normal partition teardown path is not affected: del_mtd_device()
goes through kref_put() -> mtd_device_release() -> device_unregister()
with dev->type still set to &mtd_devtype, so mtd_release() ->
release_mtd_partition() continues to work correctly for the regular
removal case.

Reported-by: syzbot+e9c76b56dc05023b8117@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e9c76b56dc05023b8117
Fixes: 19bfa9ebebb5 ("mtd: use refcount to prevent corruption")
Signed-off-by: Xue Lei <Xue.Lei@windriver.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/mtdcore.c | 23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/mtdcore.c b/drivers/mtd/mtdcore.c
index 724f917f91bac0..0c8e8eb5f0f3d8 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -104,6 +104,15 @@ static void mtd_release(struct device *dev)
 	device_destroy(&mtd_class, index + 1);
 }
 
+/*
+ * No-op device release used in add_mtd_device() error paths.
+ * Prevents mtd_release() from being called via device_release(),
+ * which would free the mtd_info that the caller still manages.
+ */
+static void mtd_dev_release_nop(struct device *dev)
+{
+}
+
 static void mtd_device_release(struct kref *kref)
 {
 	struct mtd_info *mtd = container_of(kref, struct mtd_info, refcnt);
@@ -746,10 +755,8 @@ int add_mtd_device(struct mtd_info *mtd)
 	mtd_check_of_node(mtd);
 	of_node_get(mtd_get_of_node(mtd));
 	error = device_register(&mtd->dev);
-	if (error) {
-		put_device(&mtd->dev);
+	if (error)
 		goto fail_added;
-	}
 
 	/* Add the nvmem provider */
 	error = mtd_nvmem_add(mtd);
@@ -787,8 +794,16 @@ int add_mtd_device(struct mtd_info *mtd)
 	return 0;
 
 fail_nvmem_add:
-	device_unregister(&mtd->dev);
+	device_del(&mtd->dev);
 fail_added:
+	/*
+	 * Clear type and set nop release to prevent mtd_release() ->
+	 * release_mtd_partition() -> free_partition() from freeing mtd.
+	 * The caller handles cleanup on failure.
+	 */
+	mtd->dev.type = NULL;
+	mtd->dev.release = mtd_dev_release_nop;
+	put_device(&mtd->dev);
 	of_node_put(mtd_get_of_node(mtd));
 	idr_remove(&mtd_idr, i);
 fail_locked:
-- 
2.53.0



