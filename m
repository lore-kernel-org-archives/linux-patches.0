Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1C2E304989;
	Tue, 30 Sep 2025 14:59:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759244356; cv=none; b=q77d4IWbOmDS9+06vfS12RX34FO2Ntivv6nFMMQtlnxq/zK1Sv43oDNJvfQdqqsupxeAVzgvYOfm8TQ9G5oGXaXvjGAN9KNT9i2c6BwB+JGGdRnmbfX1l48BuvQAC6JVXcO0S/+Z/xpyDq+KHaMlqYb7OzhXdH/qcfPrJixd+eM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759244356; c=relaxed/simple;
	bh=cdJgmf+YTU/dno3+gxBofMsouAZPffTmU3IKTg5sgrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ocSV0XiEESXV8bwJcS+I2tC8DWI1MPmRBo2Nqv1wgqv19eIYojvB0g+9UtkQBNp+FA8Q2dr4FJ1Dy8nHf3yiTxeK61Ufz6/CWPgPyOVuKDuAX3DDxc3NVv0I4ASn5grbCgXYizGkZEXwzh8qdchWog7pykZ0jZ8q/tfjFgzCg0c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WzjMzVTE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WzjMzVTE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6092EC4CEF0;
	Tue, 30 Sep 2025 14:59:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1759244355;
	bh=cdJgmf+YTU/dno3+gxBofMsouAZPffTmU3IKTg5sgrc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WzjMzVTEwRfJGY1ht+jR7RpAQfvtKBACNSGZUXoRbJaadpumTXq+eFHxYWZjI8Dmi
	 kZY3EbhU7vmuIb7KRG16wc4GRaNJGNhhzyxi2feiqZ5iPIAr5Qti4UUyOCDLhE2V3q
	 /qmSWzs9HdrPNHcmo0VJsuDKj0ySE9rgcf4WzCo0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 104/122] nexthop: Emit a notification when a nexthop is added
Date: Tue, 30 Sep 2025 16:47:15 +0200
Message-ID: <20250930143827.238279309@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250930143822.939301999@linuxfoundation.org>
References: <20250930143822.939301999@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ido Schimmel <idosch@nvidia.com>

[ Upstream commit 732d167bf5f53a8c1e8c53cf7dbffe2a13f63752 ]

Emit a notification in the nexthop notification chain when a new nexthop
is added (not replaced). The nexthop can either be a new group or a
single nexthop.

The notification is sent after the nexthop is inserted into the
red-black tree, as listeners might need to callback into the nexthop
code with the nexthop ID in order to mark the nexthop as offloaded.

A 'REPLACE' notification is emitted instead of 'ADD' as the distinction
between the two is not important for in-kernel listeners. In case the
listener is not familiar with the encoded nexthop ID, it can simply
treat it as a new one. This is also consistent with the route offload
API.

Changes since RFC:
* Reword commit message

Signed-off-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 390b3a300d78 ("nexthop: Forbid FDB status change while nexthop is in a group")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/nexthop.h | 3 ++-
 net/ipv4/nexthop.c    | 6 +++++-
 2 files changed, 7 insertions(+), 2 deletions(-)

diff --git a/include/net/nexthop.h b/include/net/nexthop.h
index fd87d727aa217..aa19809bfd733 100644
--- a/include/net/nexthop.h
+++ b/include/net/nexthop.h
@@ -105,7 +105,8 @@ struct nexthop {
 };
 
 enum nexthop_event_type {
-	NEXTHOP_EVENT_DEL
+	NEXTHOP_EVENT_DEL,
+	NEXTHOP_EVENT_REPLACE,
 };
 
 int register_nexthop_notifier(struct net *net, struct notifier_block *nb);
diff --git a/net/ipv4/nexthop.c b/net/ipv4/nexthop.c
index 0653aa518648c..3063aa1914b1f 100644
--- a/net/ipv4/nexthop.c
+++ b/net/ipv4/nexthop.c
@@ -1191,7 +1191,11 @@ static int insert_nexthop(struct net *net, struct nexthop *new_nh,
 
 	rb_link_node_rcu(&new_nh->rb_node, parent, pp);
 	rb_insert_color(&new_nh->rb_node, root);
-	rc = 0;
+
+	rc = call_nexthop_notifiers(net, NEXTHOP_EVENT_REPLACE, new_nh, extack);
+	if (rc)
+		rb_erase(&new_nh->rb_node, &net->nexthop.rb_root);
+
 out:
 	if (!rc) {
 		nh_base_seq_inc(net);
-- 
2.51.0



