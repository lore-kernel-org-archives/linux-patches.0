Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3E23BB687;
	Mon, 17 Aug 2026 14:14:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786976049; cv=none; b=jyFjEGMJVusvQKelWrZUIFG/uUh82LJHnyjE0wk3RNTOHHz4ZWldvp6Fss8YiD+BT6TTRSJCsjbFgP8hKp0IoX4d72yLPR+nLYg9X0shlnOwcYRz1ll1KOhxrdUPXnDFIvhOQiV4WsNC4MndWm2ikrSPYnNqxOA2FcrCk4yz7JM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786976049; c=relaxed/simple;
	bh=c2bT1vWV63HWcEEB3n02J67NyqWdC8R/B3H0/89uNU0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P8NcVYVCFnzxcUxEboBH9rmtmSWoxgvBWGhnwweX2g9Q8Lzll6ZTN2xr3ZZOlrn164EXtFFTig/YA/3Ez1d5v8NFYcGkEqqWgViHeVvKP7N1pbqVddpT/0y7wBiXFJN3kC+mpW9R0D/yolF/I2P3Z2HCBWpzcUnkVHi4ldQ7uR0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NkTZI5hP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NkTZI5hP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EB8501F000E9;
	Mon, 17 Aug 2026 14:14:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786976048;
	bh=uCpxsCYRCGWre+IlnhBawPPOyxZ2gnfX6GZljbpXELs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NkTZI5hPEOdWuj7LA1tun8KwyMEuINChRqdK3i5FxraeMdCsivQRJPETZdnmsTZ7t
	 h21pQ/GBAY+rLp/P4Q7bnPQ+1EXU9YD2pmJX5GodsyGFUIEdncVLCEYmMWbQrwcEch
	 pYxOACo5TOk/hAfbEAngwMbhyyV1NDfD19NX1/Os=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yiming Qian <yimingqian591@gmail.com>,
	Simon Horman <horms@kernel.org>,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 200/389] net: qrtr: ns: Limit the maximum server registration per node
Date: Mon, 17 Aug 2026 15:30:39 +0200
Message-ID: <20260817132547.005266054@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132538.796021292@linuxfoundation.org>
References: <20260817132538.796021292@linuxfoundation.org>
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

[ Upstream commit d5ee2ff98322337951c56398e79d51815acbf955 ]

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
Signed-off-by: Youssef Samir <youssef.abdulrahman@oss.qualcomm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/qrtr/ns.c | 26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

diff --git a/net/qrtr/ns.c b/net/qrtr/ns.c
index 36a7a9ad6b503..440e68601e251 100644
--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -68,13 +68,9 @@ struct qrtr_server {
 struct qrtr_node {
 	unsigned int id;
 	struct xarray servers;
+	u32 server_count;
 };
 
-/* Max lookup limit is chosen based on the current platform requirements. If the
- * requirement changes in the future, this value can be increased.
- */
-#define QRTR_NS_MAX_LOOKUPS 64
-
 /* Max nodes, server, lookup limits are chosen based on the current platform
  * requirements. If the requirement changes in the future, these values can be
  * increased.
@@ -249,6 +245,17 @@ static struct qrtr_server *server_add(unsigned int service,
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
 	srv = kzalloc(sizeof(*srv), GFP_KERNEL);
 	if (!srv)
 		return NULL;
@@ -258,10 +265,6 @@ static struct qrtr_server *server_add(unsigned int service,
 	srv->node = node_id;
 	srv->port = port;
 
-	node = node_get(node_id);
-	if (!node)
-		goto err;
-
 	/* Delete the old server on the same port */
 	old = xa_store(&node->servers, port, srv, GFP_KERNEL);
 	if (old) {
@@ -272,6 +275,8 @@ static struct qrtr_server *server_add(unsigned int service,
 		} else {
 			kfree(old);
 		}
+	} else {
+		node->server_count++;
 	}
 
 	trace_qrtr_ns_server_add(srv->service, srv->instance,
@@ -312,6 +317,7 @@ static int server_del(struct qrtr_node *node, unsigned int port, bool bcast)
 	}
 
 	kfree(srv);
+	node->server_count--;
 
 	return 0;
 }
@@ -716,7 +722,7 @@ static void qrtr_ns_worker(struct work_struct *work)
 		}
 
 		if (ret < 0)
-			pr_err("failed while handling packet from %d:%d",
+			pr_err_ratelimited("failed while handling packet from %d:%d",
 			       sq.sq_node, sq.sq_port);
 	}
 
-- 
2.53.0



