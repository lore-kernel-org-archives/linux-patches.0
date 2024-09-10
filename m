Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC87E191F9E;
	Tue, 10 Sep 2024 10:37:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725964636; cv=none; b=mZwGDDy2M9dQHYi8ujpbfIxI7YcRhLOFzgPGn7qcKsq5PC7u4Z1AkYEj3PRf21m5E1c3KF7BpqeFBPUGW+MCEDlO42MTFPmsgDGSyB8AiyXYxcnVdmnzXKW0kvoMK/tlt0n982dMmpvGmDV5SRWYQHaL4lwOULPZxjaUdw0UaDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725964636; c=relaxed/simple;
	bh=Y9gRSw5TvBA3JhOd4fuS1NEIZDdrMKR2haYrTJWz58Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eSqyNQwof6YUi5BOii61g+KLvxNcbY+AaE/0z+hQeUcYU/4t0V+yUG8t9vtKA1+lOFHpGLw4N1QsNB+nv4FL1EvNGABEjuKbYIvPBySjaH6i8hZUTYRQRwaHYmLTgFgxKiU/ra7y3LKTFfu42S7lMxFcwIEnVSgOiBqhOJxMSio=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ShPzPz9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ShPzPz9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7293AC4CEC3;
	Tue, 10 Sep 2024 10:37:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725964635;
	bh=Y9gRSw5TvBA3JhOd4fuS1NEIZDdrMKR2haYrTJWz58Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ShPzPz9T8UHsIu+3EHJDYX107jC4YBWk56NsxuZoTnDb+h41XIDALHjb+8PWUcSol
	 ryW5q+avRvxVsNdPx0hx5ZscqACp9aeOPWi0/gtke2470taId1POlA7kNd5xmM0fYw
	 +QNA0Dd63PxBuNHMcszlahEibTUnrLrQIyt2MFxQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 250/269] nvme-pci: allocate tagset on reset if necessary
Date: Tue, 10 Sep 2024 11:33:57 +0200
Message-ID: <20240910092616.729281674@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092608.225137854@linuxfoundation.org>
References: <20240910092608.225137854@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Keith Busch <kbusch@kernel.org>

[ Upstream commit 6f01bdbfef3b62955cf6503a8425d527b3a5cf94 ]

If a drive is unable to create IO queues on the initial probe, a
subsequent reset will need to allocate the tagset if IO queue creation
is successful. Without this, blk_mq_update_nr_hw_queues will crash on a
bad pointer due to the invalid tagset.

Fixes: eac3ef262941f62 ("nvme-pci: split the initial probe from the rest path")
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index 89e0798af780..7fc1ab4d9e7d 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2471,6 +2471,12 @@ static unsigned int nvme_pci_nr_maps(struct nvme_dev *dev)
 
 static void nvme_pci_update_nr_queues(struct nvme_dev *dev)
 {
+	if (!dev->ctrl.tagset) {
+		nvme_alloc_io_tag_set(&dev->ctrl, &dev->tagset, &nvme_mq_ops,
+				nvme_pci_nr_maps(dev), sizeof(struct nvme_iod));
+		return;
+	}
+
 	blk_mq_update_nr_hw_queues(&dev->tagset, dev->online_queues - 1);
 	/* free previously allocated queues that are no longer usable */
 	nvme_free_queues(dev, dev->online_queues);
-- 
2.43.0



