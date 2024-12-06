Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAAB414B084;
	Fri,  6 Dec 2024 14:41:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496111; cv=none; b=Xje70zl6LCgoEe2fCXZWUMUlR9HHVnXQCPN5J9z/zp3rpscc8gLxvBP2+R4vV2J6WiN7ALuPbTlHyJ0hTvFPO5niMLy8WItXpUZ0+Y33FQAD7eAMcIyyxf60RSVeqdKs5clM/xHAhNsrK3swjG1kmJX8b19TullF6AqKKZQr8Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496111; c=relaxed/simple;
	bh=yYgkN+L1kTU6c3yPwxtOtd2ZLfjoFLxL8CZzbpaJ484=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ogi3hMXckq+VgDPxJZ0y1eXvlaggsi6xOmWn+K8wzAzbF/QRmOd1A25tm3vpFdiK20KLdg/SgNnS4So56Yu9NoG17LY53qO8UG9TNoQ5eDa4X9TdsSn3an8iOJsW77GoxsD1ETnwi91ezsKf9OLfSRRBBhOHvePzxBXpsoALjPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wxcUMcFJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wxcUMcFJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57397C4CEDC;
	Fri,  6 Dec 2024 14:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496111;
	bh=yYgkN+L1kTU6c3yPwxtOtd2ZLfjoFLxL8CZzbpaJ484=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wxcUMcFJgolVbuOiXgmFGqCH5Tz0Flob1Hkp8GLW3fyBabgp9T4y/YduB1YgzWl3r
	 4DWl/G/0CsPZvkaoLv8d1SygBirKOHOQDCmm5J6JZ7q48hHWAc/D1ZVOxoCfWJveDM
	 wLqxqlZdl5gp2aF1+lmypGA3X03hCfNdiilZGib8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zicheng Qu <quzicheng@huawei.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>
Subject: [PATCH 6.12 055/146] ad7780: fix division by zero in ad7780_write_raw()
Date: Fri,  6 Dec 2024 15:36:26 +0100
Message-ID: <20241206143529.780533305@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143527.654980698@linuxfoundation.org>
References: <20241206143527.654980698@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zicheng Qu <quzicheng@huawei.com>

commit c174b53e95adf2eece2afc56cd9798374919f99a upstream.

In the ad7780_write_raw() , val2 can be zero, which might lead to a
division by zero error in DIV_ROUND_CLOSEST(). The ad7780_write_raw()
is based on iio_info's write_raw. While val is explicitly declared that
can be zero (in read mode), val2 is not specified to be non-zero.

Fixes: 9085daa4abcc ("staging: iio: ad7780: add gain & filter gpio support")
Cc: stable@vger.kernel.org
Signed-off-by: Zicheng Qu <quzicheng@huawei.com>
Link: https://patch.msgid.link/20241028142027.1032332-1-quzicheng@huawei.com
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/adc/ad7780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/adc/ad7780.c
+++ b/drivers/iio/adc/ad7780.c
@@ -152,7 +152,7 @@ static int ad7780_write_raw(struct iio_d
 
 	switch (m) {
 	case IIO_CHAN_INFO_SCALE:
-		if (val != 0)
+		if (val != 0 || val2 == 0)
 			return -EINVAL;
 
 		vref = st->int_vref_mv * 1000000LL;


