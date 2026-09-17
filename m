Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 592864D178D;
	Thu, 17 Sep 2026 17:27:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789666023; cv=none; b=lJz2julHUxwDYt7/WcVsDWrRksSYaUH0KJDkDctJaZdAzDnU2eGa8B92i30uFHx4OS/fEO3wT+ttg843TiuXNWwjnn9CaUIsMkjJMeqXVltGfBhhx42O3gcVuFqRKfmdK2okrZAa4Ew/LFXodamx6ZxU1pAgH8abFEPIy0WhPUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789666023; c=relaxed/simple;
	bh=MRyGsvdE04vAPTQeZmRQbriZK9HmyeUl+82BI8dHxMo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vo3yphzbo53wl6taNRVK6o6C9DKfOuLIgD/e8DU8Xai9X7AztRT3oFTIqysQ4D06Hi+mWFFnjbxA81kF5XG9rr2LiBUfL2YRv6jOPnpB7WIZ6JiCJm8JShnvZmqOZC6OjXhahN/IkdYfL+3vid/MBcXLHf76PA/kZfZV9YmpXFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tN/buLxi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tN/buLxi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9F031F00893;
	Thu, 17 Sep 2026 17:27:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789666022;
	bh=C8IThsPDA+g6VNvIA+4FuwijDbg126i7GdzaPrSFu7E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tN/buLxi8Z8JsJOTUppKLxNU6eHJNTfZAo207MvhNywHAYNVEGg14PtF3yNamQWfR
	 4Xb31AJbPHXJUo5FU+E/jKR0FGbWLj8yl5GyRwNexdHXnQ11u8n+V6CHTc8IB46oVm
	 Ym/6EmSRXOfu5AnCv3BykaA1kpppFV8G/IN8WXfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0860/1250] virtio_input: reset device if input_register_device() fails
Date: Thu, 17 Sep 2026 16:10:55 +0100
Message-ID: <20260917151615.278427476@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d0728285b6ce9..ee41a58c86bae 100644
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



