Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB22D1D0E3D;
	Wed,  2 Oct 2024 14:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877677; cv=none; b=ZeXvHKd1DDXR0gncobsNbQDrymp/lj6UV85AkByo2md08UpWCvMQoLg9mGm8NY8VgPrkccstUY5Lg/s8mEaATu0c47gTCyadp22V6kvxthHa75NNDi7V+iLnPDW8uM4e/4nbPmgtyoil95stBjqHIoW/oyCYMp2XGPUCED4bvow=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877677; c=relaxed/simple;
	bh=YUf/oa78P730gWVfiORjeFvlMmnXwxi/eYNfKAMQC/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HvB6oGWKMhhjvwYOp1ffi/EmJ8vKnj3hiHVpA0oX++x6d+Hb4zEzNYnpSiPVLFFU3xNY4ar5MUQscIr+mF30s6sdtvlT4aFQl8NcC+F578a8DztqgG4kHgY46LnzsEQsbTlIAvMq0U0enhXUD/zTgyFyfl0ZX4XkMN0awhINbQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kaSCWWGV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kaSCWWGV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54694C4CEC2;
	Wed,  2 Oct 2024 14:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877677;
	bh=YUf/oa78P730gWVfiORjeFvlMmnXwxi/eYNfKAMQC/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kaSCWWGVn2x657xvdIkMi3Se5zzSqTYd1OvfNOSvS/KPEZpb32i+BWQTPBXl5LJnD
	 i4wETJ7oNYpe6skNIC+QDY/jmbmvFBrNDK3LZBny7N05RxL8PCdj3Gy7e4nP+kfNEB
	 9ekhjB+Wc34IyuXozc4kijWJfOLHHNgOBMbs73sU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 156/634] hwmon: (max16065) Fix overflows seen when writing limits
Date: Wed,  2 Oct 2024 14:54:16 +0200
Message-ID: <20241002125817.268127979@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125811.070689334@linuxfoundation.org>
References: <20241002125811.070689334@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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
index aa38c45adc09e..e392529de098e 100644
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



