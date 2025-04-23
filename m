Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDE2629CB34;
	Wed, 23 Apr 2025 15:17:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421474; cv=none; b=Mu7csc/qJbRPEPu5vmR3DLJqeNg6eLZZjh60jey2qddTztDONyeQRgQ+8VpGRiE+g4NnE8EYeRU2AlywrdkOTK32FWBJxZ73ft1AOY8JqZ7MES/AYSzFaPyMCFf5tBENCkdDiL2f7picI9rys6GkeW6N0PVXoyh98aBAuUtpmWY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421474; c=relaxed/simple;
	bh=31ALOrUkJz+Cq5ozP1FVBivQ1xaULsFld4Namq76xNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YwlQdp+AY/nD+qwcOFHNvm+YRaXdGadVgcS2K6BDbXuvYiTUS/1LVgDBM3ca2J0YhYnJWNGsMbxP1JWYkyiEpinSg8uM3oliiffhZXI+i451ooUG9GNapbvleeJN+CsX17QeVnuUBkd/B6kEZw32qfuckCFn+xNkFyyJic1+txs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hcQtnxS8; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hcQtnxS8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6780CC4CEE2;
	Wed, 23 Apr 2025 15:17:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421473;
	bh=31ALOrUkJz+Cq5ozP1FVBivQ1xaULsFld4Namq76xNc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hcQtnxS83V410i5mws8C8yHpYVA8VewPXxnwp6W2h9sAP5+0lndKjQaVyVVha2ZJ+
	 Rl0qqqvqtVm971S7G6wPcdFUK7tWoqxWWOD3Hz7lR/YDhYRTpW5YPvtwXOrn7+fbQB
	 Czdjj79DYEIp4zgkQE6pnK4sp9Cy53/lVw9tEnsw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 182/393] backlight: led_bl: Hold led_access lock when calling led_sysfs_disable()
Date: Wed, 23 Apr 2025 16:41:18 +0200
Message-ID: <20250423142650.894110157@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142643.246005366@linuxfoundation.org>
References: <20250423142643.246005366@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

commit 276822a00db3c1061382b41e72cafc09d6a0ec30 upstream.

Lockdep detects the following issue on led-backlight removal:
  [  142.315935] ------------[ cut here ]------------
  [  142.315954] WARNING: CPU: 2 PID: 292 at drivers/leds/led-core.c:455 led_sysfs_enable+0x54/0x80
  ...
  [  142.500725] Call trace:
  [  142.503176]  led_sysfs_enable+0x54/0x80 (P)
  [  142.507370]  led_bl_remove+0x80/0xa8 [led_bl]
  [  142.511742]  platform_remove+0x30/0x58
  [  142.515501]  device_remove+0x54/0x90
  ...

Indeed, led_sysfs_enable() has to be called with the led_access
lock held.

Hold the lock when calling led_sysfs_disable().

Fixes: ae232e45acf9 ("backlight: add led-backlight driver")
Cc: stable@vger.kernel.org
Signed-off-by: Herve Codina <herve.codina@bootlin.com>
Link: https://lore.kernel.org/r/20250122091914.309533-1-herve.codina@bootlin.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/video/backlight/led_bl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/video/backlight/led_bl.c
+++ b/drivers/video/backlight/led_bl.c
@@ -229,8 +229,11 @@ static void led_bl_remove(struct platfor
 	backlight_device_unregister(bl);
 
 	led_bl_power_off(priv);
-	for (i = 0; i < priv->nb_leds; i++)
+	for (i = 0; i < priv->nb_leds; i++) {
+		mutex_lock(&priv->leds[i]->led_access);
 		led_sysfs_enable(priv->leds[i]);
+		mutex_unlock(&priv->leds[i]->led_access);
+	}
 }
 
 static const struct of_device_id led_bl_of_match[] = {


