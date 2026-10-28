Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211527;
	b=ot1OU6Hnweiwby8BOPSlhjdHygoAmk1s4Cah2bXf3IYndzT8i9O9PS+mxYAqpce2vq89
	 BGAF0zZ5WmNgidJ3MMxjnFFvYo0iPm/WYf5G5fyQcknU3Afx0jSkQEBczG4NSK9x3mnhh
	 VIi9w/HrpB3kV1tN7XP9+TTwL6tjYi033fzTLmql29tz5PI1UJfaOGWW/z0DDBwynjFDA
	 kAT0AnqYqsmaT9DDYjbh4O7ULjdBQOQNup2YH7EAHLa/xR4aB2arQq6NCfk5PD7Kelplh
	 BRGfR8Pi+vk15fQSDgZlYsd83NAybmKHL7nDjON/xlRjfQvoQ9ld4j+JuiRFY/QpDCA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211527;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5Gs+JzZRYI3BmdS9Slg+MFYG+dJ8wPvdIggV9Fv0yFs=;
	b=Dqc9KIQtQM4LSPJW1p8qlt5QoMKEaRClIqwuHLcmYBxEgm6kxRSYHsJWGPkKTyhfPGkX
	 HuhVw5DJm9WQGdGdlYwNTdJjeRdblSZuIfRLPbTsFtShHKILL+orpTttthaoS4QSj9wJO
	 dmn5IxtYxGVpKFUirSW3f1/qs7UcX5PBrCWkhSQxZ3y88adbZ4y4IGGPMSXX5ojh2+v9j
	 OnVBP5/OdpDRnE58p+6AGLr5K2inkU4QAHFJYdREdrrcLcpLi29yzwRf+8DV+hK4vN3V6
	 LM4zWt8W2EAXWf4AtwkQITw6QoSvt38S1mRQ9wmZ35tsuxKPsStMDqER3H5XOuX+9IA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziV2SI3G;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64D78606A31D;
	Wed, 28 Oct 2026 18:18:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ziV2SI3G
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60AD1F01825;
	Wed, 28 Oct 2026 18:18:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211527;
	bh=5Gs+JzZRYI3BmdS9Slg+MFYG+dJ8wPvdIggV9Fv0yFs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ziV2SI3GTIvWI+FercCgX0Wau03AaU175Rea8128EP7ytExIwq8ODd+bny4Q7gotg
	 PuwKVONPcJXM4Ct1xoiQj+auD7ZhoBZ524qFxeIdZdBEGEGu76w9Qn9QWYw5V2wDkE
	 NaUG4evgVNfb5OSy5VWUBCcVmwY0uVDpu9hAxmFE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+e9c76b56dc05023b8117@syzkaller.appspotmail.com,
	Xue Lei <Xue.Lei@windriver.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 407/571] mtd: fix double free and WARN_ON in add_mtd_device() error paths
Date: Wed, 28 Oct 2026 17:59:14 +0100
Message-ID: <20261028170017.670119715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xue Lei <Xue.Lei@windriver.com>

commit 9d4af746af8ce27eefc2338b2feaa1e01f28b6c3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/mtdcore.c |   23 +++++++++++++++++++----
 1 file changed, 19 insertions(+), 4 deletions(-)

--- a/drivers/mtd/mtdcore.c
+++ b/drivers/mtd/mtdcore.c
@@ -102,6 +102,15 @@ static void mtd_release(struct device *d
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
@@ -700,10 +709,8 @@ int add_mtd_device(struct mtd_info *mtd)
 	dev_set_drvdata(&mtd->dev, mtd);
 	of_node_get(mtd_get_of_node(mtd));
 	error = device_register(&mtd->dev);
-	if (error) {
-		put_device(&mtd->dev);
+	if (error)
 		goto fail_added;
-	}
 
 	/* Add the nvmem provider */
 	error = mtd_nvmem_add(mtd);
@@ -730,8 +737,16 @@ int add_mtd_device(struct mtd_info *mtd)
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


