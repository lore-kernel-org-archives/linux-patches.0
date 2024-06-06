Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8670419AA6A;
	Thu,  6 Jun 2024 14:10:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1717683033; cv=none; b=QCUTrKjyap6HUIXCjgRzzFXIAaLg5mgZf49lhwMfKQxNl4zB+U9w5TcUMyG4d4cSfOCQ0M2p2OCmJ/3fbgRMfwyRYjzu9iT5KlpbNlWJtRvcOOHUFAhXNhWvVtAGw4cb4S/9AFBALbnlXQcXBX9fe1z/3SJUR6WaHebhe1uKv/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1717683033; c=relaxed/simple;
	bh=aAgTHiMz/T5ZpU+Fuo+oUZjUnLqLOZ/5yaVw2GeUlz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pU+PTZWvo2TUL3lDvPWImu0DbgcUbW03GiyYzbilu1l4bXuBD5p+RwbHKh+BKrWw2/E8ORtSKzF5Y2CzoqOOF6FSfty4xE5UVnh+Tshv7Kv+dNZRttzasLFWstqvLyilCuRSOH5hhLoOIEvTG+BbXu+ilvkg3l0/HR4ZVZeQDaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMSbO5PG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMSbO5PG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 667BBC4AF0D;
	Thu,  6 Jun 2024 14:10:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1717683033;
	bh=aAgTHiMz/T5ZpU+Fuo+oUZjUnLqLOZ/5yaVw2GeUlz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMSbO5PG4BiAO951H0sjTv2RcckwkDzRc/wDzACWwgMIgc7mJZsjy6XeiXrK+2Wbx
	 7zldI6gyxA0Fex+PCPEnvcJwdBZzTK1L5S21MqFLqs/ZrdOC5465ZjNsaBV022Z0CL
	 Br/KiZiVjeypgyTdkFTgDlh6kOCKoQ08CJmzB37c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 258/374] net: lan966x: Remove ptp traps in case the ptp is not enabled.
Date: Thu,  6 Jun 2024 16:03:57 +0200
Message-ID: <20240606131700.511469645@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240606131651.683718371@linuxfoundation.org>
References: <20240606131651.683718371@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit eda40be3a5ff3fdce513d2bcfeaca8cc16cf962a ]

Lan966x is adding ptp traps to redirect the ptp frames to the CPU such
that the HW will not forward these frames anywhere. The issue is that in
case ptp is not enabled and the timestamping source is et to
HWTSTAMP_SOURCE_NETDEV then these traps would not be removed on the
error path.
Fix this by removing the traps in this case as they are not needed.

Fixes: 54e1ed69c40a ("net: lan966x: convert to ndo_hwtstamp_get() and ndo_hwtstamp_set()")
Suggested-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://lore.kernel.org/r/20240517135808.3025435-1-horatiu.vultur@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/microchip/lan966x/lan966x_main.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 61d88207eed42..6695ed661ef83 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -474,14 +474,14 @@ static int lan966x_port_hwtstamp_set(struct net_device *dev,
 	    cfg->source != HWTSTAMP_SOURCE_PHYLIB)
 		return -EOPNOTSUPP;
 
+	if (cfg->source == HWTSTAMP_SOURCE_NETDEV && !port->lan966x->ptp)
+		return -EOPNOTSUPP;
+
 	err = lan966x_ptp_setup_traps(port, cfg);
 	if (err)
 		return err;
 
 	if (cfg->source == HWTSTAMP_SOURCE_NETDEV) {
-		if (!port->lan966x->ptp)
-			return -EOPNOTSUPP;
-
 		err = lan966x_ptp_hwtstamp_set(port, cfg, extack);
 		if (err) {
 			lan966x_ptp_del_traps(port);
-- 
2.43.0



