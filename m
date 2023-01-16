Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC4CB6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:42:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40C61C433EF;
	Mon, 16 Jan 2023 16:42:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887347;
	bh=GWetDyaV9MsbkXIJYuM1k3LAHE6mFz1MD2EPiMZvaxE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xbdCXuUWQXSfF6JEnlmrBykZWTb0+6IQHC0EEetbBup42ZoA54lUldRqPOtepj+MS
	 ks1zSvorFMXEQ7jOO8E4S8ubM/b6QtUmrFO+YR6RNyyvrXSCy6lzn1VFC17kZ/UGxI
	 bqrH2e+373ANnziRLn3Y+xSpWYcY8Bz0Hofxp/JM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 115/521] drbd: remove call to memset before free device/resource/connection
Date: Mon, 16 Jan 2023 16:46:17 +0100
Message-Id: <20230116154852.375175560@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
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

[ Upstream commit 6e7b854e4c1b02dba00760dfa79d8dbf6cce561e ]

This revert c2258ffc56f2 ("drbd: poison free'd device, resource and
connection structs"), add memset is odd here for debugging, there are
some methods to accurately show what happened, such as kdump.

Signed-off-by: Wang ShaoBo <bobo.shaobowang@huawei.com>
Link: https://lore.kernel.org/r/20221124015817.2729789-2-bobo.shaobowang@huawei.com
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 3ae718aa6b39..1ff5af6c4f3f 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2258,7 +2258,6 @@ void drbd_destroy_device(struct kref *kref)
 		kref_put(&peer_device->connection->kref, drbd_destroy_connection);
 		kfree(peer_device);
 	}
-	memset(device, 0xfd, sizeof(*device));
 	kfree(device);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
@@ -2351,7 +2350,6 @@ void drbd_destroy_resource(struct kref *kref)
 	idr_destroy(&resource->devices);
 	free_cpumask_var(resource->cpu_mask);
 	kfree(resource->name);
-	memset(resource, 0xf2, sizeof(*resource));
 	kfree(resource);
 }
 
@@ -2748,7 +2746,6 @@ void drbd_destroy_connection(struct kref *kref)
 	drbd_free_socket(&connection->data);
 	kfree(connection->int_dig_in);
 	kfree(connection->int_dig_vv);
-	memset(connection, 0xfc, sizeof(*connection));
 	kfree(connection);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
-- 
2.35.1



