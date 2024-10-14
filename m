Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22A5E1AE001;
	Mon, 14 Oct 2024 14:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917118; cv=none; b=n082ZzggMDEwPGnpsZkEOmxowGNPMcfnzy1lbFliJqXbDYFbrmp0182ULeXwk0Q+YCJFPV5m2/y3V8xrCiqPQBTGhr4fLPEnIxexp/pA5p16o6ESOB9DNZ7kntMWK/IQeStMU8UIYC0XsMTrpvfp4NrJJsbZEQj0eV46+sw05yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917118; c=relaxed/simple;
	bh=9px6pNxj3xITxTQbk+j3eyTRdlqVJdIveRXX1Fcxkw0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=je3J4VIEN+xJe6U40+h/BKYVrnsoV+PcbFwWYQrh4ZVBYUoHelwSSOx4DiQd3/J5LfsMdY7AB1pEveoRsevs2D9lQwD2NtMuIA/8kiZjnbgOx+DUySKjvk5GXzRvA62LJgV25oxbEfiAt3DjW8MVBe5ZNc31fdn0hOP6BztIvZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GguAIles; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GguAIles"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 857BAC4CECF;
	Mon, 14 Oct 2024 14:45:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917118;
	bh=9px6pNxj3xITxTQbk+j3eyTRdlqVJdIveRXX1Fcxkw0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GguAIleskwe4mHdq9yLnDpRPy5zIz/qvtHRKcME6QcUQwoo7IgQsAOiY7bR4AQ/5H
	 sRD4m2g1qrrzfRRhfk+evvG53GtYdS5+/r/QCfTHfgqd5x+luiPqdzoXxbRweG1CJq
	 XxMcnjY/5anryXgfPxRerFVK7EmI6nelVhumeq5o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 157/213] rtnetlink: add RTNL_FLAG_DUMP_UNLOCKED flag
Date: Mon, 14 Oct 2024 16:21:03 +0200
Message-ID: <20241014141049.098673157@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241014141042.954319779@linuxfoundation.org>
References: <20241014141042.954319779@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 386520e0ecc01004d3a29c70c5a77d4bbf8a8420 ]

Similarly to RTNL_FLAG_DOIT_UNLOCKED, this new flag
allows dump operations registered via rtnl_register()
or rtnl_register_module() to opt-out from RTNL protection.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 5be2062e3080 ("mpls: Handle error of rtnl_register_module().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netlink.h  | 2 ++
 include/net/rtnetlink.h  | 1 +
 net/core/rtnetlink.c     | 2 ++
 net/netlink/af_netlink.c | 3 +++
 4 files changed, 8 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 75d7de34c9087..e8d713a37d176 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -289,6 +289,7 @@ struct netlink_callback {
 	u16			answer_flags;
 	u32			min_dump_alloc;
 	unsigned int		prev_seq, seq;
+	int			flags;
 	bool			strict_check;
 	union {
 		u8		ctx[48];
@@ -321,6 +322,7 @@ struct netlink_dump_control {
 	void *data;
 	struct module *module;
 	u32 min_dump_alloc;
+	int flags;
 };
 
 int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 0bd400be3f8d9..c1fa6fee0acfa 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -12,6 +12,7 @@ typedef int (*rtnl_dumpit_func)(struct sk_buff *, struct netlink_callback *);
 enum rtnl_link_flags {
 	RTNL_FLAG_DOIT_UNLOCKED		= BIT(0),
 	RTNL_FLAG_BULK_DEL_SUPPORTED	= BIT(1),
+	RTNL_FLAG_DUMP_UNLOCKED		= BIT(2),
 };
 
 enum rtnl_kinds {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index ffa1334cddf44..c76c54879fddd 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -6405,6 +6405,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 		owner = link->owner;
 		dumpit = link->dumpit;
+		flags = link->flags;
 
 		if (type == RTM_GETLINK - RTM_BASE)
 			min_dump_alloc = rtnl_calcit(skb, nlh);
@@ -6422,6 +6423,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 				.dump		= dumpit,
 				.min_dump_alloc	= min_dump_alloc,
 				.module		= owner,
+				.flags		= flags,
 			};
 			err = netlink_dump_start(rtnl, skb, nlh, &c);
 			/* netlink_dump_start() will keep a reference on
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index e40376997f393..8e7d5f17c58b8 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2263,6 +2263,8 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 
 		cb->extack = &extack;
 
+		if (cb->flags & RTNL_FLAG_DUMP_UNLOCKED)
+			extra_mutex = NULL;
 		if (extra_mutex)
 			mutex_lock(extra_mutex);
 		nlk->dump_done_errno = cb->dump(skb, cb);
@@ -2357,6 +2359,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	cb->data = control->data;
 	cb->module = control->module;
 	cb->min_dump_alloc = control->min_dump_alloc;
+	cb->flags = control->flags;
 	cb->skb = skb;
 
 	cb->strict_check = nlk_test_bit(STRICT_CHK, NETLINK_CB(skb).sk);
-- 
2.43.0



