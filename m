Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C37017E005;
	Sun,  1 Sep 2024 17:02:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725210149; cv=none; b=iJBR7l1U9zIPl6/EVBEpxnb5/t11mM0DyJl0PKP0XeeZgFVhEetB4OB4J66iWnbgkwxe81EI9oJv1X52JNxHrvVF3193LkT9brKVkH47p+3Y497YWEbhWVVAn0rctF0BaiRq99t0w9G+szrOoYA0UZKuwzu5oTn7dREG1D8REvs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725210149; c=relaxed/simple;
	bh=5LIwOQJJMOT/PbYglCB0tFkZInxkc9bmX2DGa81rYe8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uNbDB0udKElyHl6FderRsidKamcrAtZYZxpcLqz+hlz01wb11Yz9B7sFj0LFit6zpxz9g1fd6UgDIULPGU31v70wM3VtOj9vrUVnyLOPrjPblgLCSA5ZtfALkHMfDNP07O9udWyApQw2nvs7ji+WEAe25SQ7fIsxrYOI0yv0MFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yQCWfZlg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yQCWfZlg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24CC8C4CEC3;
	Sun,  1 Sep 2024 17:02:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725210149;
	bh=5LIwOQJJMOT/PbYglCB0tFkZInxkc9bmX2DGa81rYe8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yQCWfZlgOofVm1VZqhgpvcyUE7NCwJonX67lAOj59MaaKjvS5KqOWGSlJ8u9Ax05O
	 vhc2vQCvL9IYc+YGEUgL2+itK6l2w6Uwb2ZgWVOqNlNTxaOC13o6I0a2+dAeXYapGV
	 WlHEokOTT+drxrY4OAC3jlUF5EiE5BtGtexuik9o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sicong Huang <huangsicong@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 072/215] media: pci: cx23885: check cx23885_vdev_init() return
Date: Sun,  1 Sep 2024 18:16:24 +0200
Message-ID: <20240901160826.074317999@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160823.230213148@linuxfoundation.org>
References: <20240901160823.230213148@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

[ Upstream commit 15126b916e39b0cb67026b0af3c014bfeb1f76b3 ]

cx23885_vdev_init() can return a NULL pointer, but that pointer
is used in the next line without a check.

Add a NULL pointer check and go to the error unwind if it is NULL.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reported-by: Sicong Huang <huangsicong@iie.ac.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/cx23885/cx23885-video.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/media/pci/cx23885/cx23885-video.c b/drivers/media/pci/cx23885/cx23885-video.c
index 6851e01da1c5b..7a696aea52f10 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1354,6 +1354,10 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	/* register Video device */
 	dev->video_dev = cx23885_vdev_init(dev, dev->pci,
 		&cx23885_video_template, "video");
+	if (!dev->video_dev) {
+		err = -ENOMEM;
+		goto fail_unreg;
+	}
 	dev->video_dev->queue = &dev->vb2_vidq;
 	dev->video_dev->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
 				      V4L2_CAP_AUDIO | V4L2_CAP_VIDEO_CAPTURE;
@@ -1382,6 +1386,10 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	/* register VBI device */
 	dev->vbi_dev = cx23885_vdev_init(dev, dev->pci,
 		&cx23885_vbi_template, "vbi");
+	if (!dev->vbi_dev) {
+		err = -ENOMEM;
+		goto fail_unreg;
+	}
 	dev->vbi_dev->queue = &dev->vb2_vbiq;
 	dev->vbi_dev->device_caps = V4L2_CAP_READWRITE | V4L2_CAP_STREAMING |
 				    V4L2_CAP_AUDIO | V4L2_CAP_VBI_CAPTURE;
-- 
2.43.0



