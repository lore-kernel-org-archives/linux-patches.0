Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DD71D7E41;
	Mon, 12 May 2025 18:00:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072816; cv=none; b=Cee0Ek3/Ar5mbtwkdEr2Txh+/Fn8+HI2gbOV4bQHYNpVuuVTfBElri3Dsjmswm0Xh/b50hD/SFVi8Sg7q1/PC3GwVRl3Fl4GQQexvGigi2keDZby426x/uqx7fH+/TyYd6EXy/6IU3MLh+6rGBo8f4scBsK+TfObx/d90s7+qJo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072816; c=relaxed/simple;
	bh=E4ni8vJ4zm9pAuOhgIxKa4VyfGGC4m8qKsXELReInXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OI7Lrtj6ZQzgzoqeQEQs0QwwrSfvQ7cmvuL7D6BDpSzUALlhr1xHkzES3jX84rnrCv5VjJnoO/cfTcU0E2h/Kqq5gOd/sH9wR3sYzD1dOTI5wZKDZcR9YyhiS3TZ/eY1dtYN3HXtI4PLeZ5dh2hLJlAYNOyyrfgcIjIjPN7U7yw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xoY4kCIb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xoY4kCIb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 904BAC4CEE7;
	Mon, 12 May 2025 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072815;
	bh=E4ni8vJ4zm9pAuOhgIxKa4VyfGGC4m8qKsXELReInXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xoY4kCIbTPhyG9XNhknc2HOM8JX72WKZmxMQsqWNgCzxFrB/G1sx+pX5aqZB9vPMY
	 V5/1znLkeJqbmLrRScq7iBzIxPfJcGw9zmFaSjLlCHcDOF8/2YGnzsJwFUqAcCVja7
	 7c4Uid6vKy5y2iku8QaX+xYfv4xpWU3aqHCr9pXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/184] net: dsa: b53: keep CPU port always tagged again
Date: Mon, 12 May 2025 19:43:57 +0200
Message-ID: <20250512172043.195153681@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index f327fdeb81850..d66ef7ad7a604 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1136,6 +1136,11 @@ static int b53_setup(struct dsa_switch *ds)
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
@@ -1546,6 +1551,9 @@ int b53_vlan_add(struct dsa_switch *ds, int port,
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



