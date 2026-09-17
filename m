Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 930D34EDCCD;
	Thu, 17 Sep 2026 18:11:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789668694; cv=none; b=FqvuJuFWOtaU/7nfhPl8BdnH/RZn4GRHB22vTkxqRbh5gSMPqtF2byoBMntetmuB33GYZruC9srB60y4T+GS465cTwn0ZojBPmwUIk2tliSBnhvihvXklTwVpaJG3ghJ37sE9b8vbSFl7J8Qm2GDIkl3qKgStRw4P+Q2i6n9IBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789668694; c=relaxed/simple;
	bh=LB8PV01QMIkwWnQNAh/w5oJO61SfAZUmaWtn1jkJ0TM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GknBUp0gmtTaKjgzPi3q1MnDIVnWqaFG4XDQ5NdJp8YAN8TA6LJi1KgxPOdfJVQ4KPsCkBwaG1qUIt6twvqIQIBi1Ds7QdWFdrEyogQE3TOsWQS71cl/L8hcgWfuV/LJRQw4dYS9/kTWRyp36AUoBM2+9113egzpjKNPYkoSoS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RZXez1pd; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RZXez1pd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A49771F000FF;
	Thu, 17 Sep 2026 18:11:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789668693;
	bh=TmlHglOwf7ej1P/Nthogoy2ZBYD3/x71FjzcoKqj54o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RZXez1pdhfHpq7LNKJ1ZCiRcMAIFdKmgSaoozT+QWdK47tmWopOJAY4EJEYNOM44+
	 IkEhc8SEL3OVYFgy6cDVcEuCof12AxDnU7CPYWq9l8DEHSGgNCjr1fKpKUmkLvYYOZ
	 z/9/Nm979LpK8nEGz7TVosjkDbgFLVoEe87OPiwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Xixin Liu <liuxixin@kylinos.cn>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0508/1102] nvmet-rdma: fix queue leak when connect backlog is exceeded
Date: Thu, 17 Sep 2026 16:07:31 +0100
Message-ID: <20260917151552.494177272@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 36eb26c5a05d2..c5227d2670c4b 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -1626,19 +1626,13 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
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
@@ -1647,6 +1641,11 @@ static int nvmet_rdma_queue_connect(struct rdma_cm_id *cm_id,
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



