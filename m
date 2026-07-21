Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DBFA43D4E2;
	Tue, 21 Jul 2026 22:15:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672109; cv=none; b=UHKe/LobR8VNid8vVDC4Pd7Ai1lzF8iJWQuZOnEKdAqQrSOCQLT3HrgdYoxTUTo+cYmPd9PBBEiFlM8Lo248mhp0pfyEg78ktb6EnU7ZPcOM54ZVTndy1l186wdG4PRH9fN+8s2C1kT/e2z2VLbUAhvvpWoUuCslmOSmQ54BoCs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672109; c=relaxed/simple;
	bh=GB/IFBc2kBe2kp5Gr+AnmiTwj2Z4hyz9q46YWFLMtnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AiTE6CmjW+jgayNXK0Lz5VVxkkjTVDNzqie2t6YQQjqVI6B33NzBY8Nu6rhRAyBsUI2Gtd+Ttj+uwapoIy+F1DeLePapRjnQGA9ixtchcoTOoM+WkZot9fHJAD/z19+pzt/9pzoBsDscjxbOZyozB/Jw2KjPYhVsACvBfFo35Xw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVESWYf7; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVESWYf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 931911F00A3A;
	Tue, 21 Jul 2026 22:15:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672108;
	bh=h/bW4MunhgMkFsx29rwg183QwSGB5or28jXkNK1N9kI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kVESWYf7LoNfusU48OUd1jDPRw81CUw1Bv/qAlni5mWkWeoTNLD8aX5eq1o5CiIgM
	 wysUAR4eUShCfVi3Z857B+dTkv2xgBVMO7nYeFOv6p8qeurR6sVWtnj3IIZuihF/P+
	 PB7PbuLAkRe+cvFc72hqBJ/T7dSJGacwcVXCaSJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Donald Hunter <donald.hunter@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 493/843] rtnetlink: add RTNL_FLAG_DUMP_UNLOCKED flag
Date: Tue, 21 Jul 2026 17:22:08 +0200
Message-ID: <20260721152417.122774025@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 386520e0ecc01004d3a29c70c5a77d4bbf8a8420 ]

Similarly to RTNL_FLAG_DOIT_UNLOCKED, this new flag
allows dump operations registered via rtnl_register()
or rtnl_register_module() to opt-out from RTNL protection.

Signed-off-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Donald Hunter <donald.hunter@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: 9facb861dc6b ("ipv6: fib6: fix NULL deref in fib6_walk_continue() on multi-batch dump")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netlink.h  | 2 ++
 include/net/rtnetlink.h  | 1 +
 net/core/rtnetlink.c     | 2 ++
 net/netlink/af_netlink.c | 3 +++
 4 files changed, 8 insertions(+)

diff --git a/include/linux/netlink.h b/include/linux/netlink.h
index 61b1c7fcc401ee..a27e5e17836bdd 100644
--- a/include/linux/netlink.h
+++ b/include/linux/netlink.h
@@ -216,6 +216,7 @@ struct netlink_callback {
 	u16			answer_flags;
 	u32			min_dump_alloc;
 	unsigned int		prev_seq, seq;
+	int			flags;
 	bool			strict_check;
 	union {
 		u8		ctx[48];
@@ -243,6 +244,7 @@ struct netlink_dump_control {
 	void *data;
 	struct module *module;
 	u32 min_dump_alloc;
+	int flags;
 };
 
 int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 649d4f88a3da5d..8aac46eb818811 100644
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
index ac9dd385d80f9e..dd121a3eddff69 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -5631,6 +5631,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		}
 		owner = link->owner;
 		dumpit = link->dumpit;
+		flags = link->flags;
 
 		if (type == RTM_GETLINK - RTM_BASE)
 			min_dump_alloc = rtnl_calcit(skb, nlh);
@@ -5648,6 +5649,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 				.dump		= dumpit,
 				.min_dump_alloc	= min_dump_alloc,
 				.module		= owner,
+				.flags		= flags,
 			};
 			err = netlink_dump_start(rtnl, skb, nlh, &c);
 			/* netlink_dump_start() will keep a reference on
diff --git a/net/netlink/af_netlink.c b/net/netlink/af_netlink.c
index 2b9dbf003abd11..1029c87ea913c7 100644
--- a/net/netlink/af_netlink.c
+++ b/net/netlink/af_netlink.c
@@ -2284,6 +2284,8 @@ static int netlink_dump(struct sock *sk, bool lock_taken)
 
 		cb->extack = &extack;
 
+		if (cb->flags & RTNL_FLAG_DUMP_UNLOCKED)
+			extra_mutex = NULL;
 		if (extra_mutex)
 			mutex_lock(extra_mutex);
 		nlk->dump_done_errno = cb->dump(skb, cb);
@@ -2378,6 +2380,7 @@ int __netlink_dump_start(struct sock *ssk, struct sk_buff *skb,
 	cb->data = control->data;
 	cb->module = control->module;
 	cb->min_dump_alloc = control->min_dump_alloc;
+	cb->flags = control->flags;
 	cb->skb = skb;
 
 	nlk2 = nlk_sk(NETLINK_CB(skb).sk);
-- 
2.53.0



