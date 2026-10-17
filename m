Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B921A255E43;
	Sat, 17 Oct 2026 17:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256918; cv=none; b=CogrxYz8NX9CauQp1cTOCVgxjFwbtPZeoKwFR2fAGPn773x/3ARJiClfcxp8qzv4AG0ZDDlweiSukH5gopOhSPPqQrnWPYuQeTn6TsgVQkDo/p1GFmLo+TjX+DSSlWYRUTW5H/QDdb3n2WF7H7J5pWCSedmQo8F2n7gQGXgBr5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256918; c=relaxed/simple;
	bh=BES1zeH0808v/FtsC8vfQLBy0/GfdVtwYMVJKxoSui8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WggKKjkEseA2NWpt+N7vbTIopjjJiR16HhkCDWXeHKOeHHkSWx1WzLaqMb7uGhOZdWnGmep8EY0pbvdkupNxfw9K+b38YF6m7+1AB7mkmo85FWZ5rD3t1o2l7/s1oIURB0jS7/BhNKS1q1o7qUAcWoQqUan3dha2IHo6VVOxZQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lGWPZ+Dr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lGWPZ+Dr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6D9C1F000C4;
	Sat, 17 Oct 2026 17:08:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256916;
	bh=HKL+k80IJLDcBe+wwqLAFYVzb2s1WZ/qZ/dPZu4ijpE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lGWPZ+DrNNdi0Cw+IGikwUysgijiY5Qr4EAq/5BNOsAc38bZZjvEpD/fcI7qtzaEV
	 rs0RJcIYSQAzZ8uPZdsDGgv9Km1s7C6VEcBnylkMhF3qmWvUqDOkpU5Ob2NXQq2L/+
	 TGQILDSGkenMJ1mlTjhS5EDhX1schlWhI8encuzY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.6 0340/1674] iio: adc: xilinx-xadc: free IRQ before cancelling the unmask worker on unbind
Date: Sat, 17 Oct 2026 17:43:32 +0200
Message-ID: <20261017160439.853520322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1403,13 +1403,14 @@ static int xadc_probe(struct platform_de
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


