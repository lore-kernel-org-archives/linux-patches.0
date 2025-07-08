Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485D72E54BC;
	Tue,  8 Jul 2025 16:24:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751991842; cv=none; b=EQI18cd6/hBUVLt8E5SC+LDzMwGQQegepbbic6hlr6s9xIL682T9PPYkLv2R7glVF8ZK+Y8xrErNi/onfRgwEu6anoanW7/Lb5Vw2PeQQk8+GFkHzWXJPqGvATb7LpdUkZv2ANuSq/FRlwto2L8ealgmfg97+1VArZsszl5lgio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751991842; c=relaxed/simple;
	bh=47g32ufFJ+vorC7g/pH7DVcYuB4cP1Xj00KyJRzBYVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=odYSYIzf9JFTm3x3cc3gtvqWnL0kM8FTQNOQnzUiDtWNEWbehWWDt57FM4OPH+ubGOWkz4QY8HcF0BFysoNe0DZ5C/yXROZCCsri6JI33ESgAFsB6lyW0dpns+fFKv+SNcZRpesAV8y82X8LUVmXuOt9tNlABrzNX8PGBCFd6Wo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z7MIMIxo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z7MIMIxo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547EFC4CEF0;
	Tue,  8 Jul 2025 16:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751991841;
	bh=47g32ufFJ+vorC7g/pH7DVcYuB4cP1Xj00KyJRzBYVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z7MIMIxoBdZSGzhPYVVe2fUY3IrAFgf9ejeK9O5ZwYnuk5Z3gfTeRhccffhPll8yy
	 l9NdGnvqT7lLZ12ygkj/UKlCQasCe4VjbdkiwAzyXS/E+NT/N69MfTl/ZI0NVzsFOm
	 GPhgXFzE++WwzVE5OjJdd84comM+rWfW5hH9oa8g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Elena Popa <elena.popa@nxp.com>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>
Subject: [PATCH 6.12 002/232] rtc: pcf2127: fix SPI command byte for PCF2131
Date: Tue,  8 Jul 2025 18:19:58 +0200
Message-ID: <20250708162241.495990940@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Elena Popa <elena.popa@nxp.com>

commit fa78e9b606a472495ef5b6b3d8b45c37f7727f9d upstream.

PCF2131 was not responding to read/write operations using SPI. PCF2131
has a different command byte definition, compared to PCF2127/29. Added
the new command byte definition when PCF2131 is detected.

Fixes: afc505bf9039 ("rtc: pcf2127: add support for PCF2131 RTC")
Cc: stable@vger.kernel.org
Signed-off-by: Elena Popa <elena.popa@nxp.com>
Acked-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20250530104001.957977-1-elena.popa@nxp.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/rtc/rtc-pcf2127.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/rtc/rtc-pcf2127.c
+++ b/drivers/rtc/rtc-pcf2127.c
@@ -1383,6 +1383,11 @@ static int pcf2127_i2c_probe(struct i2c_
 		variant = &pcf21xx_cfg[type];
 	}
 
+	if (variant->type == PCF2131) {
+		config.read_flag_mask = 0x0;
+		config.write_flag_mask = 0x0;
+	}
+
 	config.max_register = variant->max_register,
 
 	regmap = devm_regmap_init(&client->dev, &pcf2127_i2c_regmap,


