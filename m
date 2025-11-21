Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20BBE33438C;
	Fri, 21 Nov 2025 13:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732080; cv=none; b=IpOcXZcHmxT0racIjnPRhi+zqrCwIlTE/LJznZaUo7AuV5dZiVuFSgG5t1LKgCcmnqI6rqAAAZSNGvBex7T3mo4TYKoOBcOlcvdmFrAy1orv5fUAofNGRIbtRa2oNCJ17MNgSWZnqJZFGly9fmjoRyA6YsuZh/oPbJ3TlWbmn7k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732080; c=relaxed/simple;
	bh=HNqwzzjiNQ26pHXh3wiSjycTFW5898utNMSqMnHOaV4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1zMR3QmiqEmzWTlparH0MP04boZIikPCqOvRJi01MjLneT8cGed1+OMDrQnEDlJiBcVcjvJjr7e02s5/P1iStgiE4T9/7NKjL2KSohI9FBHcLE/i3zIfBr+0ZOpIUPdNNytBEPlpnvNtLRITYdhkPxf8nYI7LmL5Bcbsm2IpGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zd7eM5e3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zd7eM5e3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AF4CC4CEFB;
	Fri, 21 Nov 2025 13:34:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732079;
	bh=HNqwzzjiNQ26pHXh3wiSjycTFW5898utNMSqMnHOaV4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zd7eM5e3gkL+ULLaWfRap3g5xJvram79OFcgxmdMU2qw7z4nnuvPn43N0bJ79XF2k
	 AdsberKcT7+pcsIZyvxg8UoICRVRBM1xcUAbOFqkLqe1EcYtew9ygpspY0eWIvv8Bn
	 CSPJ+UGiIm9c2i8HiVX9VuPfS46kwjPWokBzfcto=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 182/185] net: phy: micrel: Fix lan8814_config_init
Date: Fri, 21 Nov 2025 14:13:29 +0100
Message-ID: <20251121130150.460452270@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Horatiu Vultur <horatiu.vultur@microchip.com>

commit bf91f4bc9c1dfba75e457e6a5f11e3cda658729a upstream.

The blamed commit introduced the function lanphy_modify_page_reg which
as name suggests it, it modifies the registers. In the same commit we
have started to use this function inside the drivers. The problem is
that in the function lan8814_config_init we passed the wrong page number
when disabling the aneg towards host side. We passed extended page number
4(LAN8814_PAGE_COMMON_REGS) instead of extended page
5(LAN8814_PAGE_PORT_REGS)

Fixes: a0de636ed7a264 ("net: phy: micrel: Introduce lanphy_modify_page_reg")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250925064702.3906950-1-horatiu.vultur@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/phy/micrel.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/phy/micrel.c
+++ b/drivers/net/phy/micrel.c
@@ -4085,7 +4085,7 @@ static int lan8814_config_init(struct ph
 	struct kszphy_priv *lan8814 = phydev->priv;
 
 	/* Disable ANEG with QSGMII PCS Host side */
-	lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
+	lanphy_modify_page_reg(phydev, LAN8814_PAGE_PORT_REGS,
 			       LAN8814_QSGMII_PCS1G_ANEG_CONFIG,
 			       LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA,
 			       0);


