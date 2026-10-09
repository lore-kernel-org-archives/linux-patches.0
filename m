Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD444E50C2;
	Fri,  9 Oct 2026 14:42:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556947; cv=none; b=I16QX4wIh3Kml8SF0QY/rbWZZ2GK5ymXn9qVjbCf1EY/j5r4dcwI+T+SxSTdeGQTPyoEt2AOY64MjLgGvbP3YhDXyczEhwxvt5+cV0S1QtTcshworMF1BjLQcryJhb8AkKf18UKSPAZ6i0hbKaT4gyRzJyizzx4aYu713hxcS4Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556947; c=relaxed/simple;
	bh=j72wS5B3Uehp/Vb7l6s63M0ylW8TRTYO5/19jBsfItg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DH7Z0WQFr44MHFbNLY/f0L2Vh1J5mpyYqFsfOvtz598WADI3cp6Ajveubzro1HreFsGYMUpzIPXU1Q77LbY9SdGnLrlSiXItGcDzQ7EyYKw0EASAKLbnAMRYjv6bQA1Q1KfklMjEVIIsjoPibl0ESe/km8+V5eIaE3wlQzxWigk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mjx/NJYE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mjx/NJYE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B337A1F000FF;
	Fri,  9 Oct 2026 14:42:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556945;
	bh=A75LoMjrbUaL2sV13URR/bKe7m4oFJmXVJKimlRiyis=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mjx/NJYE46HWxWNLWueD81u4m3b9u1lx/LCABcckmRzolCLqtDHACk4aqonvxLhR0
	 r1wTQHvnirdntyzwjF43YsEZqeS/DNwurT+1It3dRnuyH1pASWLzyqM0vuiSAHRAVD
	 xtCngT66/CvXnD1wWJXgCKOJtY7J38Tqxys6uWCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Lechner <dlechner@baylibre.com>,
	Fan Wu <fanwu01@zju.edu.cn>,
	Sai Krishna Potthuri <sai.krishna.potthuri@amd.com>,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 318/403] iio: adc: xilinx-xadc: free IRQ before cancelling the unmask worker on unbind
Date: Fri,  9 Oct 2026 16:11:19 +0200
Message-ID: <20261009140959.662592650@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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


