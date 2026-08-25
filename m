Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8ED9E33F5B3;
	Tue, 25 Aug 2026 14:00:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787666430; cv=none; b=hnrUhyoVZeEl6nsYnu/uJRCImE9kmI+sHkPgFgNkUpDCxRGSzJrsQHAcu9yTbFwFczcz45WDjBJz7lhd15iOLB2mDOqn7ruE+JKN4W/DtJplqVx5WBEsOP5ld+EYgGd63E4XYLq8nTwIwMQf0OXYac2RpUFdk2Zqt+WnzavtuXk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787666430; c=relaxed/simple;
	bh=mlIoQlIsjzRPYoSmPka73yb82Pzv8iksuCACSIzOYrA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHMcdAISAjTLgDyxBDBmHxzXyibV9eBJEN7ygB+XkaAybxaI8alAP1YJwc31ijz2KiQc4YeNhjBcNEZ/LPJhEONpWcDaI7mHHkF5njKe5iaVAKO3Xvmdw6hWtvXut5kRD/Va8JC0bvMP4DueUSg6IYDxozKn07Wf2YUi+MjdoFY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EmUXypiU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EmUXypiU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE8AD1F00A3D;
	Tue, 25 Aug 2026 14:00:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1787666429;
	bh=nw24sNafeQpIrGj3PDTcHBS9smAkd5wAGSH4lJHrRj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EmUXypiUt0qp1/igvs8f3XhMtPbZITu2+9Tdqi9pOk5bphiGq45M8i4WKHWIxNuT5
	 /Blt0tsJJCIkjdw9kGIuIFvAR+SaxiA7sQnXvYj99FgDgjFxVZke3MB9TLbruKcZxW
	 WuuMMR3ykTPF3Zo7zhDCJOsv5uJhjoEMNClE0kXQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Vega <vega@nebusec.ai>,
	Zijie Huang <milkory@outlook.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 22/57] net/sched: reject overly deep qdisc hierarchies
Date: Tue, 25 Aug 2026 15:26:44 +0200
Message-ID: <20260825132542.162192553@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260825132541.342390421@linuxfoundation.org>
References: <20260825132541.342390421@linuxfoundation.org>
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

From: Zijie Huang <milkory@outlook.com>

[ Upstream commit dedd34b0f2310e28c5f6d4875cfbf4b7ed821c01 ]

Deep qdisc hierarchies can lead to excessive recursion in qdisc tree
walkers and exhaust the kernel stack. The existing loop check does not
cover the create-and-graft path, so a hierarchy can still be extended by
creating a new child qdisc below an already deep parent.

Store the hierarchy depth in struct Qdisc and update it when qdiscs are
grafted. Reject new child qdiscs once the parent is already at the maximum
allowed depth.

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Cc: stable@vger.kernel.org
Suggested-by: Jamal Hadi Salim <jhs@mojatatu.com>
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: Codex:gpt-5.4
Signed-off-by: Zijie Huang <milkory@outlook.com>
Signed-off-by: Ren Wei <enjou1224z@gmail.com>
Reviewed-by: Victor Nogueira <victor@mojatatu.com>
Link: https://patch.msgid.link/1e9ab39597423fd5d13cfaaf52279b8ee3d9fc3c.1785434373.git.milkory@outlook.com
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Dropped the `extack` argument from the `notify_and_destroy()` context line to match 5.15's 6-parameter version. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |    1 +
 net/sched/sch_api.c       |    9 +++++++++
 2 files changed, 10 insertions(+)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -86,6 +86,7 @@ struct Qdisc {
 	struct hlist_node       hash;
 	u32			handle;
 	u32			parent;
+	int			depth;
 
 	struct netdev_queue	*dev_queue;
 
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1045,6 +1045,9 @@ static int qdisc_graft(struct net_device
 		unsigned int i, num_q, ingress;
 		struct netdev_queue *dev_queue;
 
+		if (new)
+			new->depth = 0;
+
 		ingress = 0;
 		num_q = dev->num_tx_queues;
 		if ((q && q->flags & TCQ_F_INGRESS) ||
@@ -1124,9 +1127,15 @@ skip:
 			NL_SET_ERR_MSG(extack, "STAB not supported on a non root");
 			return -EINVAL;
 		}
+		if (new && parent->depth >= 7) {
+			NL_SET_ERR_MSG(extack, "Qdisc hierarchy is too deep");
+			return -E2BIG;
+		}
 		err = cops->graft(parent, cl, new, &old, extack);
 		if (err)
 			return err;
+		if (new)
+			new->depth = parent->depth + 1;
 		notify_and_destroy(net, skb, n, classid, old, new);
 	}
 	return 0;


