Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793213923;
	b=cwqq13Y7YxDQ2bU4RdC1yz7G2U3bK30CW0KoEPYBa0im1QrmeCq+DJFF3DeimQkYtq96
	 iFt2aSVZDTfoGoaPg4WPI8TTXDhU57zvxszYfh8lmKH2QSM0tCGwppz2v8GnZq+AtgGcU
	 tzT+1UlNGLQUpKKR/BkuvpdzBIBNMARTyqkHcFnH3LvDSE2kHL612PdwbwwSB5YvE9QVv
	 Udmqh2fiGgGBgmgwH1oGE46N/zoH3Nt9I2K8wcyXg7Z/+U/8Ro0pcBSN38BB+JC7ab/kj
	 gGiuRKqBf28pYrqADxxOvS5HrR3Pgff4xDdsqt/vlpARJYt9f5hI+sEs9NGEu06mJVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793213923;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=glCgXdvPZ/goVrt8x5QLNzmQgV4Qza2fbQEn731MmdI=;
	b=pP62gdIghZYjl2cJvv/61bcUUo87KYUlgnFy3vaVGle22GuPrQ3Mtey5F872zdnYxdP3
	 jao93EY4rI/jCIF6tlW17ModyY3lJQlBaiUSN3HqudVfR6cNyYEAmcbzC1McsdHZsdStl
	 7QfVWoc1D8LZOjIHawWQjDP1Mo2rGDeawyLHgcnTcCjsq3vAd/qdxuQv3L0ZDI7WxG4h0
	 lMz5YQKblu2flYLj+ICEvYT4wz/PM1PZqPD0f6n2g1dLg3nvSxe2v3IkFia8X2I8RCSmq
	 HhXQasMs8SFqYpfuCsVoy3clcii4rGb1bttL3us1hN0BJ4fG/UgRwwbbpw7frUSKgjQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YHdI9+WE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3BA1606A320;
	Wed, 28 Oct 2026 18:58:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=YHdI9+WE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4058F1F01825;
	Wed, 28 Oct 2026 18:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793213922;
	bh=glCgXdvPZ/goVrt8x5QLNzmQgV4Qza2fbQEn731MmdI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YHdI9+WEk9N79wbMJj0nW0iKtMn7VecrHEK23MM8z3hEGcprIp/lm0Yt+jqE53+q0
	 Qbrr1CeoXz838+gAWvtqGDebU8wzGmWlpZuHoA59X0+sR0O0vOIMR8aXUAjiRgUFCW
	 Ijgma+HAHVjP4PTskWiXuHLdeUl2Nc3R4XdjcIQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yi Zhang <yi.zhang@redhat.com>,
	Christoph Hellwig <hch@lst.de>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0678/1887] nvme-pci: fix race condition between reset and nvme_dev_disable()
Date: Wed, 28 Oct 2026 17:46:14 +0100
Message-ID: <20261028170514.839732429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit 26bc0a81f64ce00fc4342c38eeb2eddaad084dd2 ]

nvme_dev_disable() modifies the dev->online_queues field, therefore
nvme_pci_update_nr_queues() should avoid racing against it, otherwise
we could end up passing invalid values to blk_mq_update_nr_hw_queues().

 WARNING: CPU: 39 PID: 61303 at drivers/pci/msi/api.c:347
          pci_irq_get_affinity+0x187/0x210
 Workqueue: nvme-reset-wq nvme_reset_work [nvme]
 RIP: 0010:pci_irq_get_affinity+0x187/0x210
 Call Trace:
  <TASK>
  ? blk_mq_pci_map_queues+0x87/0x3c0
  ? pci_irq_get_affinity+0x187/0x210
  blk_mq_pci_map_queues+0x87/0x3c0
  nvme_pci_map_queues+0x189/0x460 [nvme]
  blk_mq_update_nr_hw_queues+0x2a/0x40
  nvme_reset_work+0x1be/0x2a0 [nvme]

Fix the bug by locking the shutdown_lock mutex before using
dev->online_queues. Give up if nvme_dev_disable() is running or if
it has been executed already.

Fixes: 949928c1c731 ("NVMe: Fix possible queue use after freed")
Tested-by: Yi Zhang <yi.zhang@redhat.com>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/pci.c | 18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index a12d3ad54a1b6..0ed96b0ecb9e3 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -2620,11 +2620,23 @@ static void nvme_pci_alloc_tag_set(struct nvme_dev *dev)
 	dev->ctrl.tagset = set;
 }
 
-static void nvme_pci_update_nr_queues(struct nvme_dev *dev)
+static bool nvme_pci_update_nr_queues(struct nvme_dev *dev)
 {
+	/* Give up if we are racing with nvme_dev_disable() */
+	if (!mutex_trylock(&dev->shutdown_lock))
+		return false;
+
+	/* Check if nvme_dev_disable() has been executed already */
+	if (!dev->online_queues) {
+		mutex_unlock(&dev->shutdown_lock);
+		return false;
+	}
+
 	blk_mq_update_nr_hw_queues(&dev->tagset, dev->online_queues - 1);
 	/* free previously allocated queues that are no longer usable */
 	nvme_free_queues(dev, dev->online_queues);
+	mutex_unlock(&dev->shutdown_lock);
+	return true;
 }
 
 static int nvme_pci_enable(struct nvme_dev *dev)
@@ -2986,8 +2998,8 @@ static void nvme_reset_work(struct work_struct *work)
 		nvme_wait_freeze(&dev->ctrl);
 		if (!dev->ctrl.tagset)
 			nvme_pci_alloc_tag_set(dev);
-		else
-			nvme_pci_update_nr_queues(dev);
+		else if (!nvme_pci_update_nr_queues(dev))
+			goto out;
 		nvme_dbbuf_set(dev);
 		nvme_unfreeze(&dev->ctrl);
 	}
-- 
2.53.0



