Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8214C367B8D;
	Wed, 20 May 2026 16:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779294881; cv=none; b=q6hBxCQJPagxvJsLxImGVDbGZphSA/XgGsv6xOL0oJQi17wDBFEtRUNnMXZuRcIhuPz86JMOPXCIgn/Lxmv9LIoqYk0XKJMuEDCzZVyBtRQuHZyHxF/bIliNIEG74uBJICf0t3Q80egGQuo7fivpNkedyHHpAOn62Gu3aUU0MI0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779294881; c=relaxed/simple;
	bh=UPaaKVUDtjqMvl8IAohcu7f9AG5ULhPgR6J0bM2Jpo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lcCFOSdKiKA6MFLFApnulxBhctOwdQBx+ildzwppb6tKNjniEBKvQ+kiL468c5y+IG0zR0AyiOowC+jgRCJAQMxrfQNrYxZcvOUuEZPg61r7af6fvBGfEWJ753cldLgT3xnFZDmx4P3RKr0F0A5QlSkdh+ky+ax1TF0GFlRyF3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wg1FAIA0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wg1FAIA0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAE201F000E9;
	Wed, 20 May 2026 16:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779294879;
	bh=LBtdGqqXwHLd7hu3nqvWTHDAeLnKLIgdlSomAodRM/M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wg1FAIA0jVRLgN9KUSAgPWLDMRb1Xqx8J3vgkXBtoKmi8wj0cJwxaQBvIeKhRdx1T
	 kyoPG5NETGFOf40loqNnDDfQbK0XeOhFFN19himVZW/hM2hNUf4sOE1tspr4IFQwLS
	 bSdfc/HwGNzLMZOPW146SDAYen2eFtoO4EPTZQ/M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Perry <charles.perry@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0205/1146] net: phy: fix a return path in get_phy_c45_ids()
Date: Wed, 20 May 2026 18:07:35 +0200
Message-ID: <20260520162152.908074527@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

From: Charles Perry <charles.perry@microchip.com>

[ Upstream commit 6f533abe7bbad2eef1e42c639b6bb9dad2b02362 ]

The return value of phy_c45_probe_present() is stored in "ret", not
"phy_reg", fix this. "phy_reg" always has a positive value if we reach
this return path (since it would have returned earlier otherwise), which
means that the original goal of the patch of not considering -ENODEV
fatal wasn't achieved.

Fixes: 17b447539408 ("net: phy: c45 scanning: Don't consider -ENODEV fatal")
Signed-off-by: Charles Perry <charles.perry@microchip.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20260409133654.3203336-1-charles.perry@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 3bd415710bf3f..f3696d9819d35 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -927,8 +927,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
 				/* returning -ENODEV doesn't stop bus
 				 * scanning
 				 */
-				return (phy_reg == -EIO ||
-					phy_reg == -ENODEV) ? -ENODEV : -EIO;
+				return (ret == -EIO ||
+					ret == -ENODEV) ? -ENODEV : -EIO;
 
 			if (!ret)
 				continue;
-- 
2.53.0



