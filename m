Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29805375AC3;
	Tue, 21 Jul 2026 17:22:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654532; cv=none; b=bBNRJc4MyItQjClcYNKHjPYqRz8MeatNxUade9YMkECX6Uwhgp9hoBghFY/dWSTmPTrZHO9CJAcW7WG2dvEuP0qNhVIezolEBdaD5JZQwRKg6KYzeAx9nzV44PqVhCOvARJMlzE4dnhztJIWoiaiPiL0lZzcg7uXDeTik1k4CUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654532; c=relaxed/simple;
	bh=/jbAwXIv7laScPJgZghZIB4f/KdkGKhTy68Vhs1ULTc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1gckxcCccx6UrjOYgqZlF5PBKqxFfnwMho1OUFsfUMprmtP1q86ZCAGcNdzCwpOAFn5dJvvOVi4F1S5wlwWEa5oiJjwiCvT7KpuFo2G0hhrAI/I3gFXD/19w3kjPj96s9ckzjQ2pUJqJlgKPi4ouHNI6rnZnrC5sdufLNfzg84=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YNm8ZioA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YNm8ZioA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8E8641F000E9;
	Tue, 21 Jul 2026 17:22:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654531;
	bh=CJgQTKlwqCNZgJmUrnKgvilSAZXiINXhBWrRd5TInJI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=YNm8ZioAZTGjhGwenroQcMgRWVqBsNKpg7hooCPkLUUJPrhK0EPiAyAfwG7h1uEGD
	 JhI7cuwFnikjdIXcmBjyTHZTPKWlI+ZEOzhcHLx4d4lLqZp2muiJk0OcGc6ieHTCGL
	 GaxjK5yXbdvqc+S0GkkJGWmNnsQz/PrbFozgdnrU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Alexey Charkov <alchark@flipper.net>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.1 1739/2077] power: supply: bq257xx: Fix VSYSMIN clamping logic
Date: Tue, 21 Jul 2026 17:23:32 +0200
Message-ID: <20260721152633.764709861@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Charkov <alchark@flipper.net>

commit b6c6b9260a92dacef6edef8e93bc2767b86b1dfe upstream.

The minimal system voltage (VSYSMIN) is meant to protect the battery from
dangerous over-discharge. When the device tree provides a value for the
minimum design voltage of the battery, the user should not be allowed to
set a lower VSYSMIN, as that would defeat the purpose of this protection.

Flip the clamping logic when setting VSYSMIN to ensure that battery design
voltage is respected.

Cc: stable@vger.kernel.org
Fixes: 1cc017b7f9c7 ("power: supply: bq257xx: Add support for BQ257XX charger")
Tested-by: Chris Morgan <macromorgan@hotmail.com>
Signed-off-by: Alexey Charkov <alchark@flipper.net>
Link: https://patch.msgid.link/20260603-bq25792-v7-2-d487bed276d0@flipper.net
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/bq257xx_charger.c |    7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

--- a/drivers/power/supply/bq257xx_charger.c
+++ b/drivers/power/supply/bq257xx_charger.c
@@ -128,9 +128,8 @@ static int bq25703_get_min_vsys(struct b
  * @vsys: voltage value to set in uV.
  *
  * This function takes a requested minimum system voltage value, clamps
- * it between the minimum supported value by the charger and a user
- * defined minimum system value, and then writes the value to the
- * appropriate register.
+ * it between the user defined minimum system value and the maximum supported
+ * value by the charger, and then writes the value to the appropriate register.
  *
  * Return: Returns 0 on success or error if an error occurs.
  */
@@ -139,7 +138,7 @@ static int bq25703_set_min_vsys(struct b
 	unsigned int reg;
 	int vsys_min = pdata->vsys_min;
 
-	vsys = clamp(vsys, BQ25703_MINVSYS_MIN_UV, vsys_min);
+	vsys = clamp(vsys, vsys_min, BQ25703_MINVSYS_MAX_UV);
 	reg = ((vsys - BQ25703_MINVSYS_MIN_UV) / BQ25703_MINVSYS_STEP_UV);
 	reg = FIELD_PREP(BQ25703_MINVSYS_MASK, reg);
 


