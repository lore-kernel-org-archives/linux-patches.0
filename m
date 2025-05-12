Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DAC97295DA6;
	Mon, 12 May 2025 17:44:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747071893; cv=none; b=gYSEn/+hxnJInu/BOzm2ATPkyDwnl8QLzg5csSsS62tnvSjF1YgnXkDSF3KG6fFDglDH6Of8jBMKnwJaZIB2NL1LleaY3oJzYbq7A0hRi9/tt2zGZ5JgzOMV0iPVaCCtncCqfGNEo3vkm97yvahMdw9oXP8dQuUBrjlKvuE74hk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747071893; c=relaxed/simple;
	bh=sWs7NM9E+WPtbX0QpmTap3NdsTkBZp5MOM+HFNgoIgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRNiXrPvQVoVuVCHma8/7BV5htyC5m1zZHrvbz8Aqy1ON9xpTyEW6QpnFjJt44kxAWH9Vm2tjj6rlFOYng+uU0kZuZ4eo4Lhn927c07pUiCn9exKGBlk6oDIgI5qRhbtnwn8chZiEAXWk+wuBXbkQKUndlL7ETzJZzzeRoAePWk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c3qA4YU5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c3qA4YU5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AAABC4CEE7;
	Mon, 12 May 2025 17:44:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747071893;
	bh=sWs7NM9E+WPtbX0QpmTap3NdsTkBZp5MOM+HFNgoIgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c3qA4YU5tSXSyuPCGLT7w/zYcCjuLwJPlpJMVqfqCmaK7IzaUxwoyEapgfF1dunVb
	 2DtBRu6EmD6npjDYaMN59P2zpSWKV19tjLk13ZmwJrt5l7RcA5SkGwF5GZs5ewZnDZ
	 8j++4UN/EYe8ABPO3D2lmg9+z0XJ1SQndSNN/ObQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 038/197] net: dsa: b53: fix VLAN ID for untagged vlan on bridge leave
Date: Mon, 12 May 2025 19:38:08 +0200
Message-ID: <20250512172045.923708793@linuxfoundation.org>
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
index e75afba8b080a..9745713e0b10d 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1986,7 +1986,7 @@ EXPORT_SYMBOL(b53_br_join);
 void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 {
 	struct b53_device *dev = ds->priv;
-	struct b53_vlan *vl = &dev->vlans[0];
+	struct b53_vlan *vl;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	unsigned int i;
 	u16 pvlan, reg, pvid;
@@ -2012,6 +2012,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
 	pvid = b53_default_pvid(dev);
+	vl = &dev->vlans[pvid];
 
 	/* Make this port join all VLANs without VLAN entries */
 	if (is58xx(dev)) {
-- 
2.39.5



