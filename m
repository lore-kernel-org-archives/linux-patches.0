Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7F6D12C462;
	Tue, 30 Apr 2024 11:04:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475079; cv=none; b=Uw3naCO2H62h2hBIylF9NUAdiA2CJ5Q1SMV+EzC9HCDmN/jwDR9LM2Qu+qZ5IMTj0Vicm1C13CtG7eu2gcDRRnPXw42cpylXQezmkw2RNVjeFP7umvPaj0hKgpbJEHzkHxsI/C9W9PWXT7ctRis/OLjFuZcx95GQoBPwB07G/Rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475079; c=relaxed/simple;
	bh=gy/7f6fdw3Uqv/P/oxLzhQ4dtVBZrGbi/GljJE7itws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PY3q54QD3aQDaAKL6IfxqN9eK3eEJ2zHta6oW1FbQ3Sj2+4swr5DyCcn1otzmkEoMYZODKTQbQemHHhvJ6DDXgghPQnSqkRu4ezWZ7R27axhywYAiHJWtqIFEVd5z4bbQDrLIl5butjFrFZ8i/sbH2gaMC3HqJug6zw8cUjc0qg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Tx5dDsrD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Tx5dDsrD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC831C2BBFC;
	Tue, 30 Apr 2024 11:04:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475078;
	bh=gy/7f6fdw3Uqv/P/oxLzhQ4dtVBZrGbi/GljJE7itws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Tx5dDsrDU29c83+rm/vA0nIxXVrzPDHr8xgKWKhF58N6TOCAq8Rvg8FO7aW8qbM73
	 WO8lztvyqJkmCUnkh3F7Io2Tc8Am3pz6GyKBaukAXr+DJgXurvO/8lGiGtfeZ1bNfb
	 /NIGyRvUpw8ez0n9aixkcv/JQR8NSQkz8tsx0+xI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@resnulli.us>,
	Amit Cohen <amcohen@nvidia.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Petr Machata <petrm@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 086/138] mlxsw: core: Unregister EMAD trap using FORWARD action
Date: Tue, 30 Apr 2024 12:39:31 +0200
Message-ID: <20240430103051.952531412@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103049.422035273@linuxfoundation.org>
References: <20240430103049.422035273@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 976c44af48141cd8595601c0af2a19a43c5b228b ]

The device's manual (PRM - Programmer's Reference Manual) classifies the
trap that is used to deliver EMAD responses as an "event trap". Among
other things, it means that the only actions that can be associated with
the trap are TRAP and FORWARD (NOP).

Currently, during driver de-initialization the driver unregisters the
trap by setting its action to DISCARD, which violates the above
guideline. Future firmware versions will prevent such misuses by
returning an error. This does not prevent the driver from working, but
an error will be printed to the kernel log during module removal /
devlink reload:

mlxsw_spectrum 0000:03:00.0: Reg cmd access status failed (status=7(bad parameter))
mlxsw_spectrum 0000:03:00.0: Reg cmd access failed (reg_id=7003(hpkt),type=write)

Suppress the error message by aligning the driver to the manual and use
a FORWARD (NOP) action when unregistering the trap.

Fixes: 4ec14b7634b2 ("mlxsw: Add interface to access registers and process events")
Cc: Jiri Pirko <jiri@resnulli.us>
Cc: Amit Cohen <amcohen@nvidia.com>
Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Petr Machata <petrm@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Petr Machata <petrm@nvidia.com>
Link: https://lore.kernel.org/r/753a89e14008fde08cb4a2c1e5f537b81d8eb2d6.1713446092.git.petrm@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlxsw/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlxsw/core.c b/drivers/net/ethernet/mellanox/mlxsw/core.c
index 1a86535c49685..f568ae250393f 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -697,7 +697,7 @@ static void mlxsw_emad_rx_listener_func(struct sk_buff *skb, u8 local_port,
 
 static const struct mlxsw_listener mlxsw_emad_rx_listener =
 	MLXSW_RXL(mlxsw_emad_rx_listener_func, ETHEMAD, TRAP_TO_CPU, false,
-		  EMAD, DISCARD);
+		  EMAD, FORWARD);
 
 static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 {
-- 
2.43.0



