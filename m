Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 398EB32A3C9;
	Tue, 16 Jun 2026 17:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632109; cv=none; b=Y0na/aL8hMdUJeH/vR6CV26hacfWlBkqwZ3o0VQtNEWLpAB4JAChVVBD3aG1/ulzgKpFdlpubok0+hRbnJN6Xp9DXJOZsURB1qLo+W3kY8eYvk7xiSoNO0Sj13MMGK6rjp1ICLAY8tORnb2nBvvUWTHBJQ6KuDi+dHw01wJZpMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632109; c=relaxed/simple;
	bh=SlIkBw4dDh4Y0sFNR0vajk7DVxaZDT/KCmzEmZriVjg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MBRcwMciHOihl2DeFgK17UZKmOJ22635vzJnO3SIVTo8jy2lbAijQ25Ua47Okjc9J4M4FuFcTCmgQZWuWyYcZYKoh+F+hLAtMy1uOPWttRFY3kjcRidbvaB0bKUO8JwfM612mGCqzvheIjM5847W4iDt+CC+VVUJ6Cnoz8QVsNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mY6J/uvN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mY6J/uvN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDF101F000E9;
	Tue, 16 Jun 2026 17:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632107;
	bh=A8zGXQWzxGJ0YyX4G2b9mS5tZH6RiDyX4ecEY6eg3Wc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mY6J/uvNIoxBH7rOIfgv2XmCr80ndIZ0wCIRr9IWGUeewND3gsIGBjBA3rfTLXWXk
	 hjbNYKPJIFJ2mAx5/kY/9eYm55ccb3ld5xCwVnNEzlPioy/SKHFGlT470SDEzF+fPK
	 TdkchQiEodUSVw83apREY+4qsrxpVaL584m2x7tU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 349/522] net: qrtr: ns: Limit the maximum number of lookups
Date: Tue, 16 Jun 2026 20:28:16 +0530
Message-ID: <20260616145142.128957783@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145125.307082728@linuxfoundation.org>
References: <20260616145125.307082728@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 5640227d9a21c6a8be249a10677b832e7f40dc55 ]

Current code does no bound checking on the number of lookups a client can
perform. Though the code restricts the lookups to local clients, there is
still a possibility of a malicious local client sending a flood of
NEW_LOOKUP messages over the same socket.

Fix this issue by limiting the maximum number of lookups to 64 globally.
Since the nameserver allows only atmost one local observer, this global
lookup count will ensure that the lookups stay within the limit.

Note that, limit of 64 is chosen based on the current platform
requirements. If requirement changes in the future, this limit can be
increased.

Cc: stable@vger.kernel.org
Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260409-qrtr-fix-v3-2-00a8a5ff2b51@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ adapted comment block to only mention QRTR_NS_MAX_LOOKUPS and kept kzalloc() instead of kzalloc_obj() due to missing prerequisite commits ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/ns.c |   14 ++++++++++++++
 1 file changed, 14 insertions(+)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -21,6 +21,7 @@ static struct {
 	struct socket *sock;
 	struct sockaddr_qrtr bcast_sq;
 	struct list_head lookups;
+	u32 lookup_count;
 	struct workqueue_struct *workqueue;
 	struct work_struct work;
 	void (*saved_data_ready)(struct sock *sk);
@@ -69,6 +70,11 @@ struct qrtr_node {
 	struct radix_tree_root servers;
 };
 
+/* Max lookup limit is chosen based on the current platform requirements. If the
+ * requirement changes in the future, this value can be increased.
+ */
+#define QRTR_NS_MAX_LOOKUPS 64
+
 static struct qrtr_node *node_get(unsigned int node_id)
 {
 	struct qrtr_node *node;
@@ -457,6 +463,7 @@ static int ctrl_cmd_del_client(struct so
 
 		list_del(&lookup->li);
 		kfree(lookup);
+		qrtr_ns.lookup_count--;
 	}
 
 	/* Remove the server belonging to this port but don't broadcast
@@ -590,6 +597,11 @@ static int ctrl_cmd_new_lookup(struct so
 	if (from->sq_node != qrtr_ns.local_node)
 		return -EINVAL;
 
+	if (qrtr_ns.lookup_count >= QRTR_NS_MAX_LOOKUPS) {
+		pr_err_ratelimited("QRTR client node exceeds max lookup limit!\n");
+		return -ENOSPC;
+	}
+
 	lookup = kzalloc(sizeof(*lookup), GFP_KERNEL);
 	if (!lookup)
 		return -ENOMEM;
@@ -598,6 +610,7 @@ static int ctrl_cmd_new_lookup(struct so
 	lookup->service = service;
 	lookup->instance = instance;
 	list_add_tail(&lookup->li, &qrtr_ns.lookups);
+	qrtr_ns.lookup_count++;
 
 	memset(&filter, 0, sizeof(filter));
 	filter.service = service;
@@ -664,6 +677,7 @@ static void ctrl_cmd_del_lookup(struct s
 
 		list_del(&lookup->li);
 		kfree(lookup);
+		qrtr_ns.lookup_count--;
 	}
 }
 


