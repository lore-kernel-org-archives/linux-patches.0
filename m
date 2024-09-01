Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F60C1C68C;
	Sun,  1 Sep 2024 16:40:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208808; cv=none; b=H4HExuXpoc6kg654FraVwcK3P+xBafv0YeXmepoEK6LSp3l9nR/eIHmy+v46eH8246up3oYN9zIrUHkFCOTlI9mJ+ZWLN9225qdG1rI5LNQg0KNlIQOwjq+Ww5MC618F38YCpkh4yzFByoBfvlHO7XeO1spEdOMUuxscO8X4Ibs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208808; c=relaxed/simple;
	bh=+G65i6KCpJJgg5i4HT/j4Zzbyts45hBs8UK24S2S/WQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHr3KMgINqnTfapOdUC1/VXGeAU8GH5PmgqzXIs8H3h0ZkdIwQwY6FPTCzdPzXMGEqhovCu9A+c2lnewhdoKA1huwa9L/JnXgLWopVvHD8paxpZK8VybXGsOyjmi1QP0F/WbXHEUskJ0F3x2nwTN75yaQQbRhlgR3d3H9d2RKOY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NFyWEJdI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NFyWEJdI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F7EDC4CEC3;
	Sun,  1 Sep 2024 16:40:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208808;
	bh=+G65i6KCpJJgg5i4HT/j4Zzbyts45hBs8UK24S2S/WQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NFyWEJdINVqSL1ooHJzsVfyb6ejR7KZgNbOKYs7b68yP9LHy4Aas06DqS+F2DgbuQ
	 LzTxtXevaUyZyvUscdeoCfv35tWhigojoUsRrW2FQ4weI9NrawSSjyh8kYnMmr1zBK
	 mX3OP/tEwzgbugfcd1Bi2kScttGgSfDkwiMfTW1M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sicong Huang <huangsicong@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 045/134] media: pci: cx23885: check cx23885_vdev_init() return
Date: Sun,  1 Sep 2024 18:16:31 +0200
Message-ID: <20240901160811.804192765@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160809.752718937@linuxfoundation.org>
References: <20240901160809.752718937@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 90224a9947022..e4e295067a7ee 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1299,6 +1299,10 @@ int cx23885_video_register(struct cx23885_dev *dev)
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
@@ -1317,6 +1321,10 @@ int cx23885_video_register(struct cx23885_dev *dev)
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



