Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D994036B937;
	Tue, 13 Oct 2026 12:42:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895325; cv=none; b=cPoSRKkqL/gGZi27xFX5ptCr4m6fh/+R87TwGCj7yLIRoP9cUiIfJZpeR25kTHq/fFQ1I6NE2bkQS+SqRbE+YO5zsIQN84JHNa7+S+Gca3tnterRQB8dvO3FCpT8br1G/zr37W8bdn/t8P+ay316ii6w6fDphbur6m+r21TqdXI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895325; c=relaxed/simple;
	bh=4mdi+U8srcKUgip3mmlicLfo8dS1rGSRr1qIHzlbHPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VwqsKzApkTAdK8lBONa1iCF14FX+5Mqk9iQYqTr48wZEn+6nYfAn5TqN7QV6kMWMFTMCGMDH6tS/Qb6GrFJ7RpHj+4Crj0vHeXahn1teK/73HNgqXhAwouRKaekhMH3YIMAV9zcQdIja8TzoQkvoGyi4l6QgnMbLRKPArrEzGZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dozWZ4+b; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dozWZ4+b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 687121F00893;
	Tue, 13 Oct 2026 12:42:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895323;
	bh=bjBU7TxkNXf9b2JhdXAkX5iY6n36CqBLiFbObkNyNew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=dozWZ4+bI62LtPH6MalCL2VudFTSLhn7mESr3qDkeP3ZFirTcTEm/gyqk+Ezc/sBU
	 IwqHhPJDHBrcrv5d5X4lTQo9FugZ51AujndVBmaTG5db34bis8M/z4wDPfpz5FT/is
	 Ntnh6AZWhwnGNobMUI181fy/4M3FyCmwOgIzzvTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.12 237/497] iio: adc: xilinx-xadc: free IRQ before cancelling the unmask worker on unbind
Date: Tue, 13 Oct 2026 13:36:44 +0200
Message-ID: <20261013112913.521897217@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
@@ -1402,13 +1402,14 @@ static int xadc_probe(struct platform_de
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


