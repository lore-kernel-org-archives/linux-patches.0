Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4A380364059;
	Wed, 30 Sep 2026 17:07:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788076; cv=none; b=bhwiIaeuUCKaBpzlozootkhE25Fd5nXeAH/NVolRt+WDfn/l1jkE2VdwEKSJNxN1TMNcTcfx4HrPdGJ2bIPoCkRdgaajAIV1ZxywPAwfRq0LSgj9LiHxloJkWSAd7CyN9rzG0ATEVKLAONtjm2IqDZriiVIqNq2qXu2fN6ttTD0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788076; c=relaxed/simple;
	bh=ENkUh2eiUCkojhPpmAvg8Jrp2bkHzzwPKH6gmt/xYYA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNkAWOL4z2FE7nCQNSH9a/d+whw1dfoL1ZokZZVcGivsdDng4uWExY8/hnI0HJDSHwulRlRSW5nsdANnvmFPDlAkyoAdoS0YMS0iBWtIEeGWJqgo80IPdGAfsHxq3gCpKIiS6KLx6zSE/fUXj1Z02nOe19p6vch5Ei37tXzpxwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SfGPVjVu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SfGPVjVu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9AFAB1F000FF;
	Wed, 30 Sep 2026 17:07:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788075;
	bh=LoCvUKsFiVkZ0OgbNetJUJHiVAMbX0MAeWb8y2960Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SfGPVjVudHrPbq7dUkXQLJkZIpB/2477gsXulCc1JXP+xRCUg9SWGh4NoA1Q8S92J
	 TytoEprGc96pMmY3X5h5NkW5yWTNQFen+eeLZYzw7g4pc5uxu9y6qFjUflQ+VUPRk5
	 fi30kT3uGvGomS07WccIZnK1XU+gAlJwfZ0ZUlbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>,
	Karol Wachowski <karol.wachowski@linux.intel.com>,
	dri-devel@lists.freedesktop.org
Subject: [PATCH 7.2 456/457] accel/ivpu: Drop IRQF_ONESHOT to allow IPC IRQ threading on PREEMPT_RT
Date: Wed, 30 Sep 2026 17:29:21 +0200
Message-ID: <20260930152355.849561690@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

From: Karol Wachowski <karol.wachowski@linux.intel.com>

commit 799c8f0b9f3fd728b32594aed3852044703b7e5b upstream.

The IPC RX hardirq handler matches consumers under a spinlock and
allocates rx_msg buffers. On PREEMPT_RT these spinlocks become sleeping
locks and the allocation may sleep, neither of which is allowed in true
hardirq context, resulting in "sleeping function called from invalid
context" splats.

IRQF_ONESHOT makes genirq keep the primary handler in hardirq even when
forced threading is enabled, so on PREEMPT_RT the handler cannot be
threaded. Drop the flag so the primary handler is threaded on PREEMPT_RT
and the IPC RX path runs in a context where sleeping is allowed. On the
MSI interrupt chip (IRQCHIP_ONESHOT_SAFE) the flag was stripped anyway,
so non-RT behaviour is unchanged.

Fixes: 85c9cc2d25f8 ("accel/ivpu: Use threaded IRQ for IPC callback processing")
Cc: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Cc: Karol Wachowski <karol.wachowski@linux.intel.com>
Cc: dri-devel@lists.freedesktop.org
Reviewed-by: Andrzej Kacprowski <andrzej.kacprowski@linux.intel.com>
Signed-off-by: Karol Wachowski <karol.wachowski@linux.intel.com>
Link: https://patch.msgid.link/20260617092031.3016582-1-karol.wachowski@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/accel/ivpu/ivpu_drv.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/accel/ivpu/ivpu_drv.c
+++ b/drivers/accel/ivpu/ivpu_drv.c
@@ -624,7 +624,7 @@ static int ivpu_irq_init(struct ivpu_dev
 	vdev->irq = pci_irq_vector(pdev, 0);
 
 	ret = devm_request_threaded_irq(vdev->drm.dev, vdev->irq, ivpu_hw_irq_handler,
-					ivpu_ipc_irq_thread_handler, IRQF_NO_AUTOEN | IRQF_ONESHOT,
+					ivpu_ipc_irq_thread_handler, IRQF_NO_AUTOEN,
 					DRIVER_NAME, vdev);
 	if (ret)
 		ivpu_err(vdev, "Failed to request an IRQ %d\n", ret);


