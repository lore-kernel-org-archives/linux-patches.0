Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24AAD148315;
	Tue, 25 Jun 2024 09:36:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308218; cv=none; b=fWNv0anc4Wb/cO/H03CalfHiEh8g5trusiInk0iMwgKM4kjtMUmSe7Rq/aoZubpPNgUhwPbXnuNfDwxngYIhF2jG5C0VZx0Y7PsF1kz+Y555GprVYnj7RkbfAeUegu+OYzEmm6olp6fVJe3MaTY7mCuejGL1o/WMYKhJoHirkqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308218; c=relaxed/simple;
	bh=WYwE9X3haBp3U7712ujhV9TGeenT1a1yX0zfs/OAFl0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=JyeoxhgfwlhUrdwcwcTWaF1zcpTgWU16QI86+CUqTo6XQrnvCYulail7Jv2U48azzXkibqaKsVfwlFSeXq7+8ctZRJ5bc9gIymkztVS4oeC7Xmu+Hegj5HgYZrpQdhzWwXgzSZvpniJGnIVvCM3/V9eEF8Q6Kuaxq+Bq8H/ELyg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k310aJGA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k310aJGA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D27DC32781;
	Tue, 25 Jun 2024 09:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308218;
	bh=WYwE9X3haBp3U7712ujhV9TGeenT1a1yX0zfs/OAFl0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k310aJGAGsOprLoLTRo0S9MAtqsbEKgpxaSbOCAzSIAxPrCsdYl1C1Xk7R0lAx07k
	 Z1vo/XGxEXt2oJMxjoj0k4ZQc1v13caKu/cI2n5BktMH05ej8QbJw3n7N/09LwIAIC
	 vAAD7KjVwVMSKASB77Yvm/75Uw6IZzvrvbl5XJ8E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 029/250] net: sfp: enhance quirk for Fibrestore 2.5G copper SFP module
Date: Tue, 25 Jun 2024 11:29:47 +0200
Message-ID: <20240625085549.174362251@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit cd4a32e60061789676f7f018a94fcc9ec56732a0 ]

Enhance the quirk for Fibrestore 2.5G copper SFP module. The original
commit e27aca3760c0 ("net: sfp: add quirk for FS's 2.5G copper SFP")
introducing the quirk says that the PHY is inaccessible, but that is
not true.

The module uses Rollball protocol to talk to the PHY, and needs a 4
second wait before probing it, same as FS 10G module.

The PHY inside the module is Realtek RTL8221B-VB-CG PHY. The realtek
driver recently gained support to set it up via clause 45 accesses.

Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Link: https://lore.kernel.org/r/20240423085039.26957-2-kabel@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index d999d9baadb26..6e42d4034b520 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -385,18 +385,23 @@ static void sfp_fixup_rollball(struct sfp *sfp)
 	sfp->phy_t_retry = msecs_to_jiffies(1000);
 }
 
-static void sfp_fixup_fs_10gt(struct sfp *sfp)
+static void sfp_fixup_fs_2_5gt(struct sfp *sfp)
 {
-	sfp_fixup_10gbaset_30m(sfp);
 	sfp_fixup_rollball(sfp);
 
-	/* The RollBall fixup is not enough for FS modules, the AQR chip inside
+	/* The RollBall fixup is not enough for FS modules, the PHY chip inside
 	 * them does not return 0xffff for PHY ID registers in all MMDs for the
 	 * while initializing. They need a 4 second wait before accessing PHY.
 	 */
 	sfp->module_t_wait = msecs_to_jiffies(4000);
 }
 
+static void sfp_fixup_fs_10gt(struct sfp *sfp)
+{
+	sfp_fixup_10gbaset_30m(sfp);
+	sfp_fixup_fs_2_5gt(sfp);
+}
+
 static void sfp_fixup_halny_gsfp(struct sfp *sfp)
 {
 	/* Ignore the TX_FAULT and LOS signals on this module.
@@ -472,6 +477,10 @@ static const struct sfp_quirk sfp_quirks[] = {
 	// Rollball protocol to talk to the PHY.
 	SFP_QUIRK_F("FS", "SFP-10G-T", sfp_fixup_fs_10gt),
 
+	// Fiberstore SFP-2.5G-T uses Rollball protocol to talk to the PHY and
+	// needs 4 sec wait before probing the PHY.
+	SFP_QUIRK_F("FS", "SFP-2.5G-T", sfp_fixup_fs_2_5gt),
+
 	// Fiberstore GPON-ONU-34-20BI can operate at 2500base-X, but report 1.2GBd
 	// NRZ in their EEPROM
 	SFP_QUIRK("FS", "GPON-ONU-34-20BI", sfp_quirk_2500basex,
@@ -488,9 +497,6 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK("HUAWEI", "MA5671A", sfp_quirk_2500basex,
 		  sfp_fixup_ignore_tx_fault),
 
-	// FS 2.5G Base-T
-	SFP_QUIRK_M("FS", "SFP-2.5G-T", sfp_quirk_oem_2_5g),
-
 	// Lantech 8330-262D-E can operate at 2500base-X, but incorrectly report
 	// 2500MBd NRZ in their EEPROM
 	SFP_QUIRK_M("Lantech", "8330-262D-E", sfp_quirk_2500basex),
-- 
2.43.0



