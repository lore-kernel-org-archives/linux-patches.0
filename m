Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A5411863
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:49:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 947CDC433EF;
	Wed, 28 Dec 2022 15:49:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672242562;
	bh=ssPWlDx4KT8OsUyHxJ8zJkILwGZmpHLVwGJDRafDgjI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HBvm5dpdF2d2FqSlUqKBFLYBQkCwPccDnkGzHRUwGZt0szNlLFCjkTUgZ5MexCDrw
	 UltJhIn4hyMahhTvgPvMBYIRzF6lbcNrrog3cKCIys3wWJAYQbbzn+sbjo9EN298WG
	 XEJmr5ofo4U8ECLMLfG/qIkqKXDim1qE9M3+h5fQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wang ShaoBo <bobo.shaobowang@huawei.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0388/1146] drbd: remove call to memset before free device/resource/connection
Date: Wed, 28 Dec 2022 15:32:07 +0100
Message-Id: <20221228144340.702938896@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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
Stable-dep-of: 8692814b77ca ("drbd: destroy workqueue when drbd device was freed")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/drbd/drbd_main.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/drivers/block/drbd/drbd_main.c b/drivers/block/drbd/drbd_main.c
index 8532b839a343..78cae4e75af1 100644
--- a/drivers/block/drbd/drbd_main.c
+++ b/drivers/block/drbd/drbd_main.c
@@ -2217,7 +2217,6 @@ void drbd_destroy_device(struct kref *kref)
 		kref_put(&peer_device->connection->kref, drbd_destroy_connection);
 		kfree(peer_device);
 	}
-	memset(device, 0xfd, sizeof(*device));
 	kfree(device);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
@@ -2309,7 +2308,6 @@ void drbd_destroy_resource(struct kref *kref)
 	idr_destroy(&resource->devices);
 	free_cpumask_var(resource->cpu_mask);
 	kfree(resource->name);
-	memset(resource, 0xf2, sizeof(*resource));
 	kfree(resource);
 }
 
@@ -2650,7 +2648,6 @@ void drbd_destroy_connection(struct kref *kref)
 	drbd_free_socket(&connection->data);
 	kfree(connection->int_dig_in);
 	kfree(connection->int_dig_vv);
-	memset(connection, 0xfc, sizeof(*connection));
 	kfree(connection);
 	kref_put(&resource->kref, drbd_destroy_resource);
 }
-- 
2.35.1



