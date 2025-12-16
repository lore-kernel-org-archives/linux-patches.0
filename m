Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDC85355026;
	Tue, 16 Dec 2025 11:51:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765885867; cv=none; b=VOohQnYlSvzmGJklsUSZpWLdMV1VH7IM7iBRi0FHB3BwDUh8oVTq6b4AB8ji9Fs/gTHz39nug2ntcxdc2zubGD9aNvBnMQ+cV4EihrRfgw8fgQgiPQnSKUsqhfJbLbnGedJXLFxr6IgFkmK1gY5PqQGnvv594mAbMGukLK/EEZc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765885867; c=relaxed/simple;
	bh=yuUfNUTU3C6Wb2c8gcWuOQb+p5nMU4yReH23EjaXkJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SP1Di53ornI4Q6AJDMIxI3LQKD488v7QE+rHRroRVxJHrnOb8GUMG6B+uNqqU7QIHlJQkY1CgZE+21URtCLfrvA+9DTIHAYUYupbQ5weRpQoXQ3oFSRa/ON4KdvEuI8yucfXhkLwd4boFwNDeLXeyx3JLEJypCJr2OMLjYjsfPw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M3dg095q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M3dg095q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45084C4CEF5;
	Tue, 16 Dec 2025 11:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765885867;
	bh=yuUfNUTU3C6Wb2c8gcWuOQb+p5nMU4yReH23EjaXkJc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M3dg095qu6R6kYEQcYRBIA72pfHyHHoS0lst6CBE/NdKE0jk19JZkZ7a5bpZNJeW1
	 3UpM+2saqqIFemRXyNJcuPWUWqpu1Dvq+bFawzdsysPNjVw5cc5a6VhcoMMzYFU4yj
	 8d2CIxm8ydqqer3CL4QTE567eua2cjygW/ya3EkM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ovidiu Panait <ovidiu.panait.rb@renesas.com>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 268/507] net: stmmac: Fix VLAN 0 deletion in vlan_del_hw_rx_fltr()
Date: Tue, 16 Dec 2025 12:11:49 +0100
Message-ID: <20251216111355.196264613@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111345.522190956@linuxfoundation.org>
References: <20251216111345.522190956@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ovidiu Panait <ovidiu.panait.rb@renesas.com>

[ Upstream commit d9db25723677c3741a0cf3643f7f7429fc983921 ]

When the "rx-vlan-filter" feature is enabled on a network device, the 8021q
module automatically adds a VLAN 0 hardware filter when the device is
brought administratively up.

For stmmac, this causes vlan_add_hw_rx_fltr() to create a new entry for
VID 0 in the mac_device_info->vlan_filter array, in the following format:

    VLAN_TAG_DATA_ETV | VLAN_TAG_DATA_VEN | vid

Here, VLAN_TAG_DATA_VEN indicates that the hardware filter is enabled for
that VID.

However, on the delete path, vlan_del_hw_rx_fltr() searches the vlan_filter
array by VID only, without verifying whether a VLAN entry is enabled. As a
result, when the 8021q module attempts to remove VLAN 0, the function may
mistakenly match a zero-initialized slot rather than the actual VLAN 0
entry, causing incorrect deletions and leaving stale entries in the
hardware table.

Fix this by verifying that the VLAN entry's enable bit (VLAN_TAG_DATA_VEN)
is set before matching and deleting by VID. This ensures only active VLAN
entries are removed and avoids leaving stale entries in the VLAN filter
table, particularly for VLAN ID 0.

Fixes: ed64639bc1e08 ("net: stmmac: Add support for VLAN Rx filtering")
Signed-off-by: Ovidiu Panait <ovidiu.panait.rb@renesas.com>
Reviewed-by: Maxime Chevallier <maxime.chevallier@bootlin.com>
Link: https://patch.msgid.link/20251113112721.70500-2-ovidiu.panait.rb@renesas.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
index 0b6f6228ae35d..fd97879a87408 100644
--- a/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
+++ b/drivers/net/ethernet/stmicro/stmmac/stmmac_vlan.c
@@ -122,7 +122,8 @@ static int vlan_del_hw_rx_fltr(struct net_device *dev,
 
 	/* Extended Rx VLAN Filter Enable */
 	for (i = 0; i < hw->num_vlan; i++) {
-		if ((hw->vlan_filter[i] & VLAN_TAG_DATA_VID) == vid) {
+		if ((hw->vlan_filter[i] & VLAN_TAG_DATA_VEN) &&
+		    ((hw->vlan_filter[i] & VLAN_TAG_DATA_VID) == vid)) {
 			ret = vlan_write_filter(dev, hw, i, 0);
 
 			if (!ret)
-- 
2.51.0



