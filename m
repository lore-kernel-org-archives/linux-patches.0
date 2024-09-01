Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 461BF1DFD1;
	Sun,  1 Sep 2024 16:51:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725209487; cv=none; b=kOCd5q+rHRVapCYhCguvQ9/g+glzUYF0twv7JK/grsUvlOlQeWMV3eW71ohxvidDmc8YFBCEiLs9wvqCdOpNQa0U6WfYxdXMllucW4LWilfJPphuOCXL8kNnfCW9PmYVT8x4C85EiX1JVWWQoUuTwQ20pRN1QpEihZ+HK06m140=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725209487; c=relaxed/simple;
	bh=vpBtJdjn900HgmS/TVnt4JoRfxnzTVB00oKOrBXGhXs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HXnq1mURoYhxPWpEYIngRPwhXaPd/795LRF/T46KbBNko7Mf8lr9sFx0pckm5FIWx8WQ4c98g2OEfuP14xWxrAH6YtYvtYTQReA/DPDH2NmfkZETRnNnk70O6QID94L+08OvxnsI7kYZhD0l2SHe2Uz2aPZdKAcbAwREf77mVN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zymzt9xG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zymzt9xG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3CD6C4CEC3;
	Sun,  1 Sep 2024 16:51:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725209487;
	bh=vpBtJdjn900HgmS/TVnt4JoRfxnzTVB00oKOrBXGhXs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zymzt9xGmOwrcQbpfl4y2syWn6+ZBUxb0P5Ujzmhvx4ClnwJk6123iVU1cPWRhqEV
	 JnB1mEgRXQ3Ramck1Ed2GfLdCx3HEWZ5+8LNyx9j3MWTA+dfO50PF20gozRg6Oe8x3
	 yJ6PWlE59vZ6KcWv54Z7OjmR1C6urnJyGtoNQ43c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sicong Huang <huangsicong@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 051/151] media: pci: cx23885: check cx23885_vdev_init() return
Date: Sun,  1 Sep 2024 18:16:51 +0200
Message-ID: <20240901160816.038478268@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160814.090297276@linuxfoundation.org>
References: <20240901160814.090297276@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 86e3bb5903712..022a9f8e19a2b 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1353,6 +1353,10 @@ int cx23885_video_register(struct cx23885_dev *dev)
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
@@ -1381,6 +1385,10 @@ int cx23885_video_register(struct cx23885_dev *dev)
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



