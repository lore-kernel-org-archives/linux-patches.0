Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6C43D905B;
	Wed,  8 Apr 2026 18:45:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775673908; cv=none; b=cqUVS0rmIIwOz8mFu+s4UwwdeZyUI071z9SMzjrzTv2HxWDhissXAgVL5H4GswDQC/ytWeMeAU+M+9zyvESEwDIO3oe+qeKb3Rp9SR0yRthWwhreFzLby69mJELVH1C33hxOOaU/PmZXV5bEC36Fbjfhulmy8TQJE/ngmZZkCtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775673908; c=relaxed/simple;
	bh=7vDa3ApQiwxJlnlp/XVC4bI2T100dO3/RsvfQyjSG9I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S2f23JYZjSQ1ZQaYmXe9oOWE/+Ed+Edzy93Sir99Wlt7IIykcAavVoDhziKcwJpisNki7vDNxAjEbyip8kNvj2/w1ORnBlnLfxqPWiMGJF255YxSa/bFkD9gPGBTqotlCXmcdcR4AWQaLrVF+M4dUVP/sh+dFDo2yWSOGqB8UCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WWQTZTcI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WWQTZTcI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9710FC2BC9E;
	Wed,  8 Apr 2026 18:45:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775673907;
	bh=7vDa3ApQiwxJlnlp/XVC4bI2T100dO3/RsvfQyjSG9I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WWQTZTcIGi7e5gw7FAY4cvpK8DDYoyZfgN7CZKJ3utqnKkaSXohSC+PyBQQpR6bGS
	 zTJ0POhiEhaiWV/ewhZhAssIlQ+N3GQ+5K3X+Qizg0ozX9ks/Z6FYDQCt27aA3WTLI
	 ZDH+/w6ySDrQO/OGHuFSf5xBIaBS1Jk/3S8Bg/ik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Felix Gu <ustc.gu@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 134/242] iio: adc: ti-ads1119: Replace IRQF_ONESHOT with IRQF_NO_THREAD
Date: Wed,  8 Apr 2026 20:02:54 +0200
Message-ID: <20260408175932.103798898@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175927.064985309@linuxfoundation.org>
References: <20260408175927.064985309@linuxfoundation.org>
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

From: Felix Gu <ustc.gu@gmail.com>

commit 36f6d4db3c5cb0f58fb02b1f54f9e86522d2f918 upstream.

As there is no threaded handler, replace devm_request_threaded_irq()
with devm_request_irq(), and as the handler calls iio_trigger_poll()
which may not be called from a threaded handler replace IRQF_ONESHOT
with IRQF_NO_THREAD.

Since commit aef30c8d569c ("genirq: Warn about using IRQF_ONESHOT
without a threaded handler"), the IRQ core checks IRQF_ONESHOT flag
in IRQ request and gives a warning if there is no threaded handler.

Fixes: a9306887eba4 ("iio: adc: ti-ads1119: Add driver")
Signed-off-by: Felix Gu <ustc.gu@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ti-ads1119.c |    6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/ti-ads1119.c
+++ b/drivers/iio/adc/ti-ads1119.c
@@ -738,10 +738,8 @@ static int ads1119_probe(struct i2c_clie
 		return dev_err_probe(dev, ret, "Failed to setup IIO buffer\n");
 
 	if (client->irq > 0) {
-		ret = devm_request_threaded_irq(dev, client->irq,
-						ads1119_irq_handler,
-						NULL, IRQF_ONESHOT,
-						"ads1119", indio_dev);
+		ret = devm_request_irq(dev, client->irq, ads1119_irq_handler,
+				       IRQF_NO_THREAD, "ads1119", indio_dev);
 		if (ret)
 			return dev_err_probe(dev, ret,
 					     "Failed to allocate irq\n");


