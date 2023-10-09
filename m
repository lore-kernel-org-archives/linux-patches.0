Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 795171A71F
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:32:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D60f6bKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE3ECC433C8;
	Mon,  9 Oct 2023 13:32:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696858331;
	bh=xw0IGzGzlV7P4kiDcCPM37TgPMUbwBI5dWYn3K/tUyo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D60f6bKGVGR5gbn3sx5oMzcpEkACZInwGVGUZoBLwwbrbi8siqolLp9uB4Oth5sth
	 rvvyVEsdEpVMPYIJWPB6YUCg+FPXCr15DsmXwLJI5TCdr0zssjM4eSmQx07jkoNVIj
	 TPr65Gh53DeBeX1zpdcWuVEzcRBLITgF+DzvMo1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 089/131] rbd: take header_rwsem in rbd_dev_refresh() only when updating
Date: Mon,  9 Oct 2023 15:02:09 +0200
Message-ID: <20231009130119.091333815@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130116.329529591@linuxfoundation.org>
References: <20231009130116.329529591@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 0b207d02bd9ab8dcc31b262ca9f60dbc1822500d upstream.

rbd_dev_refresh() has been holding header_rwsem across header and
parent info read-in unnecessarily for ages.  With commit 870611e4877e
("rbd: get snapshot context after exclusive lock is ensured to be
held"), the potential for deadlocks became much more real owning to
a) header_rwsem now nesting inside lock_rwsem and b) rw_semaphores
not allowing new readers after a writer is registered.

For example, assuming that I/O request 1, I/O request 2 and header
read-in request all target the same OSD:

1. I/O request 1 comes in and gets submitted
2. watch error occurs
3. rbd_watch_errcb() takes lock_rwsem for write, clears owner_cid and
   releases lock_rwsem
4. after reestablishing the watch, rbd_reregister_watch() calls
   rbd_dev_refresh() which takes header_rwsem for write and submits
   a header read-in request
5. I/O request 2 comes in: after taking lock_rwsem for read in
   __rbd_img_handle_request(), it blocks trying to take header_rwsem
   for read in rbd_img_object_requests()
6. another watch error occurs
7. rbd_watch_errcb() blocks trying to take lock_rwsem for write
8. I/O request 1 completion is received by the messenger but can't be
   processed because lock_rwsem won't be granted anymore
9. header read-in request completion can't be received, let alone
   processed, because the messenger is stranded

Change rbd_dev_refresh() to take header_rwsem only for actually
updating rbd_dev->header.  Header and parent info read-in don't need
any locking.

Cc: stable@vger.kernel.org # 0b035401c570: rbd: move rbd_dev_refresh() definition
Cc: stable@vger.kernel.org # 510a7330c82a: rbd: decouple header read-in from updating rbd_dev->header
Cc: stable@vger.kernel.org # c10311776f0a: rbd: decouple parent info read-in from updating rbd_dev
Cc: stable@vger.kernel.org
Fixes: 870611e4877e ("rbd: get snapshot context after exclusive lock is ensured to be held")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
[idryomov@gmail.com: backport to 5.4: open-code rbd_is_snap(), preserve
 rbd_exists_validate() call]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/rbd.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/drivers/block/rbd.c b/drivers/block/rbd.c
index e86dca49fae71..7117fa4902435 100644
--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -7001,7 +7001,19 @@ static void rbd_dev_update_header(struct rbd_device *rbd_dev,
 	rbd_assert(rbd_image_format_valid(rbd_dev->image_format));
 	rbd_assert(rbd_dev->header.object_prefix); /* !first_time */
 
-	rbd_dev->header.image_size = header->image_size;
+	if (rbd_dev->header.image_size != header->image_size) {
+		rbd_dev->header.image_size = header->image_size;
+
+		if (rbd_dev->spec->snap_id == CEPH_NOSNAP) {
+			rbd_dev->mapping.size = header->image_size;
+			rbd_dev_update_size(rbd_dev);
+		}
+	}
+
+	if (rbd_dev->spec->snap_id != CEPH_NOSNAP) {
+		/* validate mapped snapshot's EXISTS flag */
+		rbd_exists_validate(rbd_dev);
+	}
 
 	ceph_put_snap_context(rbd_dev->header.snapc);
 	rbd_dev->header.snapc = header->snapc;
@@ -7059,11 +7071,9 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 {
 	struct rbd_image_header	header = { 0 };
 	struct parent_image_info pii = { 0 };
-	u64 mapping_size;
 	int ret;
 
-	down_write(&rbd_dev->header_rwsem);
-	mapping_size = rbd_dev->mapping.size;
+	dout("%s rbd_dev %p\n", __func__, rbd_dev);
 
 	ret = rbd_dev_header_info(rbd_dev, &header, false);
 	if (ret)
@@ -7079,22 +7089,13 @@ static int rbd_dev_refresh(struct rbd_device *rbd_dev)
 			goto out;
 	}
 
+	down_write(&rbd_dev->header_rwsem);
 	rbd_dev_update_header(rbd_dev, &header);
 	if (rbd_dev->parent)
 		rbd_dev_update_parent(rbd_dev, &pii);
-
-	if (rbd_dev->spec->snap_id == CEPH_NOSNAP) {
-		rbd_dev->mapping.size = rbd_dev->header.image_size;
-	} else {
-		/* validate mapped snapshot's EXISTS flag */
-		rbd_exists_validate(rbd_dev);
-	}
-
-out:
 	up_write(&rbd_dev->header_rwsem);
-	if (!ret && mapping_size != rbd_dev->mapping.size)
-		rbd_dev_update_size(rbd_dev);
 
+out:
 	rbd_parent_info_cleanup(&pii);
 	rbd_image_header_cleanup(&header);
 	return ret;
-- 
2.40.1



