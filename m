Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52ACE340A47
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:50:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301025; cv=none; b=nwP3CFeMj1sr8nwQ0ZFNc9VoWwZZ/uTEfdWnm5Mr6a+V627dE3W95kMsgAKOJy1K04WJmj8yLqwCZb3dIcHkEhnE+yAE+vzpDJ/nFLBh0GWoWa9HeYrYYjbTEMPdKOOasPtNeiyYKNVd9ogIdk15/SoHU8KymM9qIFfcSvPtEZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301025; c=relaxed/simple;
	bh=qN7FlshoqMU79pI9pEyR07XAtSCL+xPGJYwlXEJa1Y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0RixHjECALTKSMiA87Oo5Y4ckYLjyQr1rNedm7DDiKWNkddihq83oVVn7/opi1PO+oPvhglJHeNwhGoZCAOSg3Hea8sj87741p5HHNgYPT4ncedOUUofSeUCYp44nw8SFLcco0WzFwHNTAeC1Zqzm7x0LP5YJ6uhMzFBnlFA7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Um2XAPQD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Um2XAPQD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B37D9C19424;
	Sat, 28 Feb 2026 17:50:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301025;
	bh=qN7FlshoqMU79pI9pEyR07XAtSCL+xPGJYwlXEJa1Y4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Um2XAPQDUnpayjsiFh/jgFJ9tZMA2dZ2aFvbfnKYyIVzPUbDfLnRfMdWBgDMKjO5t
	 J1e6XRBQ6afOTH9jXQZU2armSiDUGlo+WgY0JiLECVhk7WnGtxgZRYxrKuxrHKOlta
	 4XdhzuUsslQ5oMtoxuYHYd1aAB8ONavlVOkrK1OK3lq9JpkGbxRTJ3I5QM12gHxcAQ
	 dS9k4wEhRFv4HG2Qu6lVK57+7OaV1hZa9mASzb/tu6hYSpHCl8NOwiRtnoqeSUR92z
	 LHoHUC4VwoNlRk1WYcUy2Cgf0N6Otz5frE7VdKZ1xblR87JWatfNysfNqsxMqkGLhy
	 oCZngrd07LNeg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 162/752] media: ipu6: Ensure stream_mutex is acquired when dealing with node list
Date: Sat, 28 Feb 2026 12:37:53 -0500
Message-ID: <20260228174750.1542406-162-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Sakari Ailus <sakari.ailus@linux.intel.com>

[ Upstream commit 779bdaad2abf718fb8116839e818e58852874b4d ]

The ipu6 isys driver maintains the list of video buffer queues related to
a stream (in ipu6 context streams on the same CSI-2 virtual channel) and
this list is modified through VIDIOC_STREAMON and VIDIOC_STREAMOFF IOCTLs.
Ensure the common mutex is acquired when accessing the linked list, i.e.
the isys device context's stream_mutex.

Add a lockdep assert to ipu6_isys_get_buffer_list() and switch to guard()
while at it as the error handling becomes more simple this way.

Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/pci/intel/ipu6/ipu6-isys-queue.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/media/pci/intel/ipu6/ipu6-isys-queue.c b/drivers/media/pci/intel/ipu6/ipu6-isys-queue.c
index aa2cf7287477c..8f05987cdb4e7 100644
--- a/drivers/media/pci/intel/ipu6/ipu6-isys-queue.c
+++ b/drivers/media/pci/intel/ipu6/ipu6-isys-queue.c
@@ -3,6 +3,7 @@
  * Copyright (C) 2013--2024 Intel Corporation
  */
 #include <linux/atomic.h>
+#include <linux/cleanup.h>
 #include <linux/bug.h>
 #include <linux/device.h>
 #include <linux/list.h>
@@ -201,6 +202,8 @@ static int buffer_list_get(struct ipu6_isys_stream *stream,
 	unsigned long flags;
 	unsigned long buf_flag = IPU6_ISYS_BUFFER_LIST_FL_INCOMING;
 
+	lockdep_assert_held(&stream->mutex);
+
 	bl->nbufs = 0;
 	INIT_LIST_HEAD(&bl->head);
 
@@ -294,9 +297,8 @@ static int ipu6_isys_stream_start(struct ipu6_isys_video *av,
 	struct ipu6_isys_buffer_list __bl;
 	int ret;
 
-	mutex_lock(&stream->isys->stream_mutex);
+	guard(mutex)(&stream->isys->stream_mutex);
 	ret = ipu6_isys_video_set_streaming(av, 1, bl);
-	mutex_unlock(&stream->isys->stream_mutex);
 	if (ret)
 		goto out_requeue;
 
@@ -637,10 +639,10 @@ static void stop_streaming(struct vb2_queue *q)
 	mutex_lock(&av->isys->stream_mutex);
 	if (stream->nr_streaming == stream->nr_queues && stream->streaming)
 		ipu6_isys_video_set_streaming(av, 0, NULL);
+	list_del(&aq->node);
 	mutex_unlock(&av->isys->stream_mutex);
 
 	stream->nr_streaming--;
-	list_del(&aq->node);
 	stream->streaming = 0;
 	mutex_unlock(&stream->mutex);
 
-- 
2.51.0

