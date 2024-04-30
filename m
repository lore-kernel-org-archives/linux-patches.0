Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4C128801;
	Tue, 30 Apr 2024 11:16:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475799; cv=none; b=d48nIKLjx2mLoc0b162yBIcPDZV0zDcTp5Sxhaz9Nz/Fg4NCSnzQjzORkS/R2+BhpQXh+lFvNBmQnYekm3UMub748HmeZ4kWBcJ6uzrfbfXCrKrg0zP9+YHEk+bslRcwKgT2ooM367f8NOV6qNhdvUlW3lxFUTtBLb4GvgB3yBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475799; c=relaxed/simple;
	bh=u7K/DJjMRMwHRztqqUL6XTzuFni9TBC0L8kQegUGtYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=daGxr9eTUKZ8Q8LuQMcEaakCudhhw2y1baVsZEoA2vW2U4UnV5Xjw/SkrNGL7w+H/CksxJQumO3gcv3HI82qYymVq/kXb8bATrLaglBO/HgtYRWA21YeYd0EIewg/l4GPtHdnR/HtfSLGdUTNuEaB3vekTxTaIF3176lUNJVN/Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ejh/bw9g; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ejh/bw9g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E6DC2BBFC;
	Tue, 30 Apr 2024 11:16:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475799;
	bh=u7K/DJjMRMwHRztqqUL6XTzuFni9TBC0L8kQegUGtYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ejh/bw9gXXGHMXGyOSwO9FfdsGQtLjkEw0JEQMEtqIXD2tWpbkruerVQH2cf5Q5bx
	 G0QQ/mpOdHywJHPEV7mTbVTo8Qb5kXEZkUO9Ynp47X2yz5Z7UBFcf4r/PIeXRlXlyT
	 dblPeykEOosfrU1nJWWIXhgnPgIuy0eQgGljL5SI=
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
Subject: [PATCH 5.15 21/80] mlxsw: core: Unregister EMAD trap using FORWARD action
Date: Tue, 30 Apr 2024 12:39:53 +0200
Message-ID: <20240430103044.040891680@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103043.397234724@linuxfoundation.org>
References: <20240430103043.397234724@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index f080fab3de2b5..d1102d5613dff 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -746,7 +746,7 @@ static void mlxsw_emad_rx_listener_func(struct sk_buff *skb, u8 local_port,
 
 static const struct mlxsw_listener mlxsw_emad_rx_listener =
 	MLXSW_RXL(mlxsw_emad_rx_listener_func, ETHEMAD, TRAP_TO_CPU, false,
-		  EMAD, DISCARD);
+		  EMAD, FORWARD);
 
 static int mlxsw_emad_init(struct mlxsw_core *mlxsw_core)
 {
-- 
2.43.0



