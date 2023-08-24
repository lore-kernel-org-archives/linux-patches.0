Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 368D814A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:17:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACAB0C433C8;
	Thu, 24 Aug 2023 17:17:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897463;
	bh=jYUlp+0EI+2duHJTG8Kb9n3cULJx/+Zkrf0Gkk3IBXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hCkJUaPF33ePuhyPClOkZk/aBhu/8NAU7z2iXkxADz8LnhaFDa8ncD5wnDvTHxwcn
	 gRA+6iWrC8ymQFqvfV2eUkmBZ21e2uQP6+uU7CDsL4iBKw1MYR6wJphbWoID1QYYUe
	 FURQtHslE9AXIwdTdn/2w4TID2DiEWXtz95ijr8o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	William Breathitt Gray <william.gray@linaro.org>,
	Stable@vger.kernel.org,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 047/135] iio: addac: stx104: Fix race condition when converting analog-to-digital
Date: Thu, 24 Aug 2023 19:08:39 +0200
Message-ID: <20230824170619.182802857@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: William Breathitt Gray <william.gray@linaro.org>

[ Upstream commit 4f9b80aefb9e2f542a49d9ec087cf5919730e1dd ]

The ADC conversion procedure requires several device I/O operations
performed in a particular sequence. If stx104_read_raw() is called
concurrently, the ADC conversion procedure could be clobbered. Prevent
such a race condition by utilizing a mutex.

Fixes: 4075a283ae83 ("iio: stx104: Add IIO support for the ADC channels")
Signed-off-by: William Breathitt Gray <william.gray@linaro.org>
Link: https://lore.kernel.org/r/2ae5e40eed5006ca735e4c12181a9ff5ced65547.1680790580.git.william.gray@linaro.org
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/stx104.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/iio/adc/stx104.c b/drivers/iio/adc/stx104.c
index e110a910235ff..b658a75d4e3a8 100644
--- a/drivers/iio/adc/stx104.c
+++ b/drivers/iio/adc/stx104.c
@@ -117,6 +117,8 @@ static int stx104_read_raw(struct iio_dev *indio_dev,
 			return IIO_VAL_INT;
 		}
 
+		mutex_lock(&priv->lock);
+
 		/* select ADC channel */
 		iowrite8(chan->channel | (chan->channel << 4), &reg->achan);
 
@@ -127,6 +129,8 @@ static int stx104_read_raw(struct iio_dev *indio_dev,
 		while (ioread8(&reg->cir_asr) & BIT(7));
 
 		*val = ioread16(&reg->ssr_ad);
+
+		mutex_unlock(&priv->lock);
 		return IIO_VAL_INT;
 	case IIO_CHAN_INFO_OFFSET:
 		/* get ADC bipolar/unipolar configuration */
-- 
2.40.1



