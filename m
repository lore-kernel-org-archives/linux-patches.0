Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DF2D2D3A69;
	Sun,  7 Jun 2026 10:34:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780828483; cv=none; b=tXtWCo4hK+VezCmKG6SKKXyLfOFHGrPiskOmmHHaED6kDjft59w3BDlauF2yfLfIsegGbzU4Xf9CpBreQ7pm6gxMI7l4jFN1Odsy8a5ljU6aAzX3NxKqmp3V+W/bMr6v1Bz9RvGEFZzswAajjiKj8NNFEI9CNa6TaatoQ91pkyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780828483; c=relaxed/simple;
	bh=nTQabIpeVBRGRsGWI1BL7TxvEfmm9Vn/XR/4OGII5uU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UaitCK10sw+y+hf6+0jk/rHF6z3EJkcg8gEYsRn6N9tyCoiRCz9goSLdHS/mvIaaal8o5GxUOxmrBJwzSqew+LWPa69bDVSdvPi/MZzmGfsLx5IIB+W6upP6792OZ35yOa56nU3X8X+8i5Q+EenpjWnR1OnV9lQDio/cO4eg1/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=avZhWiGm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="avZhWiGm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC2D91F00893;
	Sun,  7 Jun 2026 10:34:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780828482;
	bh=esxG0K32zoW4Ly7JX23GlASS7i3W8gs6AAgkf+Do51w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=avZhWiGmLuwNeYtPlaTknZqX2AM2llP7U4Jcu8QIS+neDCoOMYtrMf5yk4FoGKQmr
	 6hrLRsESxDUfccxEXCBnn1zUkdYtmhgIwSn6aRKnrRtqnQZc02IGFjH/lgKco3eoO+
	 FcXiiBDjOjcPFO5Pr4HpMuUMSDNu4XUW7qmEDkNw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuvam Pandey <shuvampandey1@gmail.com>,
	David Lechner <dlechner@baylibre.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.0 187/332] iio: adc: nxp-sar-adc: zero-initialize dma_slave_config
Date: Sun,  7 Jun 2026 11:59:16 +0200
Message-ID: <20260607095734.933769833@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095728.031258202@linuxfoundation.org>
References: <20260607095728.031258202@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shuvam Pandey <shuvampandey1@gmail.com>

commit 8ce176501f836634f9c0419c0820140f968e9dc5 upstream.

nxp_sar_adc_start_cyclic_dma() only fills the RX-side members of
dma_slave_config before passing it to dmaengine_slave_config().

Zero-initialize the structure so unused members do not contain stack
garbage. Some DMA engines consult optional dma_slave_config fields, so
leaving them uninitialized can cause DMA setup failures.

Fixes: 4434072a893e ("iio: adc: Add the NXP SAR ADC support for the s32g2/3 platforms")
Signed-off-by: Shuvam Pandey <shuvampandey1@gmail.com>
Reviewed-by: David Lechner <dlechner@baylibre.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/nxp-sar-adc.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/nxp-sar-adc.c
+++ b/drivers/iio/adc/nxp-sar-adc.c
@@ -675,7 +675,7 @@ static void nxp_sar_adc_dma_cb(void *dat
 static int nxp_sar_adc_start_cyclic_dma(struct iio_dev *indio_dev)
 {
 	struct nxp_sar_adc *info = iio_priv(indio_dev);
-	struct dma_slave_config config;
+	struct dma_slave_config config = { };
 	struct dma_async_tx_descriptor *desc;
 	int ret;
 


