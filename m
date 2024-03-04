Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CC211EA99;
	Mon,  4 Mar 2024 21:37:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709588230; cv=none; b=dUCmSwebI4CTXOwKZeHqIQpJIO9xTAkqJuBkvEMYWA23C4XI8PhFJQP1ZeWWNDw/QOMnX/U931uTl109guPH7h1O+zSxE+2/aXA467iejoLafjgx8VIKPKio4rLTEYa4L7nPPrQW4+jg/xbWgMWSbONGej9Sw/2Aa0PrE1KtM+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709588230; c=relaxed/simple;
	bh=Cv5iWgCuf7CW8sq8QnEnG6M/NJmw2W/3sm2GrYj+qeI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rM1D8xMELn5igS1AeYJn4gwe+PrM/w3gxZYzwQSLwpS25ZHo2a3il9tJi89v3Z5G+w8JbYV8hcpZWGc673/W9vl/94AGmRUbURERuhAsRo7aode5SmUUID9XdHLJYafOak+rfQv4g6zo0I0n11vRs5wIR93kk0bJsPXSIslqXS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAiEOY/t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAiEOY/t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4560EC433C7;
	Mon,  4 Mar 2024 21:37:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709588229;
	bh=Cv5iWgCuf7CW8sq8QnEnG6M/NJmw2W/3sm2GrYj+qeI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAiEOY/tqvzMpYtXpB4/h63IXhqn5g1MB1/yXcdonzWNlfh0zDdOGuZrK8JYk99fE
	 5UA9mbm3LCvMMrlNtBgHlKLlA5F51opSz1/Z9lzoefgPMjKTPCPfKlktIBz8TVe57R
	 yavAyy+JEs0G5VE/pWyoZ9QD6ZbFt9BpwcLbpBuU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oleksij Rempel <o.rempel@pengutronix.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 020/143] net: lan78xx: fix "softirq work is pending" error
Date: Mon,  4 Mar 2024 21:22:20 +0000
Message-ID: <20240304211550.586862750@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240304211549.876981797@linuxfoundation.org>
References: <20240304211549.876981797@linuxfoundation.org>
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
index d86413a0ead4b..8b1e1e1c8d5be 100644
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



