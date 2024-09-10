Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9FB5190678;
	Tue, 10 Sep 2024 10:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725962992; cv=none; b=VrUnPTtsihRQoejkaDF3oQYGKxA7KbKFJ9tN5aUB5Y/7OAjtjA/i+X0plDN0W0O3j263PxkTb9STkll5MvQkkPzTx4xrDDtxyFLm0fmlrEeCy2W3PR5UBZ0YHLuF/1MfAAXefgeDQix3tDgCKIQeOkjEcWxfLWbZaJggHsEKNes=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725962992; c=relaxed/simple;
	bh=tL9PrYzYYQQllXEVcwp+xoE7E/f2iJCdA84MTm0F/3E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lLOxjkDESrSIvfxPNKLVT8jvNV8d3sMMnkbFDbhbSGJQy9J54znWOS+Qzj/vQS3YYWW+rxN8co2v7rrezJ/QEyzPkFisl6CUGjXq6xGK9xGr7TUxQLNjy9XbsHM75qtl+1D23COcPq2A1P3EDhi/iKNek6dgmV6n1mdA9DxLm2c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CtHO9WGj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CtHO9WGj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71A5EC4CEC3;
	Tue, 10 Sep 2024 10:09:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725962991;
	bh=tL9PrYzYYQQllXEVcwp+xoE7E/f2iJCdA84MTm0F/3E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CtHO9WGjWClzfhKuC/ys/I10HFZhU1IgX6kCGZDvIJT1wqzsB/jVgDvP6QJYLllCh
	 z0vkAtrf6uNom1ipVTRj21MtKdaJP3DgfC9Dde/Q/YejYfvEjFz0Z6v5YwKvElR1Gh
	 7Glg3LJU6ymQUKWKlUTEnCjGphjWvp1EHPRGn/qA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 098/192] hwmon: (adc128d818) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:02 +0200
Message-ID: <20240910092602.053545897@linuxfoundation.org>
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
index 97b330b6c165..bad2d39d9733 100644
--- a/drivers/hwmon/adc128d818.c
+++ b/drivers/hwmon/adc128d818.c
@@ -176,7 +176,7 @@ static ssize_t adc128_in_store(struct device *dev,
 
 	mutex_lock(&data->update_lock);
 	/* 10 mV LSB on limit registers */
-	regval = clamp_val(DIV_ROUND_CLOSEST(val, 10), 0, 255);
+	regval = DIV_ROUND_CLOSEST(clamp_val(val, 0, 2550), 10);
 	data->in[index][nr] = regval << 4;
 	reg = index == 1 ? ADC128_REG_IN_MIN(nr) : ADC128_REG_IN_MAX(nr);
 	i2c_smbus_write_byte_data(data->client, reg, regval);
@@ -214,7 +214,7 @@ static ssize_t adc128_temp_store(struct device *dev,
 		return err;
 
 	mutex_lock(&data->update_lock);
-	regval = clamp_val(DIV_ROUND_CLOSEST(val, 1000), -128, 127);
+	regval = DIV_ROUND_CLOSEST(clamp_val(val, -128000, 127000), 1000);
 	data->temp[index] = regval << 1;
 	i2c_smbus_write_byte_data(data->client,
 				  index == 1 ? ADC128_REG_TEMP_MAX
-- 
2.43.0



