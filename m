Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A77B54BD4;
	Tue, 27 Feb 2024 13:48:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709041709; cv=none; b=HU0+4K3QCjz59YLRvYQkMk60vmDcWsbPc1cW60x3X65ZJeVvdrZzDcIGZSdUszNQ/bsVWi2lmFGV/O66y9s6WuD6ycA6VJ0R+VkQSei/oGSQKXhSJmRXI814oBy9dYQEyhFBdK1s1MhgZOXG8zWiWhJhXzZ2N4+0L1jZGseAYBY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709041709; c=relaxed/simple;
	bh=ss/RnbpKonXw8zjelZqI2OdYCBVswftAm1sHEsM6S80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QzmwRp8vbmL3evH0hw1NLVWQNuVxJd/0+HTdIODvHrIlILMUTnJqXuok6iU1+Wf7uwLbdQYIkjFuxEIyMf7Spb2s92EenOA5szPv0G1yhAL1fk+EmETtdFr1rDyHMco1x2PgAGBJpKBGxOPT5OPRUebBzmqyRX6c2p9B5vU3RJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9Xv/YD+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9Xv/YD+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8AEC433F1;
	Tue, 27 Feb 2024 13:48:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709041709;
	bh=ss/RnbpKonXw8zjelZqI2OdYCBVswftAm1sHEsM6S80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9Xv/YD+dAy5m0t2WxdBdXfuYza0mRNCXROzQ2rNc2lMbEnlMUQ45LgMsWce8FDuy
	 AqlvX+7Au/o0JOreXWEVxdkQQCdPExRbwmcWyRBNLvScXbcICzNtwP60AkvNp9UtlW
	 CKsj/appZA1pcNd6Akbe4wSQ3xm2UuIVP3Nf+v5Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 043/299] HID: nvidia-shield: Add missing null pointer checks to LED initialization
Date: Tue, 27 Feb 2024 14:22:34 +0100
Message-ID: <20240227131627.371806752@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131625.847743063@linuxfoundation.org>
References: <20240227131625.847743063@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kunwu Chan <chentao@kylinos.cn>

[ Upstream commit b6eda11c44dc89a681e1c105f0f4660e69b1e183 ]

devm_kasprintf() returns a pointer to dynamically allocated memory
which can be NULL upon failure. Ensure the allocation was successful
by checking the pointer validity.

[jkosina@suse.com: tweak changelog a bit]
Signed-off-by: Kunwu Chan <chentao@kylinos.cn>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nvidia-shield.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/hid/hid-nvidia-shield.c b/drivers/hid/hid-nvidia-shield.c
index c463e54decbce..edd0b0f1193bd 100644
--- a/drivers/hid/hid-nvidia-shield.c
+++ b/drivers/hid/hid-nvidia-shield.c
@@ -800,6 +800,8 @@ static inline int thunderstrike_led_create(struct thunderstrike *ts)
 
 	led->name = devm_kasprintf(&ts->base.hdev->dev, GFP_KERNEL,
 				   "thunderstrike%d:blue:led", ts->id);
+	if (!led->name)
+		return -ENOMEM;
 	led->max_brightness = 1;
 	led->flags = LED_CORE_SUSPENDRESUME | LED_RETAIN_AT_SHUTDOWN;
 	led->brightness_get = &thunderstrike_led_get_brightness;
@@ -831,6 +833,8 @@ static inline int thunderstrike_psy_create(struct shield_device *shield_dev)
 	shield_dev->battery_dev.desc.name =
 		devm_kasprintf(&ts->base.hdev->dev, GFP_KERNEL,
 			       "thunderstrike_%d", ts->id);
+	if (!shield_dev->battery_dev.desc.name)
+		return -ENOMEM;
 
 	shield_dev->battery_dev.psy = power_supply_register(
 		&hdev->dev, &shield_dev->battery_dev.desc, &psy_cfg);
-- 
2.43.0



