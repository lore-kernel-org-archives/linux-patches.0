Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09A5A2628D;
	Sat, 30 May 2026 17:55:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163716; cv=none; b=oRhiN6j+4fQhOcwPtUS6iJ/ZgGS4h21letVjAz7wLgzGGy9+8dTnKizuvSKbEtD2Ma2yQTb9/6cPIVQ5T0kIiyoodlTTOaO/dsW4lyItCM0htULLEN4eoQpSqlG4GwR4BYv0Gd5Z8g2hiobhabd/y8ejPWg7i0bD6oiG+MWZMCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163716; c=relaxed/simple;
	bh=wlnt/m9u1h3TRO3/xpxnif5fT0rDQlB1DL319C/B8NQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=r6n7g1+b8hZ0xjz8tX6kSC02sK/2lhtJ6WuYsikobJwe46CU+/XFBWM8Ro7kxybFA65UPfoPXEWd7G6xRGG7vB6f25THTV4pfaIkAix7kJPzccSNt4j9wpHKxkras3OMgou0Oi8GyaXrGFfHtlHE30wabEydbcTacqcNeLXL3VU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eTL5mAja; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eTL5mAja"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4A20E1F00893;
	Sat, 30 May 2026 17:55:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163714;
	bh=sQ7jDue8iBxFWjWu+2D25fpk1vg7lh9kZUJNVxkgSXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eTL5mAjatBjcuNhOzWalPlEmnMDmUNPQpc9dq3yWeeW4UsDXfe2vu1GbFyZfUGVqd
	 P7sI6NbgJB5dgQMNNKR3WikLVYHpECNlQTyg/nnDeUANKbh1NaE+m8eSab7YxHSt4k
	 LhwS5G8ZcvGIUXX+W4eK/1j/n7jZxAaucj1yTodI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.15 341/776] power: supply: max17042: avoid overflow when determining health
Date: Sat, 30 May 2026 18:00:55 +0200
Message-ID: <20260530160249.389103343@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: André Draszik <andre.draszik@linaro.org>

commit 9a44949da669708f19d29141e65b3ac774d08f5a upstream.

If vmax has the default value of INT_MAX (e.g. because not specified in
DT), battery health is reported as over-voltage. This is because adding
any value to vmax (the vmax tolerance in this case) causes it to wrap
around, making it negative and smaller than the measured battery
voltage.

Avoid that by using size_add().

Fixes: edd4ab055931 ("power: max17042_battery: add HEALTH and TEMP_* properties support")
Cc: stable@vger.kernel.org
Signed-off-by: André Draszik <andre.draszik@linaro.org>
Link: https://patch.msgid.link/20260302-max77759-fg-v3-6-3c5f01dbda23@linaro.org
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/max17042_battery.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/power/supply/max17042_battery.c
+++ b/drivers/power/supply/max17042_battery.c
@@ -198,7 +198,7 @@ static int max17042_get_battery_health(s
 		goto out;
 	}
 
-	if (vbatt > chip->pdata->vmax + MAX17042_VMAX_TOLERANCE) {
+	if (vbatt > size_add(chip->pdata->vmax, MAX17042_VMAX_TOLERANCE)) {
 		*health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 		goto out;
 	}


