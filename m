Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBD7319066D;
	Tue, 10 Sep 2024 10:09:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962995; cv=none; b=HC5OGlGKTg4bkOYSbCmRxLVt9+O2pM5QMKVogCrLd808xE5xQyS8NZ+9O9DA/jeCZHREQQZ1P+6C7/9DEMmGzsPoXQtfGZZFN4g1yf/ePeNg7DypDR4xItV73WM6DEi4TGt+U6cQush6v+3vDUgTx8Kg0VNPrHSBTQZEuSvwlJQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962995; c=relaxed/simple;
	bh=yPIY/1gkbfUE7jm8EnTBTZk3daEmcZelGWVMyDoR7XY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DjZrXJ/n/Wulw3vt7PvcgdrCFwuegcWerokaHI+GzPTBNUb5IDNXeYcU/GLXGVtdPV1EMeMHBUIXHDwr1vp1QVZwQUEvR5mMYObu0s/C3ZzMjvvLAua6agI3hANg1HLswnVzC5U5unrfQcr1PvCpsE5/z1XMLToS3tvoz/Ftb24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZsLHiE7x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZsLHiE7x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64D5EC4CEC3;
	Tue, 10 Sep 2024 10:09:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962994;
	bh=yPIY/1gkbfUE7jm8EnTBTZk3daEmcZelGWVMyDoR7XY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZsLHiE7xs9NijnHSkl601c6/z8ViItJCXtnbbyZEqEfXhDDuu/7Ukk4fW1CVX3/mK
	 23umvY8truT9LwvmRiEksjcG4s6QnBvhTvAbW8zYKTjC9DAjsWXL5219VBL5LSpSYh
	 5wJ0TGEVNw/A4XfqEEM+RNxgGVpsiZrO6SJ37qnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 099/192] hwmon: (lm95234) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:03 +0200
Message-ID: <20240910092602.093836910@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092557.876094467@linuxfoundation.org>
References: <20240910092557.876094467@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit af64e3e1537896337405f880c1e9ac1f8c0c6198 ]

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large
negative number such as -9223372036854775808 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/lm95234.c | 9 +++++----
 1 file changed, 5 insertions(+), 4 deletions(-)

diff --git a/drivers/hwmon/lm95234.c b/drivers/hwmon/lm95234.c
index b4a9d0c223c4..db570fe84132 100644
--- a/drivers/hwmon/lm95234.c
+++ b/drivers/hwmon/lm95234.c
@@ -301,7 +301,8 @@ static ssize_t tcrit2_store(struct device *dev, struct device_attribute *attr,
 	if (ret < 0)
 		return ret;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, index ? 255 : 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, (index ? 255 : 127) * 1000),
+				1000);
 
 	mutex_lock(&data->update_lock);
 	data->tcrit2[index] = val;
@@ -350,7 +351,7 @@ static ssize_t tcrit1_store(struct device *dev, struct device_attribute *attr,
 	if (ret < 0)
 		return ret;
 
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 1000), 0, 255);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, 0, 255000), 1000);
 
 	mutex_lock(&data->update_lock);
 	data->tcrit1[index] = val;
@@ -391,7 +392,7 @@ static ssize_t tcrit1_hyst_store(struct device *dev,
 	if (ret < 0)
 		return ret;
 
-	val = DIV_ROUND_CLOSEST(val, 1000);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, -255000, 255000), 1000);
 	val = clamp_val((int)data->tcrit1[index] - val, 0, 31);
 
 	mutex_lock(&data->update_lock);
@@ -431,7 +432,7 @@ static ssize_t offset_store(struct device *dev, struct device_attribute *attr,
 		return ret;
 
 	/* Accuracy is 1/2 degrees C */
-	val = clamp_val(DIV_ROUND_CLOSEST(val, 500), -128, 127);
+	val = DIV_ROUND_CLOSEST(clamp_val(val, -64000, 63500), 500);
 
 	mutex_lock(&data->update_lock);
 	data->toffset[index] = val;
-- 
2.43.0



