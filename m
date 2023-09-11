Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E05B311706
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:55:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DC6C433C8;
	Mon, 11 Sep 2023 14:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694444123;
	bh=ndG81x3WV1GDT+U9P2YbTz6+BuHWYRUbdBJ0v7kSi1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z1hEREn7HLFVUXPWhivvfsR/UmsyRI3OqfJJ96Mu5VOH4qX+2dImmw2GulmmO+2Tc
	 HnF7N89nwEtwUVSM9iWTA56FOVGYP0WL/cQGkLkjGYLccrQ3vALa1cB7A7UCgZJlKh
	 o5beW1drtzQ1QJy4i3MHJGJ7JbN9B6H+q4H7UbkY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 619/737] leds: Fix BUG_ON check for LED_COLOR_ID_MULTI that is always false
Date: Mon, 11 Sep 2023 15:47:58 +0200
Message-ID: <20230911134707.821417305@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit c3f853184bed04105682383c2971798c572226b5 ]

At the time we call
    BUG_ON(props.color == LED_COLOR_ID_MULTI);
the props variable is still initialized to zero.

Call the BUG_ON only after we parse fwnode into props.

Fixes: 77dce3a22e89 ("leds: disallow /sys/class/leds/*:multi:* for now")
Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://lore.kernel.org/r/20230801151623.30387-1-kabel@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/led-core.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/leds/led-core.c b/drivers/leds/led-core.c
index 4a97cb7457888..aad8bc44459fe 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -419,15 +419,15 @@ int led_compose_name(struct device *dev, struct led_init_data *init_data,
 	struct fwnode_handle *fwnode = init_data->fwnode;
 	const char *devicename = init_data->devicename;
 
-	/* We want to label LEDs that can produce full range of colors
-	 * as RGB, not multicolor */
-	BUG_ON(props.color == LED_COLOR_ID_MULTI);
-
 	if (!led_classdev_name)
 		return -EINVAL;
 
 	led_parse_fwnode_props(dev, fwnode, &props);
 
+	/* We want to label LEDs that can produce full range of colors
+	 * as RGB, not multicolor */
+	BUG_ON(props.color == LED_COLOR_ID_MULTI);
+
 	if (props.label) {
 		/*
 		 * If init_data.devicename is NULL, then it indicates that
-- 
2.40.1



