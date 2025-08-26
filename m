Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F782F83BA;
	Tue, 26 Aug 2025 14:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218499; cv=none; b=pzyTYmD3ZDjzBMXAfrPCQtcViY7LKbfaqtb5YDJ9kNXESfts2ROD5JpZBCwgb0SP5QG/ysjobrhhu41PzcY0XPD693uliqlvqrgU5vyanWzOjes+ps6tGMzZf8ihtiAltRKry4AsxQgxPOpQ87nEUSmaR1lCdqUb6IMCAb5oKZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218499; c=relaxed/simple;
	bh=2e2V1r0DBhwkkAllKyZebN/mkjrwt1VhdG/qbpCor9Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GgUWQWh9A7YFi161MsntLk3VgLIMDieZFHX+wdjmVWQv3XJ200JQo/Kpvu0EWa0MTUud+RCZc0zCc3rjZ1AQm+aousShDg7FIntjWcLHtbWM9/yDik0Y9ddm5wiNLbHDZpHuNStVaKIbGpvvwbPfGvn6BEIbwS08kFUEoAMK9E0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vW51mTtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vW51mTtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A8EBC4CEF1;
	Tue, 26 Aug 2025 14:28:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218499;
	bh=2e2V1r0DBhwkkAllKyZebN/mkjrwt1VhdG/qbpCor9Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vW51mTtEfYsSE0cr9V9f+bjVm6C4aJMRVtV0eN2Ih3HF7e4lgfDG4+j8dXrqPvXdz
	 R4uIeTmss3DW/g2I9RSJdctjHOdBNaD/1jNrkhLU23755WlCBfvIQTPqAdP9Sq24eQ
	 +8rdLCCo3nLGwIR9ZxxXEHowEVM4kGL0L4b7g9+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chen Ni <nichen@iscas.ac.cn>,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>,
	Fabrice Gasnier <fabrice.gasnier@foss.st.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.4 024/403] iio: adc: stm32-adc: Fix race in installing chained IRQ handler
Date: Tue, 26 Aug 2025 13:05:50 +0200
Message-ID: <20250826110906.440255272@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chen Ni <nichen@iscas.ac.cn>

commit e8ad595064f6ebd5d2d1a5d5d7ebe0efce623091 upstream.

Fix a race where a pending interrupt could be received and the handler
called before the handler's data has been setup, by converting to
irq_set_chained_handler_and_data().

Fixes: 1add69880240 ("iio: adc: Add support for STM32 ADC core")
Signed-off-by: Chen Ni <nichen@iscas.ac.cn>
Reviewed-by: Nuno Sá <nuno.sa@analog.com>
Tested-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Reviewed-by: Fabrice Gasnier <fabrice.gasnier@foss.st.com>
Link: https://patch.msgid.link/20250515083101.3811350-1-nichen@iscas.ac.cn
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/stm32-adc-core.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/stm32-adc-core.c
+++ b/drivers/iio/adc/stm32-adc-core.c
@@ -393,10 +393,9 @@ static int stm32_adc_irq_probe(struct pl
 		return -ENOMEM;
 	}
 
-	for (i = 0; i < priv->cfg->num_irqs; i++) {
-		irq_set_chained_handler(priv->irq[i], stm32_adc_irq_handler);
-		irq_set_handler_data(priv->irq[i], priv);
-	}
+	for (i = 0; i < priv->cfg->num_irqs; i++)
+		irq_set_chained_handler_and_data(priv->irq[i],
+						 stm32_adc_irq_handler, priv);
 
 	return 0;
 }


