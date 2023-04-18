Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A782566
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:25:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3288C433D2;
	Tue, 18 Apr 2023 12:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681820752;
	bh=RCcIzMqCRkDHlbXcY9Qu9etEFyg9ePZW9O64p7a5/C4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h0QIVsP3w6bnz45Po0Fxmx0qSf5KileVomLVo0j5CFi98oeEWBHdwMf4RocY26IFT
	 l7s8gSaIaUWApVNh9A1hDLeOShXOesO4WUx/8/0YSzR/QymYq1uW3swHFPsUuUMQbr
	 umq/CCFj6IVZc7GJc89O1ZHr474pBtkNIx8IcvQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 4.19 18/57] iio: dac: cio-dac: Fix max DAC write value check for 12-bit
Date: Tue, 18 Apr 2023 14:21:18 +0200
Message-Id: <20230418120259.371655699@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120258.713853188@linuxfoundation.org>
References: <20230418120258.713853188@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: William Breathitt Gray <william.gray@linaro.org>

commit c3701185ee1973845db088d8b0fc443397ab0eb2 upstream.

The CIO-DAC series of devices only supports DAC values up to 12-bit
rather than 16-bit. Trying to write a 16-bit value results in only the
lower 12 bits affecting the DAC output which is not what the user
expects. Instead, adjust the DAC write value check to reject values
larger than 12-bit so that they fail explicitly as invalid for the user.

Fixes: 3b8df5fd526e ("iio: Add IIO support for the Measurement Computing CIO-DAC family")
Cc: stable@vger.kernel.org
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/20230311002248.8548-1-william.gray@linaro.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/dac/cio-dac.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/iio/dac/cio-dac.c
+++ b/drivers/iio/dac/cio-dac.c
@@ -74,8 +74,8 @@ static int cio_dac_write_raw(struct iio_
 	if (mask != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
 
-	/* DAC can only accept up to a 16-bit value */
-	if ((unsigned int)val > 65535)
+	/* DAC can only accept up to a 12-bit value */
+	if ((unsigned int)val > 4095)
 		return -EINVAL;
 
 	priv->chan_out_states[chan->channel] = val;


