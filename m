Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5049F3D3308;
	Mon,  4 May 2026 14:01:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903273; cv=none; b=fxrO7FgLIo2Z3q4HGy+9Nghp9uqq8Dzvu368ilx1R6PljGEB+UyBSdEXXi2ldG4tL/5f3kkyevN9aDqgFZRM9V7A7wTA6VBNmBZRk4/3YhsS2DTzlmCjFtrvm7GojCoHmhWnfcrCDqm8K8+7Qsynx7DK/WPWQSb2aWsaEcAgh1I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903273; c=relaxed/simple;
	bh=YO/mXTW63Iy/j8cWILf+uDjdcgRg4LpR8Ti9kiEazwI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Sl1qGLlBkTylpzfGBMnRhW+ulw/ivrhq4JlbYWt2pWBa3NRblwvwaJBemBXH95uXJHXm1RD43axESjrJ2Uz8EMiqp0f4H/Pe9x2WLbTG6Mg05GcBIh+SGsRLfUp33iRdp7LH+QWQk8vi1Poy63/39NehuoLC5pz0+4c+LQyZ9TM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oTIQU12d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oTIQU12d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9ED0C2BCB8;
	Mon,  4 May 2026 14:01:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903273;
	bh=YO/mXTW63Iy/j8cWILf+uDjdcgRg4LpR8Ti9kiEazwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oTIQU12dsnw2cVUcClPp1CMm0xIdSniVxzFaQ+P+GnQYL9iOVbERxj83OD7M63jcC
	 eMELVjys0u+4MuO0PNOpcDW1pRNjhJu41sqJciHUxI2NlRXkUcfQkfIApI53P0Ds10
	 +xJeUGDrhzp23U9nJO29UMazwQYV7uEJAIQWqzNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 137/307] net: qrtr: ns: Limit the maximum server registration per node
Date: Mon,  4 May 2026 15:50:22 +0200
Message-ID: <20260504135147.940331446@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.814938198@linuxfoundation.org>
References: <20260504135142.814938198@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

commit d5ee2ff98322337951c56398e79d51815acbf955 upstream.

Current code does no bound checking on the number of servers added per
node. A malicious client can flood NEW_SERVER messages and exhaust memory.

Fix this issue by limiting the maximum number of server registrations to
256 per node. If the NEW_SERVER message is received for an old port, then
don't restrict it as it will get replaced. While at it, also rate limit
the error messages in the failure path of qrtr_ns_worker().

Note that the limit of 256 is chosen based on the current platform
requirements. If requirement changes in the future, this limit can be
increased.

Cc: stable@vger.kernel.org
Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Reported-by: Yiming Qian <yimingqian591@gmail.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260409-qrtr-fix-v3-1-00a8a5ff2b51@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/ns.c |   26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -68,8 +68,14 @@ struct qrtr_server {
 struct qrtr_node {
 	unsigned int id;
 	struct xarray servers;
+	u32 server_count;
 };
 
+/* Max server limit is chosen based on the current platform requirements. If the
+ * requirement changes in the future, this value can be increased.
+ */
+#define QRTR_NS_MAX_SERVERS 256
+
 static struct qrtr_node *node_get(unsigned int node_id)
 {
 	struct qrtr_node *node;
@@ -230,6 +236,17 @@ static struct qrtr_server *server_add(un
 	if (!service || !port)
 		return NULL;
 
+	node = node_get(node_id);
+	if (!node)
+		return NULL;
+
+	/* Make sure the new servers per port are capped at the maximum value */
+	old = xa_load(&node->servers, port);
+	if (!old && node->server_count >= QRTR_NS_MAX_SERVERS) {
+		pr_err_ratelimited("QRTR client node %u exceeds max server limit!\n", node_id);
+		return NULL;
+	}
+
 	srv = kzalloc_obj(*srv);
 	if (!srv)
 		return NULL;
@@ -239,10 +256,6 @@ static struct qrtr_server *server_add(un
 	srv->node = node_id;
 	srv->port = port;
 
-	node = node_get(node_id);
-	if (!node)
-		goto err;
-
 	/* Delete the old server on the same port */
 	old = xa_store(&node->servers, port, srv, GFP_KERNEL);
 	if (old) {
@@ -253,6 +266,8 @@ static struct qrtr_server *server_add(un
 		} else {
 			kfree(old);
 		}
+	} else {
+		node->server_count++;
 	}
 
 	trace_qrtr_ns_server_add(srv->service, srv->instance,
@@ -293,6 +308,7 @@ static int server_del(struct qrtr_node *
 	}
 
 	kfree(srv);
+	node->server_count--;
 
 	return 0;
 }
@@ -671,7 +687,7 @@ static void qrtr_ns_worker(struct work_s
 		}
 
 		if (ret < 0)
-			pr_err("failed while handling packet from %d:%d",
+			pr_err_ratelimited("failed while handling packet from %d:%d",
 			       sq.sq_node, sq.sq_port);
 	}
 


