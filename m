Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 43736299920;
	Sat, 12 Sep 2026 09:08:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204139; cv=none; b=aKYV4CmcUYrUeMCK57zQ18vXoJYBTZteSdgyEwqfSCJe7XR6+WTAveGKCkLZQi5+XSqkQ2IUVWWpbH/qVKfD6KB119je9saRI+TioQ0++2U64XHZGCR2udqzrE+KdjdM6b6b9aIKoxZVH4lGJEexe+N9ZcrZMPLJbg2rvpV97/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204139; c=relaxed/simple;
	bh=cdlC0fhL1CgFW5gS+VoFlreXHIEfuPWXcyN4/hgc9mc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Zh0mUiuNNRly5Q729GK34cM5FoInkoeX3SaxJMXpiAf81/bk82EFM2H2NdGEOy1gZhIqSShsIdV0lOr+P7t/vgPuBJ9854J8yal4qm1eDcjzEzSq5+WwoB2+G08+lPqgTOsHFa6Mi0MNeeEfsd2uNbwzGuseWJMdrbnoz0hvuF0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JI5z6Xvd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JI5z6Xvd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D6321F000FF;
	Sat, 12 Sep 2026 09:08:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204138;
	bh=b0AL/exC0BTL5TeLoCYnrpldpJ9jq+THI6c1VOXq+Mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JI5z6XvdLcrQfRvWQSCOaNm14BqSIF7ZoK5M1AswNDKJS8SddTxe+cMzAPgPhaDiJ
	 4kx7cPgt0qH6b3D9YpGB/b7iEgKhlLy3L1WCfNe93/c7pJqW2KLNDNvU7NDdqmLtsB
	 OgOfSCLP/0YZJ3+YFAYOvO18+gzKRMgUDCwXTBLw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1549/1815] pnfs/blocklayout: Fix device leaks on parse failure
Date: Sat, 12 Sep 2026 08:54:59 +0200
Message-ID: <20260912065725.363964525@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index bb35f88501cea..db4bb0a6283e5 100644
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
 
@@ -437,6 +439,7 @@ bl_parse_scsi(struct nfs_server *server, struct pnfs_block_dev *d,
 
 out_blkdev_put:
 	fput(d->bdev_file);
+	d->bdev_file = NULL;
 	return error;
 }
 
@@ -472,8 +475,11 @@ bl_parse_concat(struct nfs_server *server, struct pnfs_block_dev *d,
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
@@ -501,8 +507,11 @@ bl_parse_stripe(struct nfs_server *server, struct pnfs_block_dev *d,
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



