Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD4623B5820;
	Sat, 12 Sep 2026 20:05:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789243550; cv=none; b=d/88sUoPIItiKixoCGvw49i3cHVvazIE1vlQGUfNkbEl+K8TXYzu9FtivNdmGDu1/MUz0eoZp6w1k6zUhyHuIYKT8zwbg12pwjRUYA2gXf7Or7p4vX3XnPbzbIJpzq6qJOg63S0hwjAgsQ5snbyU5K0PQAik77fHkwZ2FqTAjOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789243550; c=relaxed/simple;
	bh=pvGDQ/hoaZsaqwImfnxeGEihrBp6fR78n/n5A8SY9j0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=a8Hw+EvvYXq329r9CI/kLUGvH9s/CJ0cFlfj0Ah/heX9jsuIdYrp8y62itA71P5/+tUPeI6von/iITdoXo6NP5lpiGI0dCsg54p+rIffAH0EPbD/a2F5/yuhULWldUzjg7zxkgTY4uk0j8RvdExwBEGofrAry8iabZhXkbTs/aA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lJYiXM98; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lJYiXM98"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3032C1F00893;
	Sat, 12 Sep 2026 20:05:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789243546;
	bh=33cpANOH4syarJ/uW5Yxfelk2n5+s7CszEv202tqj1U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lJYiXM98iX7nXBrfj8CIop3rljAPz46+nSyVPysfOCteNU2DuTlN39tNbm/KqPRBs
	 kJ1zlNsJO7xwW0f0U8ju1s+lNXjeAksFlGkNq3dBgx4mj3DAVglOtvfmcRg6p81Jlm
	 LyUq5yIJlBTu7AEX7I7Rg9AT2RE6IqQUentQ7DOk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ruoyu Wang <ruoyuw560@gmail.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 740/798] net: bridge: Reject descending VLAN tunnel ranges
Date: Sat, 12 Sep 2026 09:06:08 +0200
Message-ID: <20260912065534.035503753@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index e4aab07752701..e7fe6b22cbf6f 100644
--- a/net/bridge/br_netlink_tunnel.c
+++ b/net/bridge/br_netlink_tunnel.c
@@ -299,7 +299,8 @@ int br_process_vlan_tunnel_info(const struct net_bridge *br,
 
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



