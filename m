Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C01B168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:54:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EC83C433EF;
	Mon,  8 May 2023 10:54:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683543274;
	bh=d9BnRLNFQ8S4dfcDbJW70ry6tDS+uDw92joYRDnVDoE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z2ILo71N4lC+B1z/2divNmWekYb38rJapHbk+lK4RqSLAt7bKpnf8BMgOLaxfVgOI
	 9vQ7B+Dw7o+1Hv6HMlfUv/HkNnN/kdbhmi5YsZ8nwCZfojM/OtoGlLycJ1Gio8OrxQ
	 NBIRTgtxmLbQoMuBAfoC0ry4ZPBehalldpHeDIzE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.3 037/694] iio: addac: stx104: Fix race condition when converting analog-to-digital
Date: Mon,  8 May 2023 11:37:52 +0200
Message-Id: <20230508094433.841344565@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
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

commit 4f9b80aefb9e2f542a49d9ec087cf5919730e1dd upstream.

The ADC conversion procedure requires several device I/O operations
performed in a particular sequence. If stx104_read_raw() is called
concurrently, the ADC conversion procedure could be clobbered. Prevent
such a race condition by utilizing a mutex.

Fixes: 4075a283ae83 ("iio: stx104: Add IIO support for the ADC channels")
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/2ae5e40eed5006ca735e4c12181a9ff5ced65547.1680790580.git.william.gray@linaro.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/addac/stx104.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/drivers/iio/addac/stx104.c
+++ b/drivers/iio/addac/stx104.c
@@ -114,6 +114,8 @@ static int stx104_read_raw(struct iio_de
 			return IIO_VAL_INT;
 		}
 
+		mutex_lock(&priv->lock);
+
 		/* select ADC channel */
 		iowrite8(chan->channel | (chan->channel << 4), &reg->achan);
 
@@ -124,6 +126,8 @@ static int stx104_read_raw(struct iio_de
 		while (ioread8(&reg->cir_asr) & BIT(7));
 
 		*val = ioread16(&reg->ssr_ad);
+
+		mutex_unlock(&priv->lock);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_OFFSET:
 		/* get ADC bipolar/unipolar configuration */


