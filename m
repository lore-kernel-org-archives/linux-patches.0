Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E96219464
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:13:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ac3Q8xcy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BEDFBC433C8;
	Mon,  9 Oct 2023 13:13:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696857208;
	bh=+DQe5Sev3uNhv6tniG77DjkEizPZR3TI7g9Oa1fYjYo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ac3Q8xcy4E08boWGeLvMXVLY5VDS5qnJK7M+12GCeDAv/X6dhpjde16Qh9VLuYXss
	 4z5nKYQPunj7HDXLJNL4AkyNfnUa6dFnswoj1x32lSA62qV8WhH1LVZ/5n7t/6C4Li
	 a+DuC9U8x/mhfarDmUMxvLocplODFyYIwNPNQ6W4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Jiri Kosina <jkosina@suse.cz>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 133/163] HID: nvidia-shield: Fix a missing led_classdev_unregister() in the probe error handling path
Date: Mon,  9 Oct 2023 15:01:37 +0200
Message-ID: <20231009130127.720531887@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130124.021290599@linuxfoundation.org>
References: <20231009130124.021290599@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit b07b6b27a50e3a740c9aa6260ee4bb3ab29515ab ]

The commit in Fixes updated the error handling path of
thunderstrike_create() and the remove function but not the error handling
path of shield_probe(), should an error occur after a successful
thunderstrike_create() call.

Add the missing call. Make sure it is safe to call in the probe error
handling path by preventing the led_classdev from attempting to set the LED
brightness to the off state on unregister.

Fixes: f88af60e74a5 ("HID: nvidia-shield: Support LED functionality for Thunderstrike")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Reviewed-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Signed-off-by: Jiri Kosina <jkosina@suse.cz>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hid/hid-nvidia-shield.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/hid/hid-nvidia-shield.c b/drivers/hid/hid-nvidia-shield.c
index 9c44974135079..1ce9e42f57c71 100644
--- a/drivers/hid/hid-nvidia-shield.c
+++ b/drivers/hid/hid-nvidia-shield.c
@@ -482,7 +482,7 @@ static inline int thunderstrike_led_create(struct thunderstrike *ts)
 
 	led->name = "thunderstrike:blue:led";
 	led->max_brightness = 1;
-	led->flags = LED_CORE_SUSPENDRESUME;
+	led->flags = LED_CORE_SUSPENDRESUME | LED_RETAIN_AT_SHUTDOWN;
 	led->brightness_get = &thunderstrike_led_get_brightness;
 	led->brightness_set = &thunderstrike_led_set_brightness;
 
@@ -694,6 +694,7 @@ static int shield_probe(struct hid_device *hdev, const struct hid_device_id *id)
 err_haptics:
 	if (ts->haptics_dev)
 		input_unregister_device(ts->haptics_dev);
+	led_classdev_unregister(&ts->led_dev);
 	return ret;
 }
 
-- 
2.40.1



