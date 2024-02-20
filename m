Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03AFC151CDC;
	Tue, 20 Feb 2024 21:38:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465117; cv=none; b=fD5YTIKNZ6qQLZX2F1yGq+2n0L2+AYhfigMePpsAFF4EMvyUR8eCkDip8JUFN5SPXg/+X9tAp9+9qx8kHZBQQQ0TszCZPJjuEQpQIiKwbaJu0hMC4Dd/WT+0lnWtw9tMyMaDMpJ7g1nCMsyoLeliJDs0zE56LPibdZUTmzBw98o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465117; c=relaxed/simple;
	bh=wwyg8qD+K7IfnslEZZuDR4lAR2Fw0/0B6pp5rZoz3UE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H6kBoEE/ByUr2jwmSTh/JAFFozp5yo+Uo/TxZnwszoHV2wecPnH+vwpTmukb8XK42cP+IY4YHpNgOqACXutHvyYGqlygnZTKW+WEHP2EABKzDdnW4OprsyAVNXReRoyeYH1ZFLE4aK1NRgKSqf0QD8D4LfCCltyr0BPe0+njRZ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lT0WgZ5x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lT0WgZ5x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5EB89C433F1;
	Tue, 20 Feb 2024 21:38:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465116;
	bh=wwyg8qD+K7IfnslEZZuDR4lAR2Fw0/0B6pp5rZoz3UE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lT0WgZ5xkuLJQy0KLqnhteWKZtPCcUnD55OOaVnLNb/ByiDasNJQWwf+HaeqUlGCy
	 9tx2Ij/qKD9gfTu/HebraBJzaYA7PDw2NO5bfinOMh7ABFUoBei+WvmVU/cc4x+VgH
	 0LR/Tg0wHztsnyLHJ6i2R3CCEE7X5XNEMMD5cS9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.7 224/309] serial: max310x: prevent infinite while() loop in port startup
Date: Tue, 20 Feb 2024 21:56:23 +0100
Message-ID: <20240220205640.166971715@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

commit b35f8dbbce818b02c730dc85133dc7754266e084 upstream.

If there is a problem after resetting a port, the do/while() loop that
checks the default value of DIVLSB register may run forever and spam the
I2C bus.

Add a delay before each read of DIVLSB, and a maximum number of tries to
prevent that situation from happening.

Also fail probe if port reset is unsuccessful.

Fixes: 10d8b34a4217 ("serial: max310x: Driver rework")
Cc: stable@vger.kernel.org
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://lore.kernel.org/r/20240116213001.3691629-5-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/max310x.c |   20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

--- a/drivers/tty/serial/max310x.c
+++ b/drivers/tty/serial/max310x.c
@@ -237,6 +237,10 @@
 #define MAX310x_REV_MASK		(0xf8)
 #define MAX310X_WRITE_BIT		0x80
 
+/* Port startup definitions */
+#define MAX310X_PORT_STARTUP_WAIT_RETRIES	20 /* Number of retries */
+#define MAX310X_PORT_STARTUP_WAIT_DELAY_MS	10 /* Delay between retries */
+
 /* Crystal-related definitions */
 #define MAX310X_XTAL_WAIT_RETRIES	20 /* Number of retries */
 #define MAX310X_XTAL_WAIT_DELAY_MS	10 /* Delay between retries */
@@ -1346,6 +1350,9 @@ static int max310x_probe(struct device *
 		goto out_clk;
 
 	for (i = 0; i < devtype->nr; i++) {
+		bool started = false;
+		unsigned int try = 0, val = 0;
+
 		/* Reset port */
 		regmap_write(regmaps[i], MAX310X_MODE2_REG,
 			     MAX310X_MODE2_RST_BIT);
@@ -1354,8 +1361,17 @@ static int max310x_probe(struct device *
 
 		/* Wait for port startup */
 		do {
-			regmap_read(regmaps[i], MAX310X_BRGDIVLSB_REG, &ret);
-		} while (ret != 0x01);
+			msleep(MAX310X_PORT_STARTUP_WAIT_DELAY_MS);
+			regmap_read(regmaps[i], MAX310X_BRGDIVLSB_REG, &val);
+
+			if (val == 0x01)
+				started = true;
+		} while (!started && (++try < MAX310X_PORT_STARTUP_WAIT_RETRIES));
+
+		if (!started) {
+			ret = dev_err_probe(dev, -EAGAIN, "port reset failed\n");
+			goto out_uart;
+		}
 
 		regmap_write(regmaps[i], MAX310X_MODE1_REG, devtype->mode1);
 	}


