Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D61DD13957E;
	Tue, 26 Aug 2025 13:01:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213277; cv=none; b=aFtHxcqON22TDFIeu/wqn23MR+XQuuv8io1ZLYdwUUK6azo3/251LB250hn1RNseZVr3rW1j29PNLBhiUCeImct4koHorHVNGk3g5/QXZFy1vNIOFRB3Wyq2A/bL6jfIaPAmggEk0FMttjUli56FeYv4Ht7wEh+o0IWj9H/7hbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213277; c=relaxed/simple;
	bh=zhSKBxD/LL260WR5Bzj5D6HS7vfFANWyoNxyXnvp2fE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=g/EP9PiNzJEMrmgfKVFmmGCi37CJ0exZ34T+oPxkXdPW62bQwqJ6kwz+GD6Cl1YzHoaBhYX61eqgeTwc2ADCmJFE/UTdaNyF8KLqq3fFyMNvTUbPF8sjcmz5VyRMybkGc2GXVPEhpTfrPNGQJwmmaCmP6QOJlL4iwXCqA52U9sc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cir5KQg+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cir5KQg+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 674B9C4CEF4;
	Tue, 26 Aug 2025 13:01:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213277;
	bh=zhSKBxD/LL260WR5Bzj5D6HS7vfFANWyoNxyXnvp2fE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cir5KQg+G59Bh/lQ5DvJQKeCBXwhUTfFToL9Z+iPWrLOhhkBvMleSH6eT3xrKyk/5
	 ZlQAPWr7TyJDoKfi9rcDuNf1ismVWouxoo8fNTDcEVmgcY57t1DaEcbOuU5y/AL3ao
	 2e7qS0f0UMRTAU/aPAfKJgYWnDRxwEpXi/Jp09hg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Buday Csaba <buday.csaba@prolan.hu>,
	=?UTF-8?q?Cs=C3=B3k=C3=A1s=20Bence?= <csokas.bence@prolan.hu>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 286/587] net: phy: smsc: add proper reset flags for LAN8710A
Date: Tue, 26 Aug 2025 13:07:15 +0200
Message-ID: <20250826111000.207378190@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Buday Csaba <buday.csaba@prolan.hu>

[ Upstream commit 57ec5a8735dc5dccd1ee68afdb1114956a3fce0d ]

According to the LAN8710A datasheet (Rev. B, section 3.8.5.1), a hardware
reset is required after power-on, and the reference clock (REF_CLK) must be
established before asserting reset.

Signed-off-by: Buday Csaba <buday.csaba@prolan.hu>
Cc: Csókás Bence <csokas.bence@prolan.hu>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250728152916.46249-2-csokas.bence@prolan.hu
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/smsc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/smsc.c b/drivers/net/phy/smsc.c
index 4ca813c00947..5f9bb0ebe455 100644
--- a/drivers/net/phy/smsc.c
+++ b/drivers/net/phy/smsc.c
@@ -786,6 +786,7 @@ static struct phy_driver smsc_phy_driver[] = {
 
 	/* PHY_BASIC_FEATURES */
 
+	.flags		= PHY_RST_AFTER_CLK_EN,
 	.probe		= smsc_phy_probe,
 
 	/* basic functions */
-- 
2.39.5



