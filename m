Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 444FF423A61;
	Tue, 31 Mar 2026 16:50:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975803; cv=none; b=pcL/7a+1Av0+RvsxwnB98I2ZaI6m4WOlBHqtsIyYLLc0b9sGhxhVT/MVhRomZIhSg7z83+xpVUL5pWnP8oWHFuLp69yCVbmF4wIYMPQP8gB5bsoWiOK3ZKQ4b+ySiVlOXarb4CA3F+H70Uam4BeNtPUSbG2d6YnwkfPo+PWLAC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975803; c=relaxed/simple;
	bh=lj+2HyzIXNze/KdAGdsPR4pNRgM13ln6ZP73zbwnPvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mB5ucwKhF6IIVSTM3YZFs5mE2ODA+5Pc6bkFU/C2i5HRkYueLKxWnkn2g11999emnY7KsZDzO7dx/D9pTc3BiQD4Mu/B4pHPZW0g6cxWzRBGeiwEwW8u6OYSacU+4Jviad4snIjG692wdsfJ32n9/uy1g4kU2+g6J+4j42/nuao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eOUS8wKg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eOUS8wKg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDC0EC19423;
	Tue, 31 Mar 2026 16:50:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975803;
	bh=lj+2HyzIXNze/KdAGdsPR4pNRgM13ln6ZP73zbwnPvU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eOUS8wKg+bzPoIBBtj+9Cf76DrS0tK/sMb/DxVUdoblPE8TPpQMRyv2xo6Zepddha
	 o7lkHhjkx7U4wXGtk6QpzC3dIe9tklpjVY1gU0E1bF9A2gLe+2dBhHL7D8M+ffK9Fe
	 GV5qmOGs2bj2fmlrIhPcSNsKPP8/d2KkKbYutG7Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thangaraj Samynathan <thangaraj.s@microchip.com>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 092/244] net: lan743x: fix duplex configuration in mac_link_up
Date: Tue, 31 Mar 2026 18:20:42 +0200
Message-ID: <20260331161745.074072182@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
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

From: Thangaraj Samynathan <thangaraj.s@microchip.com>

[ Upstream commit 71399707876b93240f236f48b8062f3423a5fe97 ]

The driver does not explicitly configure the MAC duplex mode when
bringing the link up. As a result, the MAC may retain a stale duplex
setting from a previous link state, leading to duplex mismatches with
the link partner and degraded network performance.

Update lan743x_phylink_mac_link_up() to set or clear the MAC_CR_DPX_
bit according to the negotiated duplex mode.

This ensures the MAC configuration is consistent with the phylink
resolved state.

Fixes: a5f199a8d8a03 ("net: lan743x: Migrate phylib to phylink")
Signed-off-by: Thangaraj Samynathan <thangaraj.s@microchip.com>
Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Link: https://patch.msgid.link/20260323065345.144915-1-thangaraj.s@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan743x_main.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/microchip/lan743x_main.c b/drivers/net/ethernet/microchip/lan743x_main.c
index 8c4c28a1d6575..b897d071fc452 100644
--- a/drivers/net/ethernet/microchip/lan743x_main.c
+++ b/drivers/net/ethernet/microchip/lan743x_main.c
@@ -3055,6 +3055,11 @@ static void lan743x_phylink_mac_link_up(struct phylink_config *config,
 	else if (speed == SPEED_100)
 		mac_cr |= MAC_CR_CFG_L_;
 
+	if (duplex == DUPLEX_FULL)
+		mac_cr |= MAC_CR_DPX_;
+	else
+		mac_cr &= ~MAC_CR_DPX_;
+
 	lan743x_csr_write(adapter, MAC_CR, mac_cr);
 
 	lan743x_ptp_update_latency(adapter, speed);
-- 
2.51.0



