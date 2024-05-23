Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FEB72AE94;
	Thu, 23 May 2024 13:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716470194; cv=none; b=KBdlyjJnfpMjtQRPylefD+ZFOW3td78na3aH6vXT11tC/TBvxyQFXGE9meXUOJOUfQu07Kc+w4vjl3Zn14ep9OdI4uq9dAijnJhH3Ey6jCtKnoI62I2+012610BA93BunexEwZKCaXa3H5ZOyx28jEPEPC6I5e+RRjlyizorcIk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716470194; c=relaxed/simple;
	bh=NE1/z3k41AfwGvTkk6vLoOyclCZwldIQmVZHo+99GxA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WzkSRCjEbO4FenP8uD77NqT9Q0veyo0ROx9x8Ze+HK8QVUJE7HM5kBiiLLMHfRCGyTBCAIj45N5rznguJ0/JrdzQItKoymHorEPuJUZIS25TGj5haD1+wbfEs4UQrKG/NjhEnBOo4hSGrIYqXeTXHrK3pkVhjzN0vk18O5NImP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FAUOpRJy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FAUOpRJy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF6F1C32786;
	Thu, 23 May 2024 13:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1716470194;
	bh=NE1/z3k41AfwGvTkk6vLoOyclCZwldIQmVZHo+99GxA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FAUOpRJyKEpa6TJDDXJPn6N66KhVkYVAniqr9QgnI9H7LJZuUVgTSqbBGloChI+4G
	 kn74tGCB51M7yThstKdnQBjUuujCn9VD1oRxtNWQI5ZGEa7fR2VymBxeMOjRKU6InW
	 KpWOHJEdik3UWWojw9Y6AXRM1y60Es0RbslT9ju8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 04/15] net: bcmgenet: synchronize EXT_RGMII_OOB_CTRL access
Date: Thu, 23 May 2024 15:12:46 +0200
Message-ID: <20240523130326.622019315@linuxfoundation.org>
X-Mailer: git-send-email 2.45.1
In-Reply-To: <20240523130326.451548488@linuxfoundation.org>
References: <20240523130326.451548488@linuxfoundation.org>
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
@@ -264,6 +264,7 @@ int bcmgenet_mii_config(struct net_devic
 	 * block for the interface to work
 	 */
 	if (priv->ext_phy) {
+		mutex_lock(&phydev->lock);
 		reg = bcmgenet_ext_readl(priv, EXT_RGMII_OOB_CTRL);
 		reg &= ~ID_MODE_DIS;
 		reg |= id_mode_dis;
@@ -272,6 +273,7 @@ int bcmgenet_mii_config(struct net_devic
 		else
 			reg |= RGMII_MODE_EN;
 		bcmgenet_ext_writel(priv, reg, EXT_RGMII_OOB_CTRL);
+		mutex_unlock(&phydev->lock);
 	}
 
 	if (init)


