Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1C99125C4;
	Sat,  3 Feb 2024 04:10:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933423; cv=none; b=ovdcw0HgnxJReKPB+HJDZhZg/T7cZVvAyXOBeW8TNXp1NnCDohAe++xHSD4thgjop9dF68HNW0qdFN+zBbmGKlL1wR1OPJfXjaHDS8+oMdJF1J0XWUCXApUHr6t+ChmQP2CFRsvJCP/ouZf7NYQGSlIGU8Tr3jvyE9pO8sfGeYQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933423; c=relaxed/simple;
	bh=1zbpDW1vWI16iA/bBbDQ9OTbE8uVM9IKipGCyVBDsfY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YMKBdi6dcdCOtA+vTlI81tGqHWvZy0LV+s0Q3kHVXcuoic/WVwAPZZubZjlP4C6MrxGtM6i7eCLYWOeXEf9bwF58y6Djw11AbdPOAjCw4UiI2ni6XALi0lQKipX6ZBWkRIxAQ1MVEAx735GfmY2N7H9PcXs4nlU14tiITqIU1lg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SV9c/ET7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SV9c/ET7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4BD4DC43390;
	Sat,  3 Feb 2024 04:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933423;
	bh=1zbpDW1vWI16iA/bBbDQ9OTbE8uVM9IKipGCyVBDsfY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SV9c/ET7v0BrVtIH9ca2MucenirfjJadA06zsBAYZHwCRiQFUuYQYlbZnkTDWF4I2
	 vArnbU1qHvV+Arwqu2mw614JcDEUa7Gg3cNrKojA5hbr8AwSSyEqmaGX0VlXZaT+gm
	 yVCid6ec9H/QizzOmPYw+NzkHbZfp/XXpVRR2KUA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xing Tong Wu <xingtong.wu@siemens.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 125/219] hwmon: (nct6775) Fix fan speed set failure in automatic mode
Date: Fri,  2 Feb 2024 20:04:58 -0800
Message-ID: <20240203035335.110746376@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xing Tong Wu <xingtong.wu@siemens.com>

[ Upstream commit 8b3800256abad20e91c2698607f9b28591407b19 ]

Setting the fan speed is only valid in manual mode; it is not possible
to set the fan's speed in automatic mode.
Return error when attempting to set the fan speed in automatic mode.

Signed-off-by: Xing Tong Wu <xingtong.wu@siemens.com>
Link: https://lore.kernel.org/r/20231121081604.2499-3-xingtong_wu@163.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index 80310845fb99..9720ad214c20 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -2462,6 +2462,13 @@ store_pwm(struct device *dev, struct device_attribute *attr, const char *buf,
 	int err;
 	u16 reg;
 
+	/*
+	 * The fan control mode should be set to manual if the user wants to adjust
+	 * the fan speed. Otherwise, it will fail to set.
+	 */
+	if (index == 0 && data->pwm_enable[nr] > manual)
+		return -EBUSY;
+
 	err = kstrtoul(buf, 10, &val);
 	if (err < 0)
 		return err;
-- 
2.43.0



