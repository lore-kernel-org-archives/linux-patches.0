Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7970400982;
	Thu, 16 Jul 2026 14:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784211844; cv=none; b=nxFRZSQJ5jrC+DBUOink2msrvtQWHBj4NGSW2YJkakslweD/Ffj+F2mYiYiHQFFbwoGwj0YOPvk19x/nS+Oe/KiAykVtso07mpDdRrXDtceMTQ/VR9tAttZntudTZcQdTK6nbviwTszZzJtzdH7k0TP3+Vpz0IkEOvkR21se1uM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784211844; c=relaxed/simple;
	bh=DW6D/Up4/mQXnzJq0fyUH/i03VXobwK0yjscVwHD1Mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l7EdNtcrPIoyoRWlhP7IeilZiH6vuVDjNVO2ONzQbc5fcraj/txvjGD+rB5r76o92j/jYlc1HOehe0J3Pnzwn9CF/MbWQBpJHsgqUUin+RXOKyPS6F1PuhWVo2Ex92ZuTQ/SnHgLv0eB9WFMpQhLtI+jq7T6JrkIfjWIUpRwmu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qkB1VUXa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qkB1VUXa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1F5861F000E9;
	Thu, 16 Jul 2026 14:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784211842;
	bh=cMU4zlKKaGLb8UPPYWaA6l9wz0rP+09hgWEXgk1Ylis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qkB1VUXaSFrLaFUhJt/gJndbmDah0YK0BkWFf22vRDuRPiNpDMSomi1fMwDP1vabL
	 bqD0mAP8tEplhu6Z68EBIIdsZF4IHmub6VOSr3WutpOickttebdZI2omk1ZYT0wcIF
	 UpRz/C76d9t6PolOJrYF/P9bmIrw7kKnbS+lHw6g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.12 057/349] iio: imu: bmi160: add IRQF_NO_THREAD to data-ready trigger IRQ
Date: Thu, 16 Jul 2026 15:29:51 +0200
Message-ID: <20260716133034.601156629@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133033.287196923@linuxfoundation.org>
References: <20260716133033.287196923@linuxfoundation.org>
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

From: Runyu Xiao <runyu.xiao@seu.edu.cn>

commit cd5a6a5096b246e10600da3ac47a1274ce9573c8 upstream.

bmi160_probe_trigger() registers iio_trigger_generic_data_rdy_poll()
through devm_request_irq(), but it passes only irq_type and does not add
IRQF_NO_THREAD.

When the kernel is booted with forced IRQ threading, the parent IRQ can
otherwise be threaded by the IRQ core and the subsequent IIO trigger
child IRQ is dispatched from irq/... thread context instead of hardirq
context. Because the handler immediately pushes the event into
iio_trigger_poll(), this violates the hardirq-only IIO trigger helper
contract and can drive downstream trigger consumers through the wrong
execution context.

Add IRQF_NO_THREAD on top of irq_type when registering the BMI160 data-
ready trigger handler.

Fixes: 895bf81e6bbf ("iio:bmi160: add drdy interrupt support")
Cc: stable@vger.kernel.org
Signed-off-by: Runyu Xiao <runyu.xiao@seu.edu.cn>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/imu/bmi160/bmi160_core.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

--- a/drivers/iio/imu/bmi160/bmi160_core.c
+++ b/drivers/iio/imu/bmi160/bmi160_core.c
@@ -797,7 +797,8 @@ int bmi160_probe_trigger(struct iio_dev
 
 	ret = devm_request_irq(&indio_dev->dev, irq,
 			       &iio_trigger_generic_data_rdy_poll,
-			       irq_type, "bmi160", data->trig);
+			       irq_type | IRQF_NO_THREAD,
+			       "bmi160", data->trig);
 	if (ret)
 		return ret;
 


