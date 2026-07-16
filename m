Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C75B427FB4;
	Thu, 16 Jul 2026 14:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784210551; cv=none; b=rr14Rap5NqeXfNojh0vel1J+jevE7OKKV+wSw0uNAlHi1SBQj/vTsMZDAY99pH5wvkYkkxcbpl4xpAv7fsKS65O2XvW77SdPditV9tr9bcVJDijJmMGhDIUVPJIKsEKKEcpc3BtMKN7Um+JpxZXLSDnEglzHuqhyV7o0gVzgJqw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784210551; c=relaxed/simple;
	bh=akSuUmp3yUkX/QeWyOa27OThwent3WTW9hVdHbBjN08=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5Na9RBFUB0KqVo6+6t6UbP9qGPOvO93KtxOKmIolmJgHBt+vOP5xgYPb4Tjuwi0flrDIOmWjX9EwOCi+yZW0R2yA/iMoNNHPWWNBCQpXhsZDjKNIRlMcNWMPcpMMwV9vxoHB5P9+HEmmOx6RPazSm/B2i2cuPuTNv+0E9+TL04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=peUh37JA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="peUh37JA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D215B1F000E9;
	Thu, 16 Jul 2026 14:02:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784210550;
	bh=piJuxIlSczbyyVLuoMMcXzjhLsc8gTPwvjKKUl7SHQk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=peUh37JA1dvA+RXzm1Vg1A5CTZC5U1sSycIrdsKLlssKc3sm2/KLXkooAV4rc5m2R
	 Im6wttyNSpezLlfZSs4Lwfxg3fPtND37NrQ059jaAYOS9S224c5dGFN17WuYINOKsf
	 0+3ijM0x6HBRzZkZ69XWEBSskLCw5SZULWoJyKik=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 6.18 088/480] iio: temperature: ltc2983: Fix n_wires default bypassing rotation check
Date: Thu, 16 Jul 2026 15:27:15 +0200
Message-ID: <20260716133046.614295170@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133044.672218725@linuxfoundation.org>
References: <20260716133044.672218725@linuxfoundation.org>
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

From: Liviu Stan <liviu.stan@analog.com>

commit 434c150752675f44dc52c384a7fa22e5176bc35a upstream.

When adi,number-of-wires is absent, n_wires is left at 0. The binding
documents a default of 2 wires, matching the hardware default. However
the current-rotate validation checks n_wires == 2 || n_wires == 3, so
with n_wires = 0 the guard is bypassed and adi,current-rotate is accepted
for a 2-wire RTD.

Initialize n_wires = 2 to match the binding default and ensure the
rotation check fires correctly when the property is absent.

Fixes: f110f3188e56 ("iio: temperature: Add support for LTC2983")
Signed-off-by: Liviu Stan <liviu.stan@analog.com>
Cc: <Stable@vger.kernel.org>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iio/temperature/ltc2983.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/temperature/ltc2983.c
+++ b/drivers/iio/temperature/ltc2983.c
@@ -741,7 +741,7 @@ ltc2983_rtd_new(const struct fwnode_hand
 	struct ltc2983_rtd *rtd;
 	int ret = 0;
 	struct device *dev = &st->spi->dev;
-	u32 excitation_current = 0, n_wires = 0;
+	u32 excitation_current = 0, n_wires = 2;
 
 	rtd = devm_kzalloc(dev, sizeof(*rtd), GFP_KERNEL);
 	if (!rtd)


