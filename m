Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 532FF1DF24A;
	Wed,  6 Nov 2024 12:08:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730894927; cv=none; b=gfsewO8xh3C4DPsfRexFi66pZpfI2Q0fLjutpMviCELRlvWY5rlsVhRH4IKtJqD+9TAHDHjYIFkhJ9zToG8yaY7t9YsxwM2jFGl0mgE110pxbp8a4lJgI7RGRzso2MJ/wruEpX063Y1gBiRONpsB3gTKUMuycCBLWlfGDMOW1G0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730894927; c=relaxed/simple;
	bh=znSDnmbugVFr0l67EtSQRHLO1Gxn7ln8XyibqDXR1EM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QGiAd+gYrit4UXChUGud8hjbva2gJCeInTmTri5L8yMx93DGUbhLeEt7is0VUFlzkpSioDiN2/9Wy0vDXllF58ze6wLBYrmCF/EteFqEbPsANCkPkgSmvixVqQ8qyx6U8tE9bCFlLwFnxfI0ylWh9sVqkKK+2kE2IhQ77ANCMBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DuL02C0e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DuL02C0e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CBF4FC4CECD;
	Wed,  6 Nov 2024 12:08:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730894927;
	bh=znSDnmbugVFr0l67EtSQRHLO1Gxn7ln8XyibqDXR1EM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DuL02C0eqYZAg3ZpaxmeFS5HxEA34XLaGAYrUFOM78ooHKPPfPUv2o8v/FgJ8wIOi
	 ntJbPtDgyHto064NtV6pqgkwTDtMikRw7V7E6pXACH4QEYxCY/CSDW3oJAJ5celZ+N
	 kZe0qkVzlsfo39JQhAG7locAvy7gwlnYhms4bP4I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 045/350] hwmon: (max16065) Fix overflows seen when writing limits
Date: Wed,  6 Nov 2024 12:59:33 +0100
Message-ID: <20241106120322.000154345@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120320.865793091@linuxfoundation.org>
References: <20241106120320.865793091@linuxfoundation.org>
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
index 162401aaef71b..3015dd1a75141 100644
--- a/drivers/hwmon/max16065.c
+++ b/drivers/hwmon/max16065.c
@@ -117,9 +117,10 @@ static inline int LIMIT_TO_MV(int limit, int range)
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



