Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D15256FAF
	for <patches@lists.linux.dev>; Mon, 28 Aug 2023 10:18:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5284DC433C7;
	Mon, 28 Aug 2023 10:18:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1693217913;
	bh=6l8YCI6hpnV1cvUeA4BALdGQQOc9rEcq0uZgVVyHcJw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C9tEJAwlwQgRLgWSACt7ZBj1Sf/iChh9WKN5EpR7oKzZ9RuMYN1PlxchCoRoGkWB0
	 bQorIqVMvqe6RWT1I+tI08Ub7MpkRTcvmNrw8Gnt0AuEyAvoa0UM15xcyJvPO8mOg/
	 M0P6u+JUb7ddeiXE3LrtQMpVugx6iuOfNbmsu4bs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Serge Semin <fancer.lancer@gmail.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 027/129] net: mdio: mdio-bitbang: Fix C45 read/write protocol
Date: Mon, 28 Aug 2023 12:11:46 +0200
Message-ID: <20230828101158.294276286@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230828101157.383363777@linuxfoundation.org>
References: <20230828101157.383363777@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Serge Semin <fancer.lancer@gmail.com>

[ Upstream commit 2572ce62415cf3b632391091447252e2661ed520 ]

Based on the original code semantic in case of Clause 45 MDIO, the address
command is supposed to be followed by the command sending the MMD address,
not the CSR address. The commit 002dd3de097c ("net: mdio: mdio-bitbang:
Separate C22 and C45 transactions") has erroneously broken that. So most
likely due to an unfortunate variable name it switched the code to sending
the CSR address. In our case it caused the protocol malfunction so the
read operation always failed with the turnaround bit always been driven to
one by PHY instead of zero. Fix that by getting back the correct
behaviour: sending MMD address command right after the regular address
command.

Fixes: 002dd3de097c ("net: mdio: mdio-bitbang: Separate C22 and C45 transactions")
Signed-off-by: Serge Semin <fancer.lancer@gmail.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/mdio/mdio-bitbang.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/mdio/mdio-bitbang.c b/drivers/net/mdio/mdio-bitbang.c
index b83932562be21..81b7748c10ce0 100644
--- a/drivers/net/mdio/mdio-bitbang.c
+++ b/drivers/net/mdio/mdio-bitbang.c
@@ -186,7 +186,7 @@ int mdiobb_read_c45(struct mii_bus *bus, int phy, int devad, int reg)
 	struct mdiobb_ctrl *ctrl = bus->priv;
 
 	mdiobb_cmd_addr(ctrl, phy, devad, reg);
-	mdiobb_cmd(ctrl, MDIO_C45_READ, phy, reg);
+	mdiobb_cmd(ctrl, MDIO_C45_READ, phy, devad);
 
 	return mdiobb_read_common(bus, phy);
 }
@@ -222,7 +222,7 @@ int mdiobb_write_c45(struct mii_bus *bus, int phy, int devad, int reg, u16 val)
 	struct mdiobb_ctrl *ctrl = bus->priv;
 
 	mdiobb_cmd_addr(ctrl, phy, devad, reg);
-	mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, reg);
+	mdiobb_cmd(ctrl, MDIO_C45_WRITE, phy, devad);
 
 	return mdiobb_write_common(bus, val);
 }
-- 
2.40.1



