Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6DCD71D545;
	Thu, 23 May 2024 13:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470140; cv=none; b=Bxlwc4mSUs+BusJ8M/fKWBdzdqbp2F8+OgSyS6EQAlbgaIGMLo8VnHK2sb6EudMRX0mJqm5PewFLl1q8kXYcCqAODMsiYfduTiH4GT45NXmlf8xwcnpHleSHUNAzeDbqCR+hnqykyP0uQvZHvPA3KKeG04LGPBlAS1rErcasyV4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470140; c=relaxed/simple;
	bh=88wuMKpEj40Y+NnrVvJ1r2pPxk/nS1oDujUCfLGCIhs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E0JLLsKojKe94GDRkB6N52oEAYN0MF5G5EQQbI/roOVWqJnmXTs2w3fbpUXwKp8Uzfxu+StgH9BHlDxGdDFu2+1bZ4rDWAtlm0nTXLTKAB9NHUf1X1WMEXr5Gkpjzil2dtjHZah8TuTX3282KLFbOrVFjDv6WMFDodTOVfHvc04=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QPdiMToP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QPdiMToP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84CE7C3277B;
	Thu, 23 May 2024 13:15:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470139;
	bh=88wuMKpEj40Y+NnrVvJ1r2pPxk/nS1oDujUCfLGCIhs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QPdiMToPuWpI5JTw+X7mWF1U0YJxsx8E6w9ChK9kX9OQt2INSAQMk737azjIrkOPN
	 isYurt0bjTwYvcEwgXtu+D50D/dmE25IklSGcjCQ49+IPhNUIU5XTM0B/z4HCt8J3O
	 EMKZjInG5uAFDL0H642YKLQGDeo+Fz222sUCQeD8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.4 06/16] net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access
Date: Thu, 23 May 2024 15:12:39 +0200
Message-ID: <20240523130325.985902635@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130325.743454852@linuxfoundation.org>
References: <20240523130325.743454852@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Doug Berger <opendmb@gmail.com>

commit d85cf67a339685beae1d0aee27b7f61da95455be upstream.

The EXT_RGMII_OOB_CTRL register can be written from different
contexts. It is predominantly written from the adjust_link
handler which is synchronized by the phydev->lock, but can
also be written from a different context when configuring the
mii in bcmgenet_mii_config().

The chances of contention are quite low, but it is conceivable
that adjust_link could occur during resume when WoL is enabled
so use the phydev->lock synchronizer in bcmgenet_mii_config()
to be sure.

Fixes: afe3f907d20f ("net: bcmgenet: power on MII block for all MII modes")
Cc: stable@vger.kernel.org
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/broadcom/genet/bcmmii.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/ethernet/broadcom/genet/bcmmii.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmmii.c
@@ -269,6 +269,7 @@ int bcmgenet_mii_config(struct net_devic
 	 * block for the interface to work
 	 */
 	if (priv->ext_phy) {
+		mutex_lock(&phydev->lock);
 		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
 		reg |= id_mode_dis;
 		if (GENET_IS_V1(priv) || GENET_IS_V2(priv) || GENET_IS_V3(priv))
@@ -276,6 +277,7 @@ int bcmgenet_mii_config(struct net_devic
 		else
 			reg |= RGMII_MODE_EN;
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
+		mutex_unlock(&phydev->lock);
 	}
 
 	if (init)


