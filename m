Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C119354ACC;
	Tue,  6 Jan 2026 17:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767720172; cv=none; b=p+MxcVAL2vvmyYht6x+ddBRttGmOvCGH1FMEtoBBObYpTisF8vJK1+5jSRIsKdMpkyI9nsCydB0ETgLhRKHbcy7TiWHCAZeALicDVKAdIAwLOm3UPrlXqHRKBpCXPGGyoOiLsh1AyUz+a5XCa//9LIvl5gEOsQsM4JsS0BkN0yA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767720172; c=relaxed/simple;
	bh=3rN71iMgzjzk4aVD0T10VdKAbkNRc0gjVTqO6pJm/gw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=owZ7oabn49nh6cUmXtFBkoDYSsIL2c3ZN0iu73x84o3SGPdQLxBiMjeISngjYLTsR0HrBRHu8eIlUah1dPUIJLbyv2VujtRLzXJ1RVCSh6YzUr++JrjtcqTxmFQgExZ87YbZJ/Jsp+xCbhzwalgHRQg+QMCa5iBx/52UnoQlzHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g85A8zCN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g85A8zCN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A79E1C116C6;
	Tue,  6 Jan 2026 17:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767720172;
	bh=3rN71iMgzjzk4aVD0T10VdKAbkNRc0gjVTqO6pJm/gw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g85A8zCN6MYQaVWD8e8i6xFVf58beMpKtkZCDt9Zwpgf2ksLKpUOnmojRpCBItth+
	 BJHQ8aO7fW0Dp4lBfqOMn8Hn30Ic67nDPsBbIpGHcMa5FrbtE4BaaQjbFYfnWhIdZ6
	 Z5KSrtK5izFNeh58D9hVaqPqi/TcISalVBDvqQdI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 138/567] iio: adc: ti_am335x_adc: Limit step_avg to valid range for gcc complains
Date: Tue,  6 Jan 2026 17:58:40 +0100
Message-ID: <20260106170456.431832290@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170451.332875001@linuxfoundation.org>
References: <20260106170451.332875001@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit c9fb952360d0c78bbe98239bd6b702f05c2dbb31 ]

FIELD_PREP() checks that a value fits into the available bitfield, add a
check for step_avg to fix gcc complains.

which gcc complains about:
  drivers/iio/adc/ti_am335x_adc.c: In function 'tiadc_step_config':
  include/linux/compiler_types.h:572:38: error: call to
'__compiletime_assert_491' declared with attribute error: FIELD_PREP: value
too large for the field include/linux/mfd/ti_am335x_tscadc.h:58:29: note:
in expansion of macro 'FIELD_PREP'
    #define STEPCONFIG_AVG(val) FIELD_PREP(GENMASK(4, 2), (val))
                                ^~~~~~~~~~
drivers/iio/adc/ti_am335x_adc.c:127:17: note: in expansion of macro 'STEPCONFIG_AVG'
	stepconfig = STEPCONFIG_AVG(ffs(adc_dev->step_avg[i]) - 1)

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202510102117.Jqxrw1vF-lkp@intel.com/
Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/adc/ti_am335x_adc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/iio/adc/ti_am335x_adc.c b/drivers/iio/adc/ti_am335x_adc.c
index 426e3c9f88a1..205d1f103b3c 100644
--- a/drivers/iio/adc/ti_am335x_adc.c
+++ b/drivers/iio/adc/ti_am335x_adc.c
@@ -123,7 +123,7 @@ static void tiadc_step_config(struct iio_dev *indio_dev)
 
 		chan = adc_dev->channel_line[i];
 
-		if (adc_dev->step_avg[i])
+		if (adc_dev->step_avg[i] && adc_dev->step_avg[i] <= STEPCONFIG_AVG_16)
 			stepconfig = STEPCONFIG_AVG(ffs(adc_dev->step_avg[i]) - 1) |
 				     STEPCONFIG_FIFO1;
 		else
-- 
2.51.0



