Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F5BE14F9C8;
	Tue, 20 Feb 2024 21:04:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463063; cv=none; b=mTwnmT5yMOi+x9VNtqMpgo4Da0kFDG5aNEt3apS5KGYJhJrs6dzyq+JVxbuCiDpl4b2/TAsHPJg+NzI4V71PaHAU4McH8yglicw0Mq5CUCf2fbR4JaxD9/bEge+rHbWnGXWErGqAz7+zeWRiGGe9H3+Hr4BRCVhheeLcze6Q0Cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463063; c=relaxed/simple;
	bh=A3a4eKZCnxR9/r8KgskzgCeRPjs0awCHZSBdNesz+oI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CxdLksjBYT72gA5/1ur44Y7xwjidvsH126T0EuJwQM+AfGKFcUEUT479tv0S6oOjjwuwH8yHef85TWJApMK51wQBDnCbTpnaikNmkECfIzJnSKee5hFwITXzXRQt4Gd1oygVCRAlHty3tDtn++nmctu9TLVEs2DAgCzo801wraA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y3uXwaPQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y3uXwaPQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81C0BC433F1;
	Tue, 20 Feb 2024 21:04:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463063;
	bh=A3a4eKZCnxR9/r8KgskzgCeRPjs0awCHZSBdNesz+oI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y3uXwaPQsO2BQ5NNAjpFK4qmEP28n0Tn+fZ2qeJOjYpvZWb7x6a2PGMveFP+diWRp
	 d0unmhTbpHva1fAaMTxJcImOAg2D9kvO6xCaKEdzuscNoSzL1BMcDKF/nGeAeuzGSa
	 JXCuV0pTIX5vby8lZ0BznpV5eWtWWU7wCg6tfckQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.1 123/197] serial: max310x: prevent infinite while() loop in port startup
Date: Tue, 20 Feb 2024 21:51:22 +0100
Message-ID: <20240220204844.754984384@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220204841.073267068@linuxfoundation.org>
References: <20240220204841.073267068@linuxfoundation.org>
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
@@ -1349,6 +1353,9 @@ static int max310x_probe(struct device *
 		goto out_clk;
 
 	for (i = 0; i < devtype->nr; i++) {
+		bool started = false;
+		unsigned int try = 0, val = 0;
+
 		/* Reset port */
 		regmap_write(regmaps[i], MAX310X_MODE2_REG,
 			     MAX310X_MODE2_RST_BIT);
@@ -1357,8 +1364,17 @@ static int max310x_probe(struct device *
 
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


