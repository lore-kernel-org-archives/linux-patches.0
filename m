Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7CBCB386C01;
	Tue, 10 Mar 2026 11:13:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141214; cv=none; b=jHFJr4vHQszbE7bci4s9HGWLkM5lxwuI54cSGkk1kE0+ozH/BKQ3rllQgDZlkZ+CxDgXVSjG+tt7R1GIUQywsvCW2TJYktWzIr0N9OtyOoco8ok38QdkAk7TRAATe0owhjNIFTlqVsVo8kpN2UR7WckxjpGEhOcwfnKcx+qo5h8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141214; c=relaxed/simple;
	bh=jC+sQ91oMc+A6PdKNDUp8fSyfbN3/ROxwUBIPmF6QDE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JQ2DKDdGJjkT8WQRyWRn0IfhmKMcKL31oeOWcFX777ifPBbJEvBul7QbPT3zgIp/D7F9h4x/Pk/RiOY0qbwLYRnrf/HJb4yfBouAMBMAddpC3aH4lvLzN/TgucXppYIHIfr3c9Zmw6XAd8fuh/QOwrC/tJslkEXRl+ZeuRCp3Y0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XvgFzjgf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XvgFzjgf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA327C19423;
	Tue, 10 Mar 2026 11:13:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141214;
	bh=jC+sQ91oMc+A6PdKNDUp8fSyfbN3/ROxwUBIPmF6QDE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XvgFzjgfKOUxzx8mYdWQZUzcZkkhncVll5J3JF6CNMkDcZAJXzDZrWHPwG0dR+jAr
	 B449VhNa+l0oVOSflYtd+ix2J/d3TWoLPAoG6qOFiZLNGyO2XY3ojJ8B6UNB8iq3H1
	 b2+LeQ+0Ww6n9TeA2AHsVkbHplBD7onZWtGZner4J0v3LLJadTl3U5lvVrn3uQ/bTk
	 /Nr3nNSRgXjmzUsGiS/ML22c0uQYqFTf4+7di2G3+EOulGXvPgsEAG5g2IUK2ysspk
	 N/fvXkn6I4AkCuEPppawQ1P0FPQn4jmcRMtfy3uWaDTPCGYhkQN0LiHSX6eRe/IDbx
	 cfHRdmrGew7RA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: MD Danish Anwar <danishanwar@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 215/311] net: ti: icssg-prueth: Fix ping failure after offload mode setup when link speed is not 1G
Date: Tue, 10 Mar 2026 07:04:22 -0400
Message-ID: <99863750ba2b2e9d6c6d45edb15af39181dd2fc5.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: MD Danish Anwar <danishanwar@ti.com>

[ Upstream commit 147792c395db870756a0dc87ce656c75ae7ab7e8 ]

When both eth interfaces with links up are added to a bridge or hsr
interface, ping fails if the link speed is not 1Gbps (e.g., 100Mbps).

The issue is seen because when switching to offload (bridge/hsr) mode,
prueth_emac_restart() restarts the firmware and clears DRAM with
memset_io(), setting all memory to 0. This includes PORT_LINK_SPEED_OFFSET
which firmware reads for link speed. The value 0 corresponds to
FW_LINK_SPEED_1G (0x00), so for 1Gbps links the default value is correct
and ping works. For 100Mbps links, the firmware needs FW_LINK_SPEED_100M
(0x01) but gets 0 instead, causing ping to fail. The function
emac_adjust_link() is called to reconfigure, but it detects no state change
(emac->link is still 1, speed/duplex match PHY) so new_state remains false
and icssg_config_set_speed() is never called to correct the firmware speed
value.

The fix resets emac->link to 0 before calling emac_adjust_link() in
prueth_emac_common_start(). This forces new_state=true, ensuring
icssg_config_set_speed() is called to write the correct speed value to
firmware memory.

Fixes: 06feac15406f ("net: ti: icssg-prueth: Fix emac link speed handling")
Signed-off-by: MD Danish Anwar <danishanwar@ti.com>
Link: https://patch.msgid.link/20260226102356.2141871-1-danishanwar@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/icssg/icssg_prueth.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/ethernet/ti/icssg/icssg_prueth.c b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
index f65041662173c..2c6e161225f6a 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -273,6 +273,14 @@ static int prueth_emac_common_start(struct prueth *prueth)
 		if (ret)
 			goto disable_class;
 
+		/* Reset link state to force reconfiguration in
+		 * emac_adjust_link(). Without this, if the link was already up
+		 * before restart, emac_adjust_link() won't detect any state
+		 * change and will skip critical configuration like writing
+		 * speed to firmware.
+		 */
+		emac->link = 0;
+
 		mutex_lock(&emac->ndev->phydev->lock);
 		emac_adjust_link(emac->ndev);
 		mutex_unlock(&emac->ndev->phydev->lock);
-- 
2.51.0

