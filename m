Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2D5D51A6803;
	Tue, 16 Jun 2026 17:08:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781629700; cv=none; b=l9V9Qy+bjZAWvYo02vcNkhNXnARNlXwtjIVznhaFsgIJbaKCpoeioh3nXHMEKtiRkc3MCfE2lwO41WNGdlLmLaSAHk/KhYGMjWZw2H5lBdGQ4/GLX+pQ5lBNjAfXnGrX5bHvMOZgS3Im4/w6g2gGvJ+RVCU5Dz5qPcSBPtiW1Hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781629700; c=relaxed/simple;
	bh=jslLna3qTIk4LYlQNS9YCpQPRFBo0Q8ntExMLD1lu0k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oe6VuqSv+PilwHPSvSyoD982PqNzI4Ju8cjJ9NufD+twu8svJtwGgSJx2YNiIZUynLUtMZIYDx6N8tkVTRAEPOgAXPY3QUWYFJADdG2PlpXJrBqF/twjzrIOrj2ABuUVGl5z2ssCMUkkuXeXcMM9+LkgIQwDbGDWw45kkbUXKWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lpd/oIri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lpd/oIri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF8911F000E9;
	Tue, 16 Jun 2026 17:08:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781629698;
	bh=slFLMSvqWDm1HjcGlT/3waxWDVS1bZiz+YwpmQ5VkbI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lpd/oIriLW5fRUXUgaf+VrDqI2pd71V3tZkKhQW8Dn3i6l+a2f8xFEsbsSj47OTnk
	 JuidtQ+iH3tVyhzOrpptUYIfMOVB+tOECu3+xu1I88BXjCf6OLRopIsp2u9folR4iE
	 rAaB8+EBjS7rbKLYJiX9KUBH+JBYwyzRQHYFQIJY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhenghang Xiao <kipreyyy@gmail.com>,
	Srinivas Kandagatla <srini@kernel.org>
Subject: [PATCH 6.6 334/452] misc: fastrpc: fix use-after-free race in fastrpc_map_create
Date: Tue, 16 Jun 2026 20:29:21 +0530
Message-ID: <20260616145134.895002560@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145117.796205997@linuxfoundation.org>
References: <20260616145117.796205997@linuxfoundation.org>
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

From: Zhenghang Xiao <kipreyyy@gmail.com>

commit 07ebe87915d8accdaba20c4f88c5ae430fe62fbb upstream.

fastrpc_map_lookup returns a raw pointer after releasing fl->lock. The
caller fastrpc_map_create then calls fastrpc_map_get (kref_get_unless_zero)
on this unprotected pointer. A concurrent MEM_UNMAP can free the map
between the lock release and the kref operation, resulting in a
use-after-free on the freed slab object.

Restore the take_ref parameter to fastrpc_map_lookup so the reference
is acquired atomically under fl->lock before the pointer is exposed to
the caller.

Fixes: 10df039834f8 ("misc: fastrpc: Skip reference for DMA handles")
Cc: stable@vger.kernel.org
Signed-off-by: Zhenghang Xiao <kipreyyy@gmail.com>
Signed-off-by: Srinivas Kandagatla <srini@kernel.org>
Link: https://patch.msgid.link/20260530204528.116920-5-srini@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/misc/fastrpc.c |   25 +++++++++++--------------
 1 file changed, 11 insertions(+), 14 deletions(-)

--- a/drivers/misc/fastrpc.c
+++ b/drivers/misc/fastrpc.c
@@ -364,7 +364,7 @@ static int fastrpc_map_get(struct fastrp
 
 
 static int fastrpc_map_lookup(struct fastrpc_user *fl, int fd,
-			    struct fastrpc_map **ppmap)
+			    struct fastrpc_map **ppmap, bool take_ref)
 {
 	struct fastrpc_map *map = NULL;
 	struct dma_buf *buf;
@@ -379,6 +379,12 @@ static int fastrpc_map_lookup(struct fas
 		if (map->fd != fd || map->buf != buf)
 			continue;
 
+		if (take_ref) {
+			ret = fastrpc_map_get(map);
+			if (ret)
+				break;
+		}
+
 		*ppmap = map;
 		ret = 0;
 		break;
@@ -893,19 +899,10 @@ get_err:
 static int fastrpc_map_create(struct fastrpc_user *fl, int fd,
 			      u64 len, u32 attr, struct fastrpc_map **ppmap)
 {
-	struct fastrpc_session_ctx *sess = fl->sctx;
-	int err = 0;
+	if (!fastrpc_map_lookup(fl, fd, ppmap, true))
+		return 0;
 
-	if (!fastrpc_map_lookup(fl, fd, ppmap)) {
-		if (!fastrpc_map_get(*ppmap))
-			return 0;
-		dev_dbg(sess->dev, "%s: Failed to get map fd=%d\n",
-			__func__, fd);
-	}
-
-	err = fastrpc_map_attach(fl, fd, len, attr, ppmap);
-
-	return err;
+	return fastrpc_map_attach(fl, fd, len, attr, ppmap);
 }
 
 /*
@@ -1172,7 +1169,7 @@ cleanup_fdlist:
 	for (i = 0; i < FASTRPC_MAX_FDLIST; i++) {
 		if (!fdlist[i])
 			break;
-		if (!fastrpc_map_lookup(fl, (int)fdlist[i], &mmap))
+		if (!fastrpc_map_lookup(fl, (int)fdlist[i], &mmap, false))
 			fastrpc_map_put(mmap);
 	}
 


