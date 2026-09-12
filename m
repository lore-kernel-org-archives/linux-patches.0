Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C94332EC09B;
	Sat, 12 Sep 2026 13:10:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218626; cv=none; b=raneV2KOSrLQVDxytKvajg5UDmZPboQ03NbN+xl7qgj+zvJGMsFTNSMA0qdFGwp3S+L5y1xAYJ1D3m8SeRq6s7XifRVidYEYp/4Yf7PlqpI5H0B1DN34Xa6wSOf+hakIM61ItNI0d1Mz6SJT/jlEFS5dyFzDF55v24lXJRo395k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218626; c=relaxed/simple;
	bh=Cvg7BtQ4lTbgW70OpxaKkuQOauIV7b4/qXjvCEi0PwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeGCXKzDGe0HDFTgXAGlQcGm55ByNKzgkcPZuaFnrXMCSUOE6zkxcaMxncTvKvH33keeJfvMd+ZQhUZ2P2xwoki9brbTk3OJ5XASjAEBd53zSXYl2iulerPHPNtg9NabqXpjF9hkY2odP3mK5uvNvi7KpgfQnzex5zHsBxvQcro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vdw97NQ0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vdw97NQ0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49C421F000FF;
	Sat, 12 Sep 2026 13:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218625;
	bh=25Fj/T9tLSFJfaPxH+QXWG9xgcss36pmz6kf+C1hvGw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vdw97NQ06uvzeg1vaDw0+leJTbNIymPM31sodHTMwvh4h3TSEVhNqJAfgNywlsW8R
	 /csHX3edWFrNPAJnQWwsXW+iqElyvwseVQHnspJ1+YBjPUblvwgoWFdZeG+KWQVTQ+
	 vv6m+PEy7HjNuxmG7a8ZywU3BNv7eqro4bbWdqHA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1183/1376] pnfs/blocklayout: Fix device leaks on parse failure
Date: Sat, 12 Sep 2026 09:00:09 +0200
Message-ID: <20260912065633.917150768@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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
index 22d4529c61933..0d04952454b6d 100644
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



