Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75A3021D3C0;
	Tue, 26 Aug 2025 11:48:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208932; cv=none; b=ndq/iyh6m+CkNSGJp5s4XKuTfqqJYP+9oR389vuqCc8cNqAhhh6ffsCoXddMZ5TX/m3mSnOEqeW4MEFXatqXeJAiX4yqDsLMUVqrZtkyH/Eo28ySNjeV3YSMzO8ObMght0ARQKcMIGTG/NE16ul9WckthoeKKiiL88VX9AfugTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208932; c=relaxed/simple;
	bh=v4/rnBUd6RaIBZ1Crx++Sf43KnxEwUOnHlDFY0gKA1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+MJehGHo7GtbRghkBgtZWYjOPt4rQOfI+bUE0615PW1xCwK+YXe1L/L+D/I5UallgfG3nOPF5JlTITAyp5bBRsrCWwBIItkqs9S3FGp/gtYYgDhP2r4o68xQOGeYpImMUqhnNXJ/ph1ifiPHMYeDWFdNlTMNIT4jwy3T86Qwh8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F8QZq4VO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F8QZq4VO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0571C4CEF1;
	Tue, 26 Aug 2025 11:48:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208932;
	bh=v4/rnBUd6RaIBZ1Crx++Sf43KnxEwUOnHlDFY0gKA1E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F8QZq4VODlYAvpnxRzEoigWoxWse5KgRL55hiGKcKdM2Dr/xpHx+iA1Rvfe1mxXPe
	 ID9V1ga5doYn+xnvdthR8a6rStnY1I/erjBFdOa7symRSx1CzJC7PnEOOZsTXHSZmx
	 htsldnnkkXeyFZfIqohQ+M9GAagFFYNLCjE5d5RU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Parthiban Veerasooran <parthiban.veerasooran@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 300/322] microchip: lan865x: fix missing netif_start_queue() call on device open
Date: Tue, 26 Aug 2025 13:11:55 +0200
Message-ID: <20250826110923.302234192@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

From: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>

[ Upstream commit 1683fd1b2fa79864d3c7a951d9cea0a9ba1a1923 ]

This fixes an issue where the transmit queue is started implicitly only
the very first time the device is registered. When the device is taken
down and brought back up again (using `ip` or `ifconfig`), the transmit
queue is not restarted, causing packet transmission to hang.

Adding an explicit call to netif_start_queue() in lan865x_net_open()
ensures the transmit queue is properly started every time the device
is reopened.

Fixes: 5cd2340cb6a3 ("microchip: lan865x: add driver support for Microchip's LAN865X MAC-PHY")
Signed-off-by: Parthiban Veerasooran <parthiban.veerasooran@microchip.com>
Link: https://patch.msgid.link/20250818060514.52795-2-parthiban.veerasooran@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan865x/lan865x.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan865x/lan865x.c b/drivers/net/ethernet/microchip/lan865x/lan865x.c
index dd436bdff0f8..d03f5a8de58d 100644
--- a/drivers/net/ethernet/microchip/lan865x/lan865x.c
+++ b/drivers/net/ethernet/microchip/lan865x/lan865x.c
@@ -311,6 +311,8 @@ static int lan865x_net_open(struct net_device *netdev)
 
 	phy_start(netdev->phydev);
 
+	netif_start_queue(netdev);
+
 	return 0;
 }
 
-- 
2.50.1



