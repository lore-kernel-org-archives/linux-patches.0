Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC55E65199;
	Tue, 23 Jan 2024 00:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971513; cv=none; b=qV8l+6P09DeDSVJ1x1fu+WcgcB6jAgEasb4CoSWyZe+I5Sfq3bHEL3brl6Lt7MMcaHVPFL+fTVSdWROBGQSOTfa/8YXsYvSxHRfpHvFexOBORSBzRuCDNTnTYD/sRzQmyh5eGkQvnwTxtcJXpZ12NQAPvBGEWIOOQjrVEXLPLPM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971513; c=relaxed/simple;
	bh=XjS+PzE5Ey/BVw9EO6i7LV4781J0YbBKv4pWsXKdPZA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nXNacWaSGAbudNUll+0+0AneSMEBh8MvS3eRds2IPshGtVa1UrKa278wUUjJKp1EL39sLdCzJpXK4QGGbo4gzGJTC9EKjQfAUAwCUnpvlXRjbKDaFNfa342hT0Ar3sW7rDmfgPzVk53GDiLvLPW7VztIG8zegYLr49PigjC0d2U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tTPmQ/2d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tTPmQ/2d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B41AC433F1;
	Tue, 23 Jan 2024 00:58:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971512;
	bh=XjS+PzE5Ey/BVw9EO6i7LV4781J0YbBKv4pWsXKdPZA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tTPmQ/2dnoLxTbW/kQqiTWfB4Xd3XLMMRvWRdmA/aSIXyfEaIslNZWbc43nLSKfYt
	 A7VM9vWsvRqFyfkfm4IPy+0F/9MaMIUwR/VuLTRH3Q7o5f9WqatwXdIb8Zc5v2l1tq
	 gLLeKh0bWyFZkUd4sHZ/DbF5e4AwLxqQ3atQbNwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 164/286] media: cx231xx: fix a memleak in cx231xx_init_isoc
Date: Mon, 22 Jan 2024 15:57:50 -0800
Message-ID: <20240122235738.489487778@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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
index 05d91caaed0c..46e34225b45c 100644
--- a/drivers/media/usb/cx231xx/cx231xx-core.c
+++ b/drivers/media/usb/cx231xx/cx231xx-core.c
@@ -1024,6 +1024,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 	if (!dev->video_mode.isoc_ctl.urb) {
 		dev_err(dev->dev,
 			"cannot alloc memory for usb buffers\n");
+		kfree(dma_q->p_left_data);
 		return -ENOMEM;
 	}
 
@@ -1033,6 +1034,7 @@ int cx231xx_init_isoc(struct cx231xx *dev, int max_packets,
 		dev_err(dev->dev,
 			"cannot allocate memory for usbtransfer\n");
 		kfree(dev->video_mode.isoc_ctl.urb);
+		kfree(dma_q->p_left_data);
 		return -ENOMEM;
 	}
 
-- 
2.43.0



