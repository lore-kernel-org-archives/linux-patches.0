Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795057755;
	b=N2vtZkbM4/l6ukkGHbma8e8bgyLU9RnNk3nwjpTICII5G3nMt4JQwIp6+B4uLpnjjTNu
	 DBhoP948spmEP+lWcRz4Fqv12nmiA9LUDHbN7IkThl4kQkOyCHs2hpkr6CDOoxl6/wSL+
	 Hw2FkDc5nbXIFIY6NTjaBTNKiwLKu6pe+Jj+g6uuGzFoEs+TxZd/DqoaHC8z5GeGSffKQ
	 GirfV+Eyi0r2Bm2Cxedea/sG0PF2K7x8yOQRd5IarSR+LzU+nXCQEt9FEFGYfwhXZCt9l
	 031EtwiGwP6g0wNXeTVtFTA2mlD3s4Q2K3HoISgsKm93GnwKzLwC/Nr8EQxMDKSHzVw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795057755;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C7KV0MhYY0Wtl+uB+I/ccR4e2a46fy5gGFGtE/Vn7f0=;
	b=hiqqfrgISnEIrdDqhfN1p+m85hX+RHTSOsy9OKOLBHJDyZE/qtqysqqUV8JumRENRcvR
	 vIENHPo0W7Ae5YsFwfx4QEqrd539spnnF+vvij0zZS4qMAYFPx+AmcJq4YT7coaWgMtE1
	 5VGUhyiPrQVkStkmn58LjMJ2d7M8jJrFBeHCiq6KaL7W3U1epr2xi4Kyzl3DI6reDj7yN
	 vkr+SxGzoKCfYRjOL0nST80Ccj9gl61otY4n13TP/HnCkQgYRqTSuEE9HOsV17ukIklwF
	 Qek4nisuLRSU4vpTzQvjx/NHOb30efUdY7xcTxwrRLt0gTNpo4P5d7W0wUoK0Nir0ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cuI1ZYFF;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FD3606A325;
	Thu, 19 Nov 2026 03:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cuI1ZYFF
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7493D1F000C4;
	Thu, 19 Nov 2026 03:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795057755;
	bh=C7KV0MhYY0Wtl+uB+I/ccR4e2a46fy5gGFGtE/Vn7f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cuI1ZYFFGmvjtOIzh1m2K4egfAGrn6JP5R9JyxOo2nAQsbby8vrigAlEr9YrXacg5
	 lOYGGPts6VVsM0mNIJs3uGCki4NuzFYU28CPIc1ZMWhVMwjThnWnI70CCUSfYct9nQ
	 MURzeEu9GV7ITdT8f7Yion8k9gZGr4ljJ0eIPsh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 0242/1848] media: cx23885: Fix use-after-free in cx23885_finidev due to race condition
Date: Wed, 18 Nov 2026 15:38:00 +0100
Message-ID: <20261118145922.013400222@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2217,6 +2217,10 @@ static void cx23885_finidev(struct pci_d
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
 
+	cancel_work_sync(&dev->cx25840_work);
+	cancel_work_sync(&dev->ir_rx_work);
+	cancel_work_sync(&dev->ir_tx_work);
+
 	pci_disable_device(pci_dev);
 
 	cx23885_dev_unregister(dev);


