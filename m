Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2098834D4E3;
	Wed,  3 Dec 2025 16:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764777764; cv=none; b=Vw20Tydcshb3xO4YqtUOm9GRzplAhslImtN93mFPXBccfkeeFa/30YCdetNyMrc7vb0nJBerjbKSUvgtbFDzA5gYV3ZDUvter6muo2zovv1XIQgnKLSOzGEHpz8iWbkeebYDgUGbTVpMwi7jF7rIby2SCNUn7ZhTnvXkmELoEdA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764777764; c=relaxed/simple;
	bh=9drf+E/vm6ahuOmmdM4JZh9JSZwmbgwBfTxDL4dbImU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNI38faSz6tqW+aKJ+74mhfvlpvIQf29fmMyvp8TDQpbBi9vhbI4cwmdK4b+qILhlw2s/ylR5YSRZteOrMh2S7Krr9JOGGVyhCfbDkwq01JdCpcdtUmzjJBZpyxI51kTx2VnDlqztS1D9Wf4SAvdSrQlkC9rDHQNEEYH0ZNDzJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HNugA+ZW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HNugA+ZW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98021C4CEF5;
	Wed,  3 Dec 2025 16:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764777764;
	bh=9drf+E/vm6ahuOmmdM4JZh9JSZwmbgwBfTxDL4dbImU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HNugA+ZWZHHwfna8YBq0uvRj4kNlvKAAzcLu0/IEf0cPGm0ZdwPyb27LrhDe+UKrH
	 qam4ZIoq2KSyscBLJ8zJJgYM4Yk7uUjC962fzRLAMJadnoxEVydXBkY7EsLqO/fKAa
	 Db8MnqahQ6PMN5kjKZOiY7MJEAiQ4bVUJkiKZppA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rohan G Thomas <rohan.g.thomas@altera.com>,
	Matthew Gerlach <matthew.gerlach@altera.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 140/392] net: phy: marvell: Fix 88e1510 downshift counter errata
Date: Wed,  3 Dec 2025 16:24:50 +0100
Message-ID: <20251203152419.240334893@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152414.082328008@linuxfoundation.org>
References: <20251203152414.082328008@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rohan G Thomas <rohan.g.thomas@altera.com>

[ Upstream commit deb105f49879dd50d595f7f55207d6e74dec34e6 ]

The 88e1510 PHY has an erratum where the phy downshift counter is not
cleared after phy being suspended(BMCR_PDOWN set) and then later
resumed(BMCR_PDOWN cleared). This can cause the gigabit link to
intermittently downshift to a lower speed.

Disabling and re-enabling the downshift feature clears the counter,
allowing the PHY to retry gigabit link negotiation up to the programmed
retry count times before downshifting. This behavior has been observed
on copper links.

Signed-off-by: Rohan G Thomas <rohan.g.thomas@altera.com>
Reviewed-by: Matthew Gerlach <matthew.gerlach@altera.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20250906-marvell_fix-v2-1-f6efb286937f@altera.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/marvell.c | 39 ++++++++++++++++++++++++++++++++++++++-
 1 file changed, 38 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/marvell.c b/drivers/net/phy/marvell.c
index 87975b843d276..4557bb2f68219 100644
--- a/drivers/net/phy/marvell.c
+++ b/drivers/net/phy/marvell.c
@@ -1753,6 +1753,43 @@ static int marvell_resume(struct phy_device *phydev)
 	return err;
 }
 
+/* m88e1510_resume
+ *
+ * The 88e1510 PHY has an erratum where the phy downshift counter is not cleared
+ * after phy being suspended(BMCR_PDOWN set) and then later resumed(BMCR_PDOWN
+ * cleared). This can cause the link to intermittently downshift to a lower speed.
+ *
+ * Disabling and re-enabling the downshift feature clears the counter, allowing
+ * the PHY to retry gigabit link negotiation up to the programmed retry count
+ * before downshifting. This behavior has been observed on copper links.
+ */
+static int m88e1510_resume(struct phy_device *phydev)
+{
+	int err;
+	u8 cnt = 0;
+
+	err = marvell_resume(phydev);
+	if (err < 0)
+		return err;
+
+	/* read downshift counter value */
+	err = m88e1011_get_downshift(phydev, &cnt);
+	if (err < 0)
+		return err;
+
+	if (cnt) {
+		/* downshift disabled */
+		err = m88e1011_set_downshift(phydev, 0);
+		if (err < 0)
+			return err;
+
+		/* downshift enabled, with previous counter value */
+		err = m88e1011_set_downshift(phydev, cnt);
+	}
+
+	return err;
+}
+
 static int marvell_aneg_done(struct phy_device *phydev)
 {
 	int retval = phy_read(phydev, MII_M1011_PHY_STATUS);
@@ -3134,7 +3171,7 @@ static struct phy_driver marvell_drivers[] = {
 		.handle_interrupt = marvell_handle_interrupt,
 		.get_wol = m88e1318_get_wol,
 		.set_wol = m88e1318_set_wol,
-		.resume = marvell_resume,
+		.resume = m88e1510_resume,
 		.suspend = marvell_suspend,
 		.read_page = marvell_read_page,
 		.write_page = marvell_write_page,
-- 
2.51.0



