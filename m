Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64C2D1EA8D;
	Mon, 12 Aug 2024 16:05:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723478704; cv=none; b=HcaecFsvV/Yv8LlIeFT5zFXp00EeGWQSCvlMuMtFd/FJ6lXb5bMbZAdpaPom3pEGyVl41JFkzy9qEw3JTqTzu1znPc9IGKdb9p0afct1JlzdqN83UbruzAef/dCjhLcj2CkroTwX0ofFKdm0VNp3bw73dUNDSe5lT2SDo4MOd0o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723478704; c=relaxed/simple;
	bh=+7ZOD0qEYwfa5Art4YSfBe14GKa51ODXlY82QDuAC3Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jnDgmtEpBo6+T42epiWko3AAdgodJLdJXB6rQtgYc4UHDRCVlN6dp4CaJ5cBaVmIeOPF6i89u22eS5MENwRg1YiPQNBDoVMSMwgiiBA/t9OZ+A+n65sr7TY3BfDa7JXlaHpWdIOzIBjcSfhXIs9SM80ePI9HZmVmAwv4yzM2/5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ehto0D3a; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ehto0D3a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5BE97C4AF0D;
	Mon, 12 Aug 2024 16:05:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723478704;
	bh=+7ZOD0qEYwfa5Art4YSfBe14GKa51ODXlY82QDuAC3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ehto0D3a210CQ6adFMhE6a1A0LLxfgqPPjkJ5Y3YO/ZQKPiPHqhTtdv+5R3zQeOzq
	 s4NPcpWXjrIzH2wUYtF9ztUz4gGOKVsbRFp6w2JhUjEFrOjZ7TgVHAmyDukRnqlmbu
	 3ho+bC//SbAKE7anlgVPNK9l2vA9NaEKQkWGa6D8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 013/150] net: dsa: bcm_sf2: Fix a possible memory leak in bcm_sf2_mdio_register()
Date: Mon, 12 Aug 2024 18:01:34 +0200
Message-ID: <20240812160125.668734444@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160125.139701076@linuxfoundation.org>
References: <20240812160125.139701076@linuxfoundation.org>
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

From: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>

[ Upstream commit e3862093ee93fcfbdadcb7957f5f8974fffa806a ]

bcm_sf2_mdio_register() calls of_phy_find_device() and then
phy_device_remove() in a loop to remove existing PHY devices.
of_phy_find_device() eventually calls bus_find_device(), which calls
get_device() on the returned struct device * to increment the refcount.
The current implementation does not decrement the refcount, which causes
memory leak.

This commit adds the missing phy_device_free() call to decrement the
refcount via put_device() to balance the refcount.

Fixes: 771089c2a485 ("net: dsa: bcm_sf2: Ensure that MDIO diversion is used")
Signed-off-by: Joe Hattori <joe@pf.is.s.u-tokyo.ac.jp>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20240806011327.3817861-1-joe@pf.is.s.u-tokyo.ac.jp
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/bcm_sf2.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/bcm_sf2.c b/drivers/net/dsa/bcm_sf2.c
index cd1f240c90f39..257df16768750 100644
--- a/drivers/net/dsa/bcm_sf2.c
+++ b/drivers/net/dsa/bcm_sf2.c
@@ -678,8 +678,10 @@ static int bcm_sf2_mdio_register(struct dsa_switch *ds)
 			of_remove_property(child, prop);
 
 		phydev = of_phy_find_device(child);
-		if (phydev)
+		if (phydev) {
 			phy_device_remove(phydev);
+			phy_device_free(phydev);
+		}
 	}
 
 	err = mdiobus_register(priv->slave_mii_bus);
-- 
2.43.0



