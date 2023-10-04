Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16F811C29E
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:36:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t52W/P+c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B6ACC433CC;
	Wed,  4 Oct 2023 18:36:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444618;
	bh=kVyO4DCYCRZm+LKPuRnONRFoWXzM96TOh/oyqN09kTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=t52W/P+cIdho6j+YwT99h9gOxaD3goCn3tcqUWOpk882uqAmnHoh2sFQIKQQO+YNo
	 8RlvIoaDLuc3txRwDlMSFxkOIINK2QIn11uBCuiPnt2mjihUy6sQoHQlu0JhxObeW9
	 YHRHiAr5/JejjTklsDyJwc6S+NhvJ3zh8OLho3wc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 6.5 315/321] rbd: move rbd_dev_refresh() definition
Date: Wed,  4 Oct 2023 19:57:40 +0200
Message-ID: <20231004175243.871019590@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 0b035401c57021fc6c300272cbb1c5a889d4fe45 upstream.

Move rbd_dev_refresh() definition further down to avoid having to
move struct parent_image_info definition in the next commit.  This
spares some forward declarations too.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   68 +++++++++++++++++++++++++---------------------------
 1 file changed, 33 insertions(+), 35 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -633,8 +633,6 @@ static void rbd_dev_remove_parent(struct
 
 static int rbd_dev_refresh(struct rbd_device *rbd_dev);
 static int rbd_dev_v2_header_onetime(struct rbd_device *rbd_dev);
-static int rbd_dev_header_info(struct rbd_device *rbd_dev);
-static int rbd_dev_v2_parent_info(struct rbd_device *rbd_dev);
 static const char *rbd_dev_v2_snap_name(struct rbd_device *rbd_dev,
 					u64 snap_id);
 static int _rbd_dev_v2_snap_size(struct rbd_device *rbd_dev, u64 snap_id,
@@ -4931,39 +4929,6 @@ static void rbd_dev_update_size(struct r
 	}
 }
 
-static int rbd_dev_refresh(struct rbd_device *rbd_dev)
-{
-	u64 mapping_size;
-	int ret;
-
-	down_write(&rbd_dev->header_rwsem);
-	mapping_size = rbd_dev->mapping.size;
-
-	ret = rbd_dev_header_info(rbd_dev);
-	if (ret)
-		goto out;
-
-	/*
-	 * If there is a parent, see if it has disappeared due to the
-	 * mapped image getting flattened.
-	 */
-	if (rbd_dev->parent) {
-		ret = rbd_dev_v2_parent_info(rbd_dev);
-		if (ret)
-			goto out;
-	}
-
-	rbd_assert(!rbd_is_snap(rbd_dev));
-	rbd_dev->mapping.size = rbd_dev->header.image_size;
-
-out:
-	up_write(&rbd_dev->header_rwsem);
-	if (!ret && mapping_size != rbd_dev->mapping.size)
-		rbd_dev_update_size(rbd_dev);
-
-	return ret;
-}
-
 static const struct blk_mq_ops rbd_mq_ops = {
 	.queue_rq	= rbd_queue_rq,
 };
@@ -7043,6 +7008,39 @@ err_out_format:
 	return ret;
 }
 
+static int rbd_dev_refresh(struct rbd_device *rbd_dev)
+{
+	u64 mapping_size;
+	int ret;
+
+	down_write(&rbd_dev->header_rwsem);
+	mapping_size = rbd_dev->mapping.size;
+
+	ret = rbd_dev_header_info(rbd_dev);
+	if (ret)
+		goto out;
+
+	/*
+	 * If there is a parent, see if it has disappeared due to the
+	 * mapped image getting flattened.
+	 */
+	if (rbd_dev->parent) {
+		ret = rbd_dev_v2_parent_info(rbd_dev);
+		if (ret)
+			goto out;
+	}
+
+	rbd_assert(!rbd_is_snap(rbd_dev));
+	rbd_dev->mapping.size = rbd_dev->header.image_size;
+
+out:
+	up_write(&rbd_dev->header_rwsem);
+	if (!ret && mapping_size != rbd_dev->mapping.size)
+		rbd_dev_update_size(rbd_dev);
+
+	return ret;
+}
+
 static ssize_t do_rbd_add(const char *buf, size_t count)
 {
 	struct rbd_device *rbd_dev = NULL;


