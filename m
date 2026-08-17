Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0DBEE42900D;
	Mon, 17 Aug 2026 14:48:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978085; cv=none; b=ReVDQ1xv7bab+0Oec4nac9qEuApdtB0OOcf+kA3Tp/qiqshI+vcDhFLem7SennYAap8+PbHuqrBcX4m/L6x50nf76foBcIsdZiLOr2jVZFVO9scCR0CPtaQKnfjRVIntzHprmP8QJMTYoqP0RN6Y7fLjrCXHPD3jg9tig/4/MT0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978085; c=relaxed/simple;
	bh=P8ngLWWy5hwrXcfL0vxesv83MWS31HdbfVknq2DDu6o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=js+vEPI+gbQYa7zX2ekIzXth479Kv2GEr0Z6u7YWxkv33eexaGe7H0iEaieITddJtZv5WTRPaXNGW5kxuG/WvVJWUYdCpo024i/MDyzbv+nkBrcvp4CmT9FmPKh9rihmuBOamYB33q/IX+UILgBWvPPE1Yj0Pd9RExOpvItUfbo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KbgYvozz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KbgYvozz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A894E1F000E9;
	Mon, 17 Aug 2026 14:48:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978082;
	bh=KchC/OMDJMHSIqqfvUv95mJG3ByIhBCNh6GoQH1omQM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KbgYvozzifBC8im6o4B3nfoXUJVqIIC3F6a5lagqvx2nVM/IaywVJLTjGYhwrjeym
	 yv/lV7mMSvWuNSKU0GpbB9McvzkX5MawZgFrz3lSF6iQpag0wkO6oaZncj2g9/dIit
	 jMfKDpSV9OWtqHjan2QCamFW2/O7lkn4dUwDXlP4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jamal Hadi Salim <jhs@mojatatu.com>,
	Vega <vega@nebusec.ai>,
	Zijie Huang <milkory@outlook.com>,
	Ren Wei <enjou1224z@gmail.com>,
	Victor Nogueira <victor@mojatatu.com>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.12 096/181] net/sched: reject overly deep qdisc hierarchies
Date: Mon, 17 Aug 2026 15:33:10 +0200
Message-ID: <20260817132539.234781503@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132535.394764707@linuxfoundation.org>
References: <20260817132535.394764707@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zijie Huang <milkory@outlook.com>

commit dedd34b0f2310e28c5f6d4875cfbf4b7ed821c01 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/sch_generic.h |    1 +
 net/sched/sch_api.c       |    9 +++++++++
 2 files changed, 10 insertions(+)

--- a/include/net/sch_generic.h
+++ b/include/net/sch_generic.h
@@ -101,6 +101,7 @@ struct Qdisc {
 	struct hlist_node       hash;
 	u32			handle;
 	u32			parent;
+	int			depth;
 
 	struct netdev_queue	*dev_queue;
 
--- a/net/sched/sch_api.c
+++ b/net/sched/sch_api.c
@@ -1095,6 +1095,9 @@ static int qdisc_graft(struct net_device
 		unsigned int i, num_q, ingress;
 		struct netdev_queue *dev_queue;
 
+		if (new)
+			new->depth = 0;
+
 		ingress = 0;
 		num_q = dev->num_tx_queues;
 		if ((q && q->flags & TCQ_F_INGRESS) ||
@@ -1192,9 +1195,15 @@ skip:
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
 		notify_and_destroy(net, skb, n, classid, old, new, extack);
 	}
 	return 0;


