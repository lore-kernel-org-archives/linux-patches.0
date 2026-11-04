Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831454;
	b=1h1bxHqfYJEMYnOEmaW9v4anafA3mGRH9HC4xag83z2bVfyP10ATWw7RW1N/lOtDwYHV
	 1ru9HUhCPwvmpcyiPO9giAi0OcCHvSWxS52ZNcLeY6Cc9KmW4aZsz6oqvEe+/uHQ94IJ5
	 /SOlm6x6eFTCn1yVZDdxDE/AgP6cug/LkCI3HLQrFmF6VJQqP84t12ZvRuFEL6hSyhZ2a
	 7H6/wevGUiY8ff+lso61f+WjpZhSsIhd9CPqwz2oiYbiKGbbaF1H99tK1Nh9iNHlyFUFV
	 ZXiLZo2rPNJRmhNJMTxT0RJGe+DRP75AFFk6aQhVodv/SxwoKpWFCcC3QD3TgbdGRYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831454;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=kNK9ItAlbP5UtB+DT3O2t6WPlbTq32qVC5boZAjMRyc=;
	b=svSkpfX9LIcNKnT6JxtrY2kLvRR1HCpqlwS9uZqEmdbBP4bsTbk1b3AV9B5Pa7dGtexD
	 FG/8jq55G3idDSwTQbDqFgJ5ioAPbknfwdKpKAoYm2ElJs/wSYazULaWar/6SVyzrLoB2
	 0ys4G2EO4rCPIzZi4xqCzyMwDm5SHTq8LVGaM4sbyj+RDe6PqQjdpWmd+6YG8uMYAxWPg
	 27Dmg2U9dO2xvCrj9jiP14+fW0SA/0KPyez8PWKhzfHhX+xSq66YDQsA0KNxre7xttjcL
	 X+qcxDW6KbEIavxOZd2nRFoWL6mzytN+RFRLSPh4rB58dLJoyV2YvaCCQG4ZlmdPoDQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTeyeRRR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22033606A335;
	Wed,  4 Nov 2026 22:30:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=uTeyeRRR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AED4A1F000C1;
	Wed,  4 Nov 2026 22:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831454;
	bh=kNK9ItAlbP5UtB+DT3O2t6WPlbTq32qVC5boZAjMRyc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uTeyeRRR6kt4yaer+x9toTOUc8tLmhMS9ooJ7VJP9OYC74KIlJ9ujOD5Qw0hwmnhg
	 9Y51Q5jy3Kci4y8bQy8rlDvzC2cMt9F0jtbb7Bx1jkow8U7rI+HkSv/yw/g7QFEswT
	 N6x/FO4VT/WxGXzHl8NId9GLDxfcYhfCg4MJ7z5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.18 0675/1005] media: cx23885: Fix use-after-free in cx23885_finidev due to race condition
Date: Wed,  4 Nov 2026 16:06:48 -0500
Message-ID: <20261104211102.549108092@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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


