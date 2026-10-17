Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B285F384CED;
	Sat, 17 Oct 2026 17:59:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792259983; cv=none; b=jxN/QOPLgdWp36zQ/vvlXC8Yd9utm1xnXHfDevsfxXaCJYG+dN8mBZZ9s+yCCrp3xNnGtLSorNSHk6QJjTwY7pUvS9h1GbwKOxTp01gG2DEsD8w3sW6kpLdMqDplxKjdwQENj8m+qNHPfE2HoL1/xIcFNz9J/U5O1ldVFG5DNow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792259983; c=relaxed/simple;
	bh=Bmx6+iSqq646wWuQhQ1Dt69M8oBiUFpmUQ0kswEWHy4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F1ee8fXbBfdzqrYNVMcRNzVUH9hvgqaOnzxoD3X1/1B/TEYKK0Zbnqa/X7cya0SnUOJAvL2iFcVv6yes153cs3L2k6noxZ/NNGEUB2c4VvL1htdpRESHPycVl5LtNb818gKVZjKYIe2CO8XYN3PIJ5k+SHxobHXuxx/CVLW0c/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0LX82ML6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0LX82ML6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C44911F000C4;
	Sat, 17 Oct 2026 17:59:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792259982;
	bh=rN11ppB7pXhgkqLO205KXpqYpCFu+K2ZyfionyEyLh4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0LX82ML6yV/dvirYBlwQYey0Jj+OVEHdtH5zIRALpW+iQu1ib+kLfMCmhf+CZfqvA
	 cWE7vOHcL937pNivbth0k+jORO9xjFVdn46Nhq7AxlxJlQeuuEXFvAWoOBz0DPmkHX
	 ikTnXASzh0p+hQkXD8ankKnhGTBvYWXJAncDxEck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1393/1674] pnfs/blocklayout: Fix device leaks on parse failure
Date: Sat, 17 Oct 2026 18:01:05 +0200
Message-ID: <20261017160506.926993891@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

From: ZhangGuoDong <zhangguodong@kylinos.cn>

[ Upstream commit c056f817e4200fb18079d5052c273a22f191ff0a ]

bl_parse_concat() and bl_parse_stripe() allocate a child device array and
then parse each child in turn.  If parsing a child fails, the failed child is
not counted in nr_children and the parent may be left with a children array
that bl_free_device() will not release when nr_children is zero.

Release the failed child and the already parsed children before returning the
error.  Also make bl_free_device() release the child array whenever the
children pointer is set, so that partially initialised concat or stripe
devices are cleaned up correctly.

bl_parse_scsi() can also fail after assigning d->bdev_file and dropping the
file reference.  Clear the pointer after fput() so that an outer cleanup path
does not put it again.

Fixes: 5c83746a0cf2 ("pnfs/blocklayout: in-kernel GETDEVICEINFO XDR parsing")
Signed-off-by: ZhangGuoDong <zhangguodong@kylinos.cn>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/blocklayout/dev.c | 19 +++++++++++++++----
 1 file changed, 15 insertions(+), 4 deletions(-)

diff --git a/fs/nfs/blocklayout/dev.c b/fs/nfs/blocklayout/dev.c
index 61ee0b6c0fba2..9bb745ad8976c 100644
--- a/fs/nfs/blocklayout/dev.c
+++ b/fs/nfs/blocklayout/dev.c
@@ -16,12 +16,14 @@
 static void
 bl_free_device(struct pnfs_block_dev *dev)
 {
-	if (dev->nr_children) {
+	if (dev->children) {
 		int i;
 
 		for (i = 0; i < dev->nr_children; i++)
 			bl_free_device(&dev->children[i]);
 		kfree(dev->children);
+		dev->children = NULL;
+		dev->nr_children = 0;
 	} else {
 		if (dev->pr_registered) {
 			const struct pr_ops *ops =
@@ -34,8 +36,10 @@ bl_free_device(struct pnfs_block_dev *dev)
 				pr_err("failed to unregister PR key.\n");
 		}
 
-		if (dev->bdev)
+		if (dev->bdev) {
 			blkdev_put(dev->bdev, NULL);
+			dev->bdev = NULL;
+		}
 	}
 }
 
@@ -377,6 +381,7 @@ bl_parse_scsi(struct nfs_server *server, struct pnfs_block_dev *d,
 
 out_blkdev_put:
 	blkdev_put(d->bdev, NULL);
+	d->bdev = NULL;
 	return error;
 }
 
@@ -412,8 +417,11 @@ bl_parse_concat(struct nfs_server *server, struct pnfs_block_dev *d,
 	for (i = 0; i < v->concat.volumes_count; i++) {
 		ret = bl_parse_deviceid(server, &d->children[i],
 				volumes, v->concat.volumes[i], gfp_mask);
-		if (ret)
+		if (ret) {
+			bl_free_device(&d->children[i]);
+			bl_free_device(d);
 			return ret;
+		}
 
 		d->nr_children++;
 		d->children[i].start += len;
@@ -441,8 +449,11 @@ bl_parse_stripe(struct nfs_server *server, struct pnfs_block_dev *d,
 	for (i = 0; i < v->stripe.volumes_count; i++) {
 		ret = bl_parse_deviceid(server, &d->children[i],
 				volumes, v->stripe.volumes[i], gfp_mask);
-		if (ret)
+		if (ret) {
+			bl_free_device(&d->children[i]);
+			bl_free_device(d);
 			return ret;
+		}
 
 		d->nr_children++;
 		len += d->children[i].len;
-- 
2.53.0



