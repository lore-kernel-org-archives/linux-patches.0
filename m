Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 692D6200112;
	Tue, 26 Aug 2025 11:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756208882; cv=none; b=Po22EUuH+nI6bgcXNAef/YLKpdrCKf4aFkn0/VgOb/94fSeVQW92OZddvrslAX7QHXWCcgtrrDunn2aOaYTy1rkZiNUmbaSl5NhwARhlHsIy3JnGs8nttrCbkHIAJtqJGrdZ42DnwhjLvC1sEM7OtLXVTVwBuVl7OMr6PGTMF2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756208882; c=relaxed/simple;
	bh=8Zxy6UYmvc+xVS0ECn38l6TaDiz1II0i20M+C5CpOGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SYWOyJTafsFuMOcCsmhZmrz6G2q27JGpVtGZQBbZHwlGfvEc9A/gf84oZ/gvvaoJftcIr7jwYgcICpRJ+/PT8d5XT25zbDmOEDOBmhn1NAOOD+YbOnJ7ok3ANvI5IefxN+Y3j3IqEhA4c4hPEXDm0eBT6XAKU3OAjx3IR78HLl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wmIoszMT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wmIoszMT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED203C4CEF1;
	Tue, 26 Aug 2025 11:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756208882;
	bh=8Zxy6UYmvc+xVS0ECn38l6TaDiz1II0i20M+C5CpOGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wmIoszMTd4ZVlaSapfusguzVXmTkpu81mormjFLwFIZHqat8KIFaIi9tS4x9cayga
	 97nzr9TxK39Z0YjFD56Ltis1QbasZSG49CyJbSFzA9+WW0fsFiUaL8SURINBynqrVq
	 9BgAmmPk03L+gF74NACyVj/IS5tDCIVo6UFkOqS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoey Mertes <zoey@cloudflare.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/322] mlxsw: spectrum: Forward packets with an IPv4 link-local source IP
Date: Tue, 26 Aug 2025 13:11:37 +0200
Message-ID: <20250826110922.886041169@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110915.169062587@linuxfoundation.org>
References: <20250826110915.169062587@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 3f5e5d99251b..26401bb57572 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2507,6 +2507,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 			     ROUTER_EXP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_DIP_LINK_LOCAL, FORWARD,
 			     ROUTER_EXP, false),
+	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_LINK_LOCAL, FORWARD,
+			     ROUTER_EXP, false),
 	/* Multicast Router Traps */
 	MLXSW_SP_RXL_MARK(ACL1, TRAP_TO_CPU, MULTICAST, false),
 	MLXSW_SP_RXL_L3_MARK(ACL2, TRAP_TO_CPU, MULTICAST, false),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 83477c8e6971..5bfc1499347a 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/trap.h
+++ b/drivers/net/ethernet/mellanox/mlxsw/trap.h
@@ -95,6 +95,7 @@ enum {
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_SIP_BC = 0x16A,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_IPV4_DIP_LOCAL_NET = 0x16B,
 	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_DIP_LINK_LOCAL = 0x16C,
+	MLXSW_TRAP_ID_DISCARD_ING_ROUTER_SIP_LINK_LOCAL = 0x16D,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_IRIF_EN = 0x178,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_ERIF_EN = 0x179,
 	MLXSW_TRAP_ID_DISCARD_ROUTER_LPM4 = 0x17B,
-- 
2.50.1



