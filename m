Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A67EB37C91B;
	Thu, 17 Sep 2026 18:45:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789670713; cv=none; b=YiE0JAo9rA8PP8QonZF2sHHtLNqkTx77MoxEDjR7N2QYD+cAi8oL5z7ktmXBnqgcex6IGBnHmFb0Sznc1C42TEN/dhSRKaCREDEUMs5E22DK7JITel6N9Oei+5wDX7ziRgFesoGqip7CM5zKgMp9yLGelXkPoPH+T74zdK84sE8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789670713; c=relaxed/simple;
	bh=Vym8x8jOjRBJf0hoghrqYnOwOP3AcE8ygl2ZgQDH4vU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tCFdny8nPmstmm213K1b3JKMI5VbaNI/NUMRhREv5n1tGZiazMqzw5QcuCSHxfsmCwdDhfi0p0bIKKx4onHiKY9WJiVuAa+ZYiJ2KTQbz3XaLe4nevWl4gmnjMKBQ8WKvZadOB1T7xjkbPbt4mqUND3LxzgZujKGXFpxYwT8oCU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LrQsGDhY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LrQsGDhY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C50201F000FF;
	Thu, 17 Sep 2026 18:45:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789670712;
	bh=hgdYqwoWNCdbwO5ABznuMQ/VfMAOCEqTG57iT+lUnRM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=LrQsGDhYQlXmC9X9xHO9W0QffGXG3MLf20SDVYtnfr8rSb3t2tLwGC4NBThmyJwMT
	 2LLukVnqfiuTB2lsXyDXAPz52TNBhdk/eLPW/0ZOCWJegypt5kkxtkWqdwuqgG51P2
	 XS/uHjZAS+CqE58oPALPynU8Rob4cXyEXF1tl32g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0719/1102] virtio_input: reset device if input_register_device() fails
Date: Thu, 17 Sep 2026 16:11:02 +0100
Message-ID: <20260917151558.395931855@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151539.408551884@linuxfoundation.org>
References: <20260917151539.408551884@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index a5d63269f20b9..c5a1959035d50 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -328,6 +328,7 @@ static int virtinput_probe(struct virtio_device *vdev)
 	spin_lock_irqsave(&vi->lock, flags);
 	vi->ready = false;
 	spin_unlock_irqrestore(&vi->lock, flags);
+	virtio_reset_device(vdev);
 err_mt_init_slots:
 	input_free_device(vi->idev);
 err_input_alloc:
-- 
2.53.0



