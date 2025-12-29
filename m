Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 797CC202F65;
	Mon, 29 Dec 2025 16:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025398; cv=none; b=YNguamhtNc+BzccY+X/8Eg/YmLqfmDpzKJyZfAZH92NRlX1moog/tpEN1/+IBZ5IkSt55aEeNbmFasYUHUT97BZll0vKaaR6nZQTzptu2dchq3NBdTfrWl47Jz7ECj835sT1hnHcIU8GoHXLW3ErwuJzndB8Dvbc2bhdbk+z7GA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025398; c=relaxed/simple;
	bh=u7bGRF4KeR5NLGYYMeW4eFI8zbVAtQukjF4aXfAg1/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VmnkDJitFh4lem25WZQ3AGSiPS75BFaVDIkTXmA0c74WpMA1dQAnv/tg30m4FPPyhNkVolKyjOoyvDnESn8CKBR2cAMIAINMB9mVl24+scigYUi/v4kY5zG+i6bATTm5WEz7IzuJ6f9NqgcW8eGo0LhqJyLBbFNZZ7x8i4xyVPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CN5+08x1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CN5+08x1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF723C19421;
	Mon, 29 Dec 2025 16:23:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025398;
	bh=u7bGRF4KeR5NLGYYMeW4eFI8zbVAtQukjF4aXfAg1/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CN5+08x1mQAtMr4Py5esRAt0Xef6bOOCVbyx1ghcSx1K1zSaE90GBDXX2yOMkrK/Z
	 Kf6ox6dVG5qNnYK3Av7uGreoB6pEqSYNKGkYuHlJWWP9NN9LjuykRYsgtMZv4ba2HA
	 TuX6xbPXjxd6cQ24pjzUOcLQjukbcv0nbQaohh7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 198/430] iio: adc: ti_am335x_adc: Limit step_avg to valid range for gcc complains
Date: Mon, 29 Dec 2025 17:10:00 +0100
Message-ID: <20251229160731.639860903@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
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
index 99f274adc870..a1a28584de93 100644
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



