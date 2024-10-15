Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A38521F12F3;
	Tue, 15 Oct 2024 12:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994189; cv=none; b=incd+ENHwz7z2buDk0prlGwFEPeyQhX2Y1TUT3JPBH5xwHQJYep1plk4oK5zLDRZi8/ZJnZWb8bWDaEslKg5DIDQfuD5oZE/BivNXznF6TTHJRTVSCFFDt+99HV+poHe4Nem1LYNEu2QjC51YgK+qDhobSWzAY3QTKlEg1XHUJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994189; c=relaxed/simple;
	bh=5ZIm1OJMOVD+e0Pea1f3EjPBEH17Ljo7oqyHJ1XAZ6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbTlQdiMcH5rhDl0VA1ilwAx4JcMba7MeQGomjriNqQPuVYTQFJru0IuXNcgD6RAh+eCtydSZFh0344XY6s8Z73TTwy/qdagMKrlZomLnJfiEnwyEKFmKTVYJf3Q9/i4sqr9ELumJq0IvwcttPmzJZetzN/HFiQgEAbZIrYB7vE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dWnRk7oR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dWnRk7oR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1446BC4CEC6;
	Tue, 15 Oct 2024 12:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994189;
	bh=5ZIm1OJMOVD+e0Pea1f3EjPBEH17Ljo7oqyHJ1XAZ6U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dWnRk7oRV9Z53minxxChxHzF6ru4XRYjUqDVeJ1NX/e+WBCyuC6sdD1lxI8SPAtEY
	 v/vffx+1OiYhOGjFJB2GnbTOkE0y/DcD8kic+XI8BWyZzduH+K7eYBzM8NCtrawRTr
	 n5m9gZ5hXKoMj3eJaGFfqOiEJ0TS+LCuF5pzw8I8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 633/691] net: phy: bcm84881: Fix some error handling paths
Date: Tue, 15 Oct 2024 13:29:41 +0200
Message-ID: <20241015112505.452597634@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9234a2549cb6ac038bec36cc7c084218e9575513 ]

If phy_read_mmd() fails, the error code stored in 'bmsr' should be returned
instead of 'val' which is likely to be 0.

Fixes: 75f4d8d10e01 ("net: phy: add Broadcom BCM84881 PHY driver")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/3e1755b0c40340d00e089d6adae5bca2f8c79e53.1727982168.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/bcm84881.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/bcm84881.c b/drivers/net/phy/bcm84881.c
index 9717a1626f3fa..37a64a37b2ae3 100644
--- a/drivers/net/phy/bcm84881.c
+++ b/drivers/net/phy/bcm84881.c
@@ -120,7 +120,7 @@ static int bcm84881_aneg_done(struct phy_device *phydev)
 
 	bmsr = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_C22 + MII_BMSR);
 	if (bmsr < 0)
-		return val;
+		return bmsr;
 
 	return !!(val & MDIO_AN_STAT1_COMPLETE) &&
 	       !!(bmsr & BMSR_ANEGCOMPLETE);
@@ -146,7 +146,7 @@ static int bcm84881_read_status(struct phy_device *phydev)
 
 	bmsr = phy_read_mmd(phydev, MDIO_MMD_AN, MDIO_AN_C22 + MII_BMSR);
 	if (bmsr < 0)
-		return val;
+		return bmsr;
 
 	phydev->autoneg_complete = !!(val & MDIO_AN_STAT1_COMPLETE) &&
 				   !!(bmsr & BMSR_ANEGCOMPLETE);
-- 
2.43.0



