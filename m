Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DDD04E1C76;
	Wed, 30 Sep 2026 16:23:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790785420; cv=none; b=GsXfxSQeFHXVdll9Hh8NwwOw8qYKFuYENaylwzZAYxvFPCA9geAc9V/OKkHKjHOvAFuMo9eSvkzOiL88E2bntv+aG7oN7Af8cLkyxnfT4LHagqauXUqGmQlVgOQpFt2v7q41clwBgocckvOzh5T2xDEki5Y2ruKwB52/FYaspAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790785420; c=relaxed/simple;
	bh=VLEkCz4/YW5FJuDZoIqJ2S6HYtzVDoBTG/9W656jgaM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZdCCsy7pB5Nty0YdB9kHaIK527nJWAuKiwzKbs2O/wq+kXhn348vHKTqRi3Xc1RiNo2S4Hg0DgWhvBF3W8ePC22exNyLGT8/1iSA+SSrOAyH5vpz/xViGmhQrcz6zK+snpx1ZyGnJCE5UNhRcrkXH4WncG3KZqI4K7xr1vHOXDc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dJgjGGu4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dJgjGGu4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7627D1F00899;
	Wed, 30 Sep 2026 16:23:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790785410;
	bh=qZa9iO2ljr5/Ox5vB/Vkr7wr9N4NWWGRXkV7b+fBDao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dJgjGGu4rCaSkMqQFLVteF/ppcgSntcpJdXI+N2v3REwD56mu/0ZYstUmaenmwOzU
	 +PQTdt/l+2WMcbAoglPOjFYGSOqdv2OUWDFIdbfm4TjFhQMOEknhIluPTilwd7eT1N
	 oboS0uVaCs31rw/iacaOD698mF6uzdzBLAM2dCAk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 444/982] virtio_input: reset device if input_register_device() fails
Date: Wed, 30 Sep 2026 17:19:40 +0200
Message-ID: <20260930152426.332037456@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152416.775402466@linuxfoundation.org>
References: <20260930152416.775402466@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Xiong Weimin <xiongweimin@kylinos.cn>

[ Upstream commit 81489b32a21c9360f8750d1fb600155d27452e19 ]

Probe marks the device DRIVER_OK with virtio_device_ready() before
calling input_register_device(). If registration fails, the error path
cleared vi->ready and called del_vqs() while the device was still live,
so the device could keep DMA to queues that were already torn down.

Match remove/freeze: call virtio_reset_device() on that path before
tearing down the virtqueues.

Fixes: 271c865161c5 ("Add virtio-input driver.")
Signed-off-by: Xiong Weimin <xiongweimin@kylinos.cn>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260805032931.1606652-1-xiongweimin@kylinos.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/virtio/virtio_input.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/virtio/virtio_input.c b/drivers/virtio/virtio_input.c
index 3aa46703872dc..54d90006e598f 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -327,6 +327,7 @@ static int virtinput_probe(struct virtio_device *vdev)
 	spin_lock_irqsave(&vi->lock, flags);
 	vi->ready = false;
 	spin_unlock_irqrestore(&vi->lock, flags);
+	virtio_reset_device(vdev);
 err_mt_init_slots:
 	input_free_device(vi->idev);
 err_input_alloc:
-- 
2.53.0



