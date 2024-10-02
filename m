Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D3EE16F84F;
	Wed,  2 Oct 2024 13:27:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727875652; cv=none; b=giTjjqVvmxSM3ygJtwDucKoZeFrKiiBc2Nz511UdaCAzH9DwGOWIL/ueKsRbx/B4OIEMkhOTs70/PO7mGuhm4Htwo2yVnjE+t1u8EY0jmThb8eZEid6MUobVQSaQ+nA/SQzw0PG+ZUHOoVKM40U9Bz7D1CumaLipB0G1/SsSjNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727875652; c=relaxed/simple;
	bh=zr0+LrAhuGStMk3+TJxC+F5FmF97r0aK7aH9DD9Avrg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PEUP0+TieYzNB4/K+Ktka/TVj/48KSbEODprMwUpppczdsZkNVauG1Jr7eKHayZiKNDy1FVtcqeCrGfQScD61IlQ5mmkBVwz6PWOqieQG/SzESZ3VdLAnsoZiKpUsgBTEWWCFkObU4nvMa86bLFHO86cnyBjFyxNfQo1M6Oi5f4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lM+X8Pl3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lM+X8Pl3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBA37C4CEC5;
	Wed,  2 Oct 2024 13:27:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727875652;
	bh=zr0+LrAhuGStMk3+TJxC+F5FmF97r0aK7aH9DD9Avrg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lM+X8Pl3iK1nhb7l86VPBd22wdf13sNgTFW2Ty416Fj5q7ZneHcCIUjjrnJTCtnZG
	 DpUttrZw0nQx79d4Zwp24skabqE8sOfu5vC9WWzE0B7GezbuJd4LjRPSQ10medHFGk
	 KMeGqiXpr4FhoyhNXkvjZWHzOYLUkvwBxF2D0xfE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 174/695] hwmon: (max16065) Fix overflows seen when writing limits
Date: Wed,  2 Oct 2024 14:52:52 +0200
Message-ID: <20241002125829.418672474@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 7ce9a89f93a0d..5b2a174c6bad3 100644
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



