Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBB54189DA;
	Tue, 21 Jul 2026 21:55:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784670938; cv=none; b=PpgGHTFO0OhBiq9mMFQzqhLBtkP054Wk/1smLphvPRVzTCV7eJRkcXSITOUbnwoZlwUKDQx6cxKw8TsJkStSR0tG4sLDS6ijpS6q9PMme6xXs+YNRVP2tpEBAOOjX9VH8hYUMmEtbZ6exUC8yWeG9Mneigo57ueSQVU+MwqiSlU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784670938; c=relaxed/simple;
	bh=E4UnOFUmQNQGbkZEKMcnTx7rfZa0MKJ3DMuTYpDLHT8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WAPTVNIat/TEKXscw1fPQC6U55osEnWtvETTrXddgUqaXsYXPZ0JDfAAflzTO47MP6hNmvGSxamkxX1h75sPMhkta5m0Tqj0hhx4sBLxVkXHUhEeFw8E+U1b59KoE9cdQmSz8pfGuCAgZvvpzIeEyckzBscwNGPeIH5DHSzJojw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BhL2WX9Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BhL2WX9Y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E136E1F00A3A;
	Tue, 21 Jul 2026 21:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784670937;
	bh=WvV5wqkP+GV0QUBPKrocutW3mtqeJ+6vowPgcJL3Gt0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BhL2WX9Y+nasseAsh5/osG/RzzF7+q5kLyH0ERjeoL+uT8g6IbWGs33XD7QKV5eSG
	 RmIHmIJulX5THfIL3Mwa34jbhPjOMH2IC/twhDdO9Xf3CAXb8GeCAxccWYWQGDmy17
	 HoVvKYGkmPAVdh0dSWejN1XbSIYgt/qoj+wqV/1I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 5.15 057/843] iio: imu: bmi160: add IRQF_NO_THREAD to data-ready trigger IRQ
Date: Tue, 21 Jul 2026 17:14:52 +0200
Message-ID: <20260721152407.266848037@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -801,7 +801,8 @@ int bmi160_probe_trigger(struct iio_dev
 
 	ret = devm_request_irq(&indio_dev->dev, irq,
 			       &iio_trigger_generic_data_rdy_poll,
-			       irq_type, "bmi160", data->trig);
+			       irq_type | IRQF_NO_THREAD,
+			       "bmi160", data->trig);
 	if (ret)
 		return ret;
 


