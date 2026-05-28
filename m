Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FD7033F5BE;
	Thu, 28 May 2026 20:30:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780000214; cv=none; b=f9+yY5htrudR/sO3pPwNk2/zccDnIDp9qhckorTfgTrLzCozqoeB8z5/f+vJvb23G45SCg2cZqIHn7HYMzlCJ+Yud4fmS3CAApCMLztFZFlc1f/+BIH/BoPDhK5PaTj6BLBpzOnYZJc0TPw/ktMm/U0IOD7QmtQ5VyG9yZrxRo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780000214; c=relaxed/simple;
	bh=/bVpzCJw+JHJNaHTUlmmZMv6bXF+/ErMkd0eVymDi4c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cWk+BwpyKy5XirwR1Tsuqrjbav3f60JW57gkWzZ0y3TDO21sA7eEM5ASwiD3uP0Qqdr82uhqLX9IUD3dNUGi1fm4JJjj1Unr+05E7PP/LTKk6ggiKYJNahehoIGuRidu9ORMIA30c83xXGSd+XghkscF1rer4wojsCe+MleDNYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U4KEWggv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U4KEWggv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23BF31F000E9;
	Thu, 28 May 2026 20:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780000212;
	bh=+7gXhbbZPtd2VdbbUmb3YsKNUxAB1Ofq49gScUBOtk0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U4KEWggv11cknsccutd+aRkSsgrGwrcWzA303nofseAXBA/jQGhjq10pdyJiRTph7
	 JoZgbxyXX7jfYNf19L2mK6Mu00tMlsoygKIfxLIDv4zM0Y12Fs+Lid2gUYcPDMnva+
	 UqEQn82+tGXkffqAtzimZPaH0BsZgkq3JBn1QdBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicolai Buchwitz <nb@tipi-net.de>,
	Andrew Lunn <andrew@lunn.ch>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 341/377] net: phy: honor eee_disabled_modes in phy_advertise_eee_all()
Date: Thu, 28 May 2026 21:49:39 +0200
Message-ID: <20260528194648.295951346@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nicolai Buchwitz <nb@tipi-net.de>

[ Upstream commit 8baa7506d793f0636e3f6f01b01ef7be19674d06 ]

phy_advertise_eee_all() copies supported_eee into advertising_eee
unconditionally, overwriting any filtering applied during phy_probe()
based on DT eee-broken-* properties or driver-populated
eee_disabled_modes. genphy_c45_ethtool_set_eee() calls this helper
when user space passes an empty advertisement, undoing the filtering.

Apply the same eee_disabled_modes mask in phy_advertise_eee_all() so
the filtering survives the copy, matching the pattern in phy_probe()
and phy_support_eee().

Fixes: b64691274f5d ("net: phy: add helper phy_advertise_eee_all")
Signed-off-by: Nicolai Buchwitz <nb@tipi-net.de>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://patch.msgid.link/20260518-devel-phy-support-eee-fix-v2-2-05b52626fa68@tipi-net.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy_device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 5d76bd1ffe279..78cf05a17f8ff 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -2792,7 +2792,8 @@ EXPORT_SYMBOL(phy_advertise_supported);
  */
 void phy_advertise_eee_all(struct phy_device *phydev)
 {
-	linkmode_copy(phydev->advertising_eee, phydev->supported_eee);
+	linkmode_andnot(phydev->advertising_eee, phydev->supported_eee,
+			phydev->eee_disabled_modes);
 }
 EXPORT_SYMBOL_GPL(phy_advertise_eee_all);
 
-- 
2.53.0



