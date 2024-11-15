Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7F466153800;
	Fri, 15 Nov 2024 06:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731653726; cv=none; b=giDql/jryezSCzwOQipsrj0kuXpy9foShOUzWo/t7N7rA+gi/fnEPeFu8Kn3CY1kYAL9TMCCCaxlGC8JM+Jn6yoaySTpNTrplg34c+LRsIWYTuO4LjVTpHE9k7QbCJ9BxTNjyCnNO5sRtgDa6bSdGK1WmKvDN60edQ7GvsUfL+U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731653726; c=relaxed/simple;
	bh=ljr4BDeMjey9jabcZQ5PuKwspSX3q3XfmRQ4ACZd5Ts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oNGKz13d3aDthyKgHQWZyFzedmHU6yQsBnNjQlY7MhVXfbe902OvcegxtJJOXgj3OgHP098M4hklne1tI6P4Cws5zOp4mQQSlWT+u/wJ3+YW4B4K3/feTFyUQiv1leDe48Ib4XUClJH17c9SEGad7WQuKWhfHpydmjDiasBnyr4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BFl6iHMo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BFl6iHMo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBA41C4CECF;
	Fri, 15 Nov 2024 06:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731653726;
	bh=ljr4BDeMjey9jabcZQ5PuKwspSX3q3XfmRQ4ACZd5Ts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BFl6iHMoCBYFiDp4kpuyAU+5dYhYqXMcHdcYxi3qQR4kQqzrJ0ofS2wXaRN1LLKqB
	 hUhoTR0MhJIZBkc+mIO8Omo76nayVLYkoUgGDfiXn6uW4XFWHFwFaepZWvpTNYrnUp
	 dAPBuWqPww4UA2xqOsEpZGUYmlOmDpxN/2VYSKuc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Silva <diogompaissilva@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 19/82] net: phy: ti: add PHY_RST_AFTER_CLK_EN flag
Date: Fri, 15 Nov 2024 07:37:56 +0100
Message-ID: <20241115063726.258660463@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241115063725.561151311@linuxfoundation.org>
References: <20241115063725.561151311@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Diogo Silva <diogompaissilva@gmail.com>

[ Upstream commit 256748d5480bb3c4b731236c6d6fc86a8e2815d8 ]

DP83848	datasheet (section 4.7.2) indicates that the reset pin should be
toggled after the clocks are running. Add the PHY_RST_AFTER_CLK_EN to
make sure that this indication is respected.

In my experience not having this flag enabled would lead to, on some
boots, the wrong MII mode being selected if the PHY was initialized on
the bootloader and was receiving data during Linux boot.

Signed-off-by: Diogo Silva <diogompaissilva@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Fixes: 34e45ad9378c ("net: phy: dp83848: Add TI DP83848 Ethernet PHY")
Link: https://patch.msgid.link/20241102151504.811306-1-paissilva@ld-100007.ds1.internal
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/dp83848.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/phy/dp83848.c b/drivers/net/phy/dp83848.c
index b707a9b278471..406538ba50445 100644
--- a/drivers/net/phy/dp83848.c
+++ b/drivers/net/phy/dp83848.c
@@ -137,6 +137,8 @@ MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
 		.ack_interrupt	= dp83848_ack_interrupt,	\
 		.config_intr	= dp83848_config_intr,		\
 		.handle_interrupt = dp83848_handle_interrupt,	\
+								\
+		.flags		= PHY_RST_AFTER_CLK_EN,		\
 	}
 
 static struct phy_driver dp83848_driver[] = {
-- 
2.43.0



