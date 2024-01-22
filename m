Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A849E629EF;
	Tue, 23 Jan 2024 00:52:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705971166; cv=none; b=bgbUMpD/qGQSuvyKnEi2oyeaowfcIxVw09nINmx9OodLis+pneX2DJXIAdsuykMdyR94JHNP4ACpGOTAOlkFyF3tJkSpDSAjZbjF31D2hx26WtdHJk67vTcG8xqrSGr1NhGWcz+hWNzeitxl8+0Du5FLTIVijgs9RxyFZYUX/Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705971166; c=relaxed/simple;
	bh=uyBkWGI3XNp/YurLNfJmuFrmRL2rAWU8kZ5XnA5qdBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tPGSejzr55JPesVm+/NgUTQHtmC5nMJFILZ3DdUadKxHPiwccb6tDoKzPx5BopweEw13h27h+wAw5HVfPlZ778e5d3j/c6v+pq8Pk9Q7aiJ0E6LHriLSQTgSL0I/GS45vD0N86URJ70wThEHtug9UUu9dlnU4HZVGtX1ylnRfRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BmJwiRML; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BmJwiRML"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4E2D8C43390;
	Tue, 23 Jan 2024 00:52:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705971166;
	bh=uyBkWGI3XNp/YurLNfJmuFrmRL2rAWU8kZ5XnA5qdBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BmJwiRMLxdRxhB8qBVVC+mo7HF17qZaYaQUJPoot4zWM9XGOlCfsVC87FKZuTmCj2
	 q8vV7xOjs3CDQLtUNVJmhrIkZK1yNheZ4bcvgiXNNQh+M192jQ6ry2doqPR0HIwyoz
	 JtIxCskjJlKLGdm6SZEligPLL0+QDjkWzKAM1B5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhipeng Lu <alexious@zju.edu.cn>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 191/417] media: cx231xx: fix a memleak in cx231xx_init_isoc
Date: Mon, 22 Jan 2024 15:55:59 -0800
Message-ID: <20240122235758.531791047@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235751.480367507@linuxfoundation.org>
References: <20240122235751.480367507@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 727e6268567f..f1feccc28bf0 100644
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



