Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B90EF41A57D;
	Sat, 12 Sep 2026 13:19:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789219191; cv=none; b=NrmddxYG9PdxNI3bdIvSIlQFH4nl6PGUUnXD4P9nv2H59Q22ZGgGOA6CESE6x8Hs5GR39vfQ4Tx034l1ndkMo2CwJNMsJHE5+LyUNAlVw4Mxb3k77vMlm+x47KmFogPXt46IK49qK919gvDUT4KnsWsPtZdBHEBdTqVT4keXM9o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789219191; c=relaxed/simple;
	bh=9Cg+1b+cp53rPDHFGPhcBo1K9OMnQUOG3XZly1c7AGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mij625pWw13MdYcz3yN7fhml6SMLEfSFdQBSGObAd9dxfNY84NrG7liym5H+Re33FORe9aW5jQ0dmYRDz/1AxkXAiRPvibt/QyZuaRiciCkVmiO7oDWuKrM/sXPjzZaQOjgsGaGAqBGVuC5YPrDUPxan1Zp+WXQh7Suu4d8apFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cvKn98v2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cvKn98v2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72AF81F000FF;
	Sat, 12 Sep 2026 13:19:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789219187;
	bh=SmZTOFDcnIWy5uA1+7p60XaxCacfk3cEvGXVvg2CniQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cvKn98v2DC1mWtENFMVOqgnfZTM446o3gl4xFtD/q3Bo/TLt+uDw28OsT0uiC/Uyo
	 gEGCS/lWLChck8RfiJ/IUfH/PItRxe9jweR++o/dgjGrtAoX7f9KmnR5kwctAixdWG
	 1jpD0+vmkT3bv4u4wuVoo1H59+PPfSFuOTgCum7c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1247/1376] net: bridge: Reject descending VLAN tunnel ranges
Date: Sat, 12 Sep 2026 09:01:13 +0200
Message-ID: <20260912065635.336533946@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

From: Ruoyu Wang <ruoyuw560@gmail.com>

[ Upstream commit b74a072d8fb71d3c9ffba4a17d5943e63266fb38 ]

A pair of descending VLAN and tunnel IDs can pass the tunnel range span
check. The VLAN subtraction produces a negative int, which is converted
to unsigned when compared with the u32 tunnel ID subtraction. It can
therefore equal the wrapped tunnel ID delta.

The range loop then performs no iterations. Since the batched
notification handling added a post-loop error check, this leaves err
uninitialized and makes the request's return value unpredictable.

Reject descending VLAN ranges before comparing the spans. Valid
ascending and single-entry ranges remain unchanged, while malformed
descending ranges consistently return -EINVAL.

This issue was found by a static analysis checker and confirmed by
manual source review.

Fixes: 94339443686b ("net: bridge: notify on vlan tunnel changes done via the old api")
Signed-off-by: Ruoyu Wang <ruoyuw560@gmail.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260814134053.1387275-1-ruoyuw560@gmail.com
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_netlink_tunnel.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/net/bridge/br_netlink_tunnel.c b/net/bridge/br_netlink_tunnel.c
index a713668ea34f0..e7eceab5b515d 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -302,7 +302,8 @@ int br_process_vlan_tunnel_info(const struct net_bridge *br,
 
 		if (!(tinfo_last->flags & BRIDGE_VLAN_INFO_RANGE_BEGIN))
 			return -EINVAL;
-		if ((tinfo_curr->vid - tinfo_last->vid) !=
+		if (tinfo_curr->vid < tinfo_last->vid ||
+		    (tinfo_curr->vid - tinfo_last->vid) !=
 		    (tinfo_curr->tunid - tinfo_last->tunid))
 			return -EINVAL;
 		t = tinfo_last->tunid;
-- 
2.53.0



