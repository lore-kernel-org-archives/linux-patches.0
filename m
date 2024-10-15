Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05CFD13F435;
	Tue, 15 Oct 2024 11:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728992658; cv=none; b=jLbxK6Nm9oWYa3k/lZeyUE39N/dNVpW0bthUR00HmuhQdUJzaG8OOFRBI0cfDBtsr45C2W24ZZsAGoq0Rlh2UaWiUP3hGtQkJDBKVwAciUurbKWhMD/heEjmc49mpAjggi+hcbsx+UM0AipOhHaKDbADHqQwK494sTz6U0qK6GY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728992658; c=relaxed/simple;
	bh=SnbrK2782dJE2Yl/yKgEUdCK9fbf7qqFfVfLeCpALMA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKs4KL/ilUiKbz0xNn28kC/i4UtsyMpsEkGFmIPdHOpU7Co1+8uSQKOFQNlNffmQoKf81R8KDlI6+pspckIj5GenXp2LUpOR99lO0JuXhJT2Jb/OrT8O7kyPhyep/FoAZPETdpoChWAyyeSjRMNoVyM7E0GyFXotfPG1b0NNSwE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ed/Jk32I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ed/Jk32I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 270B8C4CEC6;
	Tue, 15 Oct 2024 11:44:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728992657;
	bh=SnbrK2782dJE2Yl/yKgEUdCK9fbf7qqFfVfLeCpALMA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ed/Jk32IadPjulVICSHRddRLeECUUW32VPD+YpM8SpyVggeCkJRRcHxnLJ84ebnna
	 JRdCqyMDvSamne5yE/GyfEvaf1olq/IWC8Vui9c14ttsuzWk8dKv2waeaznsGscfPJ
	 WaMeqHpRGSwz3/DBEaqE2maDqpQIsCLtdZavaX3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tzung-Bi Shih <tzungbi@kernel.org>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 149/691] hwmon: (max16065) Fix overflows seen when writing limits
Date: Tue, 15 Oct 2024 13:21:37 +0200
Message-ID: <20241015112446.266119554@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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
index ae3a6a7bdaa23..47d039c46cb09 100644
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



