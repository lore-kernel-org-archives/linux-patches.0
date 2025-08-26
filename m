Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C83E350D5D;
	Tue, 26 Aug 2025 14:36:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218977; cv=none; b=r2liBtI0gBHxM1/FdGV+Hht3s/rvDAKFneR9mquayvhFNgMNMODp6Rrbu12zaPhwTzNFQnM/KOQ+3sXAa/nfDRqSeWnep6Wa6qp2etDXTXDlbGzbqx+kUzJxMILqwK9lzeJPfqMAqNmfc5xeQwRJBWeJaJGitL4aA4+Rj8oFtiU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218977; c=relaxed/simple;
	bh=ga30xPdgw5MOvlwB7/MwQXXbm6CAbmw8W6dv1Q6du6M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LCoK8SkX/xTL+dZMzA576ofpGN/cct58zHTxKZAYnkFZLPmyr99oa1nj7h992TaI6/1r8QwOIv8Q//XUxbuMwzRvWPBYmZp3RRGzhHAyzJNexIg+7PgtmmeMsucNXaR1tAB3vA/0MtKMr8Agt1urFTGJ27wHpp3yp9jZVjR1GKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z4iNXWBS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z4iNXWBS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1311FC4CEF1;
	Tue, 26 Aug 2025 14:36:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218977;
	bh=ga30xPdgw5MOvlwB7/MwQXXbm6CAbmw8W6dv1Q6du6M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z4iNXWBSw7kGi0eEJUWDiUyC2asRZwUw9JSgHTX1i9e0Ae54taT8YgOaLlKF6sGG9
	 1HaUpCg2zLvBfU5/tmuky3cFOHplAV9GBCLcVGZalckbzDa6cwo9Qv9TPKKr7uKHBo
	 V0/re+hGVRVAgk8PhxJPVt22syK1xALvMcJ/6yIQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Amadeusz=20S=C5=82awi=C5=84ski?= <amadeuszx.slawinski@linux.intel.com>,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Xinxin Wan <xinxin.wan@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 205/403] ASoC: codecs: rt5640: Retry DEVICE_ID verification
Date: Tue, 26 Aug 2025 13:08:51 +0200
Message-ID: <20250826110912.514517648@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xinxin Wan <xinxin.wan@intel.com>

[ Upstream commit 19f971057b2d7b99c80530ec1052b45de236a8da ]

To be more resilient to codec-detection failures when the hardware
powers on slowly, add retry mechanism to the device verification check.
Similar pattern is found throughout a number of Realtek codecs. Our
tests show that 60ms delay is sufficient to address readiness issues on
rt5640 chip.

Reviewed-by: Amadeusz Sławiński <amadeuszx.slawinski@linux.intel.com>
Reviewed-by: Cezary Rojewski <cezary.rojewski@intel.com>
Signed-off-by: Xinxin Wan <xinxin.wan@intel.com>
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://patch.msgid.link/20250530142120.2944095-3-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/rt5640.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/sound/soc/codecs/rt5640.c b/sound/soc/codecs/rt5640.c
index 3bc63fbcb188..e290a83c20af 100644
--- a/sound/soc/codecs/rt5640.c
+++ b/sound/soc/codecs/rt5640.c
@@ -2810,6 +2810,11 @@ static int rt5640_i2c_probe(struct i2c_client *i2c,
 	}
 
 	regmap_read(rt5640->regmap, RT5640_VENDOR_ID2, &val);
+	if (val != RT5640_DEVICE_ID) {
+		usleep_range(60000, 100000);
+		regmap_read(rt5640->regmap, RT5640_VENDOR_ID2, &val);
+	}
+
 	if (val != RT5640_DEVICE_ID) {
 		dev_err(&i2c->dev,
 			"Device with ID register %#x is not rt5640/39\n", val);
-- 
2.39.5



