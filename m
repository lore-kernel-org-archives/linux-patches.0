Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08E241F759C;
	Tue,  3 Dec 2024 15:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733240134; cv=none; b=X9KHaRfzDCO5m6BvfSl0qVUFb9j+7haPk2c1AP6HGuJadxw9xlWY3RMQL3UzU4bs5tCym8U/WjiFgFy5ocR21NbEk1uWxW2qA1SfsMSL/u505FrY6sVFXNCu8x61GxhZwzpAo4NvbrLQuEhTV7a8sOUoBVbsg+FQ5k/0yiMgaxY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733240134; c=relaxed/simple;
	bh=NHWVEi4rcX3bNWgXSad3tTsf4eICe4ft4yUkW025LKk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ogwtMDWmmV/2w6vMrysxcQTJlotpJQEUiN6cYM8jnypZTSOcmZ59dZlCkaFaDo8VD+Qeo868YEezWi5BdBmpyHpTY/UcUnXBl60oTkIDy0zkAIzk82afIq2csE/h7dg6iT6YezjrRk6ZRiSlOF+SUvces44nLuj3GDhLxWgKnRo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CDAWx96Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CDAWx96Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81902C4CECF;
	Tue,  3 Dec 2024 15:35:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733240133;
	bh=NHWVEi4rcX3bNWgXSad3tTsf4eICe4ft4yUkW025LKk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CDAWx96ZDOEiEqQWGmhCXPn9KLGk2mk//l39dMPdzX75IMi7byIN4usUchss15chG
	 Tj+vpihvj+HR7O/s69kB6kITjIS/dG25bm2jfdZauIJBnibwICWLJO173lRKdoPyZs
	 5ue7kthJqdzzXwO2IF5YnfHiURiIlzW99fU0T3y8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marc Hartmayer <mhartmay@linux.ibm.com>,
	Eric Farman <farman@linux.ibm.com>,
	Cornelia Huck <cohuck@redhat.com>,
	Halil Pasic <pasic@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 005/826] s390/virtio_ccw: Fix dma_parm pointer not set up
Date: Tue,  3 Dec 2024 15:35:32 +0100
Message-ID: <20241203144743.654551103@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Halil Pasic <pasic@linux.ibm.com>

[ Upstream commit 14c7579376279e507e52bf022192b46097a55377 ]

At least since commit 334304ac2bac ("dma-mapping: don't return errors
from dma_set_max_seg_size") setting up device.dma_parms is basically
mandated by the DMA API. As of now Channel (CCW) I/O in general does not
utilize the DMA API, except for virtio. For virtio-ccw however the
common virtio DMA infrastructure is such that most of the DMA stuff
hinges on the virtio parent device, which is a CCW device.

So lets set up the dma_parms pointer for the CCW parent device and hope
for the best!

Fixes: 334304ac2bac ("dma-mapping: don't return errors from dma_set_max_seg_size")
Reported-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Reviewed-by: Eric Farman <farman@linux.ibm.com>
Reviewed-by: Cornelia Huck <cohuck@redhat.com>
Tested-by: Marc Hartmayer <mhartmay@linux.ibm.com>
Link: https://lore.kernel.org/r/20241007201030.204028-1-pasic@linux.ibm.com
Signed-off-by: Halil Pasic <pasic@linux.ibm.com>
Signed-off-by: Heiko Carstens <hca@linux.ibm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/s390/virtio/virtio_ccw.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/s390/virtio/virtio_ccw.c b/drivers/s390/virtio/virtio_ccw.c
index 62eca9419ad76..21fa7ac849e5c 100644
--- a/drivers/s390/virtio/virtio_ccw.c
+++ b/drivers/s390/virtio/virtio_ccw.c
@@ -58,6 +58,8 @@ struct virtio_ccw_device {
 	struct virtio_device vdev;
 	__u8 config[VIRTIO_CCW_CONFIG_SIZE];
 	struct ccw_device *cdev;
+	/* we make cdev->dev.dma_parms point to this */
+	struct device_dma_parameters dma_parms;
 	__u32 curr_io;
 	int err;
 	unsigned int revision; /* Transport revision */
@@ -1303,6 +1305,7 @@ static int virtio_ccw_offline(struct ccw_device *cdev)
 	unregister_virtio_device(&vcdev->vdev);
 	spin_lock_irqsave(get_ccwdev_lock(cdev), flags);
 	dev_set_drvdata(&cdev->dev, NULL);
+	cdev->dev.dma_parms = NULL;
 	spin_unlock_irqrestore(get_ccwdev_lock(cdev), flags);
 	return 0;
 }
@@ -1366,6 +1369,7 @@ static int virtio_ccw_online(struct ccw_device *cdev)
 	}
 	vcdev->vdev.dev.parent = &cdev->dev;
 	vcdev->cdev = cdev;
+	cdev->dev.dma_parms = &vcdev->dma_parms;
 	vcdev->dma_area = ccw_device_dma_zalloc(vcdev->cdev,
 						sizeof(*vcdev->dma_area),
 						&vcdev->dma_area_addr);
-- 
2.43.0



