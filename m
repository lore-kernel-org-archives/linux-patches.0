Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 371CF2DF137;
	Thu, 16 Jul 2026 13:40:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784209249; cv=none; b=QPYCIQThlO+bsMAP1u4T4bpLb/h8fJrIg6ReaB1HTK53SWUYRr9QvIDDiqIJSJr/bvFmrsbYpcp/3DXnfNqJFeW0++gOngZ98v/AluaJ1XL2a/T7PAtKi2tok3JzblHBK3tcHfVMC4PkxEi1J8b/sNcGa4CJdEZEYxgD3Wjs4UY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784209249; c=relaxed/simple;
	bh=5Dpty0ehQcp6Pnykv2RfCWXtq7DKOSfycIQIiALwao0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VogcA7HLSd8WUSxP2+/UF3vYVERpH78dYPbVVKMA+kb/gyCMbqmHKcJAr3oV8vGBtCRL1xD4rOtDIgiXw4P7PGJQImGn9dCgm1U//yNxFdPQwhGdWtcv0pKUbJNqnnqMvsamYEmS06G8+Kju2x/jK4+s9yhSpzSE+Y2auRYwuOM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mvHLEvpv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mvHLEvpv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BA7D1F000E9;
	Thu, 16 Jul 2026 13:40:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784209247;
	bh=+z2+FfjLaNUZmk10qKXUb5uP47u2eTtDGwIAVJT+oR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mvHLEvpv0NsoINp7iLK7EpwrYUVrfcNij0UKXQmW3k5pWdOuWi4vCxKGI5X5+Q/V/
	 D3cXWQqCxlPoS/DyO6n344FgIXux23p4gbL9yeMxGoavm77zP460QubrqntNnp8jit
	 SNs7yWIf5rCOGhE8KMpL5qfAr8ORoUYF3ECXoKJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liviu Stan <liviu.stan@analog.com>,
	Stable@vger.kernel.org,
	Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 7.1 076/518] iio: temperature: ltc2983: Fix n_wires default bypassing rotation check
Date: Thu, 16 Jul 2026 15:25:44 +0200
Message-ID: <20260716133049.447969789@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260716133047.772246337@linuxfoundation.org>
References: <20260716133047.772246337@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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


