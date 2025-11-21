Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28576190477;
	Fri, 21 Nov 2025 13:25:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731552; cv=none; b=ac63UcUe3AnGt4ndNE3cGZUZB2A45OcMBvJ1t7gKRqN/P+lWjwfJcEDVImLJqndyqyxZF6HQ+niOqVZN0QJSTg4GgiIvagImEndRBfNJ4SlGTwzX6mUAFjoK1Vxb81ob211SNW9LqyY25X8usfXWSfqmgoCpJqPC3PHMW/2jjcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731552; c=relaxed/simple;
	bh=8qOCg76eZ186Ylt2kxaish4AdX+BvuyyAMcgZyvE5Ao=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3XuoDUkcZCzmcn/XD8Itc2EKt/dawsr3xlWTz29+3gjd2fTn2J3Rb9ucJftT7r02DAuZdetqgOwOThI0kewS0E+tcDJMw2Rddi9bAEfi2j2U5sUeNdOT5djdbtCOKXWikRY82C0SD6KfRHcy/fMj4pN0WwU+M104VRzDFT6dhY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K12rBYRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K12rBYRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A819AC4CEF1;
	Fri, 21 Nov 2025 13:25:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731552;
	bh=8qOCg76eZ186Ylt2kxaish4AdX+BvuyyAMcgZyvE5Ao=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=K12rBYRugLjd132gulq7Ln5s4WU7cD8YRDG84MB2zH9GN85jOcYMrCJIx25kfUqbx
	 nN4rIPQvgsGRjegTwsBVDvrJ3oUassGW+6p1uX5tz/4MIme2uLD6uMr87WB/2v5uD+
	 L1/oeRb5mq+bLCgyS8pLtp6wIQ+wHSXtiF3F9UN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.17 247/247] net: phy: micrel: Fix lan8814_config_init
Date: Fri, 21 Nov 2025 14:13:14 +0100
Message-ID: <20251121130203.607530142@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
@@ -4328,7 +4328,7 @@ static int lan8814_config_init(struct ph
 	struct kszphy_priv *lan8814 = phydev->priv;
 
 	/* Disable ANEG with QSGMII PCS Host side */
-	lanphy_modify_page_reg(phydev, LAN8814_PAGE_COMMON_REGS,
+	lanphy_modify_page_reg(phydev, LAN8814_PAGE_PORT_REGS,
 			       LAN8814_QSGMII_PCS1G_ANEG_CONFIG,
 			       LAN8814_QSGMII_PCS1G_ANEG_CONFIG_ANEG_ENA,
 			       0);


