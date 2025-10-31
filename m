Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C1681D5CC9;
	Fri, 31 Oct 2025 14:03:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761919385; cv=none; b=lFoA7z7IUUAub3uYuP9CX1Yjn1fRll+jXFfsfhlLH7IqfPVzhHH182TJy3wzJ/L4yU4YXpijROGQz4iHoikRwlvMAdcs2wgte4jBRGPL4WKVEYPRnxZISi/zDO6+M9fGrQUMFH7lIo2+qKMzEqACxHhccMdgtUgIEu8QBvEmtkY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761919385; c=relaxed/simple;
	bh=S/1qEFXxp5elShJ88sHvqlNvH0jRmY9sCRlJCl/xGtU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Vup4OT/JjUgSa+LDbFf4k/VWMZTL+5u2UYH1ZQFRO23KV/e03IIqKd1qViVcc5oXcTgmhR35/xNd/CSR7XoHXvgN3tAlqFswI9v9eY5y/9bzFjWT9vWWNeWsEthKnIanK9+Qgy5lqZGjlTINsRWlT/tC7zDhmVlHeRW/AOm4K04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WMPXuTty; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WMPXuTty"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D35DC4CEE7;
	Fri, 31 Oct 2025 14:03:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761919384;
	bh=S/1qEFXxp5elShJ88sHvqlNvH0jRmY9sCRlJCl/xGtU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WMPXuTty+5WwFzejc2r8VlJJmcULaxe7Av5vFG9WYI/xW1iQb70grRIl0suwmifp/
	 xGt20eQHeHuRNqrPqKM6UdHQdOIbN4zlbldEsBbDgYLDreF03WG6qDHr8/oZJ+exgA
	 xLWIIAAXdlaetc5t5/0WZBStM/2lrgR67RnqeeFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Hugo Villeneuve <hvilleneuve@dimonoff.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 22/32] serial: sc16is7xx: remove useless enable of enhanced features
Date: Fri, 31 Oct 2025 15:01:16 +0100
Message-ID: <20251031140042.978837354@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251031140042.387255981@linuxfoundation.org>
References: <20251031140042.387255981@linuxfoundation.org>
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

From: Hugo Villeneuve <hvilleneuve@dimonoff.com>

[ Upstream commit 1c05bf6c0262f946571a37678250193e46b1ff0f ]

Commit 43c51bb573aa ("sc16is7xx: make sure device is in suspend once
probed") permanently enabled access to the enhanced features in
sc16is7xx_probe(), and it is never disabled after that.

Therefore, remove re-enable of enhanced features in
sc16is7xx_set_baud(). This eliminates a potential useless read + write
cycle each time the baud rate is reconfigured.

Fixes: 43c51bb573aa ("sc16is7xx: make sure device is in suspend once probed")
Cc: stable <stable@kernel.org>
Signed-off-by: Hugo Villeneuve <hvilleneuve@dimonoff.com>
Link: https://patch.msgid.link/20251006142002.177475-1-hugo@hugovil.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/sc16is7xx.c |    7 -------
 1 file changed, 7 deletions(-)

--- a/drivers/tty/serial/sc16is7xx.c
+++ b/drivers/tty/serial/sc16is7xx.c
@@ -582,13 +582,6 @@ static int sc16is7xx_set_baud(struct uar
 		div /= prescaler;
 	}
 
-	/* Enable enhanced features */
-	sc16is7xx_efr_lock(port);
-	sc16is7xx_port_update(port, SC16IS7XX_EFR_REG,
-			      SC16IS7XX_EFR_ENABLE_BIT,
-			      SC16IS7XX_EFR_ENABLE_BIT);
-	sc16is7xx_efr_unlock(port);
-
 	/* If bit MCR_CLKSEL is set, the divide by 4 prescaler is activated. */
 	sc16is7xx_port_update(port, SC16IS7XX_MCR_REG,
 			      SC16IS7XX_MCR_CLKSEL_BIT,


