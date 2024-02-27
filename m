Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D1B13B798;
	Tue, 27 Feb 2024 13:30:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709040606; cv=none; b=oXL5BbSWUiH2qMCgHFnTUFwQsZpsG67ebc6b8s/O4J09Dwp7hCBnpXC/hraF4iXPHi+vou7tIu9XfbRAySCBvSzUYXuiWnmlUw/b9YOXasxl2MtyibAkbTLh1jFFKrMjBHI92msVPsYL3WPC28exHxFoHqly3JEVosV13BZ1Sxs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709040606; c=relaxed/simple;
	bh=TNPR1fvDQ86pEWofGy2jzAiontViDap+lYUfLTtzeNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TZM2/S7s6eBntlF4zAsexXP8/+0j9F3y6StadLWcInjSzU7to5WkY7uyZ7HFvV8piK+IfcDqXy0/7NGC6aEuI88BZn7gNB760PpQZapBnKMF89ZwiakkqGJVDcNbkX7BBbPpWjbn8R83gF1H4KYGmxg8hj8t1zqTgl11b4AoHJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CX2CcmSA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CX2CcmSA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 844DEC433C7;
	Tue, 27 Feb 2024 13:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709040605;
	bh=TNPR1fvDQ86pEWofGy2jzAiontViDap+lYUfLTtzeNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CX2CcmSAgF7KcB95bi0qpMY1nrWDCKeQQJktUk39K4LNazyLfB5L+3k7qnyoRydxB
	 zmHj5ELoT/wOTmUrqay7ceOWAoWUP2lAILa/kElkKjFoOjQAWVvUMmAwgJXT2lFA7Z
	 tv4ZnR5KejBv75+lw77PQE4eGyevFJK5jhSoWfC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunwu Chan <chentao@kylinos.cn>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jiri Kosina <jkosina@suse.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 044/334] HID: nvidia-shield: Add missing null pointer checks to LED initialization
Date: Tue, 27 Feb 2024 14:18:22 +0100
Message-ID: <20240227131632.007470275@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131630.636392135@linuxfoundation.org>
References: <20240227131630.636392135@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
index 82d0a77359c46..58b15750dbb0a 100644
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



