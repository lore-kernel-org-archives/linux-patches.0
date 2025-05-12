Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03094296FC0;
	Mon, 12 May 2025 17:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071886; cv=none; b=BWHTAqmhQzBXVhH5WKZufb822nxyedKfQoEgf0akYPxRy2L27n2YiGTJ8pXLRdTQp+FNi4o8uN2JzAYJ8oGXQLu0o1qPcKHzriZpy2EpbhUavMjz4AfZXXXlJlo/z2pFaxRemQ++uWEYD0r4aP2q1+kcjxGHg+B5ZwBAD8QdMCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071886; c=relaxed/simple;
	bh=8jgWiysZf7eCRkZ9T8zSwLqt/RabwVMhaS5omMSjFK4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3F+TA+PBcPc7JjTH+4OYUPDt2brjoCjJv6iT136Ud1fTM2gNNvkkMIjqfcdnv9w2auYK4z+TATP65BKc/dAwzAcqS0EsVpDefYcwy1gWruPZO/30/1qwLnvdY0N5q+F04WUeqgM1J/zEH2xQMcddIh7sy4Wx7hCtMF6o34lv+s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R/cFgGPp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R/cFgGPp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7E8DBC4CEE9;
	Mon, 12 May 2025 17:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071885;
	bh=8jgWiysZf7eCRkZ9T8zSwLqt/RabwVMhaS5omMSjFK4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R/cFgGPpjk54YsxRN2pUfxaEZgF5NlaT+g6piMdrpKLNcRYm7r1ucMlAkXf5yvgTx
	 zhsKFkufhQYTPHksLCzoBZv4X6FQwOLJvLqw3yr8hq1SJ9rKF8ydMPAz9aQzVd5Hd+
	 Y2fK8D1Rzbjpj3i+ptO10NcrefmtFLY8FOGWcUa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 035/197] net: dsa: b53: keep CPU port always tagged again
Date: Mon, 12 May 2025 19:38:05 +0200
Message-ID: <20250512172045.800484927@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172044.326436266@linuxfoundation.org>
References: <20250512172044.326436266@linuxfoundation.org>
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

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit 425f11d4cc9bd9e97e6825d9abb2c51a068ca7b5 ]

The Broadcom management header does not carry the original VLAN tag
state information, just the ingress port, so for untagged frames we do
not know from which VLAN they originated.

Therefore keep the CPU port always tagged except for VLAN 0.

Fixes the following setup:

$ ip link add br0 type bridge vlan_filtering 1
$ ip link set sw1p1 master br0
$ bridge vlan add dev br0 pvid untagged self
$ ip link add sw1p2.10 link sw1p2 type vlan id 10

Where VID 10 would stay untagged on the CPU port.

Fixes: 2c32a3d3c233 ("net: dsa: b53: Do not force CPU to be always tagged")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-3-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index a152f632a290e..772f8954ddf43 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1135,6 +1135,11 @@ static int b53_setup(struct dsa_switch *ds)
 	 */
 	ds->untag_bridge_pvid = dev->tag_protocol == DSA_TAG_PROTO_NONE;
 
+	/* The switch does not tell us the original VLAN for untagged
+	 * packets, so keep the CPU port always tagged.
+	 */
+	ds->untag_vlan_aware_bridge_pvid = true;
+
 	ret = b53_reset_switch(dev);
 	if (ret) {
 		dev_err(ds->dev, "failed to reset switch\n");
@@ -1545,6 +1550,9 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
 	if (vlan->vid == 0 && vlan->vid == b53_default_pvid(dev))
 		untagged = true;
 
+	if (vlan->vid > 0 && dsa_is_cpu_port(ds, port))
+		untagged = false;
+
 	vl->members |= BIT(port);
 	if (untagged && !b53_vlan_port_needs_forced_tagged(ds, port))
 		vl->untag |= BIT(port);
-- 
2.39.5



