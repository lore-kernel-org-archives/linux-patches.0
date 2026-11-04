Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827041;
	b=Hiclo0t90uytfkot0Jf7NUEBBlnMq79MZcdMS58IntFBZab61gmtNRiuxKMU/xrBJLA3
	 I7fcwxILLyXZqf5VEmQkE5mLQrLFmDav052BQAORXRE+hXOAOpdpFXHJqmOGeqexT62bw
	 WL967xRGtSw04nIShPk3jdtpPDdQlDKdZ2FbMfNgWS39Q/yIUKnoxVkCYq0mJid/boZX3
	 L82gw9A7n9Q/h9fwYSRLDODMnBspr+HSaZJ0rkc/5QCg1Eo8wuj4nqRgj0ktxxXcw7SNS
	 zm+UnZhjOpZG3ZaoO3oD0+IvlSJBFwpzLqs4E7NXjLWCxv3Mj9tRLaqF9IuUnNz6t7g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827041;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Eps6kcps0HjeQV7UDQ+r4kAxHHr7eURorDprz1sp7O4=;
	b=NcQ9bXZ7mC3S7EN1rU76cjqAVgLTSigB9t5wZjDFxAkTPc62s3hHm4HA35kYxpKZx9F3
	 zZo3qso/ZJt1llMJIx56I/3LbBi+7SW2Y6vq8HWg23ky+M6VSeUSXovdaBBCOdN0uXcYu
	 n70sCAgY6oY6rV+ZdsCyBmLlEcJiaVSuPoghJ90Q+FIBSRKgzjkSQnfgv6JtZYYXSq7L9
	 HRr1sVNZ9nq6FWzWNuGEvju3gKQ4XVKi6MrFi3VMo1H1EPOHpnH78etUnsIkVyOGZIB4M
	 ItBhcuFpd/WY9oXZ59Na5S67g7zIE5IektKMfqQqQrAEU7O+S7N+dkaTYmymhouvmPQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhizBa8E;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5707D606A84F;
	Wed,  4 Nov 2026 21:17:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xhizBa8E
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9BFC1F000C1;
	Wed,  4 Nov 2026 21:17:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827041;
	bh=Eps6kcps0HjeQV7UDQ+r4kAxHHr7eURorDprz1sp7O4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xhizBa8ErJlWfGLV+4IAlzYflAnniiWlqZJizJSn9RWR2dzg5CiC/BNCNNNKxkGNX
	 gytaU/A6yST8XUlxPowrmcq6JCKPY33pJR6EfUGXA0WRTEMLbvICYccw9m8MNANCLd
	 PHKJ1RxHGS8nobalOX26NUvcm/QXQdP7neKzbwzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.3 159/547] media: cx23885: Fix use-after-free in cx23885_finidev due to race condition
Date: Wed,  4 Nov 2026 16:05:43 -0500
Message-ID: <20261104211042.673882481@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -2246,6 +2246,10 @@ static void cx23885_finidev(struct pci_d
 	/* unregister stuff */
 	free_irq(pci_dev->irq, dev);
 
+	cancel_work_sync(&dev->cx25840_work);
+	cancel_work_sync(&dev->ir_rx_work);
+	cancel_work_sync(&dev->ir_tx_work);
+
 	pci_disable_device(pci_dev);
 
 	cx23885_dev_unregister(dev);


