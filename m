Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B83935F19
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:47:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ouXT4X53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0329DC433C8;
	Wed, 15 Nov 2023 19:47:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077667;
	bh=xUtKlEOIjn/nR/T27xoo0w0R2gLVz1JkhGn0BEco8a0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ouXT4X53YlpZkZlCQ1jPKECey+dxdFwXhyo13rU9tQqutj6dRYLA2mYa6IADrFhXY
	 AlKSLwqBSLU5JpWCIsvLdPDGeg18Dhd6niKclRFvgpV7HeU3GIeHZIG1lcseV6BzV+
	 GC56vGzhITf2BrQmFWLC6+b5nqFKTYLMhOGow83A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Raag Jadav <raag.jadav@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 421/603] pinctrl: baytrail: fix debounce disable case
Date: Wed, 15 Nov 2023 14:16:06 -0500
Message-ID: <20231115191641.956339773@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Raag Jadav <raag.jadav@intel.com>

[ Upstream commit 2d325e54d9e2e4ae247c9fd03f810208ce958c51 ]

We don't need to update debounce pulse value in case debounce is to be
disabled. Break such a case where arg value is zero.

Fixes: 4cfff5b7af8b ("pinctrl: baytrail: consolidate common mask operation")
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/linux-gpio/d164d471-5432-4c3c-afdb-33dc8f53d043@moroto.mountain/
Signed-off-by: Raag Jadav <raag.jadav@intel.com>
Acked-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/intel/pinctrl-baytrail.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/intel/pinctrl-baytrail.c b/drivers/pinctrl/intel/pinctrl-baytrail.c
index faa8b7ff5bcf3..ec76e43527c5c 100644
--- a/drivers/pinctrl/intel/pinctrl-baytrail.c
+++ b/drivers/pinctrl/intel/pinctrl-baytrail.c
@@ -983,11 +983,18 @@ static int byt_pin_config_set(struct pinctrl_dev *pctl_dev,
 
 			break;
 		case PIN_CONFIG_INPUT_DEBOUNCE:
-			if (arg)
+			if (arg) {
 				conf |= BYT_DEBOUNCE_EN;
-			else
+			} else {
 				conf &= ~BYT_DEBOUNCE_EN;
 
+				/*
+				 * No need to update the pulse value.
+				 * Debounce is going to be disabled.
+				 */
+				break;
+			}
+
 			switch (arg) {
 			case 375:
 				db_pulse = BYT_DEBOUNCE_PULSE_375US;
-- 
2.42.0



