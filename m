Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6D956471250;
	Tue, 21 Jul 2026 19:09:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660953; cv=none; b=Wf1dGdypfNYlyzb1SgoUZ8UNPNvmpfdgEJADk8dGvSuH2JOvcuCbaG+2X28RB+VAkXGPtd2dFLXQ6dbqMp2VMHToJf/artua9geIu1djMgmHK43zoF9Jouwh44cvgIbAT1I4YWQC8UZv6hePk7Hw8L3ec4ElC2vjaXzF60ehb3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660953; c=relaxed/simple;
	bh=dN+0BrppuE1OGprLY/9RN2ON9kbI3v4bG+a8bonA3Rs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5QR9nHmrIjmm4YhaU6vWtrWQWxNcrf8qeqcQh1cdsdPf6NE+i3XUcy2pRxhZo7JV6PY5JzwlkJgPCg3MOgJuZ+Lqjyz5weA+q185SC4bZx6fFdtvOEskjMbT5JFyWSf8VUufGJTnu4VS/2Xdntn3XgyQigJ5UOP6MobQa4KeDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CjpljQCV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CjpljQCV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3F391F000E9;
	Tue, 21 Jul 2026 19:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660952;
	bh=8uWIt6vhJp+cmkOrpXeI4hCHpDwEC30/1E6tRcdFj58=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CjpljQCVp03V/ytDrL7xhgrJVLEe5O8N4joKtuJJFyxS85oZryzu/xBDZPtlA1W97
	 skw3+tBZuIioSXTpqpLqIpGHcEVgqSU0qBakki//uk7UmuTFrv54cmpsA60iPb5Zia
	 95rC60aWAyGSzpkCLLjazJqV+sPtemaqaLFkVtHo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Elad Nachman <enachman@marvell.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1175/2077] net: marvell: prestera: initialize err in prestera_port_sfp_bind
Date: Tue, 21 Jul 2026 17:14:08 +0200
Message-ID: <20260721152620.532632593@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit 62b01f72d93c7bc8fde3b2e5b5f783eca5f53324 ]

prestera_port_sfp_bind() returns err after walking the ports node. If no
child node matches the port's front-panel id, err is never assigned.

Initialize err to 0 because absence of a matching optional port device
tree node is not an error. In that case no phylink is created and port
creation should continue with port->phy_link left NULL. Errors from
malformed matched nodes and phylink_create() still propagate.

Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Acked-by: Elad Nachman <enachman@marvell.com>
Link: https://patch.msgid.link/20260617193228.1653582-1-ruoyuw560@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/marvell/prestera/prestera_main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/marvell/prestera/prestera_main.c b/drivers/net/ethernet/marvell/prestera/prestera_main.c
index 41e19e9ad28d41..a82e7a80298513 100644
--- a/drivers/net/ethernet/marvell/prestera/prestera_main.c
+++ b/drivers/net/ethernet/marvell/prestera/prestera_main.c
@@ -373,7 +373,7 @@ static int prestera_port_sfp_bind(struct prestera_port *port)
 	struct device_node *ports, *node;
 	struct fwnode_handle *fwnode;
 	struct phylink *phy_link;
-	int err;
+	int err = 0;
 
 	if (!sw->np)
 		return 0;
-- 
2.53.0



