Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F3F82AE9A;
	Mon,  2 Jun 2025 14:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875168; cv=none; b=LAfbhgoQ8fjEa16AiPgsiLo7+DQ6Y9Go7zxxJH9ey4x9DgOXl0IC+Xl9F3nj/z/zs8ywKb2xHi9lXYDdjSwujvHJ0J0I2Ce0d45T3LaMWS0vWCKiC5LapgERnvsJpKhYPwyi3gGWGLvpmvfcV8aNSXZjPoO5qouF8lqfM+1EkmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875168; c=relaxed/simple;
	bh=XT66iLMEozPLcvzMzJYvctFuu1IXvdxk3hX3DM11Jm0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=i8PRodsBhrau5ztJyhAG1OtsG/Ac5RQ9ngFZVokYCDRWZ9N0wGwJeuG+v/l7LqgZGGeYyoym0xGgJ4Jgj3N5o0xAJyhjuaqTxqpvl9FyioO9mtmszVoytxNaziN/md4PZNozZa+JqTJyavd0KZ6sL1ByQdfSHFZ2J5N/EiLDgx4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SCxm7eqR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SCxm7eqR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 28660C4CEEB;
	Mon,  2 Jun 2025 14:39:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875168;
	bh=XT66iLMEozPLcvzMzJYvctFuu1IXvdxk3hX3DM11Jm0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SCxm7eqRayqVFI3B1Kfycql2b9uuizw75JAexjD+sWMD7WaxttYKf6oN+0DDPNrAP
	 3dNdnX/qlpLFVYWCaz3qJVatP/TDLBCyz/6kK9xytt/ZaPEzjKKmbyTvm1w/Z9IWpo
	 hsG9vmpJMADrA3XK+9JDgj8Wb5buFUaOC2HXAQCU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 049/270] net: dsa: b53: fix VLAN ID for untagged vlan on bridge leave
Date: Mon,  2 Jun 2025 15:45:34 +0200
Message-ID: <20250602134309.202918276@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134307.195171844@linuxfoundation.org>
References: <20250602134307.195171844@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jonas Gorski <jonas.gorski@gmail.com>

[ Upstream commit a1c1901c5cc881425cc45992ab6c5418174e9e5a ]

The untagged default VLAN is added to the default vlan, which may be
one, but we modify the VLAN 0 entry on bridge leave.

Fix this to use the correct VLAN entry for the default pvid.

Fixes: fea83353177a ("net: dsa: b53: Fix default VLAN ID")
Signed-off-by: Jonas Gorski <jonas.gorski@gmail.com>
Tested-by: Florian Fainelli <florian.fainelli@broadcom.com>
Reviewed-by: Florian Fainelli <florian.fainelli@broadcom.com>
Link: https://patch.msgid.link/20250429201710.330937-6-jonas.gorski@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/dsa/b53/b53_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/net/dsa/b53/b53_common.c b/drivers/net/dsa/b53/b53_common.c
index e926dd47b1308..0914982a80c11 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1872,7 +1872,7 @@ EXPORT_SYMBOL(b53_br_join);
 void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 {
 	struct b53_device *dev = ds->priv;
-	struct b53_vlan *vl = &dev->vlans[0];
+	struct b53_vlan *vl;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	unsigned int i;
 	u16 pvlan, reg, pvid;
@@ -1898,6 +1898,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct net_device *br)
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
 	pvid = b53_default_pvid(dev);
+	vl = &dev->vlans[pvid];
 
 	/* Make this port join all VLANs without VLAN entries */
 	if (is58xx(dev)) {
-- 
2.39.5



