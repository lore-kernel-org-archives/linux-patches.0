Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85CAC158D64;
	Mon, 29 Jan 2024 17:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548233; cv=none; b=n9hZN/SIPqwVXZXAbvuswiV8uTIYwmMXc6jNRyzsXCZ95BNxiGR0Fh2PsOP5/ihWFu1pMP9Ci5CmuTPb8xO5yWhbsn5Nrvy4m56B3PqrwowbEwpH85IpBGNAaqOyIRxSZILWXYUruNeuVcA5G1sHpVGG13F8QYjty9GT8MxztrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548233; c=relaxed/simple;
	bh=bPnHeVED4NDG7OOJnTDPeXHBgTkYV68JRcBSHPwA65E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ifAE6XczNoUuxyfxchj1ue0uhSauwc2A4ChMZtpovTEMSDw/jQ0GSufXoNMSInVpXz+4LZnDX+1gk07BO13KbQLSe2uzWT0xWe5skjM3loarxYxut7lBxuM/iU7TzyTn8TAeKTM1Xd7VoZHPYERuQCSfWIvM2yYPYfUsMj0W1oE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F/ihRw9T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F/ihRw9T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F0A6C43390;
	Mon, 29 Jan 2024 17:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548233;
	bh=bPnHeVED4NDG7OOJnTDPeXHBgTkYV68JRcBSHPwA65E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F/ihRw9Tg5NgdI1cB2o1XvAeXRNzue19SWcSLFdxYZzVUcNv+ENjmg/ci76hDpbst
	 jlm1tFeqVtRMMNNaaAhbRtSuq+BmmnMO1u8Xd8OYnY+FeNV54krqpMNK0p50cw1UFG
	 CkQrRdXoP4P5Oo0aFnQaRlIHyfl6uhEIbNJoAXXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marcelo Schmitt <marcelo.schmitt@analog.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 005/185] iio: adc: ad7091r: Set alert bit in config register
Date: Mon, 29 Jan 2024 09:03:25 -0800
Message-ID: <20240129165958.774160746@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marcelo Schmitt <marcelo.schmitt@analog.com>

[ Upstream commit 149694f5e79b0c7a36ceb76e7c0d590db8f151c1 ]

The ad7091r-base driver sets up an interrupt handler for firing events
when inputs are either above or below a certain threshold.
However, for the interrupt signal to come from the device it must be
configured to enable the ALERT/BUSY/GPO pin to be used as ALERT, which
was not being done until now.
Enable interrupt signals on the ALERT/BUSY/GPO pin by setting the proper
bit in the configuration register.

Signed-off-by: Marcelo Schmitt <marcelo.schmitt@analog.com>
Link: https://lore.kernel.org/r/e8da2ee98d6df88318b14baf3dc9630e20218418.1702746240.git.marcelo.schmitt1@gmail.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Stable-dep-of: 020e71c7ffc2 ("iio: adc: ad7091r: Allow users to configure device events")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ad7091r-base.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/iio/adc/ad7091r-base.c b/drivers/iio/adc/ad7091r-base.c
index 0e5d3d2e9c98..8aaa854f816f 100644
--- a/drivers/iio/adc/ad7091r-base.c
+++ b/drivers/iio/adc/ad7091r-base.c
@@ -28,6 +28,7 @@
 #define AD7091R_REG_RESULT_CONV_RESULT(x)   ((x) & 0xfff)
 
 /* AD7091R_REG_CONF */
+#define AD7091R_REG_CONF_ALERT_EN   BIT(4)
 #define AD7091R_REG_CONF_AUTO   BIT(8)
 #define AD7091R_REG_CONF_CMD    BIT(10)
 
@@ -232,6 +233,11 @@ int ad7091r_probe(struct device *dev, const char *name,
 	iio_dev->channels = chip_info->channels;
 
 	if (irq) {
+		ret = regmap_update_bits(st->map, AD7091R_REG_CONF,
+					 AD7091R_REG_CONF_ALERT_EN, BIT(4));
+		if (ret)
+			return ret;
+
 		ret = devm_request_threaded_irq(dev, irq, NULL,
 				ad7091r_event_handler,
 				IRQF_TRIGGER_FALLING | IRQF_ONESHOT, name, iio_dev);
-- 
2.43.0



