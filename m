Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 073172DC321;
	Sat, 12 Sep 2026 15:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789226542; cv=none; b=oyVfY8O6oQiuB8rdJ8mZRGuUsW3pa6SK2ZyJi9sd1fABpxrJIZfPIitlz0SfU5IVhyEhGW/RZgGJ7op75TlvkkvYdgX1CaAl/mRfL8/eL+EorxDUWUtaWKZQ9tvxIPvoyYH7MTYZADsr+CXvzUHcb8sLKiC0/KrzAa/EST/Q9uk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789226542; c=relaxed/simple;
	bh=LDmicALklKbKAFfrvInVSyEHu01S+8LElcsHOQW9qcw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pVejAotiKhZ1XB+syfvmvwwjFVaPaBcPHsVc95cCnuaGANzz2UsN2BieunvNRFS2dWf+DroACn4vBQJu+i8WJh4XlapBgU0Vo+IF/61UC7qRTVoL9Cdop799uA8z4wZTVA7BLkeOB/EFHgRpFdYVwZv5nklaczVaN6+zXpBM8OU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j9OEOaAM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j9OEOaAM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB2531F000FF;
	Sat, 12 Sep 2026 15:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789226540;
	bh=bMhmM3fhIg1klHuNo+y5RlQxrLKlEIldhSBs3e92/kk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=j9OEOaAMkAtJFGvYXgOu7SgPiJEzRRTAlBCNv3YLiw9qMVnyQw5faiCzr2PPAr5r+
	 XpKHu6BwtP4wy8l561N3+3sn+vZoouPr18os74hgTjYkFt5kNpUGsyYp2ob1b8PwhG
	 ivn7gQ0GTj/fy7ij4v/0vOpU+1WBMx2SKsXhSBY4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.6 1424/1424] nvmet-rdma: fix queue leak when connect backlog is exceeded
Date: Sat, 12 Sep 2026 09:04:16 +0200
Message-ID: <20260912065639.147940833@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.279695368@linuxfoundation.org>
References: <20260912065607.279695368@linuxfoundation.org>
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

From: Xixin Liu <liuxixin@kylinos.cn>

commit fb1ed67788e21832b614c23767a088c08cfdd2f2 upstream.

When pending disconnecting queues exceed the backlog limit, the
connect path only drops the device reference and leaks the newly
allocated queue and its IB resources.

Fixes: badc53620fe8 ("nvme: target: rdma: fix ndev refcount leak on queue connect")
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Xixin Liu <liuxixin@kylinos.cn>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/target/rdma.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1628,19 +1628,13 @@ static int nvmet_rdma_queue_connect(stru
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
@@ -1649,6 +1643,11 @@ static int nvmet_rdma_queue_connect(stru
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


