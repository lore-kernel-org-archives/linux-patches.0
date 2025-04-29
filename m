Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A10E03FFD;
	Tue, 29 Apr 2025 18:01:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745949675; cv=none; b=kc7cfCPQ/5yoYt09JaHSPlSj4Qh92GIqVOM0yKddKRMKml2bX2HXdw23SVsEIoDYCmFhWS+dEfPzhF2qGBDC+RUDZETG01J5A39yx7SN43xfUbF+/Ng+ZP1v63TH0sSxEfIqSCjT0B+bNSyTSAfZ6owiTE46dkf94oy5wiHZltQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745949675; c=relaxed/simple;
	bh=jSt0CsRu3A6DzbGrQ3tX40hcIumEbNdtLsm/2KTnPsI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WXBpuegGhbaNC4vm/aH8lB0MlertVGqFqbHVNOIFTkyfIc/vLElWuS6rMfqgnZccYPY/d3C5KugIR3zoydY8dAy9ZFWwDM9iFnZ5788X6NcVmirA/0LHlNSIDdFN0cyXSW59PKip7py02lIJuxL0krWn53O6tT0TV3zhs+hbId8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=meivFDZu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="meivFDZu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 359C6C4CEE3;
	Tue, 29 Apr 2025 18:01:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745949675;
	bh=jSt0CsRu3A6DzbGrQ3tX40hcIumEbNdtLsm/2KTnPsI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=meivFDZu7ZwDx2Kfc+IXR5wxm9eKuFZlvBHZ+MmBfQzvrBZEOMuiZqN0oLrz/F3Kd
	 XNKAiArRZBuc2LkB4zPc5w6GGNj1vE/2QLYbsxCjdfED5Gqn5xMRWsohE49m4ef8ER
	 +VcyS73O9cR/uQ5Mfm2x74Rqn+F+fjZJ5jD8KVCo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 020/167] backlight: led_bl: Hold led_access lock when calling led_sysfs_disable()
Date: Tue, 29 Apr 2025 18:42:08 +0200
Message-ID: <20250429161052.570153660@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161051.743239894@linuxfoundation.org>
References: <20250429161051.743239894@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Herve Codina <herve.codina@bootlin.com>

[ Upstream commit 276822a00db3c1061382b41e72cafc09d6a0ec30 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/video/backlight/led_bl.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/video/backlight/led_bl.c b/drivers/video/backlight/led_bl.c
index a1b6a2ad73a07..589dae9ebb638 100644
--- a/drivers/video/backlight/led_bl.c
+++ b/drivers/video/backlight/led_bl.c
@@ -226,8 +226,11 @@ static void led_bl_remove(struct platform_device *pdev)
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
-- 
2.39.5



