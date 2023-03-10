Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B961847E
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 13:47:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BED49C4339C;
	Fri, 10 Mar 2023 13:47:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678456050;
	bh=6dr/J/7dEG3YI4o2FHkASAm0CBPKyRgbPmG0hJ5e2kc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XFRJSk/nuyG6W+KU2Rc2kZglkvkKjEt976PGoMXqMqIyCDwPPe6s2tLjAqFhTOr3R
	 gAmqFG6lwXB59HMpHyHWgYpEb0pUH+C5mpnOJ//RLH60UjZ3XPrhHEydnBKL8N8gYG
	 jDH/Dbm+FKLnm8sqdVburqy9350lrBj1WW1bHXmc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cormier <jcormier@criticallink.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 062/193] hwmon: (ltc2945) Handle error case in ltc2945_value_store
Date: Fri, 10 Mar 2023 14:37:24 +0100
Message-Id: <20230310133713.092285797@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133710.926811681@linuxfoundation.org>
References: <20230310133710.926811681@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jonathan Cormier <jcormier@criticallink.com>

[ Upstream commit 178b01eccfb0b8149682f61388400bd3d903dddc ]

ltc2945_val_to_reg errors were not being handled
which would have resulted in register being set to
0 (clamped) instead of being left alone.

Fixes: 6700ce035f83 ("hwmon: Driver for Linear Technologies LTC2945")

Signed-off-by: Jonathan Cormier <jcormier@criticallink.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/ltc2945.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/hwmon/ltc2945.c b/drivers/hwmon/ltc2945.c
index 1b92e4f6e2349..efabe514ec560 100644
--- a/drivers/hwmon/ltc2945.c
+++ b/drivers/hwmon/ltc2945.c
@@ -257,6 +257,8 @@ static ssize_t ltc2945_set_value(struct device *dev,
 
 	/* convert to register value, then clamp and write result */
 	regval = ltc2945_val_to_reg(dev, reg, val);
+	if (regval < 0)
+		return regval;
 	if (is_power_reg(reg)) {
 		regval = clamp_val(regval, 0, 0xffffff);
 		regbuf[0] = regval >> 16;
-- 
2.39.2



