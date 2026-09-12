Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06751416124;
	Sat, 12 Sep 2026 09:18:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204709; cv=none; b=LgyPPmYpAUiilW4gswxg8/4d/2FhGb1EIb7HQfpE3I8MpssiZUFSPczcnyFzNqeuIlCbNbChqnSX1SBqJxR9txNoLAm/x3R2DMviSEOUj3eWgscjFHR4faDjlGY7di+MW8aMbD3EfLf3EBqjgNt5PRjIAKBcXM0hOLI6oojDw88=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204709; c=relaxed/simple;
	bh=FZOJnmPY/kqPgpE8oO0ZDsMDToyZCrOsBFP06nYNnGk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qi9blARZbon0xq1xRIYH7rMe2hQvGXhemerf4PjDZCHTJDJPMkF1WobC8r1ptoeglr8gdkhZ26r2WbFhe7YdfsSI6bosqvNuXX/87U4EnN/JAT9qOJYYaq4H79ayLR48/8qau3OC1938Bpv8NF/k+wpKlISoK0MUU2lg3s5KMDg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JZzDdSmT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JZzDdSmT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B06F41F00893;
	Sat, 12 Sep 2026 09:18:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204707;
	bh=YkS92oZt0ygP5ZZNYVLLjwyu15GdjpPzDLNk2uFvUv0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JZzDdSmT1Em1S1Fyh3R8PXDquqeOYUvHiWBQxFOhujrGGiKatEGTrAe2fgOUpw22y
	 GJs6YUzJlGt8LirIh964iOGEjrlUtzeLQLpi+16Uydylgcz9PlGiz8b96qhwp8b+V0
	 rcNRSsdf0yJv1gF37BF6oNNdTlAriiw6I7WqWfi8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1668/1815] net: bridge: Reject descending VLAN tunnel ranges
Date: Sat, 12 Sep 2026 08:56:58 +0200
Message-ID: <20260912065728.148256691@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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



