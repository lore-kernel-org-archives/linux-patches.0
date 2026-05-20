Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF8A43F23C5;
	Wed, 20 May 2026 18:04:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300247; cv=none; b=GEz/prE6NHPUMRTg75GhHRdrKGAQ83SiRMVtxpmqxI7BGvfdwvTt2Ty030ZR+T5gGjtR/cqqpqofxaiTwccuNegFI6sICwaXC/JbuGW89nHxeGmPJNmurBQD6BgvKhqpjOiE9LCZXhQyMohWfsNDaTVpEBpBjTT8FRQjdvL5wrw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300247; c=relaxed/simple;
	bh=UyfmklEKEGmwLdCYJbVU/WaZW1rzkeai1v3FZSOzbTU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sHCohYh8PfpbtifZ8A+GlSIJvietbKj87EnY4QvfAYWRTk4vBuWOxlbEsMbPU3nwIYW3KrGbboFDAsmezM1AbpXGBf90YJu+kUPnuOg5gZODiYaLtpfPDx91Rq6O0dZ9AV27aqUSSYHDNLg50dotossdmwhmbmDg/S3SEzFko1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tluofZPR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tluofZPR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EFA91F000E9;
	Wed, 20 May 2026 18:04:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300245;
	bh=HQLOJrTjDidNZa8DHpUqcah8c2S3De6EGJIccJixw38=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tluofZPRdSHptmtKxg6eQgZvexcardTmin/QxY4iF+8zKQ3PVei1R/RmkwOCE0T+5
	 B5F6wRHx2FPnoh7xidBocMxvzaPFcx8Q8FPk8ZEOxBf/L2x5H65GyAKNwr4cG6y9lx
	 acswN12+IhD82pz7Sf648dLw/uoV2ViHXXl7LIPE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Perry <charles.perry@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 102/666] net: phy: fix a return path in get_phy_c45_ids()
Date: Wed, 20 May 2026 18:15:13 +0200
Message-ID: <20260520162113.433118283@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 7f995d0e51f7b..eb478e4961cb9 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -873,8 +873,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
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



