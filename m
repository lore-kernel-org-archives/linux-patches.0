Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 199002101BB;
	Tue, 12 Nov 2024 10:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407648; cv=none; b=rDR55AXMLo8FGF99zSZuX++76llU6rWVrKUSnYGikK4VysQjIULQCD0URaTIKQjYyVTIazOPmjePq0bM8sFpv1q0M8y616K31JFYSHC+kPlKt5qFbHChPqiFdd0JP7/yoEuBeociESyq3z/M49FsO3jp5bR54tXbhErUlrK1pZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407648; c=relaxed/simple;
	bh=0/vMfugFvkliwmxElLFWtjGHkdIRUTeftgIazy8+hvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lXbTjfib79Np6tntNvxAadnow23XYOEQgi5Fdj+grP5EBcqwn2T+5ZFf2009LS3H7UiCSTzdZMudNIs8sgj4Yurm4Lx16CVmB0nQqwzpgXfhvT0YekCW0Y8s+Zzeui0ygz4TFAUHwUxRPXqkRK2MqVyN7pcYWwhyODvrzu9Uho8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0RILSei; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0RILSei"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94E02C4CECD;
	Tue, 12 Nov 2024 10:34:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407648;
	bh=0/vMfugFvkliwmxElLFWtjGHkdIRUTeftgIazy8+hvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0RILSeiYluEVzx7m99krYOajDewBAalWWvasfkQTx+mlCXn/WE/305coqUxwLnft
	 vbM6d03VtuUzhYz/3SNp8dLzMwfa9PBTTbG1UTN9R23WsYV2jt2KvaGNJMRrWUdORD
	 NpH72+D1vy4x+QVsNR8nAkhFVuqYPqRC7SATFrEU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Diogo Silva <diogompaissilva@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 040/119] net: phy: ti: add PHY_RST_AFTER_CLK_EN flag
Date: Tue, 12 Nov 2024 11:20:48 +0100
Message-ID: <20241112101850.245376813@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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
index 937061acfc613..351411f0aa6f4 100644
--- a/drivers/net/phy/dp83848.c
+++ b/drivers/net/phy/dp83848.c
@@ -147,6 +147,8 @@ MODULE_DEVICE_TABLE(mdio, dp83848_tbl);
 		/* IRQ related */				\
 		.config_intr	= dp83848_config_intr,		\
 		.handle_interrupt = dp83848_handle_interrupt,	\
+								\
+		.flags		= PHY_RST_AFTER_CLK_EN,		\
 	}
 
 static struct phy_driver dp83848_driver[] = {
-- 
2.43.0



