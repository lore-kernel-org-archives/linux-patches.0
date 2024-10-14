Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF13F1ADFE9;
	Mon, 14 Oct 2024 14:45:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728917121; cv=none; b=IqGA8qY0sJaquyL/CV5mLMESf1ysXco0FcmN5ejulLbLp7F4XMfBV+c8i/1etpQWfef7ykEMEiny/vU7V8vjOzSMSBRzdPAIBUZyZIMaH6K+i+Z1trul5kI26mnGKVg393gpI7sW56GC0MpY9aS68skZJ51hT9IUX4ceO442cb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728917121; c=relaxed/simple;
	bh=q0926fGT68bGzS/x5MusEIL8u4WdB6l/tJqr9HJ/gtw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GG5EN3ji4F9msGJAHHy3kCwyIM1q0J6Hged6wnDEtsUH0jhxbWnl9sAZPJCgXypST0+RiESC1DpepR5UNBCYQ54ARZC41tz60Bw/15vt1L6vfYggQX1my5jP/MwuY841xqAz29q6JYaxIiH2JcS/t+Jk3loYc1rTammY3wuGSCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iDGksb4q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iDGksb4q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E061AC4CEC3;
	Mon, 14 Oct 2024 14:45:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728917121;
	bh=q0926fGT68bGzS/x5MusEIL8u4WdB6l/tJqr9HJ/gtw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iDGksb4qCup6twiDuHoGbMsgBW4SN014s/4ZjkUUZLDtXC1h38ngAZDAtIKPnoojU
	 f0G8eI4Fz9hsQ9ldxGuDAbPoJr7F1bszNDrX6oUC3W65srnBby1PGtMnJER3RtdWBI
	 yxZ5HJo//Kyy2V3Iy4n+S8EBufISOXiV2+otdYfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 158/213] mpls: no longer hold RTNL in mpls_netconf_dump_devconf()
Date: Mon, 14 Oct 2024 16:21:04 +0200
Message-ID: <20241014141049.138116002@linuxfoundation.org>
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

[ Upstream commit e0f89d2864b062b027196925ea19f94b2ce50d6a ]

- Use for_each_netdev_dump() to no longer rely
  on net->dev_index_head hash table.

- No longer care of net->dev_base_seq

- Fix return value at the end of a dump,
  so that NLMSG_DONE can be appended to current skb,
  saving one recvmsg() system call.

- No longer grab RTNL, RCU protection is enough,
  afer adding one READ_ONCE(mdev->input_enabled)
  in mpls_netconf_fill_devconf()

Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240410111951.2673193-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 5be2062e3080 ("mpls: Handle error of rtnl_register_module().")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/mpls/af_mpls.c | 59 +++++++++++++++++-----------------------------
 1 file changed, 22 insertions(+), 37 deletions(-)

diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
index 1af29af653885..ba034fcd59f0d 100644
--- a/net/mpls/af_mpls.c
+++ b/net/mpls/af_mpls.c
@@ -1154,7 +1154,7 @@ static int mpls_netconf_fill_devconf(struct sk_buff *skb, struct mpls_dev *mdev,
 
 	if ((all || type == NETCONFA_INPUT) &&
 	    nla_put_s32(skb, NETCONFA_INPUT,
-			mdev->input_enabled) < 0)
+			READ_ONCE(mdev->input_enabled)) < 0)
 		goto nla_put_failure;
 
 	nlmsg_end(skb, nlh);
@@ -1303,11 +1303,12 @@ static int mpls_netconf_dump_devconf(struct sk_buff *skb,
 {
 	const struct nlmsghdr *nlh = cb->nlh;
 	struct net *net = sock_net(skb->sk);
-	struct hlist_head *head;
+	struct {
+		unsigned long ifindex;
+	} *ctx = (void *)cb->ctx;
 	struct net_device *dev;
 	struct mpls_dev *mdev;
-	int idx, s_idx;
-	int h, s_h;
+	int err = 0;
 
 	if (cb->strict_check) {
 		struct netlink_ext_ack *extack = cb->extack;
@@ -1324,40 +1325,23 @@ static int mpls_netconf_dump_devconf(struct sk_buff *skb,
 		}
 	}
 
-	s_h = cb->args[0];
-	s_idx = idx = cb->args[1];
-
-	for (h = s_h; h < NETDEV_HASHENTRIES; h++, s_idx = 0) {
-		idx = 0;
-		head = &net->dev_index_head[h];
-		rcu_read_lock();
-		cb->seq = net->dev_base_seq;
-		hlist_for_each_entry_rcu(dev, head, index_hlist) {
-			if (idx < s_idx)
-				goto cont;
-			mdev = mpls_dev_get(dev);
-			if (!mdev)
-				goto cont;
-			if (mpls_netconf_fill_devconf(skb, mdev,
-						      NETLINK_CB(cb->skb).portid,
-						      nlh->nlmsg_seq,
-						      RTM_NEWNETCONF,
-						      NLM_F_MULTI,
-						      NETCONFA_ALL) < 0) {
-				rcu_read_unlock();
-				goto done;
-			}
-			nl_dump_check_consistent(cb, nlmsg_hdr(skb));
-cont:
-			idx++;
-		}
-		rcu_read_unlock();
+	rcu_read_lock();
+	for_each_netdev_dump(net, dev, ctx->ifindex) {
+		mdev = mpls_dev_get(dev);
+		if (!mdev)
+			continue;
+		err = mpls_netconf_fill_devconf(skb, mdev,
+						NETLINK_CB(cb->skb).portid,
+						nlh->nlmsg_seq,
+						RTM_NEWNETCONF,
+						NLM_F_MULTI,
+						NETCONFA_ALL);
+		if (err < 0)
+			break;
 	}
-done:
-	cb->args[0] = h;
-	cb->args[1] = idx;
+	rcu_read_unlock();
 
-	return skb->len;
+	return err;
 }
 
 #define MPLS_PERDEV_SYSCTL_OFFSET(field)	\
@@ -2771,7 +2755,8 @@ static int __init mpls_init(void)
 			     mpls_getroute, mpls_dump_routes, 0);
 	rtnl_register_module(THIS_MODULE, PF_MPLS, RTM_GETNETCONF,
 			     mpls_netconf_get_devconf,
-			     mpls_netconf_dump_devconf, 0);
+			     mpls_netconf_dump_devconf,
+			     RTNL_FLAG_DUMP_UNLOCKED);
 	err = ipgre_tunnel_encap_add_mpls_ops();
 	if (err)
 		pr_err("Can't add mpls over gre tunnel ops\n");
-- 
2.43.0



