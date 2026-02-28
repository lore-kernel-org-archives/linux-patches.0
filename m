Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D395313E31
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:52:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301123; cv=none; b=a6Gtifo8xZh9VyWu32MizCVvix4rK7tKt+Mo/Ez9U6/P8FeVOL/mNYO4tcUapq7a32KxqZBfVsyqiwfMHa4KNQUAfh0zZitNbag3+SxJf8PpbxKalGjmB20h7swccfkrCK0WnSxFNArn1POE/7/iuBNG9DC38pjWQL5KchjI1NI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301123; c=relaxed/simple;
	bh=r2xgP5PyfmenROj68v9m+9bJzfof5h81AA6cs0O7Ns4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=aBG787XV0fcdmOsTYB2GTJBldMduqvH/7ybKb/yLddGkUn6KmGDVjektM4fv7Ss9/jFQZ/iHqYAjcUSWIw509VUdZY2eW6CQCETFN1+gpPiiIkRL0g/ABXE+/tAPyPYaMsfoaw87SriviWTeBqZUKQI4XYAlbsYlX1ZU1M2WG34=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=L0KygROp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="L0KygROp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CB62C2BC87;
	Sat, 28 Feb 2026 17:52:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301123;
	bh=r2xgP5PyfmenROj68v9m+9bJzfof5h81AA6cs0O7Ns4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L0KygROpynMtp7bgR9+tDv9mn3WoX5xsmPVrejEWucdCPNheewpuU4ClWjogHGMNJ
	 efAKV4bBEd9ToB5ouMci3RPG2Lf66NvzChdUQENGhlbnupsjApzvhRf5iHdy7pO+3U
	 45Koob1BXmtm3XaE6hziCFUKbIokmQqOsCpxNJaRYuMfkl9+kFP61C3DIWNX2kCudR
	 00cgkEr/5tDQUSyBhy50HVZf6ZDe/EQigp2/plB2m+/LpxCDD0f6b/Li6/aHAFGQOD
	 A2jsGbc1jPE+Or7yQBBn0qmNElzOQ/2fN7xys8mRCA9Yoa9UBKj/Vo39YwuSMxjeCU
	 2j7PtTB2H/Mqg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: =?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 281/752] net: sfp: add quirk for Lantech 8330-265D
Date: Sat, 28 Feb 2026 12:39:52 -0500
Message-ID: <20260228174750.1542406-281-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 86a8e8e0ddbc3d14c799536eb888180b84d002f3 ]

Similar to Lantech 8330-262D-E, the Lantech 8330-265D also reports
2500MBd instead of 3125MBd.

Also, all 8330-265D report normal RX_LOS in EEPROM, but some signal
inverted RX_LOS. We therefore need to ignore RX_LOS on these modules.

Signed-off-by: Marek Behún <kabel@kernel.org>
Link: https://patch.msgid.link/20260128170044.15576-1-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index 3e023723887c4..43aefdd8b70f7 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -532,9 +532,13 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
 		  sfp_fixup_ignore_tx_fault),
 
-	// Lantech 8330-262D-E can operate at 2500base-X, but incorrectly report
-	// 2500MBd NRZ in their EEPROM
+	// Lantech 8330-262D-E and 8330-265D can operate at 2500base-X, but
+	// incorrectly report 2500MBd NRZ in their EEPROM.
+	// Some 8330-265D modules have inverted LOS, while all of them report
+	// normal LOS in EEPROM. Therefore we need to ignore LOS entirely.
 	SFP_QUIRK_S("Lantech", "8330-262D-E", sfp_quirk_2500basex),
+	SFP_QUIRK("Lantech", "8330-265D", sfp_quirk_2500basex,
+		  sfp_fixup_ignore_los),
 
 	SFP_QUIRK_S("UBNT", "UF-INSTANT", sfp_quirk_ubnt_uf_instant),
 
-- 
2.51.0

