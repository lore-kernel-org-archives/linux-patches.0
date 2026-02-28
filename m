Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7C86344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301783; cv=none; b=kiQjci+jG8y1jq1JgKsM32DiOGl2QKZh6ggBOyvBKGOz0GhCHqWiCtSjsa6bh0sboHo+mUrfL6U1HN/HZi2OCkedfGYs5rE8MRLm7K4LJtDwofpvJHILZHiNL9mmI8L6yj5wf+602rSP9pWPd0L3RrKExKyrV+Z+UHD1u2VXJ84=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301783; c=relaxed/simple;
	bh=ik2qGzdlGFDw5v/MNHWXb3cktEIGTU2gw2H1RMAGA84=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=he3NeuXVqG1env0WJ8zkLQykYd/MKJpd2ujzy+alcYu1HTsL2VHhnWaQmfiLIpYavnuhDkC3bNWIbN8/TdCAGtpsEZUz6H2A456hgyLIA1MfwAYH+6IhiQECzqVNJLq+BmBbAW0GbFFyhMlZYlpnJZ9IyDQUdD2RArghPKF36Rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=lo7mm463; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="lo7mm463"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43088C19423;
	Sat, 28 Feb 2026 18:03:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301782;
	bh=ik2qGzdlGFDw5v/MNHWXb3cktEIGTU2gw2H1RMAGA84=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lo7mm463W35Hp9eY6ixcD9/5AqAIAZ0rOaDRrCu1zqdPRKxvcDq4BhVnBU0Eh0FUf
	 EvW8CLz2lA4jQGAUdsITphWpIZGCmr3YN6PrF4W3cqLcSawnRqrPONB2QbGx1EBb/J
	 vu2xVmjdn0qjt7ouzyEc7axwLhB5cOhuv4N5cCwmhbPTCtle2NCXe71v/9vpiTlGgS
	 AfdZcmq1mD/n0jt4dpuyFcFeIlqx6re79H7OZh2yOe+vBhJT5LxRNDozxXxitXZerC
	 E1y3Zyb4PWn1u0lwtK8iRgMlAhjH2aXQDzYvkABXHruMEI+pbVtMfvP99rgLLr3uj2
	 o7DOYFZQzanbQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Fernando Fernandez Mancera <fmancera@suse.de>,
	Michal Slabihoudek <michal.slabihoudek@gooddata.com>,
	Florian Westphal <fw@strlen.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 193/385] netfilter: nf_conncount: fix tracking of connections from localhost
Date: Sat, 28 Feb 2026 12:56:55 -0500
Message-ID: <20260228180011.1568201-193-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Fernando Fernandez Mancera <fmancera@suse.de>

[ Upstream commit de8a70cefcb26cdceaafdc5ac144712681419c29 ]

Since commit be102eb6a0e7 ("netfilter: nf_conncount: rework API to use
sk_buff directly"), we skip the adding and trigger a GC when the ct is
confirmed. For connections originated from local to local it doesn't
work because the connection is confirmed on POSTROUTING, therefore
tracking on the INPUT hook is always skipped.

In order to fix this, we check whether skb input ifindex is set to
loopback ifindex. If it is then we fallback on a GC plus track operation
skipping the optimization. This fallback is necessary to avoid
duplicated tracking of a packet train e.g 10 UDP datagrams sent on a
burst when initiating the connection.

Tested with xt_connlimit/nft_connlimit and OVS limit and with a HTTP
server and iperf3 on UDP mode.

Fixes: be102eb6a0e7 ("netfilter: nf_conncount: rework API to use sk_buff directly")
Reported-by: Michal Slabihoudek <michal.slabihoudek@gooddata.com>
Closes: https://lore.kernel.org/netfilter/6989BD9F-8C24-4397-9AD7-4613B28BF0DB@gooddata.com/
Signed-off-by: Fernando Fernandez Mancera <fmancera@suse.de>
Signed-off-by: Florian Westphal <fw@strlen.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netfilter/nf_conncount.c | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/net/netfilter/nf_conncount.c b/net/netfilter/nf_conncount.c
index 288936f5c1bf9..14e62b3263cd9 100644
--- a/net/netfilter/nf_conncount.c
+++ b/net/netfilter/nf_conncount.c
@@ -179,14 +179,25 @@ static int __nf_conncount_add(struct net *net,
 		return -ENOENT;
 
 	if (ct && nf_ct_is_confirmed(ct)) {
-		err = -EEXIST;
-		goto out_put;
+		/* local connections are confirmed in postrouting so confirmation
+		 * might have happened before hitting connlimit
+		 */
+		if (skb->skb_iif != LOOPBACK_IFINDEX) {
+			err = -EEXIST;
+			goto out_put;
+		}
+
+		/* this is likely a local connection, skip optimization to avoid
+		 * adding duplicates from a 'packet train'
+		 */
+		goto check_connections;
 	}
 
 	if ((u32)jiffies == list->last_gc &&
 	    (list->count - list->last_gc_count) < CONNCOUNT_GC_MAX_COLLECT)
 		goto add_new_node;
 
+check_connections:
 	/* check the saved connections */
 	list_for_each_entry_safe(conn, conn_n, &list->head, node) {
 		if (collect > CONNCOUNT_GC_MAX_COLLECT)
-- 
2.51.0

