Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0566B1E7C1A;
	Wed,  6 Nov 2024 12:58:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897916; cv=none; b=RfOZJFkLOwjf6jtvbZAgkbmr+940xJxWyK7JVDrVWdfon1HW6BJHT2o1dLCs3cLEtYeUUtXnL701SCa/E3pkR78LWllmLCKbeWBH4Y3L5rAgXYO6P4vlGzeY1B/RQFWSZuW4Ou5Uyr4Qzn5NLSFP8SfSypKnD1RhgvVvg+aeShE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897916; c=relaxed/simple;
	bh=8Iwo7gibWiRQWpEiCqYIwfop++yilqIMUwD269WStFM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dzyboUQd3CT/T/xfNkjOpjNgfeZLn/Sauu61aA3rxxIrJMx3eHrURgXDDkvco78fqSmLiD1SP7kTpsH5F7YxAj0tJKf8DF3BYEpJS2sB5XBylVqD/vsyhim5Nbrs9BcfmVi82BThYPcbDQ6Vi5hCVpTSDTtmJ+BwqtQUYNSapEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1/I7oGK+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1/I7oGK+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 82DC3C4CECD;
	Wed,  6 Nov 2024 12:58:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897915;
	bh=8Iwo7gibWiRQWpEiCqYIwfop++yilqIMUwD269WStFM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1/I7oGK+/7LBJbsFEv921BMpr0uAn6c0R42IuMuMUdDiG+V9pFuVTE6Wh/Tnp4QdI
	 B4omB3Q9lPoE/xX3LIu+0Rn2Aa+X1ILEZtGdPQVVuJg0VXpgZ7g3/4hZFovKBm5rg7
	 kmCQrhBpNPi9JguDO6rVlfRAHfVHJ+2lwCqnSl8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 061/462] hwmon: (max16065) Fix overflows seen when writing limits
Date: Wed,  6 Nov 2024 12:59:14 +0100
Message-ID: <20241106120333.022024706@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120331.497003148@linuxfoundation.org>
References: <20241106120331.497003148@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit 744ec4477b11c42e2c8de9eb8364675ae7a0bd81 ]

Writing large limits resulted in overflows as reported by module tests.

in0_lcrit: Suspected overflow: [max=5538, read 0, written 2147483647]
in0_crit: Suspected overflow: [max=5538, read 0, written 2147483647]
in0_min: Suspected overflow: [max=5538, read 0, written 2147483647]

Fix the problem by clamping prior to multiplications and the use of
DIV_ROUND_CLOSEST, and by using consistent variable types.

Reviewed-by: Tzung-Bi Shih <tzungbi@kernel.org>
Fixes: f5bae2642e3d ("hwmon: Driver for MAX16065 System Manager and compatibles")
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/max16065.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/hwmon/max16065.c b/drivers/hwmon/max16065.c
index 49b7e0b6d1bbe..5d0ecc8d56af1 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -114,9 +114,10 @@ static inline int LIMIT_TO_MV(int limit, int range)
 	return limit * range / 256;
 }
 
-static inline int MV_TO_LIMIT(int mv, int range)
+static inline int MV_TO_LIMIT(unsigned long mv, int range)
 {
-	return clamp_val(DIV_ROUND_CLOSEST(mv * 256, range), 0, 255);
+	mv = clamp_val(mv, 0, ULONG_MAX / 256);
+	return DIV_ROUND_CLOSEST(clamp_val(mv * 256, 0, range * 255), range);
 }
 
 static inline int ADC_TO_CURR(int adc, int gain)
-- 
2.43.0



