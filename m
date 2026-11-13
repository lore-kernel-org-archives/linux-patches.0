Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591140;
	b=buy3yVbZEpMz3XdMYjliczHChGsdINcpC5yKuri3Qmc1qzlkZW2JuFOZ9RgVcm2iDwBJ
	 eC+L95oX/l2fpUc2AWToodOBXsNLUd/d0nLEXH8h3iAsyU4XpO/92M/pY4yJFJ0GxtB0C
	 bFOF1g2zd/0iGfBDdt/tIxkK1q0+mZaPOxk6D3rlzNLpNWjUWMgLq4oRlsrwp7dniSxwU
	 jxFISptH9Qy4ZO4KWSgq6eNPoUVWdgwoJ9LndzaEAgoF+FmeBrCB7zn+FWFWNP3dD3sT+
	 Wdinfp3yItQypj2M3N4TtGQLIInkRIZw1OOdAzuKWqtOnHzhVskr5Hevv6115uvGgiA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591140;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=2fcfES9anQmSFehfjhmGksJ90ROrbq/ZUhIIla3WNgk=;
	b=gX/YseKIv6/vNyJ0QlIt/h7ZnmDjFdrx1FPipx4E+ZiexgZY3YDZd1RE9sQksU9A16iu
	 uSP00yaXBKglZ/09cPTEeByyghf3ikdxzyFPjag1MUAkgsJGQbZZ2rP+cjh7YLmjaWjMQ
	 RqGBSUk18HiY1NceKnrQ0ceBQ2CUl7wCjAjVfmNXDn2ee1aLatwLQ3wYKhe3VPoleIQ9Z
	 YYJzE9B4Oz/JizHCKHIL0/VMuuo5ye+5+Y5N5300vXiPJhnTLQ7KPcHuOVOhZELqMt3YE
	 xU5o6tXmLwhhGKaA+JtipSDDFExFip+/1ifazE2swE87x/QQhyBLf8ECm2hEkycCbTw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UwqMFZJJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3524A606BD1D;
	Fri, 13 Nov 2026 17:32:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UwqMFZJJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6D531F000C4;
	Fri, 13 Nov 2026 17:32:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591140;
	bh=2fcfES9anQmSFehfjhmGksJ90ROrbq/ZUhIIla3WNgk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UwqMFZJJGf0ZppLWgntVR0qPPebPmHglq6SgBvDJevUlir82sdfkBzmYWjcqPfqwj
	 bSHfLjmjJOety2la6Q4fGgqylPCRi5tuO5npik+hAWrIx7TocgTjQCJUGaJc+JG1ZJ
	 aNpVLg7b4y+B4SnoDUqTzvXeG4d67D4YhhFzNXjI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Javier Carrasco <javier.carrasco.cruz@gmail.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 249/670] hwmon: chipcap2: defer probe when IRQs are unavailable
Date: Fri, 13 Nov 2026 10:46:53 -0500
Message-ID: <20261113153820.276797265@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Javier Carrasco <javier.carrasco.cruz@gmail.com>

[ Upstream commit b5a1412618f93b594f924cf4f3b4bb6b5dc49d41 ]

This device can work with or without interrupts, but if they
are provided and still not available, but if -EPROBE_DEFER is read,
its value must be propagated to enable probe retries.

Fixes: 3af350929e75 ("hwmon: Add support for Amphenol ChipCap 2")
Cc: stable@vger.kernel.org
Signed-off-by: Javier Carrasco <javier.carrasco.cruz@gmail.com>
Link: https://patch.msgid.link/20261014-chipcap2_locks-v3-4-27ebfc2c5b9e@gmail.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/chipcap2.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/hwmon/chipcap2.c b/drivers/hwmon/chipcap2.c
index ede664d22b8a6..b82b702a0f6bd 100644
--- a/drivers/hwmon/chipcap2.c
+++ b/drivers/hwmon/chipcap2.c
@@ -651,6 +651,8 @@ static int cc2_request_ready_irq(struct cc2_data *data, struct device *dev)
 	int ret = 0;
 
 	data->irq_ready = fwnode_irq_get_byname(dev_fwnode(dev), "ready");
+	if (data->irq_ready == -EPROBE_DEFER)
+		return data->irq_ready;
 	if (data->irq_ready > 0) {
 		init_completion(&data->complete);
 		ret = devm_request_threaded_irq(dev, data->irq_ready, NULL,
@@ -668,6 +670,8 @@ static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
 	int ret = 0;
 
 	data->irq_low = fwnode_irq_get_byname(dev_fwnode(dev), "low");
+	if (data->irq_low == -EPROBE_DEFER)
+		return data->irq_low;
 	if (data->irq_low > 0) {
 		ret = devm_request_threaded_irq(dev, data->irq_low, NULL,
 						cc2_low_interrupt,
@@ -681,6 +685,8 @@ static int cc2_request_alarm_irqs(struct cc2_data *data, struct device *dev)
 	}
 
 	data->irq_high = fwnode_irq_get_byname(dev_fwnode(dev), "high");
+	if (data->irq_high == -EPROBE_DEFER)
+		return data->irq_high;
 	if (data->irq_high > 0) {
 		ret = devm_request_threaded_irq(dev, data->irq_high, NULL,
 						cc2_high_interrupt,
-- 
2.53.0



