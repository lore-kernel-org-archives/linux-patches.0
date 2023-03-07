Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A139BA32
	for <patches@lists.linux.dev>; Tue,  7 Mar 2023 17:28:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A3D1C433D2;
	Tue,  7 Mar 2023 17:28:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678210100;
	bh=FhsPD37uhCaYegaZVO0Wd6at01E0tB2o3+l5rgJBV+o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OMDQQsdSy8LZAlzdfXe6rjLxpreINrVPdYFRIBORiaOfk7+MxkLNsZCBdea2uQels
	 N8VSYXQkunAe/EyAKuwr9seTpIU/yT09XV5LfcIVxlJqDtAto0UTzX4GFMmAlBynrZ
	 f2+fEC0kEKjcgc0rdUEL29jwvudTkCnJLDHyiXIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vadim Pasternak <vadimp@nvidia.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 0433/1001] hwmon: (mlxreg-fan) Return zero speed for broken fan
Date: Tue,  7 Mar 2023 17:53:25 +0100
Message-Id: <20230307170040.149997775@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230307170022.094103862@linuxfoundation.org>
References: <20230307170022.094103862@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Vadim Pasternak <vadimp@nvidia.com>

[ Upstream commit a1ffd3c46267ee5c807acd780e15df9bb692223f ]

Currently for broken fan driver returns value calculated based on error
code (0xFF) in related fan speed register.
Thus, for such fan user gets fan{n}_fault to 1 and fan{n}_input with
misleading value.

Add check for fan fault prior return speed value and return zero if
fault is detected.

Fixes: 65afb4c8e7e4 ("hwmon: (mlxreg-fan) Add support for Mellanox FAN driver")
Signed-off-by: Vadim Pasternak <vadimp@nvidia.com>
Link: https://lore.kernel.org/r/20230212145730.24247-1-vadimp@nvidia.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/mlxreg-fan.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/mlxreg-fan.c b/drivers/hwmon/mlxreg-fan.c
index b48bd7c961d66..96017cc8da7ec 100644
--- a/drivers/hwmon/mlxreg-fan.c
+++ b/drivers/hwmon/mlxreg-fan.c
@@ -155,6 +155,12 @@ mlxreg_fan_read(struct device *dev, enum hwmon_sensor_types type, u32 attr,
 			if (err)
 				return err;
 
+			if (MLXREG_FAN_GET_FAULT(regval, tacho->mask)) {
+				/* FAN is broken - return zero for FAN speed. */
+				*val = 0;
+				return 0;
+			}
+
 			*val = MLXREG_FAN_GET_RPM(regval, fan->divider,
 						  fan->samples);
 			break;
-- 
2.39.2



