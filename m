Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96561227EA8;
	Tue, 26 Aug 2025 13:34:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756215296; cv=none; b=eRRknKzuXbOhVlLBKoRpV2x3gPWsGlhO1Ac+mX29NiJGaUn7aoB0K2JfhdxTN3rGDyXVD+HaaEd32VGMq+PS2SiCYRrcu2OECJBoc8CxKSswlsn79zkWuOl6Rklr0te/63XywOSgR+beIvz8H40fDRAXdtx16mq12zfhEmAqZ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756215296; c=relaxed/simple;
	bh=i+ZiLZ0ZsUS8D80mLTDOI6A1yhfZ0alU8dErsnp5kVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orlgzNrnXgqoNoAdpeIjBSEHtWCCuU2byRhbNXHajXx99NYzvzxcDBhe2Haogi3fh8QvhYOJ9hCED8JIbMWdQdOOZcOpr/I0kw4NDXgdCQwNPRBjMkZhaXpshU9RxOQRrQHsGaeqh1dAdb1J1RjG2BRB5LaYbhu0zw7jcdl7870=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mJOfeZr3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mJOfeZr3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29913C113CF;
	Tue, 26 Aug 2025 13:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756215296;
	bh=i+ZiLZ0ZsUS8D80mLTDOI6A1yhfZ0alU8dErsnp5kVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mJOfeZr33N9ZB1Xl1U/WK/qDIneDBRm2H3N08kdvmWrDt/QoYv4920vx5uEviVJ55
	 PnyTzVzuDs9B0CiUidIFhVagQXlrFVe3Ks/tTsLtahfuZT5LiCrCs2IvHp5FCCZbWb
	 BrpehEAj+v3nX/E2qPIf8st7GoadlNfvf41uXGOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zoey Mertes <zoey@cloudflare.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 461/482] mlxsw: spectrum: Forward packets with an IPv4 link-local source IP
Date: Tue, 26 Aug 2025 13:11:54 +0200
Message-ID: <20250826110942.212201354@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110930.769259449@linuxfoundation.org>
References: <20250826110930.769259449@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 67ecdb9e708f..2aec55dd07c6 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/spectrum.c
@@ -2522,6 +2522,8 @@ static const struct mlxsw_listener mlxsw_sp_listener[] = {
 			     ROUTER_EXP, false),
 	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_DIP_LINK_LOCAL, FORWARD,
 			     ROUTER_EXP, false),
+	MLXSW_SP_RXL_NO_MARK(DISCARD_ING_ROUTER_SIP_LINK_LOCAL, FORWARD,
+			     ROUTER_EXP, false),
 	/* Multicast Router Traps */
 	MLXSW_SP_RXL_MARK(ACL1, TRAP_TO_CPU, MULTICAST, false),
 	MLXSW_SP_RXL_L3_MARK(ACL2, TRAP_TO_CPU, MULTICAST, false),
diff --git a/drivers/net/ethernet/mellanox/mlxsw/trap.h b/drivers/net/ethernet/mellanox/mlxsw/trap.h
index 8da169663bda..f44c8548c7e3 100644
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



