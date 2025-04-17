Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B103F256C82;
	Thu, 17 Apr 2025 17:59:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912785; cv=none; b=tQWFVTrc/gOINdGR1uGX89iP0u82EXDqE6rs+6VnYJ+lVYYZnLo9E3H3ngnv9E1XbLTExKkXMKZDGZHDVN1UDV3vrVgwYJQbjA9VkEKuJ+gyXgG/c4ugsFpzX44pJ0ykM5HoX70W01ndq7N4LUzDgzAgGBGaOijO16sOfHMLiAQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912785; c=relaxed/simple;
	bh=YVmD0M42Aa+xbs9cjGZ1Anh283O8U51U5iAJk3SXpRI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bSBhSRl2aBGkVlTh9xZuwprFh0tcjQZ+RPEKerJAVN7BlE7a9pHFP3i5/YAh5PgKl0Pgc+FcaxKiGVYR+kl95doQMO/ZlAcVnlkcF31j1iS38QAlqiMxbSC5aqFeI4i2fspOYeARzEiM+VLqH1B+p/d2k/kd0zxxP8mxeBW/zNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SKmWYsMN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SKmWYsMN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B28EC4CEE4;
	Thu, 17 Apr 2025 17:59:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912785;
	bh=YVmD0M42Aa+xbs9cjGZ1Anh283O8U51U5iAJk3SXpRI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SKmWYsMNWEko84mXiTHOTtp5VBCtBNHqCcjyknzvelK5qZMFoKyeQXjKHc9d5SGMz
	 iPFH0BrkhExW4jd2lfoE1hzUFZzresWBorRpgOB8rO2M1q5Z0cA3L2wskzZcu5/zrG
	 bFCWCfOMbNqcYTm7g2bkN5EXbjyjZqITlbZLUsWs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Martin Schiller <ms@dev.tdt.de>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 123/449] net: sfp: add quirk for FS SFP-10GM-T copper SFP+ module
Date: Thu, 17 Apr 2025 19:46:51 +0200
Message-ID: <20250417175122.917754812@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Schiller <ms@dev.tdt.de>

[ Upstream commit 05ec5c085eb7ae044d49e04a3cff194a0b2a3251 ]

Add quirk for a copper SFP that identifies itself as "FS" "SFP-10GM-T".
It uses RollBall protocol to talk to the PHY and needs 4 sec wait before
probing the PHY.

Signed-off-by: Martin Schiller <ms@dev.tdt.de>
Link: https://patch.msgid.link/20250227071058.1520027-1-ms@dev.tdt.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 9369f52977694..c88217af44a14 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -385,7 +385,7 @@ static void sfp_fixup_rollball(struct sfp *sfp)
 	sfp->phy_t_retry = msecs_to_jiffies(1000);
 }
 
-static void sfp_fixup_fs_2_5gt(struct sfp *sfp)
+static void sfp_fixup_rollball_wait4s(struct sfp *sfp)
 {
 	sfp_fixup_rollball(sfp);
 
@@ -399,7 +399,7 @@ static void sfp_fixup_fs_2_5gt(struct sfp *sfp)
 static void sfp_fixup_fs_10gt(struct sfp *sfp)
 {
 	sfp_fixup_10gbaset_30m(sfp);
-	sfp_fixup_fs_2_5gt(sfp);
+	sfp_fixup_rollball_wait4s(sfp);
 }
 
 static void sfp_fixup_halny_gsfp(struct sfp *sfp)
@@ -479,9 +479,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 	// PHY.
 	SFP_QUIRK_F("FS", "SFP-10G-T", sfp_fixup_fs_10gt),
 
-	// Fiberstore SFP-2.5G-T uses Rollball protocol to talk to the PHY and
-	// needs 4 sec wait before probing the PHY.
-	SFP_QUIRK_F("FS", "SFP-2.5G-T", sfp_fixup_fs_2_5gt),
+	// Fiberstore SFP-2.5G-T and SFP-10GM-T uses Rollball protocol to talk
+	// to the PHY and needs 4 sec wait before probing the PHY.
+	SFP_QUIRK_F("FS", "SFP-2.5G-T", sfp_fixup_rollball_wait4s),
+	SFP_QUIRK_F("FS", "SFP-10GM-T", sfp_fixup_rollball_wait4s),
 
 	// Fiberstore GPON-ONU-34-20BI can operate at 2500base-X, but report 1.2GBd
 	// NRZ in their EEPROM
-- 
2.39.5



