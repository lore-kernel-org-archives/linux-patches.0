Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322E5320A31;
	Mon, 27 Oct 2025 18:46:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590813; cv=none; b=BN239BQg67WRec3T+Ja2KYlBg4O+97xo7i7tROnChGWSxIUUpd0snINDyTTai6myqfBuybbwHCp6r+e4tpEZFR7/7beQ/55w8Ga0BK/gR5pdBKB8cGbeixAgwgOF3duckdMlgYWas4rm8Q0vhsg3o6MoXB3g3tlfj/zvmHq3yIg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590813; c=relaxed/simple;
	bh=jrJDP1i0pZKMrM3tJ3Ev3zY+sPGjFVKx32dBs8qP2ew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A5Y80XouFpABcz1iTFsNAKRCR+uH0IOWTBR2DL+2YXOL6+jR79yzByhAWKSuWL5BIaOYDyYzY+BpGXqKqjgrzsTgPVQ/rwACydiEGwp/N55V0au306nQ769pd+fKvaY6bwCAs+1jU/AYi2UYTWRm+Bh/A0XOAR96b2xfxhArnPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gGA7EEVD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gGA7EEVD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5E1ACC4CEF1;
	Mon, 27 Oct 2025 18:46:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590812;
	bh=jrJDP1i0pZKMrM3tJ3Ev3zY+sPGjFVKx32dBs8qP2ew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gGA7EEVDkzCl6m2KZCXcHyugogQHy1UWZ5jDECS3OM4dcbOmYW+UBBYzf/4Hi3dGK
	 9wDkrgEB63ThCwnhtnvAmdgzLWb/wySCjrnMuS3t4EGyUaHhxXzmvu+g6Kix1mOvlw
	 LgnEO47FNWCyBeJavT7MiZeG2NAy7yvthBXnFpwo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 184/224] net: rtnetlink: add helper to extract msg types kind
Date: Mon, 27 Oct 2025 19:35:30 +0100
Message-ID: <20251027183513.773001278@linuxfoundation.org>
X-Mailer: git-send-email 2.51.1
In-Reply-To: <20251027183508.963233542@linuxfoundation.org>
References: <20251027183508.963233542@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit 2e9ea3e30f696fd438319c07836422bb0bbb4608 ]

Add a helper which extracts the msg type's kind using the kind mask (0x3).

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 6 ++++++
 net/core/rtnetlink.c    | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 74eff5259b361..02b0636a4523d 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -19,6 +19,12 @@ enum rtnl_kinds {
 	RTNL_KIND_GET,
 	RTNL_KIND_SET
 };
+#define RTNL_KIND_MASK 0x3
+
+static inline enum rtnl_kinds rtnl_msgtype_kind(int msgtype)
+{
+	return msgtype & RTNL_KIND_MASK;
+}
 
 void rtnl_register(int protocol, int msgtype,
 		   rtnl_doit_func, rtnl_dumpit_func, unsigned int flags);
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 2cdb07dd263bd..b41f31a09a7cd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5212,7 +5212,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return 0;
 
 	family = ((struct rtgenmsg *)nlmsg_data(nlh))->rtgen_family;
-	kind = type&3;
+	kind = rtnl_msgtype_kind(type);
 
 	if (kind != RTNL_KIND_GET && !netlink_net_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
-- 
2.51.0



