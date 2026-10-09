Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A6DFA4D598B;
	Fri,  9 Oct 2026 14:41:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556900; cv=none; b=F8fZaFs8F4ZN9foeQ8K4ohFuf+P/WFwajYASv+i2RNQmGbFbXOVg945EL8LuEGeE9tFsMmiJdMCIXUwYeZRHmU/sjm9nXwUBu42tssGG1PQS5MkdWGRBimhj4fqH+Ly6XD5wr3IgStkEJSgeRV00pfVT8xndfQbDAnwpDieJ3qc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556900; c=relaxed/simple;
	bh=xCU5jAs74naaPvzBZ2hmQEZ8ZwIzSykcG/pRjABP5eE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBd+LLkRijBgPaFyuZQipN07rNFcQa7mHlIchC77asSBZaNOUJzTDonji4owpVek4S4E3WYQYwuaUY85r3DGpN66DzkAvZI65h2+oXxHyx1dXjgbve57NsS8Na2fU2M9vhamTkDyUtxILo2QPVDU+iFmOFUy+B3vNRHTjKtl65E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KagqJzET; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KagqJzET"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 098FF1F000FF;
	Fri,  9 Oct 2026 14:41:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556899;
	bh=dTVfP55I5RKeQb9nUbHvDSRKhYBGoIV/aN4osVZFm7k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KagqJzETrmfc/UIoSLV4fe+AVBOXBILGkfDe3Uqmc5/7XJI4Wv/tkVuEBEf4puP7r
	 a2bq8YamQlQSrTCYpnKx8mDphgqXaVzxSwrkUEIX8KrX9TCLHoQN1o9ws55RZoxeLe
	 VvdbTIyPG/+VvQRzCVVxvDxLWMcrqWnH93ntdMbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matti Vaittinen <mazziesaccount@gmail.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Subject: [PATCH 6.18 311/403] iio: adc: rohm-bd79124: Fix channel initialization
Date: Fri,  9 Oct 2026 16:11:12 +0200
Message-ID: <20261009140959.492878227@linuxfoundation.org>
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

From: Matti Vaittinen <mazziesaccount@gmail.com>

commit edd56c01d174153bf90160279742ff6f3ad27a93 upstream.

The alarm limit register on BD79124 span to two consecutive registers.
The first register for high-limit containing also hysteresis
configuration. The initialization in driver writes only one 8-bit
register, overwriting the hysteresis and leaving the other limit
register uninitialized.

Fix the limit initialization by using the bd79124_write_int_to_reg(),
which correctly initializes the limit on both of the registers.

Fixes: 3f57a3b9ab74 ("iio: adc: Support ROHM BD79124 ADC")
Signed-off-by: Matti Vaittinen <mazziesaccount@gmail.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jonathan.cameron@oss.qualcomm.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/rohm-bd79124.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/iio/adc/rohm-bd79124.c
+++ b/drivers/iio/adc/rohm-bd79124.c
@@ -949,13 +949,13 @@ static int bd79124_chan_init(struct bd79
 {
 	int ret;
 
-	ret = regmap_write(data->map, BD79124_GET_HIGH_LIMIT_REG(channel),
-			   BD79124_HIGH_LIMIT_MAX);
+	ret = bd79124_write_int_to_reg(data, BD79124_GET_HIGH_LIMIT_REG(channel),
+				       BD79124_HIGH_LIMIT_MAX);
 	if (ret)
 		return ret;
 
-	return regmap_write(data->map, BD79124_GET_LOW_LIMIT_REG(channel),
-			    BD79124_LOW_LIMIT_MIN);
+	return bd79124_write_int_to_reg(data, BD79124_GET_LOW_LIMIT_REG(channel),
+					BD79124_LOW_LIMIT_MIN);
 }
 
 static int bd79124_get_gpio_pins(const struct iio_chan_spec *cs, int num_channels)


