Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F9C913AF4
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:48:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCB5CC433D2;
	Mon,  8 May 2023 10:48:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542908;
	bh=fR447qCUHqd1XIcwE65uEDSnE7I+CdeCFZ5MJpYYjOI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cPq9+a/KhPlR7ze6Ag4Y7yh8FhJckn68hfvMG88c3mrCFIiZfQHohf/OgoQKyB5CS
	 ANZe/fXCw0ahvBuyjMYIHG5PSSg5oCe85YUv20zrpAxxAmz8DXXYoxdkdJorIQap6R
	 GK2M62ALvcbDbcBNMKvkUfxF0jYKTXzoh3cizsAs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"H. Nikolaus Schaller" <hns@goldelico.com>,
	Pavel Machek <pavel@ucw.cz>,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 586/663] leds: tca6507: Fix error handling of using fwnode_property_read_string
Date: Mon,  8 May 2023 11:46:52 +0200
Message-Id: <20230508094448.399723195@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: H. Nikolaus Schaller <hns@goldelico.com>

[ Upstream commit c1087c29e96a48e9080377e168d35dcb52fb068b ]

Commit 96f524105b9c ("leds: tca6507: use fwnode API instead of OF")

changed to fwnode API but did not take into account that a missing property
"linux,default-trigger" now seems to return an error and as a side effect
sets value to -1. This seems to be different from of_get_property() which
always returned NULL in any case of error.

Neglecting this side-effect leads to

[   11.201965] Unable to handle kernel paging request at virtual address ffffffff when read

in the strcmp() of led_trigger_set_default() if there is no led-trigger
defined in the DTS.

I don't know if this was recently introduced somewhere in the fwnode lib
or if the effect was missed in initial testing. Anyways it seems to be a
bug to ignore the error return value of an optional value here in the
driver.

Fixes: 96f524105b9c ("leds: tca6507: use fwnode API instead of OF")
Signed-off-by: H. Nikolaus Schaller <hns@goldelico.com>
Acked-by: Pavel Machek <pavel@ucw.cz>
Reviewed-by: Marek Behún <kabel@kernel.org>
Signed-off-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/cbae7617db83113de726fcc423a805ebaa1bfca6.1680433978.git.hns@goldelico.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-tca6507.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/leds/leds-tca6507.c b/drivers/leds/leds-tca6507.c
index 161bef65c6b7b..62a968613cc37 100644
--- a/drivers/leds/leds-tca6507.c
+++ b/drivers/leds/leds-tca6507.c
@@ -691,8 +691,9 @@ tca6507_led_dt_init(struct device *dev)
 		if (fwnode_property_read_string(child, "label", &led.name))
 			led.name = fwnode_get_name(child);
 
-		fwnode_property_read_string(child, "linux,default-trigger",
-					    &led.default_trigger);
+		if (fwnode_property_read_string(child, "linux,default-trigger",
+						&led.default_trigger))
+			led.default_trigger = NULL;
 
 		led.flags = 0;
 		if (fwnode_property_match_string(child, "compatible",
-- 
2.39.2



