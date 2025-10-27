Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C447B2C15BB;
	Mon, 27 Oct 2025 19:27:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761593259; cv=none; b=fZjACWNtP7cjjfx0HXjasYu4zcTNwVM3HQs5O+BOSt62INsV7SN57twe8rR0aMvsTeVQifhxMPw00tTz/t2yj5BjT1b+qxQrKfDXMyi+HR6mFAG/ed142PqI/C8D7tns0bKsSpJU/9HAxiuBqtbuhaNAsLcEVZ6t+W16huADeS0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761593259; c=relaxed/simple;
	bh=EzpN67yZuYaAv5eXZXm0AHRBBsfgJUrXkeJR975vcQ0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=p92hMXBGoYTuT/JllgI4LHfiLLx6aFEWWIsXlFcyPWVJ7UYTZeGpPkTe7Yro64hBgC/wLC/KljYNc4V1KN2pNDqiooAekoXsEtQZvBkMOLsUfo/1D+P6VMBTnVBwlLyGAqOa6kCHNPJ1WvjownVu/PbUGfTCW3Ym5IlC8BhoEBI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rdkEN1F/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rdkEN1F/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FAC6C4CEF1;
	Mon, 27 Oct 2025 19:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761593259;
	bh=EzpN67yZuYaAv5eXZXm0AHRBBsfgJUrXkeJR975vcQ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rdkEN1F/0Nzdw9gQihmklKqAWcWHuAQvoeOMfhu0SlGR5YkzMapLUSDguvfnQGZ1x
	 8YSXmnurnT/ybBRWIgx75erkK2Xyr7ge3WaognWkIJxRGmCDPQOBjj4WNfrL2mx8G0
	 vi4GGAD+H/hd21nNXZ+rrsYjIVlfZhEiQVUOC19k=
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
Subject: [PATCH 6.17 036/184] rtnetlink: Allow deleting FDB entries in user namespace
Date: Mon, 27 Oct 2025 19:35:18 +0100
Message-ID: <20251027183515.887771491@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183514.934710872@linuxfoundation.org>
References: <20251027183514.934710872@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 094b085cff206..8f3fd52f089d2 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4707,9 +4707,6 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
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



