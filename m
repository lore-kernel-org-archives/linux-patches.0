Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8819C4431
	for <patches@lists.linux.dev>; Wed, 15 Mar 2023 12:41:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04C21C433D2;
	Wed, 15 Mar 2023 12:41:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678884073;
	bh=1BmJ+h7AKBzQz0Hws51bHogpZpwzUQwVKxNSlLSMEUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L/NBHPdUYeMxnPl6fHanIOMtRzXRcmqw+hxryCKzbWV4y388qNCWNud2D7SwzWOiv
	 p8uKk+oX/obHxwj2ClVTg5bnt8tefFUUYKhGjEK7gDl/XYLBhtlbLHsUdazMiM1h6G
	 S+LHP1HM9Kolo2JySeGmXZV9CfozxNzPpVzVsK4k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Armin Wolf <W_Armin@gmx.de>,
	Hans de Goede <hdegoede@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 095/141] platform/x86: dell-ddv: Fix temperature scaling
Date: Wed, 15 Mar 2023 13:13:18 +0100
Message-Id: <20230315115742.892893819@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230315115739.932786806@linuxfoundation.org>
References: <20230315115739.932786806@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Armin Wolf <W_Armin@gmx.de>

[ Upstream commit 0331b1b0ba65376ecf1c69414aa7696fef0930cb ]

After using the built-in UEFI hardware diagnostics to compare
the measured battery temperature, i noticed that the temperature
is actually expressed in tenth degree kelvin, similar to the
SBS-Data standard. For example, a value of 2992 is displayed as
26 degrees celsius.
Fix the scaling so that the correct values are being displayed.

Tested on a Dell Inspiron 3505.

Fixes: a77272c16041 ("platform/x86: dell: Add new dell-wmi-ddv driver")
Signed-off-by: Armin Wolf <W_Armin@gmx.de>
Link: https://lore.kernel.org/r/20230218115318.20662-2-W_Armin@gmx.de
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/platform/x86/dell/dell-wmi-ddv.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/platform/x86/dell/dell-wmi-ddv.c b/drivers/platform/x86/dell/dell-wmi-ddv.c
index f99c4cb686fdc..96fede24877f3 100644
--- a/drivers/platform/x86/dell/dell-wmi-ddv.c
+++ b/drivers/platform/x86/dell/dell-wmi-ddv.c
@@ -14,7 +14,6 @@
 #include <linux/errno.h>
 #include <linux/kernel.h>
 #include <linux/kstrtox.h>
-#include <linux/math.h>
 #include <linux/module.h>
 #include <linux/limits.h>
 #include <linux/power_supply.h>
@@ -192,7 +191,8 @@ static ssize_t temp_show(struct device *dev, struct device_attribute *attr, char
 	if (ret < 0)
 		return ret;
 
-	return sysfs_emit(buf, "%d\n", DIV_ROUND_CLOSEST(value, 10));
+	/* Use 2731 instead of 2731.5 to avoid unnecessary rounding */
+	return sysfs_emit(buf, "%d\n", value - 2731);
 }
 
 static ssize_t eppid_show(struct device *dev, struct device_attribute *attr, char *buf)
-- 
2.39.2



