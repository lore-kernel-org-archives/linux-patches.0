Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75DAF2116E9;
	Wed,  7 May 2025 18:54:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644088; cv=none; b=KZBuZAuBQ/A6KtfM1rysYne+6Fez8IqXNI65xqYTXtjmTiL1E+bYVaqSQyuW4kIhHPegFpUHs1SsvDCynV/1f89X/UJ/YjmVmQLpENZRWbP49mlW3f6OvFRLpOzxHd187M8Z+FonTs6WbLsWKDCBzfva52aXtex1kGi2lpwXYPw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644088; c=relaxed/simple;
	bh=cQNzI+uBv3f2w/Q7CBHB9rZE8mIXLgGUHiXos2QIdfo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FDgysN2hf3qIi3s7x3UWmu8KMGGHiDiHatBFKqyhmQC7AurpljKba9gFf2SZM+3j1WTpqBBye+GAhgZrBUriPZwcC0ihBMFkHHBHRNGxCWnHX2MnKkuX64eV1W2k5WSdyWY4Q3ijj9Uv9k5M2QACCdxZWuiEDMjs1AOTAjDppC0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1ToP5Rw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1ToP5Rw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9282C4CEE2;
	Wed,  7 May 2025 18:54:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644088;
	bh=cQNzI+uBv3f2w/Q7CBHB9rZE8mIXLgGUHiXos2QIdfo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1ToP5Rw1H6OkBNHXbgGHCpwwBL/14iLyI7ajU3mNdysjA2zHIIDIZJm7zgBzFb0xV
	 ZQY7ikRfhenXJd61H+mkVGQC9zcvR+DgxKAAzr18p02ninMteIs6FsVFGil62aKge5
	 R6ZhjADkNMeJcQTmzfULhPqqD/hsdrKXHLchSlZQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 086/183] net: mscc: ocelot: delete PVID VLAN when readding it as non-PVID
Date: Wed,  7 May 2025 20:38:51 +0200
Message-ID: <20250507183828.313750503@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183824.682671926@linuxfoundation.org>
References: <20250507183824.682671926@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 5ec6d7d737a491256cd37e33910f7ac1978db591 ]

The following set of commands:

ip link add br0 type bridge vlan_filtering 1 # vlan_default_pvid 1 is implicit
ip link set swp0 master br0
bridge vlan add dev swp0 vid 1

should result in the dropping of untagged and 802.1p-tagged traffic, but
we see that it continues to be accepted. Whereas, had we deleted VID 1
instead, the aforementioned dropping would have worked

This is because the ANA_PORT_DROP_CFG update logic doesn't run, because
ocelot_vlan_add() only calls ocelot_port_set_pvid() if the new VLAN has
the BRIDGE_VLAN_INFO_PVID flag.

Similar to other drivers like mt7530_port_vlan_add() which handle this
case correctly, we need to test whether the VLAN we're changing used to
have the BRIDGE_VLAN_INFO_PVID flag, but lost it now. That amounts to a
PVID deletion and should be treated as such.

Regarding blame attribution: this never worked properly since the
introduction of bridge VLAN filtering in commit 7142529f1688 ("net:
mscc: ocelot: add VLAN filtering"). However, there was a significant
paradigm shift which aligned the ANA_PORT_DROP_CFG register with the
PVID concept rather than with the native VLAN concept, and that change
wasn't targeted for 'stable'. Realistically, that is as far as this fix
needs to be propagated to.

Fixes: be0576fed6d3 ("net: mscc: ocelot: move the logic to drop 802.1p traffic to the pvid deletion")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20250424223734.3096202-1-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/net/ethernet/mscc/ocelot.c b/drivers/net/ethernet/mscc/ocelot.c
index ef93df5208871..08bee56aea35f 100644
--- a/drivers/net/ethernet/mscc/ocelot.c
+++ b/drivers/net/ethernet/mscc/ocelot.c
@@ -830,6 +830,7 @@ EXPORT_SYMBOL(ocelot_vlan_prepare);
 int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 		    bool untagged)
 {
+	struct ocelot_port *ocelot_port = ocelot->ports[port];
 	int err;
 
 	/* Ignore VID 0 added to our RX filter by the 8021q module, since
@@ -849,6 +850,11 @@ int ocelot_vlan_add(struct ocelot *ocelot, int port, u16 vid, bool pvid,
 					   ocelot_bridge_vlan_find(ocelot, vid));
 		if (err)
 			return err;
+	} else if (ocelot_port->pvid_vlan &&
+		   ocelot_bridge_vlan_find(ocelot, vid) == ocelot_port->pvid_vlan) {
+		err = ocelot_port_set_pvid(ocelot, port, NULL);
+		if (err)
+			return err;
 	}
 
 	/* Untagged egress vlan clasification */
-- 
2.39.5



