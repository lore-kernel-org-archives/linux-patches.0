Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C4931ED7C;
	Thu, 16 Jul 2026 14:01:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210493; cv=none; b=UqR7AAK6VRsAk1dKV5Nyac/etUkCV/Z44C4su4vtTXXzZspmhK6ZyA65DDGghe8GXtgc0G2jG85H39Pa+ixaXV9FQuDDY5flBxp8ner57EeSw3jSEeb2dOFVLV6cP+7Jka6GpJ0r7juY1WuLt2P1uWtrDtvvIFIrXdvU16aG1Yw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210493; c=relaxed/simple;
	bh=kbACfqLKgx1yZj/Fe0CoWw9l4WL4wbdj5sQB7GR8f7Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hLG+N62LU2IX1uYq11aJeXR3B9t/yJeAqxdFLV4m8Om0TPqzMTdb7LE4W+0akEG1kJsDs+3z7JI78s5VMPmISx66UrrEJGXxvAPo7nQFoX/TAxMVclaM5EUWZb35+kpxY9j9IfvoSzC1uprU1YU/qeLWGrsRwwipEtFBdpiajV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QvEw1uQE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QvEw1uQE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 03A921F000E9;
	Thu, 16 Jul 2026 14:01:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210492;
	bh=1Q/8NirhPXNpX1Ik3qWQ9vWV2Qzje/sIqfB7WkK+5T8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QvEw1uQETE9UfScsQXsYDINaz6Urx9rY/5MG8KIAtjUoi/kScK3jZJvJNlgZI+Ryy
	 Y1QgLPkYb7UggJyjWcOQSn+dH9ZC9gC8PRjsL4ebzYGsxPFvywXZ94/4a5vrqv4Pgc
	 zz4kLPiLWyIEtiwYJF2p+TNBCZX7miaa6xfUWrV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 068/480] iio: imu: bmi160: add IRQF_NO_THREAD to data-ready trigger IRQ
Date: Thu, 16 Jul 2026 15:26:55 +0200
Message-ID: <20260716133046.180715712@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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
@@ -788,7 +788,8 @@ int bmi160_probe_trigger(struct iio_dev
 
 	ret = devm_request_irq(&indio_dev->dev, irq,
 			       &iio_trigger_generic_data_rdy_poll,
-			       irq_type, "bmi160", data->trig);
+			       irq_type | IRQF_NO_THREAD,
+			       "bmi160", data->trig);
 	if (ret)
 		return ret;
 


