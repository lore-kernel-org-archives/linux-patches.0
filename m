Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6AEB1C688E;
	Tue, 27 Aug 2024 14:50:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724770214; cv=none; b=LY8dniuDqlU8PSJo/M47+wWMhTdgzRaqGvUjDDn2LhPyIDELljtbVqoxNwV/vGNGw1dHH/qkWcYr/Ft65mtX0k4RmGYFioeJhVfKOpWNZ6QL2d9a2mRigp4M6sTO6QB/YmtYsBStkfW2DKbPSspyZ6pkpm//+5UeHfpLxKYJPkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724770214; c=relaxed/simple;
	bh=V4yTuBx2KKVvQ5fIHth2LyjGVCucBzLgaI4CThmyIhA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t139fyHWA5Vo8OhiuUsHFHuRWWV8eVylgIN9b2B9TSKTEPGex4Dr2IOW0Vtdj6zyUZD11scGgpZkxDv6/4AraKnCmzmT7SRXxQZZZ9qWMe9y6h7BKBKswDDEBxAxAgtEI3nRo6/7LJZptvS01JFUirE5TVJs1cbp3alJ9ybM4L0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0l7tdzOS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0l7tdzOS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 36F89C4DDEF;
	Tue, 27 Aug 2024 14:50:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1724770214;
	bh=V4yTuBx2KKVvQ5fIHth2LyjGVCucBzLgaI4CThmyIhA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0l7tdzOSaDltK7krVhIoU+fa/A8DDYVN/FzloIKQvSRrTaroXa5Wx9NCpJQeTv4mf
	 rWvp63Yaxc3kviWwY2xwrGKizDw8FhHBdDF9mYNqkslqB++kSUzxqKhfLp1tKa4aVL
	 WR/4bu+wI05qTZS9rpYEO+9n70MlDKTpZ18Fs7Z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sicong Huang <huangsicong@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 162/341] media: pci: cx23885: check cx23885_vdev_init() return
Date: Tue, 27 Aug 2024 16:36:33 +0200
Message-ID: <20240827143849.578930354@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240827143843.399359062@linuxfoundation.org>
References: <20240827143843.399359062@linuxfoundation.org>
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
index 9af2c5596121c..51d7d720ec48b 100644
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



