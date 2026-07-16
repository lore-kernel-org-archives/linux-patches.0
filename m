Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CB1A2DF137;
	Thu, 16 Jul 2026 13:38:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209101; cv=none; b=KnWnRNDQ8LOAxWKzYKO7/bG1YHFWBoXFxPzeG3kh0u8nJF68FD8zb6xz0YH5RkM4iEtVNbpD5aevFZeELLxR/Bkdlpe7svfZZ8IgiPktn689p6XD+N2TVVW0+tbq5DIJYXGKnpqkhIOHN34WJtAuSYA0qQUhSfUeOD0ezaO7gRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209101; c=relaxed/simple;
	bh=fX0iaTGBVqD8EMkcmfDoDO95bqfxgSslHPj6yLIjYLo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jqrAZVoBgJpZGmyR34jt8r9KyEfIkuWGTTuPvPGBUpEBCU5qJj0hVDgh9exsdJ6qpAQn7KAVJp2Ea+Rlxr7mi7ujMBkpG8dhgVMs4vTJUXS3UGP2zO93jic9g7vgbZjxnHqoFejVLGSEA8SjJLdaNymGPPbPHNU0PI2/dfA4odg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n8nhbKuA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n8nhbKuA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB971F000E9;
	Thu, 16 Jul 2026 13:38:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209100;
	bh=as7jgEktkRN5ehLrO90zyK4tVF3CddJM0mr6XzICE6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n8nhbKuA6yvRCUm2MqYChxZhkGQj6+Uy3wbpvnDP3xtNRefodhMTjrE8AubmB52rN
	 Q0K2NGKjVWLRKzgOvd3ZIjNyQ7BmE39F/kvu0X3FoQgE8y4JllqTSTqTZCIKZc140M
	 Z0tnwLxY3SgsO7U17rlDuD71hh9Me0fRZhH+9FrY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Runyu Xiao <runyu.xiao@seu.edu.cn>,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 056/518] iio: imu: bmi160: add IRQF_NO_THREAD to data-ready trigger IRQ
Date: Thu, 16 Jul 2026 15:25:24 +0200
Message-ID: <20260716133049.012562530@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
 


