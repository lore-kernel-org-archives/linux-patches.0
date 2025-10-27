Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A9BE2F25F1;
	Mon, 27 Oct 2025 19:05:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761591943; cv=none; b=IedoWyP1XQQd9R6Mw6BPEOOrs2oHkiNAoKfoNhqrUhGxxnaiRfxtvtqIPLeZq0/40rduwAFYfQ287IwKsPYO5YpBQsEq4Qvj0yD8edbd0wRXxjsbxI3tvPK0djI7dmDOmhwujHPG59qrFk61fScS0T7L4fCMF0HWwtiH6HNGknI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761591943; c=relaxed/simple;
	bh=tAVTz133X5P+ST/wLgx/DKrF02EXaI3T7d557EqX8wQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XFOtEbRom/1cchCgIAXZjHHhvhSBkA+cQLIzccxxhwvoik/Y35mFB45OGAJOBoDiT+rXMVPp8qi6KPRIMq1jThk7W6qDUoWXtzu5ISvMFc3XxXJXyPQEw8wd7z0XbP8Lt8tY5XW+HgVjMCfG8xpIiuL3LBVdZ4dyPOxNDoylRlA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D5tceLUE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D5tceLUE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFAF8C4CEF1;
	Mon, 27 Oct 2025 19:05:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1761591943;
	bh=tAVTz133X5P+ST/wLgx/DKrF02EXaI3T7d557EqX8wQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D5tceLUEeSimuusGxk7crMCh8A97xwnpwQ/Gn4jKQsypUMvDBJ6Bv718x8l5r0VkN
	 ZavOD4GcV/1QxgHuoeqAGaKjCmHvQNeujqvWcPOX0L2jn0sfQ7qek2Iz32PZg97+uq
	 uL9m24ixQF7Rj5vtB/ijxzB/gXDPt45QBUWEOc5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nikolay Aleksandrov <razor@blackwall.org>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 056/123] net: add ndo_fdb_del_bulk
Date: Mon, 27 Oct 2025 19:35:36 +0100
Message-ID: <20251027183447.895000131@linuxfoundation.org>
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
index 179c569a55c42..83bb0f21b1b02 100644
--- a/include/linux/netdevice.h
+++ b/include/linux/netdevice.h
@@ -1273,6 +1273,10 @@ struct netdev_net_notifier {
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
@@ -1528,6 +1532,11 @@ struct net_device_ops {
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



