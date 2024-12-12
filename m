Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A009C235C42;
	Thu, 12 Dec 2024 16:55:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734022556; cv=none; b=rl6/ZEJU3mrSMJicq9rk5VV5ppjBwpRizYWRzPiXju+L7Cpamq9ItUqAXQBpbR6kCpKQtFSWFAUajSDWZlPlKLEUYTxTvsdj2uVKxIjW1zgEpRBuhsm0wHrvZGpAWP/ZS+g9lhsiRPpyFrNYNBXBChAAG/6wqeUfyBpd11nH7A8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734022556; c=relaxed/simple;
	bh=Ufp6LXg5zPsA5zFFP6hkUe5JFPuAnKMLRi/R9iFn5OU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SkuaH31GcomfsfLE0NAqRGUtsdEwKoW2NHGtHJMWbu1SXOUB+lsq040qUuhgvUeIij7lylVDVsnU8LfXsqIiQwpLY3z4GLw/6Zn0ylWyBTWNlKAKme8xz9gx2kMtQ64hlxTVPHB6cpRH0mUkiGP7H3x12h5b5a8aZhbKJSbD8zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XRq7MH/J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XRq7MH/J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D291C4CED0;
	Thu, 12 Dec 2024 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734022556;
	bh=Ufp6LXg5zPsA5zFFP6hkUe5JFPuAnKMLRi/R9iFn5OU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XRq7MH/JMi28/MXjyVOv/0epNwLH/XIuY+MrVmOQ+rfrtsLX14WIdOzHUhTDp77fE
	 EaUKJ447odKhBMCvJmLxoILsyL8BKv1aI/ZJZbowX56OTMguJI5wuIwrmhfv4wz37/
	 2WiUkjNRTJQCaiiGMO2w2yTK4J+UgfsyYlE0dzZc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kyle Tso <kyletso@google.com>,
	Krzysztof Kozlowski <krzk@kernel.org>,
	Bart Van Assche <bvanassche@acm.org>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 273/565] power: supply: core: Remove might_sleep() from power_supply_put()
Date: Thu, 12 Dec 2024 15:57:48 +0100
Message-ID: <20241212144322.252879918@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit f6da4553ff24a5d1c959c9627c965323adc3d307 ]

The put_device() call in power_supply_put() may call
power_supply_dev_release(). The latter function does not sleep so
power_supply_put() doesn't sleep either. Hence, remove the might_sleep()
call from power_supply_put(). This patch suppresses false positive
complaints about calling a sleeping function from atomic context if
power_supply_put() is called from atomic context.

Cc: Kyle Tso <kyletso@google.com>
Cc: Krzysztof Kozlowski <krzk@kernel.org>
Fixes: 1a352462b537 ("power_supply: Add power_supply_put for decrementing device reference counter")
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Link: https://lore.kernel.org/r/20240917193914.47566-1-bvanassche@acm.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/power_supply_core.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/power/supply/power_supply_core.c b/drivers/power/supply/power_supply_core.c
index 8b2cd63016160..2ebf838fbf9d3 100644
--- a/drivers/power/supply/power_supply_core.c
+++ b/drivers/power/supply/power_supply_core.c
@@ -479,8 +479,6 @@ EXPORT_SYMBOL_GPL(power_supply_get_by_name);
  */
 void power_supply_put(struct power_supply *psy)
 {
-	might_sleep();
-
 	atomic_dec(&psy->use_cnt);
 	put_device(&psy->dev);
 }
-- 
2.43.0



