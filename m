Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9E34321431;
	Mon, 27 Oct 2025 18:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761590823; cv=none; b=K/MbyMNttbKJDZCTMSSbKb9xfaaWAwvKS2tm5kHguaaUMg0saTgo2hTBi3vdG6xEWL+7cV36bS56KfBPe+QvQNz0daevrVr80EVI7f3F4mLgXFQvpGnYhHrczMHP2fKf46r2PEzk79+yS9pZVa6KpcZ/MXPY+oWIcn+6dbvKgwc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761590823; c=relaxed/simple;
	bh=y4LB5kf8QBl0yiJLWw2n6En9oAqDPeol7vvQXREMqGY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mpSEtg29vJ/DDQ3w+8QCaPZBmzUkVPx0ftT2zIZVFqTQjfqpnaAHHtEOvJoCu5oQP5Jb6yfib+4KMk/k1H8NID6thnkxNSnRlApUigaUp0i8m6GoPt7A5EIFvVYsQdNU4jXJobgbzgZt4CZ16oPe6Ckop1PyWJOoy/qYc8UX/Wg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=msqF2AXo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="msqF2AXo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C814EC4CEF1;
	Mon, 27 Oct 2025 18:47:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761590823;
	bh=y4LB5kf8QBl0yiJLWw2n6En9oAqDPeol7vvQXREMqGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=msqF2AXogMMrqhHFS8PJkvkOypKq+wesbBY7hSc8E9FRfh/yNojL3tQsqmRo82Bw2
	 cR3tSOcjCtf+q/iiWBC05ZozLnfBz1HFTu3zAPPFMZF1bKCON+4tFHUkEzBfbQ3dwL
	 98ypo2l59DADMtuxFuDfuxPX2rNio1V/dpEAb778=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 188/224] net: add ndo_fdb_del_bulk
Date: Mon, 27 Oct 2025 19:35:34 +0100
Message-ID: <20251027183513.866073066@linuxfoundation.org>
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

[ Upstream commit 1306d5362a591493a2d07f685ed2cc480dcda320 ]

Add a new netdev op called ndo_fdb_del_bulk, it will be later used for
driver-specific bulk delete implementation dispatched from rtnetlink. The
first user will be the bridge, we need it to signal to rtnetlink from
the driver that we support bulk delete operation (NLM_F_BULK).

Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Signed-off-by: David S. Miller <davem@davemloft.net>
Stable-dep-of: bf29555f5bdc ("rtnetlink: Allow deleting FDB entries in user namespace")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/netdevice.h | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/include/linux/netdevice.h b/include/linux/netdevice.h
index f5c1058f565c8..037a48bc5690a 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1158,6 +1158,10 @@ struct tlsdev_ops;
  *		      struct net_device *dev,
  *		      const unsigned char *addr, u16 vid)
  *	Deletes the FDB entry from dev coresponding to addr.
+ * int (*ndo_fdb_del_bulk)(struct ndmsg *ndm, struct nlattr *tb[],
+ *			   struct net_device *dev,
+ *			   u16 vid,
+ *			   struct netlink_ext_ack *extack);
  * int (*ndo_fdb_dump)(struct sk_buff *skb, struct netlink_callback *cb,
  *		       struct net_device *dev, struct net_device *filter_dev,
  *		       int *idx)
@@ -1396,6 +1400,11 @@ struct net_device_ops {
 					       struct net_device *dev,
 					       const unsigned char *addr,
 					       u16 vid);
+	int			(*ndo_fdb_del_bulk)(struct ndmsg *ndm,
+						    struct nlattr *tb[],
+						    struct net_device *dev,
+						    u16 vid,
+						    struct netlink_ext_ack *extack);
 	int			(*ndo_fdb_dump)(struct sk_buff *skb,
 						struct netlink_callback *cb,
 						struct net_device *dev,
-- 
2.51.0



