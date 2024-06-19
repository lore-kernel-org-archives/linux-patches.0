Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 265891422B8;
	Wed, 19 Jun 2024 13:14:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802857; cv=none; b=ry2ZwoNf2i1klCffHqoZVJtLbiQv2p3c6WmupRjKis40oB+GCfUCgdtlgBU6NT8Cb8RQPmjoitVMq7ep5Ox6dJXV1EEAsXHkgd/2mTRTQuTew3arftsuPkYYUJLQ5Z7rdKa8pd+3ZjyaPb1cXpQb3Mt1t/jVSfEGV1iMsn5ie7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802857; c=relaxed/simple;
	bh=OdJ5+HSLrbZpMwlEDbHD8ZsDmQ+aV5dRX43cWvc1Dqw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ys/Aa1dXRXqWb/Lz8S60IxRpmFAM7D1+LsU7iCm1NqmCwCY8Yo3GFrHQhzzs67OJm76Z6efShCQAcawJR/g2A01VITTtTpUE2ktqxVflVlZzeupkujSujgp7qS4ERpUst7XX00SZsxWc7S/D2nN6+4vwQf65cWTm7Z5+cvlf2zY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ckcimpYy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ckcimpYy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1995C2BBFC;
	Wed, 19 Jun 2024 13:14:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802857;
	bh=OdJ5+HSLrbZpMwlEDbHD8ZsDmQ+aV5dRX43cWvc1Dqw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ckcimpYy7U8oPnh3gHsdn4xDD/TMbo+RcVcYrfmRWDRlwUa3Cv0l7OohtDdfmdAcX
	 TPn1tqtaUP/NpVrQwBNmMQxpJrh4GBYGL+1lvaxLhOXTc7GlOYBUAis9Iqh67ewcZt
	 r+veXSYGZ0UksPsVeQxDK/L0A2s6sG5UyyeipeJg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Eric Dumazet <edumazet@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 043/281] rtnetlink: make the "split" NLM_DONE handling generic
Date: Wed, 19 Jun 2024 14:53:22 +0200
Message-ID: <20240619125611.507096825@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 5b4b62a169e10401cca34a6e7ac39161986f5605 ]

Jaroslav reports Dell's OMSA Systems Management Data Engine
expects NLM_DONE in a separate recvmsg(), both for rtnl_dump_ifinfo()
and inet_dump_ifaddr(). We already added a similar fix previously in
commit 460b0d33cf10 ("inet: bring NLM_DONE out to a separate recv() again")

Instead of modifying all the dump handlers, and making them look
different than modern for_each_netdev_dump()-based dump handlers -
put the workaround in rtnetlink code. This will also help us move
the custom rtnl-locking from af_netlink in the future (in net-next).

Note that this change is not touching rtnl_dump_all(). rtnl_dump_all()
is different kettle of fish and a potential problem. We now mix families
in a single recvmsg(), but NLM_DONE is not coalesced.

Tested:

  ./cli.py --dbg-small-recv 4096 --spec netlink/specs/rt_addr.yaml \
           --dump getaddr --json '{"ifa-family": 2}'

  ./cli.py --dbg-small-recv 4096 --spec netlink/specs/rt_route.yaml \
           --dump getroute --json '{"rtm-family": 2}'

  ./cli.py --dbg-small-recv 4096 --spec netlink/specs/rt_link.yaml \
           --dump getlink

Fixes: 3e41af90767d ("rtnetlink: use xarray iterator to implement rtnl_dump_ifinfo()")
Fixes: cdb2f80f1c10 ("inet: use xa_array iterator to implement inet_dump_ifaddr()")
Reported-by: Jaroslav Pulchart <jaroslav.pulchart@gooddata.com>
Link: https://lore.kernel.org/all/CAK8fFZ7MKoFSEzMBDAOjoUt+vTZRRQgLDNXEOfdCCXSoXXKE0g@mail.gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/rtnetlink.h |  1 +
 net/core/rtnetlink.c    | 44 +++++++++++++++++++++++++++++++++++++++--
 net/ipv4/devinet.c      |  2 +-
 net/ipv4/fib_frontend.c |  7 +------
 4 files changed, 45 insertions(+), 9 deletions(-)

diff --git a/include/net/rtnetlink.h b/include/net/rtnetlink.h
index 3bfb80bad1739..b45d57b5968af 100644
--- a/include/net/rtnetlink.h
+++ b/include/net/rtnetlink.h
@@ -13,6 +13,7 @@ enum rtnl_link_flags {
 	RTNL_FLAG_DOIT_UNLOCKED		= BIT(0),
 	RTNL_FLAG_BULK_DEL_SUPPORTED	= BIT(1),
 	RTNL_FLAG_DUMP_UNLOCKED		= BIT(2),
+	RTNL_FLAG_DUMP_SPLIT_NLM_DONE	= BIT(3),	/* legacy behavior */
 };
 
 enum rtnl_kinds {
diff --git a/net/core/rtnetlink.c b/net/core/rtnetlink.c
index 8ba6a4e4be266..74e6f9746fb30 100644
--- a/net/core/rtnetlink.c
+++ b/net/core/rtnetlink.c
@@ -6484,6 +6484,46 @@ static int rtnl_mdb_del(struct sk_buff *skb, struct nlmsghdr *nlh,
 
 /* Process one rtnetlink message. */
 
+static int rtnl_dumpit(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	rtnl_dumpit_func dumpit = cb->data;
+	int err;
+
+	/* Previous iteration have already finished, avoid calling->dumpit()
+	 * again, it may not expect to be called after it reached the end.
+	 */
+	if (!dumpit)
+		return 0;
+
+	err = dumpit(skb, cb);
+
+	/* Old dump handlers used to send NLM_DONE as in a separate recvmsg().
+	 * Some applications which parse netlink manually depend on this.
+	 */
+	if (cb->flags & RTNL_FLAG_DUMP_SPLIT_NLM_DONE) {
+		if (err < 0 && err != -EMSGSIZE)
+			return err;
+		if (!err)
+			cb->data = NULL;
+
+		return skb->len;
+	}
+	return err;
+}
+
+static int rtnetlink_dump_start(struct sock *ssk, struct sk_buff *skb,
+				const struct nlmsghdr *nlh,
+				struct netlink_dump_control *control)
+{
+	if (control->flags & RTNL_FLAG_DUMP_SPLIT_NLM_DONE) {
+		WARN_ON(control->data);
+		control->data = control->dump;
+		control->dump = rtnl_dumpit;
+	}
+
+	return netlink_dump_start(ssk, skb, nlh, control);
+}
+
 static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			     struct netlink_ext_ack *extack)
 {
@@ -6548,7 +6588,7 @@ static int rtnetlink_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 				.module		= owner,
 				.flags		= flags,
 			};
-			err = netlink_dump_start(rtnl, skb, nlh, &c);
+			err = rtnetlink_dump_start(rtnl, skb, nlh, &c);
 			/* netlink_dump_start() will keep a reference on
 			 * module if dump is still in progress.
 			 */
@@ -6694,7 +6734,7 @@ void __init rtnetlink_init(void)
 	register_netdevice_notifier(&rtnetlink_dev_notifier);
 
 	rtnl_register(PF_UNSPEC, RTM_GETLINK, rtnl_getlink,
-		      rtnl_dump_ifinfo, 0);
+		      rtnl_dump_ifinfo, RTNL_FLAG_DUMP_SPLIT_NLM_DONE);
 	rtnl_register(PF_UNSPEC, RTM_SETLINK, rtnl_setlink, NULL, 0);
 	rtnl_register(PF_UNSPEC, RTM_NEWLINK, rtnl_newlink, NULL, 0);
 	rtnl_register(PF_UNSPEC, RTM_DELLINK, rtnl_dellink, NULL, 0);
diff --git a/net/ipv4/devinet.c b/net/ipv4/devinet.c
index 8382cc998bff8..84b5d1ccf716a 100644
--- a/net/ipv4/devinet.c
+++ b/net/ipv4/devinet.c
@@ -2801,7 +2801,7 @@ void __init devinet_init(void)
 	rtnl_register(PF_INET, RTM_NEWADDR, inet_rtm_newaddr, NULL, 0);
 	rtnl_register(PF_INET, RTM_DELADDR, inet_rtm_deladdr, NULL, 0);
 	rtnl_register(PF_INET, RTM_GETADDR, NULL, inet_dump_ifaddr,
-		      RTNL_FLAG_DUMP_UNLOCKED);
+		      RTNL_FLAG_DUMP_UNLOCKED | RTNL_FLAG_DUMP_SPLIT_NLM_DONE);
 	rtnl_register(PF_INET, RTM_GETNETCONF, inet_netconf_get_devconf,
 		      inet_netconf_dump_devconf,
 		      RTNL_FLAG_DOIT_UNLOCKED | RTNL_FLAG_DUMP_UNLOCKED);
diff --git a/net/ipv4/fib_frontend.c b/net/ipv4/fib_frontend.c
index c484b1c0fc00a..7ad2cafb92763 100644
--- a/net/ipv4/fib_frontend.c
+++ b/net/ipv4/fib_frontend.c
@@ -1050,11 +1050,6 @@ static int inet_dump_fib(struct sk_buff *skb, struct netlink_callback *cb)
 			e++;
 		}
 	}
-
-	/* Don't let NLM_DONE coalesce into a message, even if it could.
-	 * Some user space expects NLM_DONE in a separate recv().
-	 */
-	err = skb->len;
 out:
 
 	cb->args[1] = e;
@@ -1665,5 +1660,5 @@ void __init ip_fib_init(void)
 	rtnl_register(PF_INET, RTM_NEWROUTE, inet_rtm_newroute, NULL, 0);
 	rtnl_register(PF_INET, RTM_DELROUTE, inet_rtm_delroute, NULL, 0);
 	rtnl_register(PF_INET, RTM_GETROUTE, NULL, inet_dump_fib,
-		      RTNL_FLAG_DUMP_UNLOCKED);
+		      RTNL_FLAG_DUMP_UNLOCKED | RTNL_FLAG_DUMP_SPLIT_NLM_DONE);
 }
-- 
2.43.0



