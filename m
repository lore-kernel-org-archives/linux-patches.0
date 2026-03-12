Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3BCC40242C;
	Thu, 12 Mar 2026 20:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347304; cv=none; b=Vk3bDddIqTW29V/AGgi1p8A+zChmhemylPbhOxpZq4naiPJXIZhtCmxTmfpZjtIe3xZNZOBcWQtYVfpV9D9Fvn8Aiw1Eg0olb/nwPX/FOrb3kiDhMogkdZcgDi2JiF76h5nXaC4xYUlQv8jbYVIj0M/4noyukRwcwXrMggvNJAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347304; c=relaxed/simple;
	bh=eW27+RcIatsXHo0TFrvbgnGavLLtI2K2RbRZPMR4/RM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l4uw6ZNGM9hSEO1o5jhqozR3Z8Z3/BMfzdZxPiDvg5zK398pevMwWuk1979kSh2FYUM+cCBbLljhReSPa5QQG+OaUrVeagL3vkTmDsfN14DzkUrTICpA28LALeVHAevfWGFkAejjGppZqTrhLTfrinycDjyd9oL8f5ruvTBfIFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Vcyh1XGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Vcyh1XGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40300C2BCB0;
	Thu, 12 Mar 2026 20:28:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347304;
	bh=eW27+RcIatsXHo0TFrvbgnGavLLtI2K2RbRZPMR4/RM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vcyh1XGVFlu5qUWv1AaA2uTTrS0gHf8p04RfH7qIX5eW3R9AGqRBtrnotUy18Txdf
	 LULVzjyHLath1khnpopTdA/rYgv5ifK4WtlPOix9km0r/myL1r7CFzoUV3cnPeVlgr
	 nMH+t+ZzpDf/bKgNsdzTOJfoVImhXyeO3Z+TfHco=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Olivier Sobrie <olivier@sobrie.be>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 226/265] hwmon: (max6639) fix inverted polarity
Date: Thu, 12 Mar 2026 21:10:13 +0100
Message-ID: <20260312201026.490893844@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Olivier Sobrie <olivier@sobrie.be>

[ Upstream commit 170a4b21f49b3dcff3115b4c90758f0a0d77375a ]

According to MAX6639 documentation:

  D1: PWM Output Polarity. PWM output is low at
  100% duty cycle when this bit is set to zero. PWM
  output is high at 100% duty cycle when this bit is set
  to 1.

Up to commit 0f33272b60ed ("hwmon: (max6639) : Update hwmon init using
info structure"), the polarity was set to high (0x2) when no platform
data was set. After the patch, the polarity register wasn't set anymore
if no platform data was specified. Nowadays, since commit 7506ebcd662b
("hwmon: (max6639) : Configure based on DT property"), it is always set
to low which doesn't match with the comment above and change the
behavior compared to versions prior 0f33272b60ed.

Fixes: 0f33272b60ed ("hwmon: (max6639) : Update hwmon init using info structure")
Signed-off-by: Olivier Sobrie <olivier@sobrie.be>
Link: https://lore.kernel.org/r/20260304212039.570274-1-olivier@sobrie.be
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max6639.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/hwmon/max6639.c b/drivers/hwmon/max6639.c
index 32b4d54b20766..0b0a9f4c2307f 100644
--- a/drivers/hwmon/max6639.c
+++ b/drivers/hwmon/max6639.c
@@ -615,7 +615,7 @@ static int max6639_init_client(struct i2c_client *client,
 			return err;
 
 		/* Fans PWM polarity high by default */
-		err = regmap_write(data->regmap, MAX6639_REG_FAN_CONFIG2a(i), 0x00);
+		err = regmap_write(data->regmap, MAX6639_REG_FAN_CONFIG2a(i), 0x02);
 		if (err)
 			return err;
 
-- 
2.51.0



