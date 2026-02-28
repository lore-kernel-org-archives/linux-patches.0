Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46D6C3446B0
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302045; cv=none; b=Ag9r7Vi6xE9RKAelbRYlYR+2dfHyK8WlXgw6SCsCo2PYAmOADcz/Nkb7oefk9fuyffFDp72qOPJu4Z6wKCzrO6j8hoFPyn0pLLH3oCO0+ojwmSpEbbaBnzyOMWxGJujjFNGnKS8UUpI2tTvIMLqPjRsOv+XdsQzd6DQArfHpsqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302045; c=relaxed/simple;
	bh=x7T7gXRXk2Mez3XQb4rfhR48AD15xz/gzIWXv6zalg0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fHKM88vm5ikSXbTyEbR33qH0ByzVU3ALuG/ns/dlF2CaUNdgTDtyRjxsGyMDmXzM97NJ0PsGgCVktv66S669Ba/w5adG17EmOhf3VS5gzrY0isuEGoEGB2MO+vA/E8B1MpdsYvcsUgY+x0497tlvNjLHoJNPHaAMiSgh8GWwPfs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C6GIs62s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C6GIs62s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6F0EC19423;
	Sat, 28 Feb 2026 18:07:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302045;
	bh=x7T7gXRXk2Mez3XQb4rfhR48AD15xz/gzIWXv6zalg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C6GIs62s8dLT2qABR3FCvJ7OB88rXgqPG5ajFJOyWqSaV9sMmGGkuEpv4U9uIhX8N
	 PviZ85WNcjLSYstbeIQXS7QAroa7vJCtnneyue5MEtx0RHhpaVQe3TSIYDqkScDEzm
	 sfb3sfW1U20q2YxCdqzCFAyxWEJoymgYGp4xQ8XYDx95DFb+05zqYnQWBv744+TGl4
	 3vcUF4s/htXbj9Bahe5hdOZWX/FPyD0J7s3gvvJ1KMzf49ZISHFWZqijHLPuaMDY/U
	 SVUwJFgzgHil0Cz3s00pQLPlYrp9TeSC37mfVtanlneDyt1FaJeoIt8hbi20nGS/ZG
	 oEyqad/AhpvWQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Alper Ak <alperyasinak1@gmail.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 018/283] tpm: tpm_i2c_infineon: Fix locality leak on get_burstcount() failure
Date: Sat, 28 Feb 2026 13:02:40 -0500
Message-ID: <20260228180709.1583486-18-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Alper Ak <alperyasinak1@gmail.com>

[ Upstream commit bbd6e97c836cbeb9606d7b7e5dcf8a1d89525713 ]

get_burstcount() can return -EBUSY on timeout. When this happens, the
function returns directly without releasing the locality that was
acquired at the beginning of tpm_tis_i2c_send().

Use goto out_err to ensure proper cleanup when get_burstcount() fails.

Fixes: aad628c1d91a ("char/tpm: Add new driver for Infineon I2C TIS TPM")
Signed-off-by: Alper Ak <alperyasinak1@gmail.com>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/char/tpm/tpm_i2c_infineon.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/char/tpm/tpm_i2c_infineon.c b/drivers/char/tpm/tpm_i2c_infineon.c
index 81d8a78dc6552..3675faa4a00c7 100644
--- a/drivers/char/tpm/tpm_i2c_infineon.c
+++ b/drivers/char/tpm/tpm_i2c_infineon.c
@@ -543,8 +543,10 @@ static int tpm_tis_i2c_send(struct tpm_chip *chip, u8 *buf, size_t len)
 		burstcnt = get_burstcount(chip);
 
 		/* burstcnt < 0 = TPM is busy */
-		if (burstcnt < 0)
-			return burstcnt;
+		if (burstcnt < 0) {
+			rc = burstcnt;
+			goto out_err;
+		}
 
 		if (burstcnt > (len - 1 - count))
 			burstcnt = len - 1 - count;
-- 
2.51.0

