Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45B7020297C;
	Fri, 15 May 2026 16:13:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861598; cv=none; b=kmIgsP1RR7JvLBg5FLWV8xjxxWb6vq5w5mc7rBW9kwqDibD0HAywTZbMTUBw6Q9qigFoo32VmV/FbbGaIMIqvlU9J1qpf8H8UXVl88KqhrAPnvDzawULLhmJ7dUf3FOKDHrip8NEhdUjuc/xAp3ofU3gg6GAb24hoO+U/cyby/0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861598; c=relaxed/simple;
	bh=5Zqly2z0475CEpwt/t9ql2ugMmPOEm/WxQ4eZQeWSqA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V0iC2Pz23FPcLH9DMDj1XKZ8njppU2W7DPcjki4n9mC8Q51PgCr5NxM3LKD0ETQ/TTIRwsULUEV3yP5ZAFnkMFbhFTSrvQ3fD5OQsX7uqOlyYrsQBdPZ9OXfo74RRjyV6W/+JNj9rBmDQ7nMvCKRkjVJyd8420/VJkCHKtRr8so=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HwMGE0L+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HwMGE0L+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A46AFC2BCB0;
	Fri, 15 May 2026 16:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861598;
	bh=5Zqly2z0475CEpwt/t9ql2ugMmPOEm/WxQ4eZQeWSqA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HwMGE0L+ronWzNpZsefK6IEj5JEpDA36oz/AcWdEK9qMNKd7fpxCBCbysGgB5iLu3
	 i4PpnocxXHDC/2xc8akHNhkrPO4yEP+V9Ie5TSjkVH7iPOdv73Bg8HYMBt7iY30qnl
	 6nc/v5r/pSXGkSvRgeo1mYpulDCavkpKZF7YUYXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 391/474] net: qrtr: ns: Limit the maximum number of lookups
Date: Fri, 15 May 2026 17:48:20 +0200
Message-ID: <20260515154723.503721702@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -22,6 +22,7 @@ static struct {
 	struct socket *sock;
 	struct sockaddr_qrtr bcast_sq;
 	struct list_head lookups;
+	u32 lookup_count;
 	struct workqueue_struct *workqueue;
 	struct work_struct work;
 	void (*saved_data_ready)(struct sock *sk);
@@ -76,6 +77,11 @@ struct qrtr_node {
  */
 #define QRTR_NS_MAX_SERVERS 256
 
+/* Max lookup limit is chosen based on the current platform requirements. If the
+ * requirement changes in the future, this value can be increased.
+ */
+#define QRTR_NS_MAX_LOOKUPS 64
+
 static struct qrtr_node *node_get(unsigned int node_id)
 {
 	struct qrtr_node *node;
@@ -441,6 +447,7 @@ static int ctrl_cmd_del_client(struct so
 
 		list_del(&lookup->li);
 		kfree(lookup);
+		qrtr_ns.lookup_count--;
 	}
 
 	/* Remove the server belonging to this port but don't broadcast
@@ -558,6 +565,11 @@ static int ctrl_cmd_new_lookup(struct so
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
@@ -566,6 +578,7 @@ static int ctrl_cmd_new_lookup(struct so
 	lookup->service = service;
 	lookup->instance = instance;
 	list_add_tail(&lookup->li, &qrtr_ns.lookups);
+	qrtr_ns.lookup_count++;
 
 	memset(&filter, 0, sizeof(filter));
 	filter.service = service;
@@ -606,6 +619,7 @@ static void ctrl_cmd_del_lookup(struct s
 
 		list_del(&lookup->li);
 		kfree(lookup);
+		qrtr_ns.lookup_count--;
 	}
 }
 


