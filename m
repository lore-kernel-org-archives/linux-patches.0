Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8477D12D1EA;
	Tue, 30 Apr 2024 11:07:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475272; cv=none; b=N2KNqQAd+gFaOK9qDeMRQGGDiceNVueQW/sVoFaEt/ZMB3mAUadgbHQ+hEkgCwyTuSr5w+UVCL2Hxqb+mEIzR3zZ9uSPocSZcDKb6ndZBhV/XfJM9EMsrOtuhMA/9Mp1vr+MalcAzWDPqhk6eNgEIeWIg/aAb/GY52+LWTGm7No=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475272; c=relaxed/simple;
	bh=G6w06YJvn5nn8pqxwanlckeIJx/w8GP2LDbqgXLJgtI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PnmYBBXj80voSYLNVKT6wSxFdsnKqshM9aoRb6fewZvG+tl2OkuQw5dKMWLJ6FcYIZKqbMh1N9cq6bkoZNe7ay+ir86n4GCigguU2t4MXuMG8FsEA/Zxkqu2GChdcajXTsQI/hmWy5kf7RgZ8qgx7BAKr4nRwD1XXZJJnBjysdI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=j7VeL8fJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="j7VeL8fJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7D6EC4AF1B;
	Tue, 30 Apr 2024 11:07:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475272;
	bh=G6w06YJvn5nn8pqxwanlckeIJx/w8GP2LDbqgXLJgtI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=j7VeL8fJnZPGUxAx3PnfhEkyGrw+hPU9HYh+75TWZc6JS2ABUtLNnJTnOZMYmNM0f
	 E7uk9xQgIRNERWccqCIJd1eJ6P6/0xt7i6TSBSvUx3iZeIn25WlFRZve3kWOh7M5HC
	 aHwNgc9pr/AGAzHIvlL8zbNS/hNoSbpjSYFclF9s=
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
Subject: [PATCH 6.6 047/186] mlxsw: core: Unregister EMAD trap using FORWARD action
Date: Tue, 30 Apr 2024 12:38:19 +0200
Message-ID: <20240430103059.397713543@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 1ccf3b73ed724..85507d01fd457 100644
--- a/drivers/net/ethernet/mellanox/mlxsw/core.c
+++ b/drivers/net/ethernet/mellanox/mlxsw/core.c
@@ -835,7 +835,7 @@ static void mlxsw_emad_rx_listener_func(struct sk_buff *skb, u16 local_port,
 
 static const struct mlxsw_listener mlxsw_emad_rx_listener =
 	MLXSW_RXL(mlxsw_emad_rx_listener_func, ETHEMAD, TRAP_TO_CPU, false,
-		  EMAD, DISCARD);
+		  EMAD, FORWARD);
 
 static int mlxsw_emad_tlv_enable(struct mlxsw_core *mlxsw_core)
 {
-- 
2.43.0



