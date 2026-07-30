Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3863643FD01;
	Thu, 30 Jul 2026 15:58:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427088; cv=none; b=aLqURoo3Bwy9m32DJt2aRaVEWvt5jfiTWHrVtGmWBl7CdxvRhSddBPwDM3QU+r8jE2ysq56tT/osQfuVuq2pswHTlMC89ZXmJynsRx2p+LCfmy9ga5O9XnRCuHBfcrOKXAA5lvYd/KqPN5xbtjWMg0TB+DLCgdkPh/h2PPd4XoM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427088; c=relaxed/simple;
	bh=2sgxrekKWIHTdATIfomlWPtW/GBLzkbL3hKec9QGB3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bkoiU80mwmqdyscL8TD5UE0ith17L4xKKFz4A8AJXWUhH8SUBOtQwpcqD6UCHZiGA2j+i+uABnn0J/NiYcyyQV44dJcTvzDyt8GLPoNUqvFMUSPvApxlB/mMJWB++poFRMLdVs/8Y8WlF7PLzLKTodbI+g8e/foaXluflyz9sgo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FPGEVKhV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FPGEVKhV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 949EF1F00A3A;
	Thu, 30 Jul 2026 15:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427087;
	bh=6oJ01fle18pIs6tCQ5H7Yb9uZfIFmAohUPzp5gfhiBI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FPGEVKhVaaESQJurlNF/gRjDPV2H09xwG0TRSGa+L8KyNs68ZyfhQzhSsSD6uVtVl
	 7uREpjFDuW4iQV+4hc4IFDrsOgCxUM/qXmJQoaTC0IycBSI1Svv7ugxhJavpITzqqr
	 O4ENwqn4oL3N9hLw/4vOjUTWqh61DvkzyiPUdOgk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e9c76b56dc05023b8117@syzkaller.appspotmail.com,
	Xue Lei <Xue.Lei@windriver.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 048/484] mtd: fix double free and WARN_ON in add_mtd_device() error paths
Date: Thu, 30 Jul 2026 16:09:05 +0200
Message-ID: <20260730141424.467337911@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 97ca2a897f1d49..506ebd4ba1b458 100644
--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -103,6 +103,15 @@ static void mtd_release(struct device *dev)
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
@@ -745,10 +754,8 @@ int add_mtd_device(struct mtd_info *mtd)
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
@@ -786,8 +793,16 @@ int add_mtd_device(struct mtd_info *mtd)
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



