Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA4DE3321D8
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 17:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301218; cv=none; b=YPJEgX8gZZTl+k6SJT4lKRJJO9ey8CarRjPQILVVU1MTZtUI4e82OK+6ou0qR0VOuaq7CPQeOcsi9IgE1+XM93awpAaFYLW3GtoGm2VjWLDEb1z3QYU2xHpU1fCVeRBCa6DeKAEAb61s02z/IwbJehDPhV8vUKj/z6tdE1CA6ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301218; c=relaxed/simple;
	bh=Bd41o2rswMZE6Q+rHhQPOTZy5oI39Vt0D1sCOpwwBwQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OaCM1sdFvbGcxfLRZWV5V3qmfXD2NvnAxa/P+Aqkgo5yiV+0o1C3cwT9fquPydxuJ7SGbZcGqv6dRaMZ8kZOWnzMXStj4S/Sr6c3lhuhNhYNy8o6VOgAvDCnFpqMfIDkhYRrzYFXJP8jH7kxkPrT75RjROh3FeFy1gcssb75VmE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T9vmbQQ3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T9vmbQQ3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38867C116D0;
	Sat, 28 Feb 2026 17:53:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301218;
	bh=Bd41o2rswMZE6Q+rHhQPOTZy5oI39Vt0D1sCOpwwBwQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T9vmbQQ3h1lsR/3mTddzxFLkxHkncKeJ71EVYXnfVonemISo6kzTYZxz+8ciUOJ5h
	 1v1tAdwSseoGJoiEIWri62s/Fwilnw7sTMEFzHM7E2ezhs66SB31HbUst7zLxkSH2N
	 wTtdoBjE5Z25moWAHQqWzoWA+bNxAc+ZALO2JvPBjlWFmk2IbFenv7+ABZNEVxG4nC
	 jvKdwZN3YAbqsidjiKQT9BUIh5IjjvScofp7bTuxBmzkX/8JzZlss7FlNNUO8ufeJx
	 RIuaWauHO+al6BUEyQz92r8VeNEF3FsyQSSDoUEYwQwwh1XdQVDZjGqM5nSQY2rhyJ
	 HuWsjO0SRLEyA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Maciej Grochowski <Maciej.Grochowski@sony.com>,
	Jon Mason <jdmason@kudzu.us>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 395/752] ntb: ntb_hw_switchtec: Fix shift-out-of-bounds for 0 mw lut
Date: Sat, 28 Feb 2026 12:41:46 -0500
Message-ID: <20260228174750.1542406-395-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228174750.1542406-1-sashal@kernel.org>
References: <20260228174750.1542406-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Maciej Grochowski <Maciej.Grochowski@sony.com>

[ Upstream commit 186615f8855a0be4ee7d3fcd09a8ecc10e783b08 ]

Number of MW LUTs depends on NTB configuration and can be set to zero,
in such scenario rounddown_pow_of_two will cause undefined behaviour and
should not be performed.
This patch ensures that rounddown_pow_of_two is called on valid value.

Signed-off-by: Maciej Grochowski <Maciej.Grochowski@sony.com>
Signed-off-by: Jon Mason <jdmason@kudzu.us>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/ntb/hw/mscc/ntb_hw_switchtec.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
index f15ebab138144..0536521fa6ccc 100644
--- a/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
+++ b/drivers/ntb/hw/mscc/ntb_hw_switchtec.c
@@ -1202,7 +1202,8 @@ static void switchtec_ntb_init_mw(struct switchtec_ntb *sndev)
 				       sndev->mmio_self_ctrl);
 
 	sndev->nr_lut_mw = ioread16(&sndev->mmio_self_ctrl->lut_table_entries);
-	sndev->nr_lut_mw = rounddown_pow_of_two(sndev->nr_lut_mw);
+	if (sndev->nr_lut_mw)
+		sndev->nr_lut_mw = rounddown_pow_of_two(sndev->nr_lut_mw);
 
 	dev_dbg(&sndev->stdev->dev, "MWs: %d direct, %d lut\n",
 		sndev->nr_direct_mw, sndev->nr_lut_mw);
@@ -1212,7 +1213,8 @@ static void switchtec_ntb_init_mw(struct switchtec_ntb *sndev)
 
 	sndev->peer_nr_lut_mw =
 		ioread16(&sndev->mmio_peer_ctrl->lut_table_entries);
-	sndev->peer_nr_lut_mw = rounddown_pow_of_two(sndev->peer_nr_lut_mw);
+	if (sndev->peer_nr_lut_mw)
+		sndev->peer_nr_lut_mw = rounddown_pow_of_two(sndev->peer_nr_lut_mw);
 
 	dev_dbg(&sndev->stdev->dev, "Peer MWs: %d direct, %d lut\n",
 		sndev->peer_nr_direct_mw, sndev->peer_nr_lut_mw);
-- 
2.51.0

