Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793216374;
	b=jnxL9Qg1nzPTFPZL/EY8n3e1Ym538Fk3sVKpEOz3zATzWxBVXKazQJHpQBPRZueXheK8
	 hR7i4+ZQEFBD65O4N/1lbRu/Px+vdj//s14hLrbkyiXSPTy2b4ff42U7LakRzPVk3q9ES
	 s1YpvpYR8K32flOpuqqx1YJ6l+BRrmyyCvkOdfqlnKGPzgSZoxlz94nCmXDmUJ/tw75vo
	 db1KcV8cxlqdgEF/RW78nfmO/xWyQhrJoIm+FTIejR1NRRp+SdaDcXjhtFxz9v45U/FwY
	 R3MK16P0pZut92amg4LaHmDZtPmB+FU9gPt2aAJ1TFrobGT7m0CqibKPZLtutdia92g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793216374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=CBnX2U456DB2DFHdREKtkl6t/Nv2moM3Hga8bl7H2+Q=;
	b=ABx2LaxJzKscrIN5KXI7R+n15HqMhAGDrZOps+26HCovxfKhl7zZX/DFBmxjLu+Wp+SQ
	 b+XC8Ai0HayrEaDy3v3GFUxD6zWsz5w7NY36BbTRwmxLvqel5Y0IL4oBsVD04Npxzrzji
	 Kj62a9y+vk/kmhSKeHrvmwYDPgXA7TiKbmwt42B+Q1/A0KsQHVhN6dDe5m6tS//siMzTw
	 p6zH6xCwfTcsBAv3oX5rh5L2XumyccjZRQr4fdDTqSkLmLBvNw4wFm68IlYENlrKT6dVC
	 iJzqc+Z4dLVSm1hlFq9UKwkCSiVJ8uOAPSNhe3+ojQAkpiz4jFXDi4raZLfTdlMTuQQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hm3pFeV6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D604606A31C;
	Wed, 28 Oct 2026 19:39:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Hm3pFeV6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CC61F01825;
	Wed, 28 Oct 2026 19:39:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793216374;
	bh=CBnX2U456DB2DFHdREKtkl6t/Nv2moM3Hga8bl7H2+Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Hm3pFeV6/Cv2G8CstzUzg67HgtzIaVgAPuynmUQ9TICF1aEDik5v9T+RW+Mffgsmc
	 DXoBuCrBC7/vXMz58bx15lICMjjyPlquvHJVmIypPd+j/nzZ4SMTujF9DBifG7NUH7
	 C8t3H+gonIdhyQPOarLaPCbVBXTAkcu4ulGPj0s0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	ZhangGuoDong <zhangguodong@kylinos.cn>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1534/1887] pnfs/blocklayout: Fix device leaks on parse failure
Date: Wed, 28 Oct 2026 18:00:30 +0100
Message-ID: <20261028170534.372699773@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index fc64139536002..09f4d9d1960a1 100644
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
 			blkdev_put(dev->bdev, FMODE_READ | FMODE_WRITE);
+			dev->bdev = NULL;
+		}
 	}
 }
 
@@ -375,6 +379,7 @@ bl_parse_scsi(struct nfs_server *server, struct pnfs_block_dev *d,
 
 out_blkdev_put:
 	blkdev_put(d->bdev, FMODE_READ | FMODE_WRITE);
+	d->bdev = NULL;
 	return error;
 }
 
@@ -410,8 +415,11 @@ bl_parse_concat(struct nfs_server *server, struct pnfs_block_dev *d,
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
@@ -439,8 +447,11 @@ bl_parse_stripe(struct nfs_server *server, struct pnfs_block_dev *d,
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



