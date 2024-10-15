Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AD8A1C07C4;
	Tue, 15 Oct 2024 13:01:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997274; cv=none; b=hacdEc9/d+fq+B49eVFQQdaxUYwzaLgRq3oi8iHKuowVgtbVgspmJ1VBuo+hqzlxtcx7oV531e7gUuSsx1lpZuBf+HJ53fyLnV4Vxto70h0e2IK0hXqjSheNRjs/qon2kkX9Y8oSHAWmuRevYJ1ViBU9lk2L+jpASLdxIMc/Zqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997274; c=relaxed/simple;
	bh=1Jez2nEphx/GVgsI3i7mJOQLrR5HKVjBsfPJbGHmros=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vikl58JvffMWjWzqorM6YZezDeOFvs3HblcEcZ2auUCfJaGKaWFNdb8V60UWjSnt+tFkEpoWB+G5pABJqnQy1IVGJXMfTPK5DYPsDNptqIQJJdFyidzkHyQsyVIqK002TDIEjMhKhNRNuR+5gfsaG/Mq8LlJl2KxlayrrUyKYeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JTYn2gdk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JTYn2gdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0475C4CEC6;
	Tue, 15 Oct 2024 13:01:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997274;
	bh=1Jez2nEphx/GVgsI3i7mJOQLrR5HKVjBsfPJbGHmros=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JTYn2gdk/OfvvMji1ZwxgHkBfwdiJMFYUNww+wDBzhRVMlLPaPLcjJ7mrrfG8zsYm
	 SGyHDAcI4bI05CZJyh2pSthFXr0+wlqIubmZWB+ZfpYFVpLKKI2LykZxYaw21zJ76e
	 MjCjLdhZwle3iYpRIA2EPRaj4dybNjvFa5YumlGc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 103/518] hwmon: (max16065) Fix overflows seen when writing limits
Date: Tue, 15 Oct 2024 14:40:07 +0200
Message-ID: <20241015123920.976187639@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index a26226e7bc374..6a09ab606fcbf 100644
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



