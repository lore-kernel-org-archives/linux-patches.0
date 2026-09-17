Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D36114FC355;
	Thu, 17 Sep 2026 17:14:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665283; cv=none; b=NJ+VboYR+2Y34kNURYungOxpmUjccPDAm/WvpsaMy9Aq0a+lJdMXpKKMBxtoIuOgDl86EQ4bB34bF77jaUnTnUmSvrwm0R0Jj39y5YZGNDO+IZg2qDVnBGlF1JFQbnd6jXKKG3JNgCY2VgVenLOno/MT3Vzb9k4/ESIuKdawvP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665283; c=relaxed/simple;
	bh=riTC/9Ki232pUMSEKfo5n3MeBdwdgA6UVnFC3lRkNU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kn4up5I2FlWJOW9qckjERwhe10n67FfTyqTtmQTWJqp3Ft/UtTdlgCmIAM2HG3/06YlZhruX4QyocGuaubRV3tvjzNXyVIkGw/oQ+xXa9atFyQ8Ywh+7jvRix9C5r9mS7eyM9HNVuEtUl6gq3Pj88nJoFqCrpizSIxuorY4oHVU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T3u9iurf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T3u9iurf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35B3E1F000FF;
	Thu, 17 Sep 2026 17:14:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665281;
	bh=y/YThA2UsqhfOrxPEJi1MVszGCHWVZoN9yvguGRD7w8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=T3u9iurf9Y1Mwmexka2G52e2IvBXwOTVSTwjwR5x4tWgYf9olD8RoSTJYIX0ZoVxN
	 ssethh/Kp8vEEsyjv7SHKDzu+CI8lZKSisVHxZKahZ4f+cOdKTVNX/+ZhN4IBmKJPQ
	 tDVytx9FXoQHzHSFIOB+t29xDUQeLRUXhPvOvW2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0610/1250] nvmet-rdma: fix queue leak when connect backlog is exceeded
Date: Thu, 17 Sep 2026 16:06:45 +0100
Message-ID: <20260917151608.411362051@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

[ Upstream commit fb1ed67788e21832b614c23767a088c08cfdd2f2 ]

When pending disconnecting queues exceed the backlog limit, the
connect path only drops the device reference and leaks the newly
allocated queue and its IB resources.

Fixes: badc53620fe8 ("nvme: target: rdma: fix ndev refcount leak on queue connect")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/rdma.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index 97eb0c61baa14..2b03bce27a88c 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1628,19 +1628,13 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 		mutex_unlock(&nvmet_rdma_queue_mutex);
 		if (pending > NVMET_RDMA_BACKLOG) {
 			ret = NVME_SC_CONNECT_CTRL_BUSY;
-			goto put_device;
+			goto free_queue;
 		}
 	}
 
 	ret = nvmet_rdma_cm_accept(cm_id, queue, &event->param.conn);
-	if (ret) {
-		/*
-		 * Don't destroy the cm_id in free path, as we implicitly
-		 * destroy the cm_id here with non-zero ret code.
-		 */
-		queue->cm_id = NULL;
+	if (ret)
 		goto free_queue;
-	}
 
 	mutex_lock(&nvmet_rdma_queue_mutex);
 	list_add_tail(&queue->queue_list, &nvmet_rdma_queue_list);
@@ -1649,6 +1643,11 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
 	return 0;
 
 free_queue:
+	/*
+	 * Don't destroy the cm_id in free path, as we implicitly
+	 * destroy the cm_id here with non-zero ret code.
+	 */
+	queue->cm_id = NULL;
 	nvmet_rdma_free_queue(queue);
 put_device:
 	kref_put(&ndev->ref, nvmet_rdma_free_dev);
-- 
2.53.0



