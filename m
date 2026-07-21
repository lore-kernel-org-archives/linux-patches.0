Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22F023AC0EF;
	Tue, 21 Jul 2026 21:08:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784668138; cv=none; b=CXd/2baUfKSbMw7WgYSwKubT2USX3sPHzU236Juw9x7vROuqGg7osgKgWxHVzlFfC99Ux+LFn+hMTL/KGPSy9GEJPc4rCUCFO8cbLIyCkdXQpKyQJHR0S7n36pogF/Amh2Hi1c4dkn/QquCh7LV8qvdmbf7cJy/nYrTeXDXdxI8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784668138; c=relaxed/simple;
	bh=E8MLjMHbbyJEPZsqHHuNmoWGfYzu0YjNfvixS0bOolM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ISL+e8L3WM/nwCiedJex0CU1LcbLfGZKbxsK/Ng8XEUK+plHKkTVLkK5Edh9kYyrUpTAVIgct3ogz6e5QOoqzJF0PJ+rxtc7lIasGds+hgdyWM3R2K6VibHd73mDSUibk/CWOufAwcJ3X+uYVSmPH7VJwPWZDuY4XX5fwk6CV+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aYOawhH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aYOawhH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88D351F000E9;
	Tue, 21 Jul 2026 21:08:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784668137;
	bh=0N52Ii+rvZva8lcKCuCw31yFUl9ICEniDtJmZgHxDL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=aYOawhH4JAdIXcOOuhmVpomME1zdGvZ3AuhREQ/fe1VYIfeGe/YNTONQindlieSaN
	 lxdFqoxHQd59MUtRKfdf+WXqKZKfHNavLA0KNr9KXkqkwg25r4MSAJV+l6HP0FCCHO
	 4zHgm1Pnkx7Tv/GVMD04jP8WE4bF5EY5bYSGSiq8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.1 0063/1067] iio: imu: bmi160: add IRQF_NO_THREAD to data-ready trigger IRQ
Date: Tue, 21 Jul 2026 17:11:04 +0200
Message-ID: <20260721152425.979160699@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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
@@ -784,7 +784,8 @@ int bmi160_probe_trigger(struct iio_dev
 
 	ret = devm_request_irq(&indio_dev->dev, irq,
 			       &iio_trigger_generic_data_rdy_poll,
-			       irq_type, "bmi160", data->trig);
+			       irq_type | IRQF_NO_THREAD,
+			       "bmi160", data->trig);
 	if (ret)
 		return ret;
 


