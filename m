Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7D813E3C49;
	Mon,  4 May 2026 14:27:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904863; cv=none; b=KQDh/ISFh8rAQqHHdwLvIob8UQUWo33HLIOikq3vdGUG4zQrF+ah2HpIVQ3OaZzFLW//kteqN/FNiVe/e8wmUEIgjW42qJLFXBQ1Mi79Xiyfg3D7B6fftgiMgVCmbioAeAtyV/4v8kNxDPl+i+GzKSgjI1WvB3BGRu4gdZ8pPZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904863; c=relaxed/simple;
	bh=w1YqLDry5rTeNaWm15sEvMMufUD8d6qNMnCUzLrZjj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aaXyjAPZwjpc4CUmzPJVbc5c2Fhol5EjLz6Tf80VDm9RmadVczKdjVtKYPOe6cW+h5199K1YcsQ+ojOrgjQrykQVZY1lZfl1KBse7IV1sfX2iuq+1p9thvYdMGUMg45grJFie7qyFcT2iXuyiN3/VTwFQd1sLGaQg8aMZj4DnJs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cTHAp2Ot; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cTHAp2Ot"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1DAAFC2BCF4;
	Mon,  4 May 2026 14:27:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904863;
	bh=w1YqLDry5rTeNaWm15sEvMMufUD8d6qNMnCUzLrZjj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cTHAp2Otr8U41B8bd5EOKU5b5CAccMs+Y7XVa0v6Ekfe7eZW3uxspWS/UzZPRbOD/
	 ESYxHJkkh758R/PEuZT2nzoPeOlWWuS3s2JQAuZjQp+gdw5KXyF3jFPVYSBv7pp05O
	 juFzNbbXPmUNqq7nqGiMSK9Uj0WM4F9f/Lqws5CA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 202/215] net: qrtr: ns: Limit the total number of nodes
Date: Mon,  4 May 2026 15:53:41 +0200
Message-ID: <20260504135138.076493217@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135130.169210693@linuxfoundation.org>
References: <20260504135130.169210693@linuxfoundation.org>
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

From: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>

[ Upstream commit 27d5e84e810b0849d08b9aec68e48570461ce313 ]

Currently, the nameserver doesn't limit the number of nodes it handles.
This can be an attack vector if a malicious client starts registering
random nodes, leading to memory exhaustion.

Hence, limit the maximum number of nodes to 64. Note that, limit of 64 is
chosen based on the current platform requirements. If requirement changes
in the future, this limit can be increased.

Cc: stable@vger.kernel.org
Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260409-qrtr-fix-v3-4-00a8a5ff2b51@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
[ dropped comment/define changes for missing QRTR_NS_MAX_SERVERS/LOOKUPS prereqs and kept plain kzalloc instead of kzalloc_obj ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/ns.c |   15 +++++++++++++++
 1 file changed, 15 insertions(+)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -82,6 +82,13 @@ struct qrtr_node {
  */
 #define QRTR_NS_MAX_LOOKUPS 64
 
+/* Max nodes limit is chosen based on the current platform requirements.
+ * If the requirement changes in the future, this value can be increased.
+ */
+#define QRTR_NS_MAX_NODES   64
+
+static u8 node_count;
+
 static struct qrtr_node *node_get(unsigned int node_id)
 {
 	struct qrtr_node *node;
@@ -90,6 +97,11 @@ static struct qrtr_node *node_get(unsign
 	if (node)
 		return node;
 
+	if (node_count >= QRTR_NS_MAX_NODES) {
+		pr_err_ratelimited("QRTR clients exceed max node limit!\n");
+		return NULL;
+	}
+
 	/* If node didn't exist, allocate and insert it to the tree */
 	node = kzalloc(sizeof(*node), GFP_KERNEL);
 	if (!node)
@@ -103,6 +115,8 @@ static struct qrtr_node *node_get(unsign
 		return NULL;
 	}
 
+	node_count++;
+
 	return node;
 }
 
@@ -409,6 +423,7 @@ static int ctrl_cmd_bye(struct sockaddr_
 delete_node:
 	xa_erase(&nodes, from->sq_node);
 	kfree(node);
+	node_count--;
 
 	return ret;
 }


