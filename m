Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3F7F7AE47;
	Mon,  4 Mar 2024 21:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588727; cv=none; b=X3KZ0ShXzir28Lz1IFhXYp6pWnUnhObWZE8nyzclP8jcEBNIIQXqNXuWBYZ/vFHyPU6ptmCCJ0zicAqSjcqzfO1Vn1CeqovOWmq1fzTp4gmaILz4PPhvSc+q1oXKwfDjvOFDM/NonREcOVi8tQTFXepTj2NeQrERvu+2nc9WaFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588727; c=relaxed/simple;
	bh=pAzwTSktb4woCaUnmOb3KjpPz8pmpUR6XwBjJuSnZpQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qs1P6iNNLc2hVwjES3ndxV2U3w/2+4//Y6Wr0P1ksrB/E85MdMz/FRnKGAe8GR25it/Kps1uFdmR9SA+1dkUAUCgdTmuc0kNeCpxGjzBG3iXATb47DLA654uJ4+Ct75hnWRykX6xZZhrH2CiOX4ycGWFD0mTIp4qwW5ueTUR7/c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rh+OTShd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rh+OTShd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4614EC433F1;
	Mon,  4 Mar 2024 21:45:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588727;
	bh=pAzwTSktb4woCaUnmOb3KjpPz8pmpUR6XwBjJuSnZpQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rh+OTShdrtZ4V/L9NUaLMYoDFld7KbfsOJ/inyvzjvsrQqjU/JFkm0lIuEqaMIreh
	 0+mCchx42NvSJftTf+rwLs6agapnw1QlHho8ai2yj4UsbOwCB3DI3TRv8Y2ymWrOg1
	 +wP1joD/1FJ0exmky/iWusfYSqylvsL81iYC/eEo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 039/215] net: lan78xx: fix "softirq work is pending" error
Date: Mon,  4 Mar 2024 21:21:42 +0000
Message-ID: <20240304211558.250980123@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211556.993132804@linuxfoundation.org>
References: <20240304211556.993132804@linuxfoundation.org>
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

From: Oleksij Rempel <o.rempel@pengutronix.de>

[ Upstream commit e3d5d70cb483df8296dd44e9ae3b6355ef86494c ]

Disable BH around the call to napi_schedule() to avoid following
error:
NOHZ tick-stop error: local softirq work is pending, handler #08!!!

Fixes: ec4c7e12396b ("lan78xx: Introduce NAPI polling support")
Signed-off-by: Oleksij Rempel <o.rempel@pengutronix.de>
Link: https://lore.kernel.org/r/20240226110820.2113584-1-o.rempel@pengutronix.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/usb/lan78xx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/usb/lan78xx.c b/drivers/net/usb/lan78xx.c
index 7b9d480e44fe4..4fd4563811299 100644
--- a/drivers/net/usb/lan78xx.c
+++ b/drivers/net/usb/lan78xx.c
@@ -1501,7 +1501,9 @@ static int lan78xx_link_reset(struct lan78xx_net *dev)
 
 		lan78xx_rx_urb_submit_all(dev);
 
+		local_bh_disable();
 		napi_schedule(&dev->napi);
+		local_bh_enable();
 	}
 
 	return 0;
-- 
2.43.0



