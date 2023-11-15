Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C25E1286B6
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d3Q/iunm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73F54C433C9;
	Wed, 15 Nov 2023 20:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078414;
	bh=q+n5prNmzyNBcYhlMA/pAJeECx/2b/k9xRgwze8bQWU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d3Q/iunm2F+8nDw6dVPRWQiC79sZqS5YNiDNz2rEy8MX5xPjpH1p8vJqb164Dm6sM
	 7MeyaiqxzXNERSo/ntuAlFve8CoW2CNeZR0L2OZ3A0KeMTPZrYRgybIlhGW7pAaNUJ
	 JcSjdvaXoBU+I5fSE9KJW+gF7T3XhQqBFjO61Fds=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 310/379] rtc: pcf85363: fix wrong mask/val parameters in regmap_update_bits call
Date: Wed, 15 Nov 2023 14:26:25 -0500
Message-ID: <20231115192703.488623937@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit 2be36c09b6b07306be33519e1aa70d2e2a2161bb ]

The current implementation passes PIN_IO_INTA_OUT (2) as a mask and
PIN_IO_INTAPM (GENMASK(1, 0)) as a value.
Swap the variables to assign mask and value the right way.

This error was first introduced with the alarm support. For better or
worse it worked as expected because 0x02 was applied as a mask to 0x03,
resulting 0x02 anyway. This will of course not work for any other value.

Fixes: e5aac267a10a ("rtc: pcf85363: add alarm support")
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://lore.kernel.org/r/20231013-topic-pcf85363_regmap_update_bits-v1-1-c454f016f71f@gmail.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/rtc/rtc-pcf85363.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/rtc/rtc-pcf85363.c b/drivers/rtc/rtc-pcf85363.c
index c05b722f00605..0d1517cb3c62d 100644
--- a/drivers/rtc/rtc-pcf85363.c
+++ b/drivers/rtc/rtc-pcf85363.c
@@ -402,7 +402,7 @@ static int pcf85363_probe(struct i2c_client *client)
 	if (client->irq > 0) {
 		regmap_write(pcf85363->regmap, CTRL_FLAGS, 0);
 		regmap_update_bits(pcf85363->regmap, CTRL_PIN_IO,
-				   PIN_IO_INTA_OUT, PIN_IO_INTAPM);
+				   PIN_IO_INTAPM, PIN_IO_INTA_OUT);
 		ret = devm_request_threaded_irq(&client->dev, client->irq,
 						NULL, pcf85363_rtc_handle_irq,
 						IRQF_TRIGGER_LOW | IRQF_ONESHOT,
-- 
2.42.0



