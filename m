Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCC87366831;
	Tue, 12 May 2026 18:11:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778609517; cv=none; b=KISa0bz9+35Xg55Vgj4qbEpGiJ6WFu+zKQ+Zdk3nd0AzkaP7JNZVioeYGsuv7vu07FyhvhG1oTnojC8674e7zGAePAte2j/7CUA8fc3EvtOH01oCwFUIr2HY+vlVjr8M8CpkX0XlyhYTyc6+8bbMjGd/TbO2/BX8OGmRbqXqUkI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778609517; c=relaxed/simple;
	bh=jKLd30wkAs3AEiwJbsOWXLHYFRLIAMvy6b1+NGmkL6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=IJEhTux2p1J3LeiBnsQMuGkYs1ZdnP++PQDkK5VLQ5BwKRBJGqR++vMCoZZP2557sVMl9uOPEF57b4YuXY72ZwbOY7/etF4Z5X2LGW3+NC9Lo40mbuXwMIwGQRbfpE5iRQa3lTbX+EOi11YF9RY+e0JfN5LwxteROZgrHkhz2Tk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=htESMrNV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="htESMrNV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C4D6C2BCB0;
	Tue, 12 May 2026 18:11:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778609517;
	bh=jKLd30wkAs3AEiwJbsOWXLHYFRLIAMvy6b1+NGmkL6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=htESMrNVJF3W6LEvmgzE+QL0ZOrw16I2waQoG3qq4nQbReOMtYHRFx+pY+XXdg6XF
	 ncNYomMbLioC0Z+IDLTjy4Z0jfZ+vK+qq1NlHUSXPuleFkibkxtQYdx+BF4dJe184x
	 7eIuL2d5iqWRnrmWb5fvxu1aYniu3+M8GEpGiCiI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 7.0 226/307] power: supply: max17042: avoid overflow when determining health
Date: Tue, 12 May 2026 19:40:21 +0200
Message-ID: <20260512173944.888409338@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173940.117428952@linuxfoundation.org>
References: <20260512173940.117428952@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -201,7 +201,7 @@ static int max17042_get_battery_health(s
 		goto out;
 	}
 
-	if (vbatt > chip->pdata->vmax + MAX17042_VMAX_TOLERANCE) {
+	if (vbatt > size_add(chip->pdata->vmax, MAX17042_VMAX_TOLERANCE)) {
 		*health = POWER_SUPPLY_HEALTH_OVERVOLTAGE;
 		goto out;
 	}


