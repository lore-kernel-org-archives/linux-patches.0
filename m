Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A35D63DDDA0;
	Tue, 16 Jun 2026 19:00:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781636414; cv=none; b=OlaSfjnXRwETHTHSgL6Jr9nKWK6X06jccI6nkELUaI81rZB4VVDU+JumXjLvs+tD+NTXE6lYQe9Yk8bIgDrgoukS8GXkdbtIcJGYfLHQ9/xzzHQQmM/Qd+iy79G2BB3qT9mg6o9M12MKRTo03Vv3u3BUEir5IlLF6cJs0FNt+28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781636414; c=relaxed/simple;
	bh=CpMeTqx4jGE/nVzUNGtw44QB40V/twVUn8+SEHEgr48=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jBYdAsb0kM9DXCUDAnOTk5wcH23qPVui5SUF6tAzxoeTOnk+gGJHwruQjr112MG3Oj+9uAYKwGaaB/6ZoQZVld8xio4Yc6eOABaYjsiBdTC+vRIZ3hKoQge7P9BgO7S3NEZOy9An+yDQJUmDvPVhmYVRGBtzI6ViybflYinE+Io=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KxpfgL9q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KxpfgL9q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB9891F000E9;
	Tue, 16 Jun 2026 19:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781636413;
	bh=srlf/+/ix78n/uiu51HatcIJL3WRoKbFuM82kG6/BOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KxpfgL9qHIy1KHvdcdnIIV54W7C6EXBeClBe+wGEgkSjGSK4kVwA0UOykIaxM8F30
	 VdXZE0fBdqniBYPFXhq+s4pwH+Dmy9mAyVutKymx5XoditWg7Kha6kJv+60UiRKL6s
	 wYX4q9q6XjGShjWyrMv5g2A+L1HsJ/MJKyvs9DZE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 234/342] net: qrtr: ns: Limit the maximum number of lookups
Date: Tue, 16 Jun 2026 20:28:50 +0530
Message-ID: <20260616145059.100980140@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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
@@ -598,6 +605,11 @@ static int ctrl_cmd_new_lookup(struct so
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
@@ -606,6 +618,7 @@ static int ctrl_cmd_new_lookup(struct so
 	lookup->service = service;
 	lookup->instance = instance;
 	list_add_tail(&lookup->li, &qrtr_ns.lookups);
+	qrtr_ns.lookup_count++;
 
 	memset(&filter, 0, sizeof(filter));
 	filter.service = service;
@@ -672,6 +685,7 @@ static void ctrl_cmd_del_lookup(struct s
 
 		list_del(&lookup->li);
 		kfree(lookup);
+		qrtr_ns.lookup_count--;
 	}
 }
 


