Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17030183CB8;
	Tue,  8 Oct 2024 12:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391564; cv=none; b=V95mXwdnWO5+P6TCvFP5FtTkIbrbQjm8Hl42e3wL/6R7K0K3vGD4EuZMxVPmvjBW5VKVP79wzPSlDc8vTtahtzPhhWPrdBbuhqLQfCRvveekiIvcyMaRNzQWjmRlk44xudaNFLi8YnU4dSSykTmiS+m8Y3HyL0lNfEmZtneff/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391564; c=relaxed/simple;
	bh=n+R/viSZ1rP1lBXXF28nTxftQEpDbp+FQ0Tv1vi1/Lg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=EijIMPpk9yb7UNQo6x6n7/NLJlZ0K9ZclZ2BTt1O2ZQlACdLDrk8eYQdCNgLFzrjbUdu7+lxOA+oijdMJ11lEafn8Td2PoW64MabEqdMZN7v3NvToiRaSkqBhAqetzh9J665lmPMZOy3ORDw8smSXVRw7uC+3SPBGQyO7XDICqM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LIaeICsi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LIaeICsi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AEADC4CEC7;
	Tue,  8 Oct 2024 12:46:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391563;
	bh=n+R/viSZ1rP1lBXXF28nTxftQEpDbp+FQ0Tv1vi1/Lg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LIaeICsiO8alWWf1VoOiJKQWy+WSvVjDt8ArZMHTK9PjEck4A+WEZCeDtYugCUP3H
	 DcoFTM1tsllrdD5SQisHgsaXZT+vBamW2gd5R7ZYrZuXtTnaCcswaewNUMHRH5PhPV
	 hz+FSTQvD5jy/4o8XV/M6TBiA1zvpWBWS9MoY+Fo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Niklas=20S=C3=B6derlund?= <niklas.soderlund+renesas@ragnatech.se>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Andrew Lunn <andrew@lunn.ch>,
	Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>,
	Geert Uytterhoeven <geert+renesas@glider.be>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 154/558] net: phy: Check for read errors in SIOCGMIIREG
Date: Tue,  8 Oct 2024 14:03:04 +0200
Message-ID: <20241008115708.420803986@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>

[ Upstream commit 569bf6d481b0b823c3c9c3b8be77908fd7caf66b ]

When reading registers from the PHY using the SIOCGMIIREG IOCTL any
errors returned from either mdiobus_read() or mdiobus_c45_read() are
ignored, and parts of the returned error is passed as the register value
back to user-space.

For example, if mdiobus_c45_read() is used with a bus that do not
implement the read_c45() callback -EOPNOTSUPP is returned. This is
however directly stored in mii_data->val_out and returned as the
registers content. As val_out is a u16 the error code is truncated and
returned as a plausible register value.

Fix this by first checking the return value for errors before returning
it as the register content.

Before this patch,

    # phytool read eth0/0:1/0
    0xffa1

After this change,

    $ phytool read eth0/0:1/0
    error: phy_read (-95)

Signed-off-by: Niklas Söderlund <niklas.soderlund+renesas@ragnatech.se>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Reviewed-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Tested-by: Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Reviewed-by: Geert Uytterhoeven <geert+renesas@glider.be>
Link: https://patch.msgid.link/20240903171536.628930-1-niklas.soderlund+renesas@ragnatech.se
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/phy/phy.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/net/phy/phy.c b/drivers/net/phy/phy.c
index 785182fa5fe01..b88d857ea23b8 100644
--- a/drivers/net/phy/phy.c
+++ b/drivers/net/phy/phy.c
@@ -342,14 +342,19 @@ int phy_mii_ioctl(struct phy_device *phydev, struct ifreq *ifr, int cmd)
 		if (mdio_phy_id_is_c45(mii_data->phy_id)) {
 			prtad = mdio_phy_id_prtad(mii_data->phy_id);
 			devad = mdio_phy_id_devad(mii_data->phy_id);
-			mii_data->val_out = mdiobus_c45_read(
-				phydev->mdio.bus, prtad, devad,
-				mii_data->reg_num);
+			ret = mdiobus_c45_read(phydev->mdio.bus, prtad, devad,
+					       mii_data->reg_num);
+
 		} else {
-			mii_data->val_out = mdiobus_read(
-				phydev->mdio.bus, mii_data->phy_id,
-				mii_data->reg_num);
+			ret = mdiobus_read(phydev->mdio.bus, mii_data->phy_id,
+					   mii_data->reg_num);
 		}
+
+		if (ret < 0)
+			return ret;
+
+		mii_data->val_out = ret;
+
 		return 0;
 
 	case SIOCSMIIREG:
-- 
2.43.0



