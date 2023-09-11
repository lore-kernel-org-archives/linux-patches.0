Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00FB71170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:21:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75072C433C7;
	Mon, 11 Sep 2023 14:21:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442078;
	bh=TmEdzOoq4uNHhEdzyWalCI1wrKevcBMPhhNU10vy/6Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QErKrIVXYAfle9osQ3s9qWobDrDlfD1BqSTh2OrR3DhmmEzTWwd0sBz0Y+Q1r5ot4
	 LEgGctFqr6O0wHv9HDrzIBZludd+iNzSTnzijfafap5iLPByrmClQt7syokmwKtuD/
	 lKRLlIPs3pyjFPpHzPiiRreku4k9nWl6kum+N9Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 612/739] leds: Fix BUG_ON check for LED_COLOR_ID_MULTI that is always false
Date: Mon, 11 Sep 2023 15:46:51 +0200
Message-ID: <20230911134708.191809254@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.921299741@linuxfoundation.org>
References: <20230911134650.921299741@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index b9b1295833c90..04f9ea675f2ce 100644
--- a/drivers/leds/led-core.c
+++ b/drivers/leds/led-core.c
@@ -474,15 +474,15 @@ int led_compose_name(struct device *dev, struct led_init_data *init_data,
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



