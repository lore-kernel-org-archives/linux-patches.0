Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B582144C97;
	Sun,  1 Sep 2024 16:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725207727; cv=none; b=Rvlb4VyrPtufUJ30T/0VcW4gVxBa9i4CSRBz6+qiJp5vjDfbm/JEElEvX0j/aKmQoB/r4VQE9G29NI7+I0slKGJQAKgeNUxfr8NZxz/HLxYyG75uTqRewlA6Hz3FerHNV5fJhoUDK73zsdP89aqIOlqL/R75ZeYWi7EH8JqELBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725207727; c=relaxed/simple;
	bh=QX8lu6aCQ+R6fo8blx6JyDm3rufilsl7ofMHPw2X+YU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TunFpKpKZOX5/3E9I03QerfbMXkSAngE2Yx1uNGRw5IEnJq6dN9U1LOyXyfCHEwMVFQM+ze8fQkl7a6IBny/xm2GBiuSuC8jSo18BTKc7ofbBEEE/9uWJb6Cu79dQ9NDaLye+4onJGBA0SbmHR6BMVGcOA9izJu36ceDi/NnaQ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=toMNF3dN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="toMNF3dN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B2DEC4CEC3;
	Sun,  1 Sep 2024 16:22:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725207727;
	bh=QX8lu6aCQ+R6fo8blx6JyDm3rufilsl7ofMHPw2X+YU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=toMNF3dNhzkiRy2JjkrgUC3BivFCvjvaZb/2vZAtzZrYlhJXYefO5PHwBYaBStPoS
	 2NbMqY9vE+b8liJF+yLt6v1FvfYF5pE2MnuCQdJhdYZKylLPi+Gn73kL+wYmDKqWM7
	 hFvinCVHSE0zl7jM2f8PQ7QgSOfxo0T0EIT//qLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sicong Huang <huangsicong@iie.ac.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 28/98] media: pci: cx23885: check cx23885_vdev_init() return
Date: Sun,  1 Sep 2024 18:15:58 +0200
Message-ID: <20240901160804.754307514@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160803.673617007@linuxfoundation.org>
References: <20240901160803.673617007@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 16564899f1141..435a3c1c7e650 100644
--- a/drivers/media/pci/cx23885/cx23885-video.c
+++ b/drivers/media/pci/cx23885/cx23885-video.c
@@ -1297,6 +1297,10 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	/* register Video device */
 	dev->video_dev = cx23885_vdev_init(dev, dev->pci,
 		&cx23885_video_template, "video");
+	if (!dev->video_dev) {
+		err = -ENOMEM;
+		goto fail_unreg;
+	}
 	dev->video_dev->queue = &dev->vb2_vidq;
 	err = video_register_device(dev->video_dev, VFL_TYPE_GRABBER,
 				    video_nr[dev->nr]);
@@ -1311,6 +1315,10 @@ int cx23885_video_register(struct cx23885_dev *dev)
 	/* register VBI device */
 	dev->vbi_dev = cx23885_vdev_init(dev, dev->pci,
 		&cx23885_vbi_template, "vbi");
+	if (!dev->vbi_dev) {
+		err = -ENOMEM;
+		goto fail_unreg;
+	}
 	dev->vbi_dev->queue = &dev->vb2_vbiq;
 	err = video_register_device(dev->vbi_dev, VFL_TYPE_VBI,
 				    vbi_nr[dev->nr]);
-- 
2.43.0



