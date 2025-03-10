Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C7E17CA12;
	Mon, 10 Mar 2025 17:17:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627038; cv=none; b=hPxxop0lT58JA39dfKi7GOFgly2dp6kzpw8Uo0dXzEbOkXXgd+uYd42ZpZjaRELLMpr2nnJs4al1c927eJdibsCWdNFo8nrSGNLJ0thqxR5q6tF3G+cJIOpydcsRgFNm2CsR7TaOPrm/n2Nr5VZ5f1M3Q14HSMP7nD7Jxau1JUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627038; c=relaxed/simple;
	bh=/k7EzXK804qLq6z1sHZPNaDQ8aV0fKSXMDZPYbuRddw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QJEHUhGT/cu/OUFfuf2+b/WhwCWYWuJ5Uy9drGmCxq3geVBl3jXZkIHL2cZzNRDy+BEc5Squuhqn1PTeeum4U3ktjPPFyCq7iM/3bX9mjdgX/8a/2kdguvILcOOxJmiwsuBHkmYLPpFKEDoxn1PMIAwAZ/FuSvGz07RAQrcswaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lFtpW2IV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lFtpW2IV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 866BBC4CEE5;
	Mon, 10 Mar 2025 17:17:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627037;
	bh=/k7EzXK804qLq6z1sHZPNaDQ8aV0fKSXMDZPYbuRddw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lFtpW2IVo2XkSmWS/ZPvZjgGp1/enUHHYixvMItSfnBJUcTX7RYz0nHIFd31M0zpj
	 gBGfFcx93mCZrnIn7ka55NpsQ7i9XFmNpuMlZzI8QUCEmsrh2A21m7Qs/soOhfrt3o
	 GH7BIRpPSxmqiYWaZG3d9+uEw/saroyZ0B7r5+3c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 199/207] iio: hid-sensor-prox: Split difference from multiple channels
Date: Mon, 10 Mar 2025 18:06:32 +0100
Message-ID: <20250310170455.694201151@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 4eba4d92906c3814ca3ec65c16af27c46c12342e ]

When the driver was originally created, it was decided that
sampling_frequency and hysteresis would be shared_per_type instead
of shared_by_all (even though it is internally shared by all). Eg:
in_proximity_raw
in_proximity_sampling_frequency

When we introduced support for more channels, we continued with
shared_by_type which. Eg:
in_proximity0_raw
in_proximity1_raw
in_proximity_sampling_frequency
in_attention_raw
in_attention_sampling_frequency

Ideally we should change to shared_by_all, but it is not an option,
because the current naming has been a stablished ABI by now. Luckily we
can use separate instead. That will be more consistent:
in_proximity0_raw
in_proximity0_sampling_frequency
in_proximity1_raw
in_proximity1_sampling_frequency
in_attention_raw
in_attention_sampling_frequency

Fixes: 596ef5cf654b ("iio: hid-sensor-prox: Add support for more channels")
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Link: https://patch.msgid.link/20241216-fix-hid-sensor-v2-1-ff8c1959ec4a@chromium.org
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/light/hid-sensor-prox.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iio/light/hid-sensor-prox.c b/drivers/iio/light/hid-sensor-prox.c
index c83acbd782759..71dcef3fbe57d 100644
--- a/drivers/iio/light/hid-sensor-prox.c
+++ b/drivers/iio/light/hid-sensor-prox.c
@@ -49,9 +49,10 @@ static const u32 prox_sensitivity_addresses[] = {
 #define PROX_CHANNEL(_is_proximity, _channel) \
 	{\
 		.type = _is_proximity ? IIO_PROXIMITY : IIO_ATTENTION,\
-		.info_mask_separate = _is_proximity ? BIT(IIO_CHAN_INFO_RAW) :\
-				      BIT(IIO_CHAN_INFO_PROCESSED),\
-		.info_mask_shared_by_type = BIT(IIO_CHAN_INFO_OFFSET) |\
+		.info_mask_separate = \
+		(_is_proximity ? BIT(IIO_CHAN_INFO_RAW) :\
+				BIT(IIO_CHAN_INFO_PROCESSED)) |\
+		BIT(IIO_CHAN_INFO_OFFSET) |\
 		BIT(IIO_CHAN_INFO_SCALE) |\
 		BIT(IIO_CHAN_INFO_SAMP_FREQ) |\
 		BIT(IIO_CHAN_INFO_HYSTERESIS),\
-- 
2.39.5



