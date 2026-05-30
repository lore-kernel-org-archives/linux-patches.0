Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A4642EF652;
	Sat, 30 May 2026 18:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166045; cv=none; b=aYNGRuhTwtNTy16orgehJ6wdCTGVc+7MoDvc5p9UdThoYM8js0VRY9t3izS7GKAVIQEYIhM3BjerhfGgOmzeDAJAcRKWmOym8Cq66Xxvy7y/oPxwHXtWz46K0lGfyk4Jjs0ppO3Qgd4ATedoFEqa4H9WQuEGJZWjb8DonI0weyg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166045; c=relaxed/simple;
	bh=7etIV46BABr6bgMQv0jjuQuOc0HcZonBtjt0vU3yCWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=eVZJ62IUjEn0DpRMVyiRvX9kID8g54IRrzaL+GrtBMDcbbrhSrI/LV4OnMYhq/CKgkKUvyl4DQSvRxrzT3HkBtDFNUZGEi9dk/pcvBu/UbfDDMvCYhcS5VrtdfBLhB9Se120CJwBZfgxfZAsUdHvaukm8dTxJlV4SszLWYLhxHA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=veOctgly; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="veOctgly"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF8991F00893;
	Sat, 30 May 2026 18:34:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166044;
	bh=YOESeJ/kHtMrsThpUZa9vrdT16ZsltSCQivtC8vVbyw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=veOctgly3xVu5UMN+hkUQzKkuoaOGJltZzPvh5zAlu8HuzCZxK5pmPtVlTosuCcDI
	 M0pzUKQ4lstFh6ckGIc3Oqf9KxdL0o22A1hRIxy4dAvJjDqboKpG4DDMg/pST7anXF
	 U/nNmBanMZeHZE/3FX01R/jhSlmhDGxM+jfiSjGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 5.10 258/589] power: supply: max17042: avoid overflow when determining health
Date: Sat, 30 May 2026 18:02:19 +0200
Message-ID: <20260530160231.754355825@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -199,7 +199,7 @@ static int max17042_get_battery_health(s
 		goto out;
 	}
 
-	if (vbatt > chip->pdata->vmax + MAX17042_VMAX_TOLERANCE) {
+	if (vbatt > size_add(chip->pdata->vmax, MAX17042_VMAX_TOLERANCE)) {
 		*health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 		goto out;
 	}


