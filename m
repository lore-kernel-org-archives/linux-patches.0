Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CCB11C26
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:06:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AA24C433D7;
	Wed, 23 Nov 2022 09:06:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669194417;
	bh=o6rk69TqJwlX/1YvnOwi94I6eVeFaPzx3v6Ap0aXeaU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uwWmnzc8neXjPl7u3b4sMxpuzV0iQruQUcVIicwYdCp6w6NRhi9bwn0lsm9XEMZ58
	 ZLkmuTrXcD8ULdmkZMGs6wht7D2DfB2mnvn6AjDhb97cC3mEoIz6g5hVUGSIIMXwev
	 IF1c2BCrvqcbFJlBO2vi7PgtsDJLlYSJa79nCaaI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <error27@gmail.com>,
	=?UTF-8?q?Christoph=20B=C3=B6hmwalder?= <christoph.boehmwalder@linbit.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 071/114] drbd: use after free in drbd_create_device()
Date: Wed, 23 Nov 2022 09:50:58 +0100
Message-Id: <20221123084554.717895497@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084551.864610302@linuxfoundation.org>
References: <20221123084551.864610302@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <error27@gmail.com>

[ Upstream commit a7a1598189228b5007369a9622ccdf587be0730f ]

The drbd_destroy_connection() frees the "connection" so use the _safe()
iterator to prevent a use after free.

Fixes: b6f85ef9538b ("drbd: Iterate over all connections")
Signed-off-by: Dan Carpenter <error27@gmail.com>
Reviewed-by: Christoph Böhmwalder <christoph.boehmwalder@linbit.com>
Link: https://lore.kernel.org/r/Y3Jd5iZRbNQ9w6gm@kili
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index c3e4f9d83b29..3ae718aa6b39 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2770,7 +2770,7 @@ static int init_submitter(struct drbd_device *device)
 enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsigned int minor)
 {
 	struct drbd_resource *resource = adm_ctx->resource;
-	struct drbd_connection *connection;
+	struct drbd_connection *connection, *n;
 	struct drbd_device *device;
 	struct drbd_peer_device *peer_device, *tmp_peer_device;
 	struct gendisk *disk;
@@ -2898,7 +2898,7 @@ enum drbd_ret_code drbd_create_device(struct drbd_config_context *adm_ctx, unsig
 out_idr_remove_vol:
 	idr_remove(&connection->peer_devices, vnr);
 out_idr_remove_from_resource:
-	for_each_connection(connection, resource) {
+	for_each_connection_safe(connection, n, resource) {
 		peer_device = idr_remove(&connection->peer_devices, vnr);
 		if (peer_device)
 			kref_put(&connection->kref, drbd_destroy_connection);
-- 
2.35.1



