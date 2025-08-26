Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 159CA3568E0;
	Tue, 26 Aug 2025 14:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217811; cv=none; b=AQ/xj1gLd6+N7UY5U17KCscCMzy5RJqB9wXuakvZ1BPqNXtWZXN9H94Ebm7RhrPa8Qkhx7PawMmW1ATwoo8Z2aDDJwsGheJnA+HLgu4FLaV3f/x4+1xoUYejPD8gL08TCoSnIMxierebVHYFHkgoWSORNpp9co5eVDAunRGkDUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217811; c=relaxed/simple;
	bh=/Z0wcSBZRe9oS4+feIXp+z7NavFrX3yebaMGapcMOwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=pe9c0XVEMxKOr5Bd/Fk0WvVJldhLp1iqfXQtbxL6c5wrIUIgLNYCi8vZUpUbKEfhio1NJ6vzdNzkoDhZ0W9Ae/yMUWumKGfIDIYgo4ILS1BN1J4OMqZoY9dMf8V8qgkk/n+maWk3I0D7Xmc2bZ179gKrE7FsKxqD1JPAF/L4WE0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oYp5wDgx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oYp5wDgx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A258C4CEF1;
	Tue, 26 Aug 2025 14:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217810;
	bh=/Z0wcSBZRe9oS4+feIXp+z7NavFrX3yebaMGapcMOwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oYp5wDgxckrZWlomLSG5pFTGrD0ppCiPtboM57yEycC9FE+ylO+imiSTY0DsVxYWJ
	 RoB6YPyY+qeiOTIEPYSU4hd4+1HDHCroCidgvuTcsjUdd+rsUx7TDWYCHZIpuaZ8z7
	 Wtlb3iJySnHODAvKqNwzqkYbJ1Xqcopodxw1MJWA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 284/523] net: dsa: b53: prevent SWITCH_CTRL access on BCM5325
Date: Tue, 26 Aug 2025 13:08:14 +0200
Message-ID: <20250826110931.442494076@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Álvaro Fernández Rojas <noltari@gmail.com>

[ Upstream commit 22ccaaca43440e90a3b68d2183045b42247dc4be ]

BCM5325 doesn't implement SWITCH_CTRL register so we should avoid reading
or writing it.

Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>
Link: https://patch.msgid.link/20250614080000.1884236-8-noltari@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index 5840001ea3e7..cb341a4d7540 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -339,11 +339,12 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 
 	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_MODE, mgmt);
 
-	/* Include IMP port in dumb forwarding mode
-	 */
-	b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, &mgmt);
-	mgmt |= B53_MII_DUMB_FWDG_EN;
-	b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
+	if (!is5325(dev)) {
+		/* Include IMP port in dumb forwarding mode */
+		b53_read8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, &mgmt);
+		mgmt |= B53_MII_DUMB_FWDG_EN;
+		b53_write8(dev, B53_CTRL_PAGE, B53_SWITCH_CTRL, mgmt);
+	}
 
 	/* Look at B53_UC_FWD_EN and B53_MC_FWD_EN to decide whether
 	 * frames should be flooded or not.
-- 
2.39.5



