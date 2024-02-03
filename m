Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8220F1CAA0;
	Sat,  3 Feb 2024 04:18:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933881; cv=none; b=uMCMHaE8AQ7snfmwFvSEtIRmiH4sftDhIOaXh7dndPRVdfHJoX/ZY0wAupRLlrCiafkueeNksrMFVQDerApkUH1nMhTD1Zl6s5jpSVI5AF4JcbQCOqcWDEUp4+FkUGT4bkSJ7eZQ9iQKqQnYWSdO9botbKdBj5lILdRKZUvp1l8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933881; c=relaxed/simple;
	bh=CkcCVEKAl/qzatc16u1nPF1EyEC75y1Hh9IKzgqEaAI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1SfHcv/lnPoOTut3o2aAztuSYS6Gv//jdiOc0Fdugm/ZJvDIDQCXTWVlogfRJSCYzSBBvx4EogyjexrWodaIfUqbrphTxw3kxhJF9vBwgWqHuxAZhYRfYT9mFLSSBxwc7LyceXNxiPWdsJxdm/HGJRZgka3Z0gs78IzhKxMosI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SN5ox3L4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SN5ox3L4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49BD8C433F1;
	Sat,  3 Feb 2024 04:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933881;
	bh=CkcCVEKAl/qzatc16u1nPF1EyEC75y1Hh9IKzgqEaAI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SN5ox3L4+/OMpf790Z5BUukkSWNnddlqTKL+2KGcs/PZvAEyO7LlEGGzeygF2wX/r
	 pqFdng1YUwKz3Z0xuczC7uxRYTfzAUrfY+TUyXUXH7MENjz3KUpXvjbN6D6YcLYJCq
	 lGi7jd44lnuZzGvYlJXZCxj4XMrVN1vKjAbv0dBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xing Tong Wu <xingtong.wu@siemens.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 195/353] hwmon: (nct6775) Fix fan speed set failure in automatic mode
Date: Fri,  2 Feb 2024 20:05:13 -0800
Message-ID: <20240203035409.858623351@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035403.657508530@linuxfoundation.org>
References: <20240203035403.657508530@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index d928eb8ae5a3..92a49fafe2c0 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -2553,6 +2553,13 @@ store_pwm(struct device *dev, struct device_attribute *attr, const char *buf,
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



