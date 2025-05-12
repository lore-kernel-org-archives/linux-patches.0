Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 401611E505;
	Mon, 12 May 2025 17:58:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072730; cv=none; b=LF17VmHUtowY1l8eMI1EeA5U43DOJfvq49Dz/WWzeY7aUlv+oxqHiSU2yL/+mmO3aTPUb5gs822LVO/wBryM17xf+AW0UYPeGkqfTdRbfS/N+TAXGYO8JQTq8gXO8qGjDDaBnZQ2pF37Hnqen9GqWTaVaHBkevHzyFR8CLg8gto=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072730; c=relaxed/simple;
	bh=LYR+hgWWvjj24hLsfI71Uo2+GYeMbLSZPFrU5xYcza0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MGFC6bKXISQWf1bxnHTmdsj5dGnMkS8ScexpgTNMIEjYRNJyMyV4AnBAVzFv4CJliutBI3JTrgdVE8QQZdlIpvozOxyAYJ8o1XfI/FdoGHOpBRKw1Bn9Mfjnlb4jULg7bQRLtL0BA2JMP+Wxyr3iODDaShzhdeq1UGtsYU1J6aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AxzWB+Q/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AxzWB+Q/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4479C4CEE7;
	Mon, 12 May 2025 17:58:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072730;
	bh=LYR+hgWWvjj24hLsfI71Uo2+GYeMbLSZPFrU5xYcza0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AxzWB+Q/I2vkrW4Q6LyONW/Q11Q/W5pjXjfDO62o8GWYsvzwQVNb9V5zGpDontk+s
	 KwP7dG3ka0/dPkMa/EYHaWiA5zvzNIHnGpmTvvstcHhhr+h9kps94ncMqP2JON7udL
	 DeFPNcM1MGIAe87gBLyOhJs8O+xm2UJdnxA16ZNA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonas Gorski <jonas.gorski@gmail.com>,
	Florian Fainelli <florian.fainelli@broadcom.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 039/184] net: dsa: b53: fix VLAN ID for untagged vlan on bridge leave
Date: Mon, 12 May 2025 19:44:00 +0200
Message-ID: <20250512172043.319291741@linuxfoundation.org>
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
index d450100c1d020..25afafc4bfc7f 100644
--- a/drivers/net/dsa/b53/b53_common.c
+++ b/drivers/net/dsa/b53/b53_common.c
@@ -1987,7 +1987,7 @@ EXPORT_SYMBOL(b53_br_join);
 void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 {
 	struct b53_device *dev = ds->priv;
-	struct b53_vlan *vl = &dev->vlans[0];
+	struct b53_vlan *vl;
 	s8 cpu_port = dsa_to_port(ds, port)->cpu_dp->index;
 	unsigned int i;
 	u16 pvlan, reg, pvid;
@@ -2013,6 +2013,7 @@ void b53_br_leave(struct dsa_switch *ds, int port, struct dsa_bridge bridge)
 	dev->ports[port].vlan_ctl_mask = pvlan;
 
 	pvid = b53_default_pvid(dev);
+	vl = &dev->vlans[pvid];
 
 	/* Make this port join all VLANs without VLAN entries */
 	if (is58xx(dev)) {
-- 
2.39.5



