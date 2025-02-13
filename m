Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CB7526B08D;
	Thu, 13 Feb 2025 14:52:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458365; cv=none; b=fTKunV8z3h7TYLq48ntFNKyqFTN/CogtKeJ12bJONVu/CAn8vmqzpebrr5cA/SiAjyTOBxeycF512rLqrOdVqL8jw05yfHD23sEmSzjdrGuyyY/8YWN6k4NszDjGbwJcYc8AprX6BAvwc9BkXryTo0sEk1lF1on9EPRSichtad8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458365; c=relaxed/simple;
	bh=F+Tft9Ur2PPOXwN125gsJPzPaePlWOAS2Va6g2jTigo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P5LRgca53Uv3TucSe6FSdr7wMKYIq52Aw/cyw3lL9yrEczd9YPXhPopT7aVksAA0ofUj/WHwNOuKgFniJIyayvcYUUnnkS1nm2p7kg7QzwIFq0yEtCUdgIK3JB/LZWzKuJyXgOVujF5ydASq70CVy7EZHyNlfBBn0cS1/IhI588=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Nkac+qIH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Nkac+qIH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 876A0C4CED1;
	Thu, 13 Feb 2025 14:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458365;
	bh=F+Tft9Ur2PPOXwN125gsJPzPaePlWOAS2Va6g2jTigo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Nkac+qIHSMEKt4jXFFB+1mN7mGW1wZBpeQPYHpaMDNVwwPEXQDdXdZrpvm9JT5dYX
	 M3jbvpGBIXcHo71sR3NRK+/sxp7YvN6DEQWK/qIDb0zWSKezxN9Jis6Ac2BEAa0xX5
	 pKiy8wreLPPZ5gJiyqFvsXgHIO+otFhMhG5ptmwY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milos Reljin <milos_reljin@outlook.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 379/422] net: phy: c45-tjaxx: add delay between MDIO write and read in soft_reset
Date: Thu, 13 Feb 2025 15:28:48 +0100
Message-ID: <20250213142451.173082388@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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

From: Milos Reljin <milos_reljin@outlook.com>

commit bd1bbab717608757cccbbe08b0d46e6c3ed0ced5 upstream.

In application note (AN13663) for TJA1120, on page 30, there's a figure
with average PHY startup timing values following software reset.
The time it takes for SMI to become operational after software reset
ranges roughly from 500 us to 1500 us.

This commit adds 2000 us delay after MDIO write which triggers software
reset. Without this delay, soft_reset function returns an error and
prevents successful PHY init.

Cc: stable@vger.kernel.org
Fixes: b050f2f15e04 ("phy: nxp-c45: add driver for tja1103")
Signed-off-by: Milos Reljin <milos_reljin@outlook.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/AM8P250MB0124D258E5A71041AF2CC322E1E32@AM8P250MB0124.EURP250.PROD.OUTLOOK.COM
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1296,6 +1296,8 @@ static int nxp_c45_soft_reset(struct phy
 	if (ret)
 		return ret;
 
+	usleep_range(2000, 2050);
+
 	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
 					 VEND1_DEVICE_CONTROL, ret,
 					 !(ret & DEVICE_CONTROL_RESET), 20000,


