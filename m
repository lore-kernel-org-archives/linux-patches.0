Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 333A82F24
	for <patches@lists.linux.dev>; Wed, 12 Apr 2023 08:37:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEEF9C433EF;
	Wed, 12 Apr 2023 08:37:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681288656;
	bh=NhsScW4y2Y9pkswRHZwszDvBFBlk2v4xUQOht6nyfu0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=nlYRzS35WvAYYkcELGY3+Mv9WbvtrTqna4XKFA0QX+juZ6CbH1FKAhq/NlJ8lHg6U
	 oCnc07gd20rQYiOYkcZCKnaEFoMuunwW85eX9UuD1rqBVE/0xQMeVlbcnZ/7Xk7rHJ
	 OPMRO8PcfVbpFRvkGNnRZchz8Es0hyspaGgjteX0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 5.15 61/93] iio: dac: cio-dac: Fix max DAC write value check for 12-bit
Date: Wed, 12 Apr 2023 10:34:02 +0200
Message-Id: <20230412082825.709517725@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230412082823.045155996@linuxfoundation.org>
References: <20230412082823.045155996@linuxfoundation.org>
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
@@ -66,8 +66,8 @@ static int cio_dac_write_raw(struct iio_
 	if (mask != IIO_CHAN_INFO_RAW)
 		return -EINVAL;
 
-	/* DAC can only accept up to a 16-bit value */
-	if ((unsigned int)val > 65535)
+	/* DAC can only accept up to a 12-bit value */
+	if ((unsigned int)val > 4095)
 		return -EINVAL;
 
 	priv->chan_out_states[chan->channel] = val;


