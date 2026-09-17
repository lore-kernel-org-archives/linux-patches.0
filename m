Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4424CDDE7;
	Thu, 17 Sep 2026 15:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789658738; cv=none; b=G7ej/dWitQs9cKHlmOKUcT0lssiq5FQORiMAPorhQdxLn1MYt83gm3jIq5GR9AOrV5Gt//QaCNgd3d83ZA9rz3vbcu4aAYVQB1B1Kb7mbR8u5rY34mqmTbSRs71DRUPqtgXWO9XkgYlBli9KzODcm6GYeeN9CABkUmmL0vsQuLU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789658738; c=relaxed/simple;
	bh=ApHb271DyTTS6UMljiYclmpBeXIpc/V9oOhAqef1H78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHSq52rriuRCN86w5br2q8yjcssXC7WssB/PS4GJTYKIs7EOt9veQKYBW7dhiDVtgO1cpYMR/En/dFKpTiRllz32tJnao/fzMMKUvhUGjanFeY3g9vUH+EpfcZHPKVFRJfdZYSxWhX0bf6+Fb5TKXNXrpPHZ6nwQ0c/zlNnQJck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sfDvE0bd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sfDvE0bd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD6F91F008BC;
	Thu, 17 Sep 2026 15:25:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789658725;
	bh=OHPumBSotRKyCm2S5mdEM7F5E/EwhjPc8EmdofeKB2c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=sfDvE0bdzwINPyjhDS0qCyViZGZ0ZSpL0A0BAv8bcILBmQUliTmxKmgqDID9zV/Ou
	 LW6j9LHhuZ+gV8pysEVNbmSpmKwm4XXnAULHsFIeyAbXF8Z47nQU7ut2pTvkVDmqQ1
	 nvPtygJ780+1aVhcdfO4Gj9p0TNhwNnGXMzNdToE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 019/733] nvmet-rdma: fix queue leak when connect backlog is exceeded
Date: Thu, 17 Sep 2026 16:05:27 +0100
Message-ID: <20260917151351.161382005@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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
index de5a88fbb2337..542138fd669f4 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1627,19 +1627,13 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
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
@@ -1648,6 +1642,11 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
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



