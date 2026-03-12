Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DB9B26F288;
	Thu, 12 Mar 2026 20:26:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347169; cv=none; b=RMA/4WbKJzXtD8wLnJ8o/hTM4fAsT2RBVl4pTEI4v+av4Y8fx44XYVEwtzBZUrFar+JpgDeAwHzUlU33M9Z4vC3I0pqHpA7z12c2eqmjpypP16kyIApjtReUvn7Bo6zk/y/mn4We1ZIFoSeJgoWPwy3nagIBOHtZwLAwk3uuJbY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347169; c=relaxed/simple;
	bh=+KR7w0nq7kbI7AyamJg4sCfi2VdEo484GxmER2mdgbY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e1iTKOfGTXnEgP7o6jw6p9qemxsvvnIWlmIUm4S1flIBrfWs06E+ZdvVkavwx/A9x7wADBY4XzjDCI9ACaovKrYkvUgWh/ZLihCVTo6c1Vw7peB29qQJVEqMIpwyeesafYkP/PSMpM6w6XVWq3bwTscWDjAP5EjphzKpqOr7VVI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xjJUVxxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xjJUVxxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 151A9C4CEF7;
	Thu, 12 Mar 2026 20:26:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347169;
	bh=+KR7w0nq7kbI7AyamJg4sCfi2VdEo484GxmER2mdgbY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xjJUVxxQ8FJyMwQPPsvslkKiQ0YkZPwEYuNWagf+fbiKacIS4vFD33yOBR3+NzPAU
	 g9JnZPdRfwyEe+AVYvVDAZJgw6iGnz2vxYctgxEVsnUV37o1nz90ocOE0TKSaMY4ls
	 MjnzqkrdWcpJpIlhd+Qj2sZYHxusv9DKwglz9etg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	MD Danish Anwar <danishanwar@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 191/265] net: ti: icssg-prueth: Fix ping failure after offload mode setup when link speed is not 1G
Date: Thu, 12 Mar 2026 21:09:38 +0100
Message-ID: <20260312201025.213190160@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 055c5765bd861..5e1133c322a7d 100644
--- a/drivers/net/ethernet/ti/icssg/icssg_prueth.c
+++ b/drivers/net/ethernet/ti/icssg/icssg_prueth.c
@@ -307,6 +307,14 @@ static int prueth_emac_common_start(struct prueth *prueth)
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



