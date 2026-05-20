Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93DD6364E89;
	Wed, 20 May 2026 17:23:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297810; cv=none; b=QVWhf95CWyoLCs5Xcaijz1OJUhqicHfN9XSJKc7HRUHRdaXcXzHlYGuuhgexkO6P9VQw9FZ4m/G4REizYRueYnroIOzp3Hv+Q+pwwtNtMR3we3lKV5icUY/gfYzuvgQTd8emQB6HMeuamC4U0M6pVRW7OUTFYxNi2yUh0rnQxc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297810; c=relaxed/simple;
	bh=Ylyuydj0sHMzJKL8hfAQnyV/1IWZEzmNJ0VEVW6t6gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Jsz1tjvSxGb0FRE9GFIMjchR1b138pX1UFfEXmO8UMQHg8lR1/6QkPg83OaLz4AybkPjWQkKBB467mwiWdd8E7EFJjQviV0rP9HFgDEDpHeemzoCw67gCpKUci9LMPuDjzyyNn6qz0syH0dxVq4cLdyIHH2PTgkmf+y8om2apTo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Jb3lzj1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Jb3lzj1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0498D1F000E9;
	Wed, 20 May 2026 17:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297809;
	bh=lz9sD+WN1e6JJv5Wp63F9aB2HkArT52Fi4KjQme6qAY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Jb3lzj1gZba3+Z6A10XcRhtf5yLfH3jMG+NSoED5OEtm/ViAbbh3ce1HLjfUgMpAy
	 aIUl026ClOJVA7VNZLHJiOf7XpWAuEw0oDLHNBB+P2PxEEqbjDhqP0sZxbBTS7fd8B
	 /4piednSTE07vpnrn8UB+4K3svnbMB8GIB42FF5A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Charles Perry <charles.perry@microchip.com>,
	Andrew Lunn <andrew@lunn.ch>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 170/957] net: phy: fix a return path in get_phy_c45_ids()
Date: Wed, 20 May 2026 18:10:53 +0200
Message-ID: <20260520162138.240914373@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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
index 2353d6eced68d..dea8b94286d15 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -963,8 +963,8 @@ static int get_phy_c45_ids(struct mii_bus *bus, int addr,
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



