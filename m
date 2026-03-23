Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B2DC03B895B;
	Mon, 23 Mar 2026 15:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278348; cv=none; b=Ze3vRLizr9QEp5LsMu6Z4flDFJOpBLYtDTqn1PN7EoWprI1e/1h5hru4tplv5LxPhAWJSZCa25RaYYE0OOhax6x5nlh4M9ZFEXDPn00ANUp9PelUXaU75pwHEubJWgfRninV6E89FU8aceg+oLcPWMi/hMtVrwsfk1xdXVKZxEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278348; c=relaxed/simple;
	bh=BWmuUMJWwjNP3+rdYwKaNOn5JnKdD0x6Nzpn4rB5y6k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lVnP+qEuzOa4QwUtIjyxCEBupOeYXu466Ltm+diuIRGW2rxFBoNwjBvz7rMbbubb1z1ONaQ30UaU1YzGKk6Fus98aCffZYay2AYBpQl7Y/T7H4YzCQlf94CGE1D/HCZa7zkEwjiri7RdhAR5pM1GmBnhFudu9BXOF6pxW/IVwvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LWFAfSx9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LWFAfSx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4022EC2BC9E;
	Mon, 23 Mar 2026 15:05:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278348;
	bh=BWmuUMJWwjNP3+rdYwKaNOn5JnKdD0x6Nzpn4rB5y6k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWFAfSx9pYKgceMc1lxmlbxgphOa0ncMTQFlvLYiZ/TyG7iY47t1eci32Lj2sA0Cb
	 3Otd7qaQfm7zOUl/rCaXFGL0KIwyx9wDyM7Y9/RHh0rQfa3ez2EbwK1qBWWDIOI/55
	 4kck0dV9bHLNciXBu929NXQRyKwhj3q5WFbJOCwk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wenyuan Li <2063309626@qq.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 236/567] can: hi311x: hi3110_open(): add check for hi3110_power_enable() return value
Date: Mon, 23 Mar 2026 14:42:36 +0100
Message-ID: <20260323134539.675092372@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Wenyuan Li <2063309626@qq.com>

[ Upstream commit 47bba09b14fa21712398febf36cb14fd4fc3bded ]

In hi3110_open(), the return value of hi3110_power_enable() is not checked.
If power enable fails, the device may not function correctly, while the
driver still returns success.

Add a check for the return value and propagate the error accordingly.

Signed-off-by: Wenyuan Li <2063309626@qq.com>
Link: https://patch.msgid.link/tencent_B5E2E7528BB28AA8A2A56E16C49BD58B8B07@qq.com
Fixes: 57e83fb9b746 ("can: hi311x: Add Holt HI-311x CAN driver")
[mkl: adjust subject, commit message and jump label]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/hi311x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/hi311x.c b/drivers/net/can/spi/hi311x.c
index 1acd4fc7adc8b..2038b864832c9 100644
--- a/drivers/net/can/spi/hi311x.c
+++ b/drivers/net/can/spi/hi311x.c
@@ -756,7 +756,9 @@ static int hi3110_open(struct net_device *net)
 		return ret;
 
 	mutex_lock(&priv->hi3110_lock);
-	hi3110_power_enable(priv->transceiver, 1);
+	ret = hi3110_power_enable(priv->transceiver, 1);
+	if (ret)
+		goto out_close_candev;
 
 	priv->force_quit = 0;
 	priv->tx_skb = NULL;
@@ -791,6 +793,7 @@ static int hi3110_open(struct net_device *net)
 	hi3110_hw_sleep(spi);
  out_close:
 	hi3110_power_enable(priv->transceiver, 0);
+ out_close_candev:
 	close_candev(net);
 	mutex_unlock(&priv->hi3110_lock);
 	return ret;
-- 
2.51.0



