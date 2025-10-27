Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5EB127978C;
	Mon, 27 Oct 2025 19:05:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591940; cv=none; b=SSlVhQ432kLhpclixlRp3sbQLv3cglm6rsGUrAx8Fz6HoyY1RlWEhsm8vxfneHdLXSPX9FUEacMqdoLDD6ZJY2Flb9S391R519J0afwTMw7Tc3sfLjyjI4lhkClf+RXbERWB6Ey707W9TqRdI3Hzd/i0/Y8CslyhwDIZ/TFDurg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591940; c=relaxed/simple;
	bh=obwt3TUDD5nXFhwmhrPdnzzjPruP2kZ8VgPGri1czgM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GeirZS9lUYWtyQuAu5eOr7101r8LVY/bsM++aSXcIse8kmxam9ua9Abs2up/B0WMaeWoA728zQlYAO4cLkjLSwT6qCydwCi/lyIBbgkkUYfnjyr7qAa/RlXW/B4zzRAonKouabFTQc1wHPt3qS1wMXJTiPig89aV+5MZPXmxrF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mw2cFnCE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mw2cFnCE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45D8DC4CEF1;
	Mon, 27 Oct 2025 19:05:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591940;
	bh=obwt3TUDD5nXFhwmhrPdnzzjPruP2kZ8VgPGri1czgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Mw2cFnCEdMxSRMw1zm+iqPzR+98E86pHk6fSk8uTxQybhXWH8m3zHGfHBWHultFl+
	 FB/XEghrFTi87vcMpob8daz0XOij5rMYoQGrU6Q+rFfyevDlShsEaLvOBRzyC/xSOu
	 X9yE+p+SeAZWMF7Z5FPlimPsmCRmwnXhMc9rXp0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Ahern <dsahern@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 055/123] net: rtnetlink: add bulk delete support flag
Date: Mon, 27 Oct 2025 19:35:35 +0100
Message-ID: <20251027183447.869223701@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit a6cec0bcd34264be8887791594be793b3f12719f ]

Add a new rtnl flag (RTNL_FLAG_BULK_DEL_SUPPORTED) which is used to
verify that the delete operation allows bulk object deletion. Also emit
a warning if anyone tries to set it for non-delete kind.

Suggested-by: David Ahern <dsahern@kernel.org>
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h | 3 ++-
 net/core/rtnetlink.c    | 8 ++++++++
 2 files changed, 10 insertions(+), 1 deletion(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 268eadbbaa300..fdc7b4ce0ef7b 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -10,7 +10,8 @@ typedef int (*rtnl_doit_func)(struct sk_buff *, struct nlmsghdr *,
 typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback *);
 
 enum rtnl_link_flags {
-	RTNL_FLAG_DOIT_UNLOCKED = BIT(0),
+	RTNL_FLAG_DOIT_UNLOCKED		= BIT(0),
+	RTNL_FLAG_BULK_DEL_SUPPORTED	= BIT(1),
 };
 
 enum rtnl_kinds {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 79fb6d74e6dab..61ab0497ac755 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -214,6 +214,8 @@ static int rtnl_register_internal(struct module *owner,
 	if (dumpit)
 		link->dumpit = dumpit;
 
+	WARN_ON(rtnl_msgtype_kind(msgtype) != RTNL_KIND_DEL &&
+		(flags & RTNL_FLAG_BULK_DEL_SUPPORTED));
 	link->flags |= flags;
 
 	/* publish protocol:msgtype */
@@ -5634,6 +5636,12 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	}
 
 	flags = link->flags;
+	if (kind == RTNL_KIND_DEL && (nlh->nlmsg_flags & NLM_F_BULK) &&
+	    !(flags & RTNL_FLAG_BULK_DEL_SUPPORTED)) {
+		NL_SET_ERR_MSG(extack, "Bulk delete is not supported");
+		goto err_unlock;
+	}
+
 	if (flags & RTNL_FLAG_DOIT_UNLOCKED) {
 		doit = link->doit;
 		rcu_read_unlock();
-- 
2.51.0



