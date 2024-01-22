Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88FB212BF3D;
	Tue, 23 Jan 2024 00:16:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968963; cv=none; b=qfxvFUwLPoVOcnjZLbCn3nZTR0TmUNsozCzo0J7RNrh8hw6vE9YoasyJOaTYkP6XSZcYdktkjEyinnWnUxOVbyyu2REpHD60CSR8wCSPGyR3NUmhzI6nRTjYNREWRFmhBLCz+g2MdXc/4kuXBEt8CdR1/Z6zYTMb/9aqyPGUkyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968963; c=relaxed/simple;
	bh=F7Q447cNELYfucGkpEhk8wwp3up97htvzgutj7ywJ2E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dseIAPigcMZbW57xMR3nk99Z83Jth96A0AO0SuB+YEnEOo03o3YSPc7T3wiIXwytDqHuqIhL10i+J0tzkVBj0222sdwJI+sqeJComPuyU16jm4d9FSVD26ETnOwwffH3lMSsllO2ul/NidCiJppFjjNK58Cg+cPYe+HJYKirjl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vLzWVKuT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vLzWVKuT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2C32DC433F1;
	Tue, 23 Jan 2024 00:16:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968963;
	bh=F7Q447cNELYfucGkpEhk8wwp3up97htvzgutj7ywJ2E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vLzWVKuTVcRwdLhgJJUNj0qjOsdCZbtxv7xjQKrdvG5jPHbGUWFuxB419RhsRdrWu
	 ZjlMAUpQT9x5JbdBbEd4PvbueRvcg9ghSK/mQaStfRtkmXtlzQEkzqn43Qt8TWd0HZ
	 h+vEy9TBrPehHQVEnxUPlBbPtdaMND/jAcmbzkDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 125/194] media: cx231xx: fix a memleak in cx231xx_init_isoc
Date: Mon, 22 Jan 2024 15:57:35 -0800
Message-ID: <20240122235724.592585212@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
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

From: Zhipeng Lu <alexious@zju.edu.cn>

[ Upstream commit 5d3c8990e2bbf929cb211563dadd70708f42e4e6 ]

The dma_q->p_left_data alloced by kzalloc should be freed in all the
following error handling paths. However, it hasn't been freed in the
allocation error paths of dev->video_mode.isoc_ctl.urb and
dev->video_mode.isoc_ctl.transfer_buffer.

On the other hand, the dma_q->p_left_data did be freed in the
error-handling paths after that of dev->video_mode.isoc_ctl.urb and
dev->video_mode.isoc_ctl.transfer_buffer, by calling
cx231xx_uninit_isoc(dev). So the same free operation should be done in
error-handling paths of those two allocation.

Fixes: 64fbf4445526 ("[media] cx231xx: Added support for Carraera, Shelby, RDx_253S and VIDEO_GRABBER")
Signed-off-by: Zhipeng Lu <alexious@zju.edu.cn>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/cx231xx/cx231xx-core.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/media/usb/cx231xx/cx231xx-core.c b/drivers/media/usb/cx231xx/cx231xx-core.c
index 982cb56e97e9..0f11f50c0ae4 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1028,6 +1028,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	if (!dev->video_mode.isoc_ctl.urb) {
 		dev_err(dev->dev,
 			"cannot alloc memory for usb buffers\n");
+		kfree(dma_q->p_left_data);
 		return -ENOMEM;
 	}
 
@@ -1037,6 +1038,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 		dev_err(dev->dev,
 			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.isoc_ctl.urb);
+		kfree(dma_q->p_left_data);
 		return -ENOMEM;
 	}
 
-- 
2.43.0



