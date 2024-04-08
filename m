Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 466462E62C;
	Mon,  8 Apr 2024 13:02:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712581332; cv=none; b=t+kKBCNmzrgWeOTcCwmYB24c3eHkQjPDKtJ12JDdf3WD4w+Zl/isr3ho7cRyQraIKOHOaj/pTWR1GNR9uMfKTUiEX+7W8OiOZSal7z6zpki6vBwVIR7t/sMft2XQUOTaivJdLwbbF4xK4CxecoHn1GR7yeO/GVVxsyb37vdRF9U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712581332; c=relaxed/simple;
	bh=kb865PHF6/l1egQdUK67it8Uk6iQUgau+tV1FK2ZAj0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mvNYjAsxwy9zIa0dPOrdwsMMPgSHENPJwVXSp7nMtoBI/lzfFrEiBc+GorqtJpl12FFYfACbGIjduU2txMcvWBtZf4tGs+Db3IU/rLCOkxBv+XltV40+HLWUfQlbwdsZZ8hNpI2CmzL8Hl7U/cP2/QVAt6TaTODlwrI3g8n5Y80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NwVzDA/0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NwVzDA/0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C644C433F1;
	Mon,  8 Apr 2024 13:02:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712581331;
	bh=kb865PHF6/l1egQdUK67it8Uk6iQUgau+tV1FK2ZAj0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NwVzDA/0spS4vGw4KItPnxJyR7L5/gOrgJR3oZC2QPwAkVpuaEPhyxUqFLtSFry4z
	 lfk9ii1/8voedesMcQL9TaGUnQ7z4Jw559LnQqU4Te2PZ3uE2YRDgu7zAR9uJmGgkJ
	 sqLZnydaWcTiOaC38gXXHNQw/XFAmMAldOj9Rt1g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Thompson <davthompson@nvidia.com>,
	Asmaa Mnebhi <asmaa@nvidia.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jiri Pirko <jiri@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 004/138] mlxbf_gige: stop PHY during open() error paths
Date: Mon,  8 Apr 2024 14:56:58 +0200
Message-ID: <20240408125256.360396619@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125256.218368873@linuxfoundation.org>
References: <20240408125256.218368873@linuxfoundation.org>
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

From: David Thompson <davthompson@nvidia.com>

[ Upstream commit d6c30c5a168f8586b8bcc0d8e42e2456eb05209b ]

The mlxbf_gige_open() routine starts the PHY as part of normal
initialization.  The mlxbf_gige_open() routine must stop the
PHY during its error paths.

Fixes: f92e1869d74e ("Add Mellanox BlueField Gigabit Ethernet driver")
Signed-off-by: David Thompson <davthompson@nvidia.com>
Reviewed-by: Asmaa Mnebhi <asmaa@nvidia.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
index 83c4659390fd5..113e3d9d33530 100644
--- a/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
+++ b/drivers/net/ethernet/mellanox/mlxbf_gige/mlxbf_gige_main.c
@@ -157,7 +157,7 @@ static int mlxbf_gige_open(struct net_device *netdev)
 
 	err = mlxbf_gige_tx_init(priv);
 	if (err)
-		goto free_irqs;
+		goto phy_deinit;
 	err = mlxbf_gige_rx_init(priv);
 	if (err)
 		goto tx_deinit;
@@ -185,6 +185,9 @@ static int mlxbf_gige_open(struct net_device *netdev)
 tx_deinit:
 	mlxbf_gige_tx_deinit(priv);
 
+phy_deinit:
+	phy_stop(phydev);
+
 free_irqs:
 	mlxbf_gige_free_irqs(priv);
 	return err;
-- 
2.43.0



