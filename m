Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD9E3335BA8;
	Mon, 18 Aug 2025 13:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524915; cv=none; b=iMG6WJeAmDFX140S01R697j7uIVQOz47wR5L/v/fxm2jtLLqZ7nWLSmsqUXaxPKVpO/QNPYWzNuJQBAakW/1NlCdUPu7k7s2USuMWKD3QQ34d9EHR3egzx8pNa2yE5rZxiucuGexw2NHAxf3S0T+JcNBsk9CBWbQNrg3asauCWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524915; c=relaxed/simple;
	bh=vtFXI++kzCVBk5gDKke7kp1D8+2inMWaHQGlXb2Inzs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EQrjUN8WD++/KbfFrXu9SiDenT7FiSo+7whsrkQWtvkD+qvasTixp6jpDnCiHGsDn5cL/eipuc0TiXHjY7aF2VFM4T0sU2M/nozKH1qMd/kfQvEUqf2PlDWBGKMrvnr+g/8F4ioeWuRteDFjdX9QKYomcf4QGyiJh7Y+91TnXgs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=arYPu1Oi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="arYPu1Oi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43F09C4CEEB;
	Mon, 18 Aug 2025 13:48:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524915;
	bh=vtFXI++kzCVBk5gDKke7kp1D8+2inMWaHQGlXb2Inzs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=arYPu1OiMEv7+bxEb0wSV4Y+kGp10vOLPzCHo7SavjFXPUR0/Pn14JKbi7VO/I8aa
	 ndSOD9T5k8SOjrwNht3pQaqxMbsv+soduFDy6EGvsGmmMJK9zqlppd9DX2sCgRBWzq
	 g41kKwqceSI7geGS2kXuEdfPJRCTim1NC1SmOOZA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 070/570] net: ti: icssg-prueth: Fix emac link speed handling
Date: Mon, 18 Aug 2025 14:40:57 +0200
Message-ID: <20250818124508.516475751@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 06feac15406f4f66f4c0c6ea60b10d44775d4133 ]

When link settings are changed emac->speed is populated by
emac_adjust_link(). The link speed and other settings are then written into
the DRAM. However if both ports are brought down after this and brought up
again or if the operating mode is changed and a firmware reload is needed,
the DRAM is cleared by icssg_config(). As a result the link settings are
lost.

Fix this by calling emac_adjust_link() after icssg_config(). This re
populates the settings in the DRAM after a new firmware load.

Fixes: 9facce84f406 ("net: ti: icssg-prueth: Fix firmware load sequence.")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Message-ID: <20250805173812.2183161-1-danishanwar@ti.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index 2f5c4335dec3..008d77727400 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -50,6 +50,8 @@
 /* CTRLMMR_ICSSG_RGMII_CTRL register bits */
 #define ICSSG_CTRL_RGMII_ID_MODE                BIT(24)
 
+static void emac_adjust_link(struct net_device *ndev);
+
 static int emac_get_tx_ts(struct prueth_emac *emac,
 			  struct emac_tx_ts_response *rsp)
 {
@@ -266,6 +268,10 @@ static int prueth_emac_common_start(struct prueth *prueth)
 		ret = icssg_config(prueth, emac, slice);
 		if (ret)
 			goto disable_class;
+
+		mutex_lock(&emac->ndev->phydev->lock);
+		emac_adjust_link(emac->ndev);
+		mutex_unlock(&emac->ndev->phydev->lock);
 	}
 
 	ret = prueth_emac_start(prueth);
-- 
2.50.1



