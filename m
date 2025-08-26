Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9293934F46B;
	Tue, 26 Aug 2025 13:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756216486; cv=none; b=bgsrEsiNLsX/GDYtrReiVHsw2xSL1eTFKX1hNsRdLLD9BZ31tw8v72tcPls+Kp1NEXyxSsjvkvyyHkPeZ4zIAIwaPgMD8fGUpsuBhP0zh+YFqu3yinLsMEhSvOHK05uEPQeTYh3ilQ7RUfYKlUK9zAisjhplAH8OlXQiMPFaRPQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756216486; c=relaxed/simple;
	bh=ZMNvTyl+mjzkPK2NwUv43retle0tNgBlf7k1/hUdock=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RVin9eICWvI7G40wSOCEaL+qp2AXnsTrYAx1ysThsbsCtmnxUb5VvDfeAwX7JiSNSk6UOUygOyKu+gEmeRjrKvYfcrNLw6jAS1HzKErLDTN/7uteALhjTFrFGpw9QkIq+O5doReQvwA8prEs/5hfHJlKx9G5Kp/4aos8PuScwVA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hAg7G+Lg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hAg7G+Lg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20B2DC4CEF1;
	Tue, 26 Aug 2025 13:54:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756216486;
	bh=ZMNvTyl+mjzkPK2NwUv43retle0tNgBlf7k1/hUdock=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hAg7G+LgraQ6exIZ3YMvxaeIPEM8cH7QkNpt6gCBClgApFfBWsBrEHM8xlLzwFdh3
	 b2XDVo6kKBdy7x3QVmgMzEnj8/G3pPg/qZXNsj532Iq7Pc4ZBcT6NyGUf6egVgKuNw
	 i8kRsMJmevpK76NAhtO28KbM6kiG/QKgFw87BBAg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 428/644] net: phy: smsc: add proper reset flags for LAN8710A
Date: Tue, 26 Aug 2025 13:08:39 +0200
Message-ID: <20250826110957.067897530@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Buday Csaba <buday.csaba@prolan.hu>

[ Upstream commit 57ec5a8735dc5dccd1ee68afdb1114956a3fce0d ]

According to the LAN8710A datasheet (Rev. B, section 3.8.5.1), a hardware
reset is required after power-on, and the reference clock (REF_CLK) must be
established before asserting reset.

Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Cc: Csókás Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250728152916.46249-2-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 5c3ebb66fceb..4175df632de2 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -452,6 +452,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* PHY_BASIC_FEATURES */
 
+	.flags		= PHY_RST_AFTER_CLK_EN,
 	.probe		= smsc_phy_probe,
 	.remove		= smsc_phy_remove,
 
-- 
2.39.5



