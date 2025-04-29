Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7BDA21ABDB;
	Tue, 29 Apr 2025 17:20:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745947248; cv=none; b=Gjxfpn6hu0/qLeprdBIv3FkQ+fyCFxuCtoOQellDFgzLP87t9QjaqDYeF35qCF2gwYjAoJ8neMNpx9n9aWSGMUwcdliXOW68Pcs9i3cMmwEDvHmoB7bsK1nf+UjUV1N61cRUeyla2sH8OJsKXYdQFp9madcOZRR0WSks+f5xAGE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745947248; c=relaxed/simple;
	bh=f3u+l5icYdG7KnNdskH/WSP7B79pq0jvsUqIwUhAOAk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rdimplg4+zDUMiBYagJZtOh02Ie0tLKjY4QTt/pv6a0Q+Mgk7HeBR4pR3pZfIdlxpuRX4IJL/cIPuVAvkyXa3yJj6k/sT5XthjU4gyYeVg6XIMzL37/PGFN+U4bN5NNB7Hyiavg6VhbK8Gc0m/VwBDPaqsdmM3/r5wf/UWd4A8Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JOAwwFT+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JOAwwFT+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B151C4CEE3;
	Tue, 29 Apr 2025 17:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745947248;
	bh=f3u+l5icYdG7KnNdskH/WSP7B79pq0jvsUqIwUhAOAk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JOAwwFT+e7hYJOrFG89q5EypSJ92x+3f6k5OFNf9v+CbP4n2oAMWSqJGpEyqOoOrE
	 CCABS+vevQ7OO9oZbVNsDdQmcA4S3IoLozpKpUGVWoL9UODndjXtKi4jBgYSOCY/Fc
	 tXibmc0d7b6Zdo1hjc7SjgA9PCAE76AuhG/672rw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Herve Codina <herve.codina@bootlin.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 219/286] backlight: led_bl: Hold led_access lock when calling led_sysfs_disable()
Date: Tue, 29 Apr 2025 18:42:03 +0200
Message-ID: <20250429161116.955469616@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/video/backlight/led_bl.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/video/backlight/led_bl.c
+++ b/drivers/video/backlight/led_bl.c
@@ -226,8 +226,11 @@ static int led_bl_remove(struct platform
 	backlight_device_unregister(bl);
 
 	led_bl_power_off(priv);
-	for (i = 0; i < priv->nb_leds; i++)
+	for (i = 0; i < priv->nb_leds; i++) {
+		mutex_lock(&priv->leds[i]->led_access);
 		led_sysfs_enable(priv->leds[i]);
+		mutex_unlock(&priv->leds[i]->led_access);
+	}
 
 	return 0;
 }


