Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D606A32ABC0;
	Thu, 28 May 2026 20:11:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999088; cv=none; b=oxnVBJBYh8/IHwEvHt6rEq9kM65zigUZxYvRQGxCU6Mr4sgsLkwClTbgv4IG/dzXDW0UWvP1ImflnicxK/KEp6zY8Y8q1dPMyzZdeABnp8MCSb8ydVAMEawqZE59T9M1gOMnuArgkmU7+j0VQcmCe/sKPyq40qLglglAbvFjdzA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999088; c=relaxed/simple;
	bh=ihMUVCt8oHku85OIsY9+sy7Ltxx2i1uDR+ob1bwH2rg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KS4hWJFHlhNnwsLjvRMzVkkm79dU5DfA7lpvA4Wc6oeCkacEPA4pC19L8hNTXoDUiPpQhZQiomEWWab2L+M1EzbGRaDn/NRp846uaBp5U5QZRxpRDqbsLHVcN2ykUOL0myhRuc8lzaxs+qoyccZU2z8gDixyHRLqKMGvZxCk7GY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J80G/+ZN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J80G/+ZN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40DB11F000E9;
	Thu, 28 May 2026 20:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999087;
	bh=Mnhzn6HuikMftxAqmRw1M/HXfzF2JZu7nj/00UDfHgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=J80G/+ZN7TsywsUGA6HfM8l/2nAFqnXj6fH5Xv3HQ/d79bopmskCMP5i3ONcfXsLo
	 hsr/ZCvcE0GNGqaNN3oXtX5ObJbvMZF21U740oPym9TYJydV3YUJyV8nCIyAYsRohu
	 YmvPAKrI8KgeUjRvdQqIN3AKZX2csIhFx8v2ZOWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 405/461] net: phy: honor eee_disabled_modes in phy_advertise_eee_all()
Date: Thu, 28 May 2026 21:48:54 +0200
Message-ID: <20260528194659.205378285@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 8baa7506d793f0636e3f6f01b01ef7be19674d06 ]

phy_advertise_eee_all() copies supported_eee into advertising_eee
unconditionally, overwriting any filtering applied during phy_probe()
based on DT eee-broken-* properties or driver-populated
eee_disabled_modes. genphy_c45_ethtool_set_eee() calls this helper
when user space passes an empty advertisement, undoing the filtering.

Apply the same eee_disabled_modes mask in phy_advertise_eee_all() so
the filtering survives the copy, matching the pattern in phy_probe()
and phy_support_eee().

Fixes: b64691274f5d ("net: phy: add helper phy_advertise_eee_all")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260518-devel-phy-support-eee-fix-v2-2-05b52626fa68@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 893ad97fc60c3..cfb505ed9a3a0 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2907,7 +2907,8 @@ EXPORT_SYMBOL(phy_advertise_supported);
  */
 void phy_advertise_eee_all(struct phy_device *phydev)
 {
-	linkmode_copy(phydev->advertising_eee, phydev->supported_eee);
+	linkmode_andnot(phydev->advertising_eee, phydev->supported_eee,
+			phydev->eee_disabled_modes);
 }
 EXPORT_SYMBOL_GPL(phy_advertise_eee_all);
 
-- 
2.53.0



