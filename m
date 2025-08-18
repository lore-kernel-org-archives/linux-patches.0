Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C2A534AB01;
	Mon, 18 Aug 2025 14:01:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755525682; cv=none; b=cjxOGMBeOwIDyQJWJZ4AtBTyydCcz4/j72I2ukhxOVb9+8mwa3FF3fAHChLw10ciEgYIJ/qoHEU+yBOCOuDbodghiMp0qLh+ikSFFWuTorvKLGvokeuHwjqx2O9AVTstI22q77iSIX+kj615Q8D8YTLeVA/lVOUopaj+7jUabSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755525682; c=relaxed/simple;
	bh=3/x6A2GdN34xHKKFyr8fPqMWQluhcNEphgsdgobOinA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Je9cfcFxYwcFJPzakQ8XRN1RAAqcdMDCt4EQuXc7sxe5s++oGeYGiAD+BNqpyi1ZCmDCbjDUIvqyNq3YszdPezeDHI2K9HyKt3sI4d/PsZCl4cVKUFrygMZP6vjps35/5VB/lD9I6HM7TV+LamLUEkNcn1oqIe2+5Ec+wNlCoxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1JgsfJwj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1JgsfJwj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90874C4CEEB;
	Mon, 18 Aug 2025 14:01:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755525682;
	bh=3/x6A2GdN34xHKKFyr8fPqMWQluhcNEphgsdgobOinA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1JgsfJwjgw0bGaeOxp681DeuZyvd1li4V/WZcNVG657BpEoeKTXI4juCM2NXOgAGM
	 KgsrJPkHxO0NRz6bHVlftYwUeFFBFSoG3kZfOqOtxMXv4c0uwsoY0UDtuVOPuWdLjU
	 Hz5e6ZW2vv1+KGM/+tM24uDv5gyCrmywMRuol0Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	=?UTF-8?q?=C3=81lvaro=20Fern=C3=A1ndez=20Rojas?= <noltari@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.16 334/570] net: dsa: b53: prevent SWITCH_CTRL access on BCM5325
Date: Mon, 18 Aug 2025 14:45:21 +0200
Message-ID: <20250818124518.718399247@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
index 990d21fad939..bb0a5fd6a372 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -361,11 +361,12 @@ static void b53_set_forwarding(struct b53_device *dev, int enable)
 
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



