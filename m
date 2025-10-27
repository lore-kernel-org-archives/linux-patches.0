Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BF862F25F1;
	Mon, 27 Oct 2025 19:05:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591948; cv=none; b=hd6v74wF8w1UdmjgzNLAY6fquS5jjiGEOVJPYH/rOiB0FaM2IqK7qdAIggjZPruiY2W3fwAn1+xba57xAcTINbkT06UPkZb8nC94agKG+ar4Vfhp6i1bkfD6J9qoAUQtKw7bOVR+7zvWzm1KmhjO5C10fMWCdY47edHf2p0HTD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591948; c=relaxed/simple;
	bh=YsAhsp21yEca7QwnU2pbFkg47ym52eLib9zvoxiyCE0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=dRvBVeZOSFfXxE1sq7A4zx3RpvPHZhOTNJ9nqIdJLJyE0Wn7awOGxBkk7KntwdJn+Hm+zC9XfAtf0K03djpcEKyR59Deo5J5uUNiABM7gvZiJBQ/kSERU941Y2Uw7Nm38OQTXEssyyL3+EODSE1UpYoUk9ElAQVP3bXr6Ql9eIo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bSa0mlDj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bSa0mlDj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5276C4CEF1;
	Mon, 27 Oct 2025 19:05:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591948;
	bh=YsAhsp21yEca7QwnU2pbFkg47ym52eLib9zvoxiyCE0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bSa0mlDjy/ShxK+dYThcmJkO77YrCnSmB5rrD3P2+Pils7vjmMrKo7z8kmpzxXoiR
	 W5j7vd3fnmV5LY0lhNJSBIdM1vdAbyAoz12X3B7y+SIm8Tl4hqscQZH+1b/EGDxWey
	 mXjXJYs/ZjN3eB2phvZaJdLf9vOgUqRBZKSqshbc=
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
Subject: [PATCH 5.15 058/123] rtnetlink: Allow deleting FDB entries in user namespace
Date: Mon, 27 Oct 2025 19:35:38 +0100
Message-ID: <20251027183447.946500748@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183446.381986645@linuxfoundation.org>
References: <20251027183446.381986645@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 08bb8e09994db..c44ab3b71f3e7 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -4192,9 +4192,6 @@ static int rtnl_fdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
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



