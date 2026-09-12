Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30896455626;
	Sat, 12 Sep 2026 13:12:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789218752; cv=none; b=LtT4MDbgwOEAqQZd6EeSoojlQsVLweSqTLe74FbqphML6vptW9WC6a+Ib33o82lM2kkl6QuF7lLfwkPEp9BBKlMiQkri/NE7KTzml9wghtYYbdn9NrrO1cBnPWfLoHwju/kogsz4WwYqqNvoRBbViSrVFnJiBJUma+eUiFxA7zI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789218752; c=relaxed/simple;
	bh=IobsdcotOHJGmsom1qsUY+S2nwm9iNu6MjHPEAEFRuQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Lja9HW3zJT3q3ubman2c4EguLoUMzV6WgJbH+H+X6EiN/WkqcuQMEcDgSwZXfd718S4dtS4Gej2Qvt56/WZ3h+eO5lNMMfH+glcJgxMdKXb+K6EsBSQLHet/iChBZjdv3UnfWaZMb+64VZeTMDhQujdOAVGy5XagFONDA66V0k0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=exqUxSBf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="exqUxSBf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 407D01F000FF;
	Sat, 12 Sep 2026 13:12:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789218750;
	bh=wKRXGXjrvru44t7idoYt0qRlZVOreAS0dKYxJC3U40I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=exqUxSBfq+KZm7QFhjubdQy+yVrVP2rdZ9MtvJMREeWpcod0lEKdhsUs7sWwC7DWr
	 Z0P4NkZSDyjHBVTgOevvwu7iLs1gzZqIvPapD8lH8KHn8oKEYQ354dG51L/iKaZGXh
	 fuDDSR6AbWBtJa52kFGZPGXbA2zv4Ne9Al13PwIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1202/1376] net: dsa: mv88e6xxx: Fix PCS link check on CMODE read error
Date: Sat, 12 Sep 2026 09:00:28 +0200
Message-ID: <20260912065634.337702785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 7b196e27ad58e612ad1c04b347d0c2135045aa14 ]

mv88e6352_pcs_link_check() ignores errors returned by
port_get_cmode(). If the port status register read fails,
mv88e6352_port_get_cmode() returns without setting cmode. The link check
then compares an uninitialized value and may incorrectly treat the PCS
as active.

Save the return value and fail the link check after releasing the
register lock. marvell_c22_pcs_get_state() initializes the reported link
state to down before calling the check, so a read failure is handled
safely until a later poll succeeds.

This issue was found by a static analysis checker and confirmed by manual
source review.

Fixes: 85764555442f ("net: dsa: mv88e6xxx: convert 88e6352 to phylink_pcs")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
Link: https://patch.msgid.link/20260813153131.3952970-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/mv88e6xxx/pcs-6352.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/mv88e6xxx/pcs-6352.c b/drivers/net/dsa/mv88e6xxx/pcs-6352.c
index 88f624b654702..f0b42786d5873 100644
--- a/drivers/net/dsa/mv88e6xxx/pcs-6352.c
+++ b/drivers/net/dsa/mv88e6xxx/pcs-6352.c
@@ -305,13 +305,16 @@ static bool mv88e6352_pcs_link_check(struct marvell_c22_pcs *mpcs)
 	struct mv88e6xxx_port *port = mpcs->port;
 	struct mv88e6xxx_chip *chip = port->chip;
 	u8 cmode;
+	int err;
 
 	/* Port 4 can be in auto-media mode. Check that the port is
 	 * associated with the mpcs.
 	 */
 	mv88e6xxx_reg_lock(chip);
-	chip->info->ops->port_get_cmode(chip, port->port, &cmode);
+	err = chip->info->ops->port_get_cmode(chip, port->port, &cmode);
 	mv88e6xxx_reg_unlock(chip);
+	if (err)
+		return false;
 
 	return cmode == MV88E6XXX_PORT_STS_CMODE_100BASEX ||
 	       cmode == MV88E6XXX_PORT_STS_CMODE_1000BASEX ||
-- 
2.53.0



