Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA5011DE3A8;
	Thu, 17 Apr 2025 18:04:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913098; cv=none; b=ghd6PpKVfGqY6zSl+rGr9jHuAq/ph9OynKCsmpRHURFGECzhm6qRB1dAzZSQSccSGvKk9KJTxn0MVvbPXGkeUqPW0zTN7ykPikYX4ejTMXiOr0Ka2vVPddxcPUgTlkLPpYH+VWcOG+Ab+GFXo1SWMKOo37IwxdYOggPLe+/wE3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913098; c=relaxed/simple;
	bh=uUHuDwR3udDFfFCR05tZxJsfC8kh0FO1vMK9B26yaEY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m1loCCaZRgkL4QqRgs3+7ZHZxMmYFcS/trquerg2XkdRcJ6xOxbZCXdFQG+s0/PvkKi8aX9zzHmbUfN6k6j7u5XfANPRzK2eaji05ODy2Xj3liVeGHf5cEZPUXIG2BHup8j4xiSbQkJ51INTBVc9QD5c27a4CfFh74aYThqfbsY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bHEL/S3m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bHEL/S3m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 139D1C4CEE4;
	Thu, 17 Apr 2025 18:04:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913098;
	bh=uUHuDwR3udDFfFCR05tZxJsfC8kh0FO1vMK9B26yaEY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bHEL/S3mzK3TahSqmRs3okHv+h50AuacbaMV6z190rDyEZ2EyF0fTfu/upWWpt9LT
	 KumSBaWbamTT1P+GHuB4uRY71DCX3nKg+Y4u6vc1rR601GwWXPLvkmSs8zA0Z7hv0J
	 QAGVyPfiBafzynrDMKfKmLg1wvOA5uScsK1Yw8pM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hidenori Kobayashi <hidenorik@chromium.org>,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 225/449] media: intel/ipu6: set the dev_parent of video device to pdev
Date: Thu, 17 Apr 2025 19:48:33 +0200
Message-ID: <20250417175127.047050334@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


