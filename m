Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC0F285056;
	Mon, 23 Mar 2026 15:04:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278253; cv=none; b=jHZkp5sZl4jkxWSMBfIzONt9NZsJzYUhe3pbm2h3H6Fv5FxZmsx187nUbWa7HuJp+KFwCAZ0jqwRZXAggi27MWtOJ9dBAGOuHcurEdByKWT0bhukuTvC1AoiYHanUJ8TQDTyZeWXQY9vqL43sEyTetqUxW42nlEskySt/Q0rUuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278253; c=relaxed/simple;
	bh=kwZ5sQW5MNiZrqfW4WOlSOxeIal45BGl7hoQ0bZAt6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VuF57/op+OdNDad/ZN9193EaC1ZKbpixM+QXacshAgPr7l2XvnTJfnLSwMiaybU31XMluGHpwiKdFk0J3H7NZBRVeZEkGyZDmXKWYoNU/nBq3giwBk/x8ygG+Hj0r45eD7TYnaOHiojldQJg7v3axWTC97zMnvzKF9gggpCSqeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cjDO04eh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cjDO04eh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 314CFC4CEF7;
	Mon, 23 Mar 2026 15:04:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278253;
	bh=kwZ5sQW5MNiZrqfW4WOlSOxeIal45BGl7hoQ0bZAt6g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cjDO04ehp6xITzDid6VGzTDKc0OEDj6qcCJh+BeJIN/TJhcTVEjz2eDmktK8o9RLz
	 GzeFUZz3W58nytJEJsCcnpO+QWRpaayz5KzEo08VhLBL2bdzBqDtq4ThOKqSQIYotP
	 GNUW37k9BIzv5RzKgrEgqYX7Rq0m8x1jME+y3Txw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Morgan <macromorgan@hotmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 232/567] net: sfp: add quirk for Potron SFP+ XGSPON ONU Stick
Date: Mon, 23 Mar 2026 14:42:32 +0100
Message-ID: <20260323134539.573791778@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chris Morgan <macromorgan@hotmail.com>

[ Upstream commit dfec1c14aecee6813f9bafc7b560cc3a31d24079 ]

Add quirk for Potron SFP+ XGSPON ONU Stick (YV SFP+ONT-XGSPON).

This device uses pins 2 and 7 for UART communication, so disable
TX_FAULT and LOS. Additionally as it is an embedded system in an
SFP+ form factor provide it enough time to fully boot before we
attempt to use it.

https://www.potrontec.com/index/index/list/cat_id/2.html#11-83
https://pon.wiki/xgs-pon/ont/potron-technology/x-onu-sfpp/

Signed-off-by: Chris Morgan <macromorgan@hotmail.com>
Link: https://patch.msgid.link/20250617180324.229487-1-macroalpha82@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 87d126852158 ("net: sfp: improve Huawei MA5671a fixup")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/sfp.c | 21 ++++++++++++++++++++-
 1 file changed, 20 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/sfp.c b/drivers/net/phy/sfp.c
index c47d7232d1c6e..6ef50d1ce2eda 100644
--- a/drivers/net/phy/sfp.c
+++ b/drivers/net/phy/sfp.c
@@ -359,6 +359,11 @@ static void sfp_fixup_ignore_tx_fault(struct sfp *sfp)
 	sfp->state_ignore_mask |= SFP_F_TX_FAULT;
 }
 
+static void sfp_fixup_ignore_hw(struct sfp *sfp, unsigned int mask)
+{
+	sfp->state_hw_mask &= ~mask;
+}
+
 static void sfp_fixup_nokia(struct sfp *sfp)
 {
 	sfp_fixup_long_startup(sfp);
@@ -392,7 +397,19 @@ static void sfp_fixup_halny_gsfp(struct sfp *sfp)
 	 * these are possibly used for other purposes on this
 	 * module, e.g. a serial port.
 	 */
-	sfp->state_hw_mask &= ~(SFP_F_TX_FAULT | SFP_F_LOS);
+	sfp_fixup_ignore_hw(sfp, SFP_F_TX_FAULT | SFP_F_LOS);
+}
+
+static void sfp_fixup_potron(struct sfp *sfp)
+{
+	/*
+	 * The TX_FAULT and LOS pins on this device are used for serial
+	 * communication, so ignore them. Additionally, provide extra
+	 * time for this device to fully start up.
+	 */
+
+	sfp_fixup_long_startup(sfp);
+	sfp_fixup_ignore_hw(sfp, SFP_F_TX_FAULT | SFP_F_LOS);
 }
 
 static void sfp_fixup_rollball(struct sfp *sfp)
@@ -500,6 +517,8 @@ static const struct sfp_quirk sfp_quirks[] = {
 	SFP_QUIRK_F("Walsun", "HXSX-ATRC-1", sfp_fixup_fs_10gt),
 	SFP_QUIRK_F("Walsun", "HXSX-ATRI-1", sfp_fixup_fs_10gt),
 
+	SFP_QUIRK_F("YV", "SFP+ONU-XGSPON", sfp_fixup_potron),
+
 	// OEM SFP-GE-T is a 1000Base-T module with broken TX_FAULT indicator
 	SFP_QUIRK_F("OEM", "SFP-GE-T", sfp_fixup_ignore_tx_fault),
 
-- 
2.51.0



