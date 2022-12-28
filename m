Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F0421863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 14:57:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 282FDC433EF;
	Wed, 28 Dec 2022 14:57:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672239461;
	bh=lt56AJLZk86KHE/qGuInMKxwISOp594Kw6zKAO5qaFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bdwy78IdXI7kp2qaykBYxBzErIjugFPXDy9LkiRjO5y+T7SBgEXdv5O5EWHSuqC/Z
	 m2UXrlf2GCUnrdY6Tl8WN9/Ot2EP5o7eO4Xdz0WHfg1dBbv7WSuQ1A3ZQR+diyRxLx
	 DAYWK7XHiprsj6nKvMK+3C6VQ6wTETjaE6BxmyPU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 229/731] drbd: destroy workqueue when drbd device was freed
Date: Wed, 28 Dec 2022 15:35:36 +0100
Message-Id: <20221228144303.199209257@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144256.536395940@linuxfoundation.org>
References: <20221228144256.536395940@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Wang ShaoBo <bobo.shaobowang@huawei.com>

[ Upstream commit 8692814b77ca4228a99da8a005de0acf40af6132 ]

A submitter workqueue is dynamically allocated by init_submitter()
called by drbd_create_device(), we should destroy it when this
device is not needed or destroyed.

Fixes: 113fef9e20e0 ("drbd: prepare to queue write requests on a submit worker")
Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lore.kernel.org/r/20221124015817.2729789-3-bobo.shaobowang@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index be819f80884f..eaf20a332401 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2244,6 +2244,8 @@ void drbd_destroy_device(struct kref *kref)
 		kref_put(&peer_device->connection->kref, drbd_destroy_connection);
 		kfree(peer_device);
 	}
+	if (device->submit.wq)
+		destroy_workqueue(device->submit.wq);
 	kfree(device);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
@@ -2797,7 +2799,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 
 	err = add_disk(disk);
 	if (err)
-		goto out_idr_remove_from_resource;
+		goto out_destroy_workqueue;
 
 	/* inherit the connection state */
 	device->state.conn = first_connection(resource)->cstate;
@@ -2811,6 +2813,8 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 	drbd_debugfs_device_add(device);
 	return NO_ERROR;
 
+out_destroy_workqueue:
+	destroy_workqueue(device->submit.wq);
 out_idr_remove_from_resource:
 	for_each_connection_safe(connection, n, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);
-- 
2.35.1



