Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795044347;
	b=lSnaYs8oyW+eJ4wwROHLFP6pQ0z5bDR95jLCFIZMEVwUwkYInym/Lq+A8ALQJ3JmXOyC
	 z/80fbtf62j4vPTTLMMhkta3t9LGvSHqhVx0n53DKwLrXUcKZJFtDp15P4eKbAOl3wVv8
	 MOIqI0KK5mUDP0zkFusM+BEQmvFMB3tQpNaEjRGxB16n4AHHxKvWnszpbVOqt/M9BMna4
	 CGf/yoJ1raGdB3UaTpdBvjFZb6J9yqkWo5y20U9n1zRA+d5ozPEZI0jn0jAcJAMnWLHmf
	 GuSgzJvf/52RkVLIAYgsUFNS64ks7kBt0T0mVUVe8r0pj47lL+lIe6Nlwz4FKT8rfyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795044347;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+Dzx0g8ANRldSqcL+6M1SQRf5QKiDNPpJ38t5cKXVtU=;
	b=YQWd/CnHHVKhBJc7AkAYP9oKXXfbnNT/FRKBxEsxKTe6A4IGu1/wjsg6U9cfSUkKuvFW
	 /vQnh2adGL1a+2z8PpHQHOJ7FL1IpIqdwGcppV3GCZWCvbt0qnVKOmq0J1LmJGW8vxu93
	 qVv1XTnKNm6VTLQdCzdIY78zO7KkKJx7thA5/ZQuDUUsTwLZ0d5ix0TY6YBRf2m72Fzm8
	 jux7jV94dVeqC/0H4NstTQvbGBs+VI+3EW87eaYMdn4wAwAKSttMJL/IbDx3/6shFLgZ3
	 VGi/jm4zopw3sWGPmZO2ofINpm4VFHrPWDz5mQyHlvqrIbgt9D1vzbzXhfr6cco+fZg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALmZOrVl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D56FB606A320;
	Wed, 18 Nov 2026 23:25:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ALmZOrVl
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34DA21F000C4;
	Wed, 18 Nov 2026 23:25:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795044347;
	bh=+Dzx0g8ANRldSqcL+6M1SQRf5QKiDNPpJ38t5cKXVtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ALmZOrVlpXGyIZq46PvrbVwME/hwYxCr2gzvp3COLJ7zB+gmTYWTtN5oIBHj5/83f
	 mx7VlkRp029HNrQxf7NNtqCRLnciNvFJehS7dAo8VSWIwEVKxkGk7fHr+Mp/1XiFgF
	 tjMNaJILVmsbxiqyOovD113HTggXsoZQrVWBVP4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 0536/2857] media: cx23885: Fix use-after-free in cx23885_finidev due to race condition
Date: Wed, 18 Nov 2026 15:26:10 +0100
Message-ID: <20261118150220.783445321@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

commit 75016a992d9b03f5cc6df1414d1da35840d4feeb upstream.

In cx23885_v4l2_dev_notify_init, &dev->cx25840_work is bound with
cx23885_av_work_handler, and &dev->ir_rx_work and &dev->ir_tx_work
are bound with cx23885_ir_rx_work_handler and
cx23885_ir_tx_work_handler. cx23885_irq can schedule these works on
system_wq when an AV_CORE interrupt is received, and the IR subdevice
can also schedule the IR works from its interrupt service routine via
the v4l2_device notify callback.

If we remove the device, cx23885_finidev makes cleanup and the memory
allocated for dev is released by kfree(dev), while the works mentioned
above may still be pending or running. The sequence of operations that
may lead to a UAF bug is as follows:

CPU0                                      CPU1

                                          | cx23885_irq
                                          | schedule_work(&dev->cx25840_work)
cx23885_finidev                           |
cx23885_input_fini(dev)                   |
cx23885_ir_fini(dev)                      |
cx23885_shutdown(dev)                     |
free_irq(pci_dev->irq, dev)               |
pci_disable_device(pci_dev)               |
cx23885_dev_unregister(dev)               |
v4l2_device_unregister(v4l2_dev)          |
kfree(dev)                                |
// dev is freed                           |
                                          | cx23885_av_work_handler
                                          | // use dev (use-after-free)

Fix it by canceling the works after the IRQ handler that can schedule
them has been stopped, and before proceeding with the remaining
cleanup in cx23885_finidev.

Note that the flush_work() calls in cx23885_input_ir_stop() do not
close this race: they only wait for works that are already queued or
running at that moment, they do not prevent the IRQ handler, which is
still registered at that point, from scheduling the works again
afterwards, and they are skipped entirely when dev->sd_ir is NULL.
The cancel_work_sync() calls are therefore placed after free_irq(),
the only point at which no new work can be scheduled.

Fixes: e5514f104d87 ("V4L/DVB: cx23885: Move AV Core irq handling to a work handler")
Cc: stable@vger.kernel.org
Assisted-by: Codex:deepseek-v4-flash
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/pci/cx23885/cx23885-core.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/media/pci/cx23885/cx23885-core.c
+++ b/drivers/media/pci/cx23885/cx23885-core.c
@@ -2233,6 +2233,10 @@ static void cx23885_finidev(struct pci_d
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
 
+	cancel_work_sync(&dev->cx25840_work);
+	cancel_work_sync(&dev->ir_rx_work);
+	cancel_work_sync(&dev->ir_tx_work);
+
 	pci_disable_device(pci_dev);
 
 	cx23885_dev_unregister(dev);


