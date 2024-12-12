Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 863EE235C30;
	Thu, 12 Dec 2024 16:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021269; cv=none; b=cAoI1H+91/TxNW9Wn14rnlsv057yFzVtazOzVQNAzG+AyjvU0nOfGY1866w+tNfb36tS52Tkf5jNYGCBOq1Nz1dlWSJSxr64O35SSZOhqQtaDxI6LOgJyW83IJOjRrUvoWetlkb39o1RCRGyULXZP5acday1McG+KTwfw2++9Mk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021269; c=relaxed/simple;
	bh=eb+veMoFlfWWc1x7v17+JW77YA768+ChP/lJ+tjgVYI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j478JjohjZpZmrKwkNam9hmsGoPV5jPkaj9pEuoz/D4J6AUhHf+9n7m2cBpeOS7rkMSZrYiDYY6zaMZ7LshdgiPVB5JtGawioaMkxugZtJ/aQPMZ/m9ABFp682hinfD2wz/NP+bSmzp8STnnj0zhJo+KVceIIJDZ2joB2Y1OwKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vHOMRHZ1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vHOMRHZ1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7999AC4CECE;
	Thu, 12 Dec 2024 16:34:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021268;
	bh=eb+veMoFlfWWc1x7v17+JW77YA768+ChP/lJ+tjgVYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vHOMRHZ19Yz/VOQQtuMi6rVAFz9/S/lhvqtpXELBMVtuy/bOWMPHfmtZF7cUvLnHG
	 Jj5MnzaxiuBZDuZa5Y3ockc7zZBLx4wNCSo5cHYdFBIoplgZ8T0JBm84hVEOK3w2wq
	 sLFRMz7ea4eZ+INQ8Z5NfzRNrhARGMSVyjdt1C9k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 692/772] dsa: qca8k: Use nested lock to avoid splat
Date: Thu, 12 Dec 2024 16:00:37 +0100
Message-ID: <20241212144418.500435526@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

From: Andrew Lunn <andrew@lunn.ch>

[ Upstream commit 078e0d596f7b5952dad8662ace8f20ed2165e2ce ]

qca8k_phy_eth_command() is used to probe the child MDIO bus while the
parent MDIO is locked. This causes lockdep splat, reporting a possible
deadlock. It is not an actually deadlock, because different locks are
used. By making use of mutex_lock_nested() we can avoid this false
positive.

Signed-off-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20241110175955.3053664-1-andrew@lunn.ch
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/qca/qca8k-8xxx.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/dsa/qca/qca8k-8xxx.c b/drivers/net/dsa/qca/qca8k-8xxx.c
index 641692f716f86..47e9b2c303831 100644
--- a/drivers/net/dsa/qca/qca8k-8xxx.c
+++ b/drivers/net/dsa/qca/qca8k-8xxx.c
@@ -551,7 +551,7 @@ qca8k_phy_eth_command(struct qca8k_priv *priv, bool read, int phy,
 	 * We therefore need to lock the MDIO bus onto which the switch is
 	 * connected.
 	 */
-	mutex_lock(&priv->bus->mdio_lock);
+	mutex_lock_nested(&priv->bus->mdio_lock, MDIO_MUTEX_NESTED);
 
 	/* Actually start the request:
 	 * 1. Send mdio master packet
-- 
2.43.0



