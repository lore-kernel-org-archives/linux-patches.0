Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 904AA1F4C90;
	Tue, 26 Aug 2025 14:03:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756217013; cv=none; b=gJD5kdTRboVNgV0VpO3SW46xVxHuez66BgmFEAdLFqDSNF3xzFEyjsAz4w32xzE8xzc7IbelUIPAWNEl9sqFX+Jj1OWxy2aoiaQmd4qJHek0S4ooF7XaHBaHDryUB8GwSTZ68Y4s862asf/FIuiBxgVw1v4sJSXcI63i04OCabo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756217013; c=relaxed/simple;
	bh=D5vpd7UdrrAjJ48N51rsjIKX1Hx1+vRwebC4EVBcajg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iWwDs1dltQ4ThyP2ioORhe+h/jd3yfIRLI6J10lYMV7ZL7ePsAl2/WS6rggWkN6XbSP+jKTL6OWt0X++bImvIjy66q6Gov4ECFQFrD3Zta+E/CccDJBPalF8BBQBXBK9V4YY/MuAVWE/wWCk/KI80VJdxWYBFHC1iMw2UA3TZb4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Uc9Ekhs4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Uc9Ekhs4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E3BEC4CEF1;
	Tue, 26 Aug 2025 14:03:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756217013;
	bh=D5vpd7UdrrAjJ48N51rsjIKX1Hx1+vRwebC4EVBcajg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Uc9Ekhs4i8LgI3um8tvQHVBZ9NGScKLEk6qss5SWvg29QHp6771dxNqZIHOfrbCgW
	 Mbd2VXEJmQ68aKh3pcdQQS2SpFcs9T+6pr4JAKrssdyywLQuksAMISVtYiBKXXFuJb
	 2SgvA2N4BVJWxk3izmYbq2CMcPvGJxjJDypyZlBU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoey Mertes <zoey@cloudflare.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 626/644] mlxsw: spectrum: Forward packets with an IPv4 link-local source IP
Date: Tue, 26 Aug 2025 13:11:57 +0200
Message-ID: <20250826111002.069413254@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110946.507083938@linuxfoundation.org>
References: <20250826110946.507083938@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit f604d3aaf64ff0d90cc875295474d3abf4155629 ]

By default, the device does not forward IPv4 packets with a link-local
source IP (i.e., 169.254.0.0/16). This behavior does not align with the
kernel which does forward them.

Fix by instructing the device to forward such packets instead of
dropping them.

Fixes: ca360db4b825 ("mlxsw: spectrum: Disable DIP_LINK_LOCAL check in hardware pipeline")
Reported-by: Zoey Mertes <zoey@cloudflare.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://patch.msgid.link/6721e6b2c96feb80269e72ce8d0b426e2f32d99c.1755174341.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/spectrum.c | 2 ++
 drivers/net/ethernet/mellanox/mlxsw/trap.h     | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
index 35908a8c640a..85353042a790 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2269,6 +2269,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 			     ROUTER_EXP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_DIP_LINK_LOCAL, FORWARD,
 			     ROUTER_EXP, false),
+	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_LINK_LOCAL, FORWARD,
+			     ROUTER_EXP, false),
 	/* Multicast Router Traps */
 	MLXSW_SP_RXL_MARK(ACL1, TRAP_TO_CPU, MULTICAST, false),
 	MLXSW_SP_RXL_L3_MARK(ACL2, TRAP_TO_CPU, MULTICAST, false),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 9e070ab3ed76..eabaca6c240a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -93,6 +93,7 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_SIP_BC = 0x16A,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_DIP_LOCAL_NET = 0x16B,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_DIP_LINK_LOCAL = 0x16C,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_LINK_LOCAL = 0x16D,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_IRIF_EN = 0x178,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_ERIF_EN = 0x179,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM4 = 0x17B,
-- 
2.50.1



