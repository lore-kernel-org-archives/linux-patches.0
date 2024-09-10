Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD4AA46444;
	Tue, 10 Sep 2024 09:38:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725961113; cv=none; b=niiVJkt7gJQLpGFVvvZXMGZYVmOWBA/sIaux/E2Y3V6ZQry5klReFU92lQbcl3/ciy0YQGMIBA/u+1CoTd7lcqhZsH1boqRcvhekB3A9Nj9HNdyhRujmJRRSf90c8DuYdStQurtyk5HYk2zl4tWoHODCUV3vLoMrnRlpoSOh5JQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725961113; c=relaxed/simple;
	bh=NyqWP07UmOSJDjZog40UpUisd9Ga1ywP9X6XIXzTyUI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Gw529mpLJK2E1G6z0jF3aufEOiZ1obD/sW2TwBCPD0LeGnd1sYLDzF7/IblI63xBFd0oO8KG+WJCA17rSUR7gyiKKN0NoodoP82O5+ByItobA8ZPYXXgIU8xwajSIm/iM8ica8YsvlqaxteEph1J1WGrMGOe5O+t2FPqUQcsOig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zlRq64i5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zlRq64i5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62AC1C4CEC3;
	Tue, 10 Sep 2024 09:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725961112;
	bh=NyqWP07UmOSJDjZog40UpUisd9Ga1ywP9X6XIXzTyUI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zlRq64i57bebrO6Qh3Y79VnBdFTt7KTOKCD+AikJYqwOH0PqzWJQNwcFz5xCppnEs
	 5O7NkOY1Cb6M9yUYcONDJZO0EJdyDq5rq6ioHE/VFW8bBg+Ypw60CQMeNHbsOOzdxq
	 HroUPqBE9fmyk7/GxYCUTA3dBLVw1ueZHel/+sUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 57/96] hwmon: (adc128d818) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:31:59 +0200
Message-ID: <20240910092544.028209460@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092541.383432924@linuxfoundation.org>
References: <20240910092541.383432924@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 8cad724c8537fe3e0da8004646abc00290adae40 ]

DIV_ROUND_CLOSEST() after kstrtol() results in an underflow if a large
negative number such as -9223372036854775808 is provided by the user.
Fix it by reordering clamp_val() and DIV_ROUND_CLOSEST() operations.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/adc128d818.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/adc128d818.c b/drivers/hwmon/adc128d818.c
index bd2ca315c9d8..5abb28cd81bf 100644
--- a/drivers/hwmon/adc128d818.c
+++ b/drivers/hwmon/adc128d818.c
@@ -184,7 +184,7 @@ static ssize_t adc128_set_in(struct device *dev, struct device_attribute *attr,
 
 	mutex_lock(&data->update_lock);
 	/* 10 mV LSB on limit registers */
-	regval = clamp_val(DIV_ROUND_CLOSEST(val, 10), 0, 255);
+	regval = DIV_ROUND_CLOSEST(clamp_val(val, 0, 2550), 10);
 	data->in[index][nr] = regval << 4;
 	reg = index == 1 ? ADC128_REG_IN_MIN(nr) : ADC128_REG_IN_MAX(nr);
 	i2c_smbus_write_byte_data(data->client, reg, regval);
@@ -222,7 +222,7 @@ static ssize_t adc128_set_temp(struct device *dev,
 		return err;
 
 	mutex_lock(&data->update_lock);
-	regval = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	regval = DIV_ROUND_CLOSEST(clamp_val(val, -128000, 127000), 1000);
 	data->temp[index] = regval << 1;
 	i2c_smbus_write_byte_data(data->client,
 				  index == 1 ? ADC128_REG_TEMP_MAX
-- 
2.43.0



