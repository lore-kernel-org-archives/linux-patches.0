Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7954C191F72;
	Tue, 10 Sep 2024 10:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725963796; cv=none; b=Mjx5dXHmuTv0MTeGCeExcTIe/Sf3BOzMshE03xDRSooY6u/CLvlXIZPLA/S5krvxjX/A3/7xMQ3ffJ+Heoa7j2siLiElvwOxCtuhRTLLpRMvUo4g9j/c7lZCk8W3pUE0KODJOXUnZLk1KTzJ1Ppv7prs9VF+Bvl/HiHtQxyRWjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725963796; c=relaxed/simple;
	bh=z31QGl1pt3vSqbQ0P4AnrgAbAtU1jdx27MSzCswNShY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=evTJUceuQ/7TbiYudhzkU0vL/s80yQK9L/Ka8UovNRQdKvSJrZVCf01xk9zBpoNfTr4qRcyYpN8ccwN3nDkwDelTIn3r3jWZAdK2ZI0FECF9zmbJMYcTb8x+Cbwvhx7ar3nlcn1UbJCvTN3+LWfk5c4ywX5EJiuzf1P+vS4xD98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkumJb1O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkumJb1O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB124C4CEC3;
	Tue, 10 Sep 2024 10:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725963796;
	bh=z31QGl1pt3vSqbQ0P4AnrgAbAtU1jdx27MSzCswNShY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkumJb1Oe8KvzyH/AckjgpelcK9FtY57qg+tiKjZ4W0dNB0TTKGFyanL7dLPCsLGo
	 v1c8Q2QO8GfyTm3A+NI6FtwQ9mxoIhN0vyng2c6uVMQveAYR3xTyfTMzOcvBIQNkKo
	 Y4moyJpAhzyOV9CVmFVqeiRrK6jIDytqTkppK2gQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 142/214] hwmon: (adc128d818) Fix underflows seen when writing limit attributes
Date: Tue, 10 Sep 2024 11:32:44 +0200
Message-ID: <20240910092604.557465827@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240910092558.714365667@linuxfoundation.org>
References: <20240910092558.714365667@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index fd938c70293f..739cd48228d4 100644
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



