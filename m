Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 286F01662F1;
	Thu, 13 Feb 2025 15:21:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739460063; cv=none; b=Yu+I2phkwn2BcFGwCkkbgVNclPKGTEFzExSglCB73aWDFZiUaN3m6Nwr3lzb9Ms+7YrKqLT2tzVVbv1xa+hN42T0fdVWOckAYvZjnQLemMJ7vBzhMwVKPK7ZsPVNiWnRI1/2S4aOEPXX1SXKBgmRarM4zRMyccIGENT82T17iNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739460063; c=relaxed/simple;
	bh=0ID7PdlMvzwsZk5pZJCkLaIIseuXPGR0A6i4dDykDNQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aESJpfME5JcFjQjq2gKDgiH5IgNWwbZjRi9CXKMlw7ztk1ELeHYpRYvbrdJQT5VDcy85xlQhCzKMASwZjqZ+BTnrMvzNeNdKtEzzgcyBw4JUo/I7Yeyd+zQklBd45nHv6pr7zfBvZlHuY9a1BduKvsVKiWfWvEJYdrSKLexJCNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eEJLWDed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eEJLWDed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BEBBC4CEE5;
	Thu, 13 Feb 2025 15:21:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739460063;
	bh=0ID7PdlMvzwsZk5pZJCkLaIIseuXPGR0A6i4dDykDNQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eEJLWDedYvRTLI2tDx+IytPc711ofDXBYNCicqWkMdPkPwkdQGxKv5nVZwhrdeGdd
	 l5gzaZVt0VOgWibUMG7A6ErXuhEJcLCDYZTU69DKNcYutRlGA6F0XyTZbx+zg143WB
	 zYkKKiH7keudRDblkAr4DL99zQ0tbK4LXcESXAtI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Milos Reljin <milos_reljin@outlook.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.13 416/443] net: phy: c45-tjaxx: add delay between MDIO write and read in soft_reset
Date: Thu, 13 Feb 2025 15:29:41 +0100
Message-ID: <20250213142456.664771319@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Milos Reljin <milos_reljin@outlook.com>

commit bd1bbab717608757cccbbe08b0d46e6c3ed0ced5 upstream.

In application note (AN13663) for TJA1120, on page 30, there's a figure
with average PHY startup timing values following software reset.
The time it takes for SMI to become operational after software reset
ranges roughly from 500 us to 1500 us.

This commit adds 2000 us delay after MDIO write which triggers software
reset. Without this delay, soft_reset function returns an error and
prevents successful PHY init.

Cc: stable@vger.kernel.org
Fixes: b050f2f15e04 ("phy: nxp-c45: add driver for tja1103")
Signed-off-by: Milos Reljin <milos_reljin@outlook.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/AM8P250MB0124D258E5A71041AF2CC322E1E32@AM8P250MB0124.EURP250.PROD.OUTLOOK.COM
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/nxp-c45-tja11xx.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/drivers/net/phy/nxp-c45-tja11xx.c
+++ b/drivers/net/phy/nxp-c45-tja11xx.c
@@ -1297,6 +1297,8 @@ static int nxp_c45_soft_reset(struct phy
 	if (ret)
 		return ret;
 
+	usleep_range(2000, 2050);
+
 	return phy_read_mmd_poll_timeout(phydev, MDIO_MMD_VEND1,
 					 VEND1_DEVICE_CONTROL, ret,
 					 !(ret & DEVICE_CONTROL_RESET), 20000,


