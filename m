Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41BF6EEC9;
	Tue, 10 Sep 2024 09:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962322; cv=none; b=FQDEQB+4tSaEmy+bPhzGlsmdDzsdwnj4Y9mPLF4Vks2G9siFgRHljsq3IEHqVBbvONFBU+aTxF5SE0UJkNmvnfvfT9y2aBU6D1LHMxL+uxdPPif1OHFOcntCjzqpPHl5NHHstziqg8z2WZLqSDiYcDv+unZ71eqa9w9tk+ug5zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962322; c=relaxed/simple;
	bh=aoCFucY+AEJbQCr9aJNBJuISKOQU3KQv5OuRVEn5bpI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PKzV0jmJi65RAQ+R3QTm4bSUa4gLdaegOujmjUfa6idLKacBqrZcyUIBiajcw2QErAvNXEALImA9aR6JWx79nTrq5HeIDE4pDFYyjLr8MpVmOfG6jO47Tnp5XSnWJnb7jqm0HwKmyTvvJ1NZ+OfQ7ZUZCQ4+tO5MaingEDUF0v4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RR7VCpey; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RR7VCpey"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD7F2C4CEC3;
	Tue, 10 Sep 2024 09:58:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962322;
	bh=aoCFucY+AEJbQCr9aJNBJuISKOQU3KQv5OuRVEn5bpI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RR7VCpeygBfkfaUrX3DWpEB6Ujn3EreAdx+iy8K2vzZU8+m3+ak0a5oIu05nDcMQH
	 82hfO4Gfpf3qoLll/8XMjAW2PenAENewHyvO1B324VFerSeJ4Bof7trxbwzA7Akbo7
	 F1fplfbPX6d3gst8ubbFa2AYC60T+9dIuPQbtih0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 344/375] nvme-pci: allocate tagset on reset if necessary
Date: Tue, 10 Sep 2024 11:32:21 +0200
Message-ID: <20240910092634.145022697@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092622.245959861@linuxfoundation.org>
References: <20240910092622.245959861@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index 146d33c4839f..18d85575cdb4 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2473,6 +2473,12 @@ static unsigned int nvme_pci_nr_maps(struct nvme_dev *dev)
 
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



