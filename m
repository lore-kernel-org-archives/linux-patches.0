Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795058080;
	b=eNDLonR8ZFd9416EsPuz2rQCM6u+HzyhuQhh0/fqvC48Jnl7fEhTw4uub7QxyPF5Zl05
	 RkcKFIR24rSa0Pegi0WWNPCMugLx/kVPaIZP/gqEIZaBjiOmoDqAfHYLTY34iHhZrgteR
	 9YfSqqnIBClewfuI0Bujg2EJQ1wYOoZpgAEOkWQqUAJptqolqfak2vukhnlyV5heWwhIl
	 61Wtk0nPhRQ21WmRJ2en+7REOZ95+xqgbEJGrkutqyhwlul46V6QyLqfRUceq9msiSRzG
	 Tr1vcTl3VV9Kpqvs07favfNl1wmvEYR6DzA8vtQs1+PB/MLgK2TyMMmruqEtvdqVkYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795058080;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=il+yY9zOlptDwctXMkgP3JHladeDwQ2s04kB+YRkWVM=;
	b=fdasP0V8TdM6kLL8oBz9HFWKpeBQJ9bXAvP6KpK2vHogt4uFNmNuUP1D0YrbViZY67B3
	 T24W2ilUH1ENFeOHhZ/abJ7JUXp8T9mYX1BcaQK8kw/vRrS6Vv6unhAlIntrD5w+Gb6tU
	 ohJ4ZJ5e2Y+ZqzNVXoaIydzalOkyM2SwoHqm9HpXMGJRmtIs+QxoMN3158116R4rfGFFY
	 sXLHBn89RPdk1a3WMoc0qqiME+b9//Oo55/H469eRtNJRsmdUJIp2aXeVeu9TeM4zF8/S
	 fom4QH310b8oAF1UIwh1ivvZVhmJdROdiBTin7NL3SQuIsmnROMdv5Jch4gARJsX9MQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0VN+vk+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F68606A325;
	Thu, 19 Nov 2026 03:14:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=v0VN+vk+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD08E1F000C5;
	Thu, 19 Nov 2026 03:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795058080;
	bh=il+yY9zOlptDwctXMkgP3JHladeDwQ2s04kB+YRkWVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=v0VN+vk+blZXOc333ee2mwNsys1UaBnGsJKdtY52asEEbEMVYUToLLP2+/1VDcq8y
	 yDs/lpcfCh3UvJFDrbZIloTWNG/9AXrF+Z4vWA9ACnECQ77nj251hl67Q1/N17CeVh
	 J81MQpOOjzMVhNSYC54hX48QrN+B3iLnrZczGURk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 0351/1848] media: ir-hix5hd2: Ensure rdev is setup before interrupts are enabled
Date: Wed, 18 Nov 2026 15:39:49 +0100
Message-ID: <20261118145927.411832477@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Young <sean@mess.org>

[ Upstream commit f7509d2567cf92eeccc31c363a2e2ae43188930c ]

Once the interrupt handler is enabled, priv->rdev can be used. Ensure
it is setup correctly so there is no race condition.

Fixes: a84fcdaa9058 ("[media] rc: Introduce hix5hd2 IR transmitter driver")
Signed-off-by: Sean Young <sean@mess.org>
Cc: stable@vger.kernel.org
Reviewed-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/rc/ir-hix5hd2.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/media/rc/ir-hix5hd2.c b/drivers/media/rc/ir-hix5hd2.c
index 0ffc27514fab8..f89dd3cb7ac38 100644
--- a/drivers/media/rc/ir-hix5hd2.c
+++ b/drivers/media/rc/ir-hix5hd2.c
@@ -318,6 +318,9 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 	if (ret < 0)
 		goto clkerr;
 
+	priv->rdev = rdev;
+	priv->dev = dev;
+
 	if (devm_request_irq(dev, priv->irq, hix5hd2_ir_rx_interrupt,
 			     0, pdev->name, priv) < 0) {
 		dev_err(dev, "IRQ %d register failed\n", priv->irq);
@@ -325,8 +328,6 @@ static int hix5hd2_ir_probe(struct platform_device *pdev)
 		goto regerr;
 	}
 
-	priv->rdev = rdev;
-	priv->dev = dev;
 	platform_set_drvdata(pdev, priv);
 
 	return ret;
-- 
2.53.0



