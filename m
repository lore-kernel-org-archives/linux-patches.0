Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2E6430F526;
	Mon, 27 Oct 2025 19:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761592423; cv=none; b=RH4fFALv7wvujG09zTrAVH5gMlH6g+Vq6Ga1fev8NGovU0j0go5d/BbFl15s4YKiriOzztPFR2dVhYHRlZi86mbuBbvFY5lZGtYYW2TVQLw8mOS/irRK452yui8A77+ItshjlX3k2s37C5bR1yJcJHEGD7oqR6K6GC/1EjDyBOw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761592423; c=relaxed/simple;
	bh=ynhCb8RXYUZbkAXch04KM6swloQzzuINp6P1HMRMsF4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MCi0mS+s/fUdGrdSKsYKY5hbU4KtoiesiLkfRjW7Lmz4ssEr7dB1KaQ9JzZcc532UP21++ChsIJJOrNKOXEfgDaMzfoluf0xW60TY3OodHTzre04t0d2YlEmYcYfRPWDm3tF3VbdO6a4gqGzyxb0eR4Dy7fDPsmsBBH2QT55X/M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=z5vttuYW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="z5vttuYW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B28FC4CEF1;
	Mon, 27 Oct 2025 19:13:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761592423;
	bh=ynhCb8RXYUZbkAXch04KM6swloQzzuINp6P1HMRMsF4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=z5vttuYW6ZA2p+dhMxV9h+9dqf1PttjqM/0Jsrdxvz0vF/L9Y1hA2aeq/oZsnX/gc
	 uSYqdzHnr7yb3YaFAz6z3s9Xmzrir/5SGsuDsMw0Ta5LD7JXs2eDClfqtPg5Bi8/RI
	 wXTB3DZ+9bTlJ4DIiEvjiBX3wdmgx2XpdS0CP+t8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Michael=20Wei=C3=9F?= <michael.weiss@aisec.fraunhofer.de>,
	Harshal Gohel <hg@simonwunderlich.de>,
	=?UTF-8?q?Johannes=20Wiesb=C3=B6ck?= <johannes.wiesboeck@aisec.fraunhofer.de>,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 082/157] rtnetlink: Allow deleting FDB entries in user namespace
Date: Mon, 27 Oct 2025 19:35:43 +0100
Message-ID: <20251027183503.473118851@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183501.227243846@linuxfoundation.org>
References: <20251027183501.227243846@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johannes Wiesböck <johannes.wiesboeck@aisec.fraunhofer.de>

[ Upstream commit bf29555f5bdc017bac22ca66fcb6c9f46ec8788f ]

Creating FDB entries is possible from a non-initial user namespace when
having CAP_NET_ADMIN, yet, when deleting FDB entries, processes receive
an EPERM because the capability is always checked against the initial
user namespace. This restricts the FDB management from unprivileged
containers.

Drop the netlink_capable check in rtnl_fdb_del as it was originally
dropped in c5c351088ae7 and reintroduced in 1690be63a27b without
intention.

This patch was tested using a container on GyroidOS, where it was
possible to delete FDB entries from an unprivileged user namespace and
private network namespace.

Fixes: 1690be63a27b ("bridge: Add vlan support to static neighbors")
Reviewed-by: Michael Weiß <michael.weiss@aisec.fraunhofer.de>
Tested-by: Harshal Gohel <hg@simonwunderlich.de>
Signed-off-by: Johannes Wiesböck <johannes.wiesboeck@aisec.fraunhofer.de>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20251015201548.319871-1-johannes.wiesboeck@aisec.fraunhofer.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/rtnetlink.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 6bc2f78a5ebbf..6fd6c717d1e39 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4274,9 +4274,6 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int err;
 	u16 vid;
 
-	if (!netlink_capable(skb, CAP_NET_ADMIN))
-		return -EPERM;
-
 	if (!del_bulk) {
 		err = nlmsg_parse_deprecated(nlh, sizeof(*ndm), tb, NDA_MAX,
 					     NULL, extack);
-- 
2.51.0



