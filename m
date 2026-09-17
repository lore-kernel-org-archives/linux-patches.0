Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D4C04E3251;
	Thu, 17 Sep 2026 15:42:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789659729; cv=none; b=Zd31IkT+CKsFkh42xT6qKq8nWxP3kTfaOym4tob3OS5rvFq6OlRKk0h4PIDXQEOyRHWiYon4kcFE4E7J0gIjScQ4NqF6zLQ9CaCY45zJ48taMoNrmtqVMAIom1vv3FsfmMNYHU1xiekrPi4Nx4THK3GMy976xfPcYU0cSHCosGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789659729; c=relaxed/simple;
	bh=mrL0aOUXReO2eaAOTU3nTX0kALMuh5pI6UT5ZPDoAAs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlIvmxwoIHw1lIugg5LOxzVYkF8dO9/0kSbRyHh2XP49S72gPLY968q36lcRWEW28/td/lhg4M1oYKmgUAs6DkiztVcFLbli18Wm9RsO5KaD0ixNtPI5j2Qs2CY476dCr8n+VlwEmm9zDXDBPaO5mwlTw+TxyOn9Df0h+xaa0/U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ORP6NdIi; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ORP6NdIi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0941F00899;
	Thu, 17 Sep 2026 15:42:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789659723;
	bh=gEkpG8LIBDjbhzFk8ymLoO8sM8s3LwuMRyrMiGEqZvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ORP6NdIiXvuGEyP6SWdHm/63hNrJEBu0WQb1WY+IipQD7d5op9pvXsOc1AiDiDKa5
	 2wg7779PUPIUrXb8ZOlXX/DnHDz1Wb5RvjG1PlqqTlgwk1HpNCyEXTLFQC5jjS5R0x
	 OAjvg69mOkbbWkAYX2yCEi6GnUOadg2S0dDrz8rA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiong Weimin <xiongweimin@kylinos.cn>,
	"Michael S. Tsirkin" <mst@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 352/733] virtio_input: reset device if input_register_device() fails
Date: Thu, 17 Sep 2026 16:11:00 +0100
Message-ID: <20260917151400.350621081@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151350.597953846@linuxfoundation.org>
References: <20260917151350.597953846@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index deec24e8e6828..1a87be4c88cf5 100644
--- a/drivers/virtio/virtio_input.c
+++ b/drivers/virtio/virtio_input.c
@@ -331,6 +331,7 @@ static int virtinput_probe(struct virtio_device *vdev)
 	spin_lock_irqsave(&vi->lock, flags);
 	vi->ready = false;
 	spin_unlock_irqrestore(&vi->lock, flags);
+	virtio_reset_device(vdev);
 err_mt_init_slots:
 	input_free_device(vi->idev);
 err_input_alloc:
-- 
2.53.0



