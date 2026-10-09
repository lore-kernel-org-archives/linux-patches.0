Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DF92C0F6D;
	Fri,  9 Oct 2026 14:53:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791557613; cv=none; b=SrPVvTT4syHDwqc5kybJ0Oj85MqakgBjnpxUDC9C0X+AheaqcAVjKSf0O2JkfeZKmkiAg3mjpDbj8dBGDXnKoAQBW3oENFDa89aiBW8e4AYzSDRVubh/2nCydF7LKxWiW3AnKaolp/WwDvrM1pXx+iDcXv6Rjsf7JmsHmw6r6Ig=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791557613; c=relaxed/simple;
	bh=7/m1CVAChIiDYzwewuFINd81f5uExpJq2Yh5VVj+Goo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KrjTRnFYdl/0oyQ6GIsrROm8iFafp345pWCttkbulTLzYUUD+wqWhDqckxUDmhDGyVich96ZXnYhzsDAZqGNXqB8FJ7FxpJ1/8jzKN74km2hXmiFFSZe1TDvdJqiJMYqh2Qylhwnc3Tqdzb55hROmvwWiD90ZQtj8Wau8GMFJ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P1LTdZyI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P1LTdZyI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 32F551F000FF;
	Fri,  9 Oct 2026 14:53:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791557611;
	bh=dW6ydnpdxB4nX73RYwHrRdTEwn8Bh/ZLgiHGN1UONPw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P1LTdZyIZ6hbksadUp9LNh3jD4A572wR+xVZ1SbvG54q9oRqKYtmUYN3IbhQkiwDz
	 0XXjyTwa3vo56ePBCz39nDqVtpcOwkdvnx9sqDIrzrW5tBbc3WRlzMqFcbne4K94JJ
	 eAnn3/om6SpXOq4xYoAicqxdvGF9qz3O/VVh69Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 7.2 393/428] iio: adc: xilinx-xadc: free IRQ before cancelling the unmask worker on unbind
Date: Fri,  9 Oct 2026 16:12:10 +0200
Message-ID: <20261009140954.839097174@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

From: Fan Wu <fanwu01@zju.edu.cn>

commit 0f3f427076240e75ff265e61645627a71ca4918c upstream.

The ZYNQ XADC alarm IRQ handler queues zynq_unmask_work via
schedule_delayed_work(); that work is cleared by a devm callback.
Register the devm callback before devm_request_irq() so the devres LIFO
teardown frees the IRQ first, ensuring the handler can no longer queue
work by the time the workqueue is cleared. Otherwise the handler could
re-arm the work and run it after the xadc structure has been freed.

This issue was found by an in-house static analysis tool.

Fixes: 2a9685d1a3b7 ("iio: adc: xilinx: use more devres helpers and remove remove()")
Cc: stable@vger.kernel.org
Assisted-by: Codex:gpt-5.6
Reviewed-by: David Lechner <dlechner@baylibre.com>
Signed-off-by: Fan Wu <fanwu01@zju.edu.cn>
Reviewed-by: Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/xilinx-xadc-core.c |    9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/xilinx-xadc-core.c
+++ b/drivers/iio/adc/xilinx-xadc-core.c
@@ -1401,13 +1401,14 @@ static int xadc_probe(struct platform_de
 	}
 
 	if (irq > 0) {
-		ret = devm_request_irq(dev, irq, xadc->ops->interrupt_handler,
-				       0, dev_name(dev), indio_dev);
+		/* Clear out any work queued by the interrupt */
+		ret = devm_add_action_or_reset(dev, xadc_cancel_delayed_work,
+					       &xadc->zynq_unmask_work);
 		if (ret)
 			return ret;
 
-		ret = devm_add_action_or_reset(dev, xadc_cancel_delayed_work,
-					       &xadc->zynq_unmask_work);
+		ret = devm_request_irq(dev, irq, xadc->ops->interrupt_handler,
+				       0, dev_name(dev), indio_dev);
 		if (ret)
 			return ret;
 	}


