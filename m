Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B35514EC4D;
	Tue,  9 Jul 2024 11:20:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720524038; cv=none; b=T89AAmU19oMtrwhTeRLUqeUuOZJY2lCCVvy0c2t8eie7v5dx0szZ2VXdHpR4gpyzT1IGS+qmNqhnmv/IkA/sXJZF4AtP5kuiLljylFUDKBkxlvm07YM5Q+jeQHwxLlf+ssY3R3Kl2x5ZFoTYtbYZ5ntjKPKJwZFzGS5e5po7PYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720524038; c=relaxed/simple;
	bh=UrgoYUCkpPBHIbvQwVspY0AoYiUUjLe02dNbej72kq4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d6WlJh4NVr7WFxBYmO59ehA74GWVSf2oAhvRgwihoex2cmRtBfTbjyBfDiNvREmXWz5B0qaXUxvZbXAtfk9hIPeb+5SCeKnJQ8d+G1/Jhy4mQAXk2kspTxWKTU2CQnDym3HypiZIwDULqpGXtM+2GsOaLPyhGU2kGBI13kWz4Hk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mPQ1ybR4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mPQ1ybR4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 831B7C3277B;
	Tue,  9 Jul 2024 11:20:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1720524037;
	bh=UrgoYUCkpPBHIbvQwVspY0AoYiUUjLe02dNbej72kq4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mPQ1ybR40HeRZHAQXe1/BwPaHJ3tuAMpTWj4gI2/ZkFn3bAQ8kzfdFqtUTtgEcrkK
	 pYUzAH97yh2DdIF2ZYAKQvL21Q13dTZQx8k3F5kMT2lyiGQW/+W6Okh4C1+HL+3JJE
	 9KyAPII50S3rRUIRx4e5GhPi2F/S8aTL2U2FhnWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 050/197] net: dsa: mv88e6xxx: Correct check for empty list
Date: Tue,  9 Jul 2024 13:08:24 +0200
Message-ID: <20240709110710.900461698@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240709110708.903245467@linuxfoundation.org>
References: <20240709110708.903245467@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Simon Horman <horms@kernel.org>

[ Upstream commit 4c7f3950a9fd53a62b156c0fe7c3a2c43b0ba19b ]

Since commit a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO
busses") mv88e6xxx_default_mdio_bus() has checked that the
return value of list_first_entry() is non-NULL.

This appears to be intended to guard against the list chip->mdios being
empty.  However, it is not the correct check as the implementation of
list_first_entry is not designed to return NULL for empty lists.

Instead, use list_first_entry_or_null() which does return NULL if the
list is empty.

Flagged by Smatch.
Compile tested only.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Signed-off-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20240430-mv88e6xx-list_empty-v3-1-c35c69d88d2e@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/chip.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/dsa/mv88e6xxx/chip.c b/drivers/net/dsa/mv88e6xxx/chip.c
index 5a202edfec371..80741e506f422 100644
--- a/drivers/net/dsa/mv88e6xxx/chip.c
+++ b/drivers/net/dsa/mv88e6xxx/chip.c
@@ -131,8 +131,8 @@ struct mii_bus *mv88e6xxx_default_mdio_bus(struct mv88e6xxx_chip *chip)
 {
 	struct mv88e6xxx_mdio_bus *mdio_bus;
 
-	mdio_bus = list_first_entry(&chip->mdios, struct mv88e6xxx_mdio_bus,
-				    list);
+	mdio_bus = list_first_entry_or_null(&chip->mdios,
+					    struct mv88e6xxx_mdio_bus, list);
 	if (!mdio_bus)
 		return NULL;
 
-- 
2.43.0



