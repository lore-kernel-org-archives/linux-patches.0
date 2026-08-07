Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B1AC306744;
	Fri,  7 Aug 2026 15:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115187; cv=none; b=ikp8ru0RriksYV0JeegAIshVDJqHpsYPKpxaJPTfrOUNHC6LkekK53/8p/zXb+csuXRAeNa7vc2BjU0p+NB3UB2HByCyYdyMrRrK64seJurksA3UwH9s43gFLQrHqW79pbAnfc/5FADy+VEHc1SMHNX5ncR63iriVyewXdsbWBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115187; c=relaxed/simple;
	bh=CNyaNq8gFbq2Qoy2icKuamQxyF34KASxY0soenOPLuA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AEj/3L8/oicEylXPeDxVHZPvxkPNVoa8+qXXTBaXt0YA8wnAvfHd3cfTWfkHodPzAEQ8MSOaDw3Oj2ZZ62sak7VHkSkc35YooV2H/V78y9StFFT/9Xbl7JDi/SBzpJ+10FBelVK82C0sDvN/Wazk5IQSAXjMGB2mLfvRN8HZ7lY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QOGGB5HX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QOGGB5HX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A51521F000E9;
	Fri,  7 Aug 2026 15:06:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115186;
	bh=pSwS3RE9IzLsExLlErrGngd8JVWXs1g7tYVVtjXU8DA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QOGGB5HXomVpkey4sGHH62IpCExNhO5WS1DsCTv9lPl8Y/FFDn62EwUBemT05eimh
	 dxa3FkqG+nxsggVULTWdDPVpRZygW86qiWBm2TJkfeSEWETcN63l4gkB4Q9nN15J7S
	 7jfhYlYKaxYzyoNJhIZMdwu0hRS+iohAAr5lvAtA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Golle <daniel@makrotopia.org>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 144/396] net: dsa: mt7530: check bus->read() errors in the MDIO regmap backend
Date: Fri,  7 Aug 2026 16:35:04 +0200
Message-ID: <20260807143427.415561089@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

[ Upstream commit b4ce102b2cd88424c5860fbbb20b9eb343a93bf4 ]

bus->read() returns a negative errno on failure, but
mt7530_regmap_read() assigns it to a u16, truncating e.g. -ETIMEDOUT
into 0xff92, and returns success. The garbage word is then consumed as
register data, and read-modify-write cycles write it back to the
switch. Check both reads and propagate their errors.

The same defect existed in mt7530_mii_read() since the driver was
introduced and moved into the regmap backend unchanged.

Fixes: b8f126a8d543 ("net-next: dsa: add dsa support for Mediatek MT7530 switch")
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/3c628e48276c2e5522c8795a6be60d11c7a76a7d.1785213071.git.daniel@makrotopia.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mt7530-mdio.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mt7530-mdio.c b/drivers/net/dsa/mt7530-mdio.c
index 0286a6cecb6f5..6cc2c8975af66 100644
--- a/drivers/net/dsa/mt7530-mdio.c
+++ b/drivers/net/dsa/mt7530-mdio.c
@@ -55,8 +55,15 @@ mt7530_regmap_read(void *context, unsigned int reg, unsigned int *val)
 	if (ret < 0)
 		return ret;
 
-	lo = bus->read(bus, priv->mdiodev->addr, r);
-	hi = bus->read(bus, priv->mdiodev->addr, 0x10);
+	ret = bus->read(bus, priv->mdiodev->addr, r);
+	if (ret < 0)
+		return ret;
+	lo = ret;
+
+	ret = bus->read(bus, priv->mdiodev->addr, 0x10);
+	if (ret < 0)
+		return ret;
+	hi = ret;
 
 	*val = (hi << 16) | (lo & 0xffff);
 
-- 
2.53.0



