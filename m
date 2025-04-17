Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9AA57255E34;
	Thu, 17 Apr 2025 18:26:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914402; cv=none; b=bBign6W5ZyU+eYFwm5tNY4VT1de22eyjDcpnf81jdCujMNdvM61By+pmvtzVlNOdMwIN3zh+ge+/lpDOslCQcd8USENpdzC/19R4JsHWFCvR5Fuk2P2NMRWPtPKYOli+ddqsls3Fo5nQK2My6Nsd444y7KNVDm0ACKsGS+IHYz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914402; c=relaxed/simple;
	bh=9ZOzRsitorkf6+CbhWKsFpA/+Z/PRHTZvf+5FslSXNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WJ8je+Bh0tGkCGfCQQ+kuDlR2B6unZIfK67YiPT3e4qa04XuHM5Uceo1BPaI8j++bvelGdiX599NvT5jV1hdgdA+sB1ZlQfbFuUONDKNrH+gTAGbQTemOoppl5RSxyKqE1m8grSz72TcORevhS4lize5hSHGCkouMBG8zeygokE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0INDEhEZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0INDEhEZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACE7CC4CEE4;
	Thu, 17 Apr 2025 18:26:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914402;
	bh=9ZOzRsitorkf6+CbhWKsFpA/+Z/PRHTZvf+5FslSXNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0INDEhEZoPbZL53eQ53yZIgPh0rt/zpwEJRJ/3bN06XriQRgvV9+jUIiwSKoGo/Va
	 V1Win1LILGGW0vSVhjob9bhVNjmbDdUqVJ2zRWvpHGPL9h7mgkOXO9knRqLmZ9EwCT
	 47ezhevbTmPw9y8cqJki9vRUEmHhh6dfLz/4+7Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidenori Kobayashi <hidenorik@chromium.org>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 203/414] media: intel/ipu6: set the dev_parent of video device to pdev
Date: Thu, 17 Apr 2025 19:49:21 +0200
Message-ID: <20250417175119.604088296@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

commit 6f0ab5d3671f7cbb326c8cab6fb69cb7ab9901cc upstream.

The bus_info in v4l2_capability of IPU6 isys v4l2_dev is missing.
The driver didn't set the dev_parent of v4l2_dev, its parent is set
to its parent auxdev which is neither platform nor PCI device, thus
media_set_bus_info() will not set the bus_info of v4l2_capability, then
`v4l2-ctl --all` cannot show the bus_info.

This patch fixes it by setting the dev_parent of video_device and v4l2
framework can detect the device type and set the bus_info instead.

Fixes: 3c1dfb5a69cf ("media: intel/ipu6: input system video nodes and buffer queues")
Cc: stable@vger.kernel.org
Signed-off-by: Hidenori Kobayashi <hidenorik@chromium.org>
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys-video.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys-video.c
@@ -1296,6 +1296,7 @@ int ipu6_isys_video_init(struct ipu6_isy
 	av->vdev.release = video_device_release_empty;
 	av->vdev.fops = &isys_fops;
 	av->vdev.v4l2_dev = &av->isys->v4l2_dev;
+	av->vdev.dev_parent = &av->isys->adev->isp->pdev->dev;
 	if (!av->vdev.ioctl_ops)
 		av->vdev.ioctl_ops = &ipu6_v4l2_ioctl_ops;
 	av->vdev.queue = &av->aq.vbq;


