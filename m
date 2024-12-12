Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96C5A21E085;
	Thu, 12 Dec 2024 15:56:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734018960; cv=none; b=O9nJthmuYvZ/U9NWkbnFDlZSoR1+nLYadqH1UbEjQ4WL6uGiKe+XJrcQr1KQNnCl5WNoyBhPPUiBHLkUW6jiDOUDjkznJ093TaX9LW9eE4lU2SSBaLTSNwK8QsIwhyLA97Qh92MWfWIqoha8l6NzdKqO3FSenJOUHws1xOJ64CQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734018960; c=relaxed/simple;
	bh=ETCzaibNcunPMxT7nrXKPzWFvqiXkVIKkqoykJXICEk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sOmd/SHYUGrL4ShQPvrL/b+1DwcY6VyUbt6TYbNtA1hr8sP6F4JopnI9iQxm3RRtftlw1MBcIT3RlayxWohUzOPTtLXWW1cv/u8zjMZwwXZjn5ZZaHrAh/he4dOv03/KYDf+Bo0lk+jQEBbDDvyFC+7K/iyzOEcfSHbuGehK+fE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ggPpeNzp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ggPpeNzp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5B7DC4CED3;
	Thu, 12 Dec 2024 15:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734018960;
	bh=ETCzaibNcunPMxT7nrXKPzWFvqiXkVIKkqoykJXICEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ggPpeNzptfGL8ZamfP/FymDLjo4KzAdoH03qPlA3hmoLoJezm8I55YOMB6ule4Yv4
	 T8/Cnuohsb+qG5CjsUF8DGdvOfWcut+3oCTdF2Teu5CIkdaQzR5r/t016Wmiw5XvY2
	 lbvDY40xVOp/sUZ6SGtzzuaxQts6WCqzVtQM/Ed8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pei Xiao <xiaopei01@kylinos.cn>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 079/772] hwmon: (nct6775-core) Fix overflows seen when writing limit attributes
Date: Thu, 12 Dec 2024 15:50:24 +0100
Message-ID: <20241212144353.197456251@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Pei Xiao <xiaopei01@kylinos.cn>

[ Upstream commit 57ee12b6c514146c19b6a159013b48727a012960 ]

DIV_ROUND_CLOSEST() after kstrtoul() results in an overflow if a large
number such as 18446744073709551615 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Pei Xiao <xiaopei01@kylinos.cn>
Fixes: c3963bc0a0cf ("hwmon: (nct6775) Split core and platform driver")
Message-ID: <7d5084cea33f7c0fd0578c59adfff71f93de94d9.1731375425.git.xiaopei01@kylinos.cn>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/nct6775-core.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/nct6775-core.c b/drivers/hwmon/nct6775-core.c
index 83e424945b598..9de3ad2713f1d 100644
--- a/drivers/hwmon/nct6775-core.c
+++ b/drivers/hwmon/nct6775-core.c
@@ -2787,8 +2787,7 @@ store_target_temp(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0,
-			data->target_temp_mask);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, data->target_temp_mask * 1000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->target_temp[nr] = val;
@@ -2868,7 +2867,7 @@ store_temp_tolerance(struct device *dev, struct device_attribute *attr,
 		return err;
 
 	/* Limit tolerance as needed */
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, data->tolerance_mask);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, data->tolerance_mask * 1000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->temp_tolerance[index][nr] = val;
@@ -2994,7 +2993,7 @@ store_weight_temp(struct device *dev, struct device_attribute *attr,
 	if (err < 0)
 		return err;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 255);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 255000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->weight_temp[index][nr] = val;
-- 
2.43.0



