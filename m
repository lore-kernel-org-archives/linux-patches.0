Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCA8B3D9DC0;
	Sat, 12 Sep 2026 11:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211523; cv=none; b=cedVqmv8zFaywsot0Zg1Ic/Dtb8jMk8S5UOaXZ7kGMspI/4907y5WX7Y51KYPQjqHJmAbRkLEyh+hGPyB1azI3UuqvEQ4s3fC12LgM9ytIoc274Ltjm1AXFIqmUbZPkseBBQU7/Y4jYtvNFpIXt00KhgWPLlok8z5pghwMgRhqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211523; c=relaxed/simple;
	bh=9jmBKEzSpT5mQX5pOs5xJwlKcl3DkpNIPBf5cQNx9rY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fuUUrZZg+2k50TwVUIVoBo28CrPBubj4JZ7eAmRi6HQvNWdywXoo7XgN5kTnmdZ8simQIrh06OvwB4suJfqUo0CQBoSwAvhOnrWaWax9+hw0E2kc7vU9AhFY2bxMwm3JeYHqE8D2FYBasSFoZJGofGjsrAq51BuHug/tkKWSHX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ju3d7aRr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ju3d7aRr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B99C01F000FF;
	Sat, 12 Sep 2026 11:12:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211522;
	bh=MXfeY2DlPlRVU6bT1/+yJWgfFIAOkHt82+rK69nEbyA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ju3d7aRrgmt6QgQnFic6rty4XzGkA9nL7VzLOk9OO6Sk0DF5cqFhITWqbDfcX/tqm
	 n5b14AnWydNcpKn+Cre6Bsgh8EgSFyWN+GnQh6rrVeHiHaBNoSY+0+pentrMVnLBCq
	 kKmljFl1a/XVzX19mUqU+oIwzKq3BiwYa6/hrZ+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1249/1518] pnfs/blocklayout: Fix device leaks on parse failure
Date: Sat, 12 Sep 2026 08:56:58 +0200
Message-ID: <20260912065651.761488529@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
 fs/nfs/blocklayout/dev.c | 21 +++++++++++++++------
 1 file changed, 15 insertions(+), 6 deletions(-)

diff --git a/fs/nfs/blocklayout/dev.c b/fs/nfs/blocklayout/dev.c
index 134d7f760a33a..4b0d1bb50dd6e 100644
--- a/fs/nfs/blocklayout/dev.c
+++ b/fs/nfs/blocklayout/dev.c
@@ -85,15 +85,17 @@ bl_free_device(struct pnfs_block_dev *dev)
 {
 	bl_unregister_dev(dev);
 
-	if (dev->nr_children) {
+	if (dev->children) {
 		int i;
 
 		for (i = 0; i < dev->nr_children; i++)
 			bl_free_device(&dev->children[i]);
 		kfree(dev->children);
-	} else {
-		if (dev->bdev_file)
-			fput(dev->bdev_file);
+		dev->children = NULL;
+		dev->nr_children = 0;
+	} else if (dev->bdev_file) {
+		fput(dev->bdev_file);
+		dev->bdev_file = NULL;
 	}
 }
 
@@ -434,6 +436,7 @@ bl_parse_scsi(struct nfs_server *server, struct pnfs_block_dev *d,
 
 out_blkdev_put:
 	fput(d->bdev_file);
+	d->bdev_file = NULL;
 	return error;
 }
 
@@ -469,8 +472,11 @@ bl_parse_concat(struct nfs_server *server, struct pnfs_block_dev *d,
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
@@ -498,8 +504,11 @@ bl_parse_stripe(struct nfs_server *server, struct pnfs_block_dev *d,
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



