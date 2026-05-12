Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E4773955DD;
	Tue, 12 May 2026 17:48:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608085; cv=none; b=bm7kAwQb8hhZmXCJBwjOhEstBh9IGbhAyO0AZjlTqabtb58HvjzYCAfA11M9huYdO5/d11ztcpDaNgpmRi0NpehakHnrjF6TVW+NrPtJG0/vHtPSx3jjf3fgJZMqPGZfz11Wn7NG7m8p1iV3cvunPGJYL/vgAmyL6MgAX8ZpGmY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608085; c=relaxed/simple;
	bh=FawG/ahdDaF3AaiKE/xws2NQSDdQ1N1WBkQGGueONZ8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=uGkjfASf2TMjfboVRJhtYN29BIEPvyjgJv5JqRVcu6Y2erxD7ZorVPaYBl4UY8CmYjVu4LtISoGBJRnxMm1VMnu9LJSbM35jRTt7YuQu4VSy25WxoHHPvjodFGozo0YXcHcZQXQ8l1PvMDGskZpvUzJG9CKWV1a7uM/h/Y5reXU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IviJv95L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IviJv95L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95747C2BCB0;
	Tue, 12 May 2026 17:48:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608084;
	bh=FawG/ahdDaF3AaiKE/xws2NQSDdQ1N1WBkQGGueONZ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IviJv95L3lPmgKIi/Yeeu7LHS1x2YI0n8HDFFEYd5baxW87ZRW/zxR2eJjerRZ1lR
	 QUasqUhKAvwHXMkTQ7Bd2ei9xNSUPHx7N+tNX340+89tCRkXeE7cwZSluoB1uJeAO0
	 /AsGeQwziLmJqBiftitOrC0HsDYtzCxDLOa1yih8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Andr=C3=A9=20Draszik?= <andre.draszik@linaro.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.12 147/206] power: supply: max17042: avoid overflow when determining health
Date: Tue, 12 May 2026 19:39:59 +0200
Message-ID: <20260512173935.976461310@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


