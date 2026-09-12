Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09B3FCA6F;
	Sat, 12 Sep 2026 11:13:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211636; cv=none; b=T7jhQpHSc3fwqdP7vNukwKimBwH1GdASfA1uKnqkvOf1v4nGODcA/LtG5VL5PGWrJVK25fcNR1+uJXl/rP+tWKg6YNJ1d6gmTNxcU1xD/asylpztvJTaLtwrDVCM+O6FX5xI8o7sk9XDHsbCmnyMvfHoGq4EnN8oZ7w7RiGuzvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211636; c=relaxed/simple;
	bh=053yEyh2ueR2DZmYWK4scqYFfvq/v0qTRxAviKwVXFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QUrvOcMLehDdazr9S7t8fujIqercRWhKf4ltHl/DQlMisww95s4nC5+ruPEyrsW5JJ+Cl4sTmdrFh7NuWEOqol08e7kVPEGQA2PeA348YgTtX4pKUnRVtSxk23kNjA6Wi94//QmD1Ib6WMhQjcN4kAc0WgQ2xNWLZ6JmgGNcRrA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MopZAoko; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MopZAoko"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 971C51F000FF;
	Sat, 12 Sep 2026 11:13:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211634;
	bh=RF6/q0Tbv3G8s1nVh37ALy7ksGfU4XQobMALF8FCZPo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MopZAokoQmhUAvyYlkUD1ykOIfhvVEwPXkLkxB5n5LCxblTV4TsDZbrgLO1d21Iwr
	 umBek5hpXE4SibDOcYm9xuXUjqiIK/m/LECzx0q2rxKkvlzyP6pDLxQfO+ZhB3l51C
	 RJ5V7T6TAsHxi/g8puEfGChoVNfnDWkIJ6vQuKLA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Vladimir Oltean <olteanv@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1270/1518] net: dsa: mv88e6xxx: Fix PCS link check on CMODE read error
Date: Sat, 12 Sep 2026 08:57:19 +0200
Message-ID: <20260912065652.240832536@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
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
index 36993400837ea..e09019ed19fb6 100644
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



