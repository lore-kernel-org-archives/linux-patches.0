Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A4B0612D7;
	Tue, 20 Feb 2024 21:19:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463972; cv=none; b=MeUXjNrLPldl0lHxXutSI5bg1ekzO5t8tZsS2unAPDr+BXNM69oBHQQbGPZZsJDXBj+Bt50kb8uRkjpIEGNOx6XWShDr1pDDfhVWPk0XP2aL60t8xArqhqIxe/os+nkh5k+wxu6NIVh1/1NeVTiZhtQcTurKuiwPMorbebVp4hE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463972; c=relaxed/simple;
	bh=o2mbXi0n0ycZxEhdeF50zQChVZUGUAzoKM/8sn1Tcuk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T45QOu4S0DzCknmEOCjGlQf3rBA2yuqIOPnMopK41wWVWMsORrxYAqBBAUPOjPHDonXwS3hs8iDTWPIS51rSWJhWTCiwU4hXiniyiQ0NKY7lmNzh58KAzY7T2kgjS18FrtR/XaHqLZeKqgo2QMOHwSGk3E9hqCtZd1wNGuS1t5w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zb+hODGn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zb+hODGn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E057C433C7;
	Tue, 20 Feb 2024 21:19:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463972;
	bh=o2mbXi0n0ycZxEhdeF50zQChVZUGUAzoKM/8sn1Tcuk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zb+hODGnpvVJwW3Lx4XIUy05B2A23LPZZhCZXdxAOSqDT+h5Oq7iifRofAypBu1C6
	 OXJ1AXAThERpB8ReJ8PejFynb79fPfb6NgQ8OzuV1kvcbz+0F8GAG59k+DGX0q+aDK
	 SyO1HOZarZYM5Rn7n1kuAD2jDWxfvjv7wsD87nwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>
Subject: [PATCH 6.6 182/331] serial: max310x: prevent infinite while() loop in port startup
Date: Tue, 20 Feb 2024 21:54:58 +0100
Message-ID: <20240220205643.250469028@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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


