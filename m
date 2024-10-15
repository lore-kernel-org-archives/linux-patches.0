Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30DC51C07C4;
	Tue, 15 Oct 2024 12:58:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728997100; cv=none; b=mFTSRSf9UZWHXBbrpEEprOi7/dLCJUZ/RhhHeTa8xhSG3NfJw81NcNdW5cPnT07GqNdOTrJNyXMCrBVkPJhp5jKi5DDKZfGCI4Xi0qyicYLhgwiym/vi56qECzHQxC1yOBKbxuZqn8s2aUP8rQdEnqeg8Gq+WwZTOqcayBdQHsE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728997100; c=relaxed/simple;
	bh=be8Akbk/jYXBweHjt+CKakfdNT4PQrCS36y9HClJe6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eTqA/AoTJkzhjho5ePstYzy2tKvk5TXaCktl7StkgAOKRqcu2kgdctcYQ1sov1anMFvw8ZSY7qXbKr3BGoIuf7gGdTClp7ibAniUK2/vZqbuu06u1SEp5LpUhxIMY0Mwe7xo98ZB3IQU4nSCcGIa9Ec3syNuJ6L9uXo38Eb2vBU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZoyC51B/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZoyC51B/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D96AC4CEC6;
	Tue, 15 Oct 2024 12:58:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728997099;
	bh=be8Akbk/jYXBweHjt+CKakfdNT4PQrCS36y9HClJe6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZoyC51B/nZ5AEuTGWba86TA36EWpR9KuiEuuRfBTs5b4a3vAlrvdlYkna2zmfT8qZ
	 ElqrqA0qhPpuUfaVnZGiJ8YWfslga6Ld9kWhn6K28cYtZcS5kvgrK6jXrC0mG1zLuC
	 XYFfDHup1WnMtHkOs2QIGLzcSncqN+wT79H5r+/o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	En-Wei WU <en-wei.wu@canonical.com>,
	Heiner Kallweit <hkallweit1@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 087/518] r8169: disable ALDPS per default for RTL8125
Date: Tue, 15 Oct 2024 14:39:51 +0200
Message-ID: <20241015123920.362371212@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015123916.821186887@linuxfoundation.org>
References: <20241015123916.821186887@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Heiner Kallweit <hkallweit1@gmail.com>

[ Upstream commit b9c7ac4fe22c608acf6153a3329df2b6b6cd416c ]

En-Wei reported that traffic breaks if cable is unplugged for more
than 3s and then re-plugged. This was supposed to be fixed by
621735f59064 ("r8169: fix rare issue with broken rx after link-down on
RTL8125"). But apparently this didn't fix the issue for everybody.
The 3s threshold rang a bell, as this is the delay after which ALDPS
kicks in. And indeed disabling ALDPS fixes the issue for this user.
Maybe this fixes the issue in general. In a follow-up step we could
remove the first fix attempt and see whether anybody complains.

Fixes: f1bce4ad2f1c ("r8169: add support for RTL8125")
Tested-by: En-Wei WU <en-wei.wu@canonical.com>
Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
Link: https://patch.msgid.link/778b9d86-05c4-4856-be59-cde4487b9e52@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/realtek/r8169_phy_config.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/realtek/r8169_phy_config.c b/drivers/net/ethernet/realtek/r8169_phy_config.c
index e18a76f5049fd..f8f6f2ce3db3b 100644
--- a/drivers/net/ethernet/realtek/r8169_phy_config.c
+++ b/drivers/net/ethernet/realtek/r8169_phy_config.c
@@ -1263,6 +1263,7 @@ static void rtl8125a_2_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0xa86, 0x15, 0x0001, 0x0000);
 	rtl8168g_enable_gphy_10m(phydev);
 
+	rtl8168g_disable_aldps(phydev);
 	rtl8125a_config_eee_phy(phydev);
 }
 
@@ -1302,6 +1303,7 @@ static void rtl8125b_hw_phy_config(struct rtl8169_private *tp,
 	phy_modify_paged(phydev, 0xbf8, 0x12, 0xe000, 0xa000);
 
 	rtl8125_legacy_force_mode(phydev);
+	rtl8168g_disable_aldps(phydev);
 	rtl8125b_config_eee_phy(phydev);
 }
 
-- 
2.43.0



