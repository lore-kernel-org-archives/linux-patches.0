Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A7F3CEB89;
	Mon,  4 May 2026 14:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903281; cv=none; b=OKfQ1az+PU4nSWSwIXHsxnaWf0Rcwa3e5QTTCceKaN+vUaz+0tMYjaY48khurZc0gt+KI7exKLU8flg+jCQw5+T5FQzqeLcDMmGji5VbXvo8S6IiRCSBgMdwuc3NvkytbQN79qqazHeFoabD14f0zRi+9Jz3cGMb4wEc/XI84yY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903281; c=relaxed/simple;
	bh=c7GEUQdacdaMlnBWeG2sOiF+neMb6QyUe9Nq0mChWqE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l86yrX1aeyRY9cNh0sYy65aYmxAzZZae+qBY14TZYB+dHLNPPuTZHc7KyYqLK+236n1stL1qqmgb1gbDHEeozHtD14V2uXon593REwqmRgU83PsYI6l/mRmlmqa6b3l9umaw62xOTALlEKNj99TSwlT81UADxA74uiGTDNc9dFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=okDzokWF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="okDzokWF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FB42C2BCC4;
	Mon,  4 May 2026 14:01:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903280;
	bh=c7GEUQdacdaMlnBWeG2sOiF+neMb6QyUe9Nq0mChWqE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=okDzokWFHuYj0zhiwhxFcOW6cp0KvqGDRzLaPw8Yw3EwCTgY+lDrtTvRHV87d5H2e
	 eeXddhg9F4d+Cy7Z5ijWduWAKzjSfr85hOjfLkB4bY4Rwwmf9v7er2wNE77sU8xS1y
	 xRIxIlbZAZ5IrLBXQnrROmEA0WBvVTVp+HD6lPl8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 140/307] net: qrtr: ns: Limit the total number of nodes
Date: Mon,  4 May 2026 15:50:25 +0200
Message-ID: <20260504135148.049553948@linuxfoundation.org>
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

commit 27d5e84e810b0849d08b9aec68e48570461ce313 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/ns.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -72,12 +72,16 @@ struct qrtr_node {
 	u32 server_count;
 };
 
-/* Max server, lookup limits are chosen based on the current platform requirements.
- * If the requirement changes in the future, these values can be increased.
+/* Max nodes, server, lookup limits are chosen based on the current platform
+ * requirements. If the requirement changes in the future, these values can be
+ * increased.
  */
+#define QRTR_NS_MAX_NODES   64
 #define QRTR_NS_MAX_SERVERS 256
 #define QRTR_NS_MAX_LOOKUPS 64
 
+static u8 node_count;
+
 static struct qrtr_node *node_get(unsigned int node_id)
 {
 	struct qrtr_node *node;
@@ -86,6 +90,11 @@ static struct qrtr_node *node_get(unsign
 	if (node)
 		return node;
 
+	if (node_count >= QRTR_NS_MAX_NODES) {
+		pr_err_ratelimited("QRTR clients exceed max node limit!\n");
+		return NULL;
+	}
+
 	/* If node didn't exist, allocate and insert it to the tree */
 	node = kzalloc_obj(*node);
 	if (!node)
@@ -99,6 +108,8 @@ static struct qrtr_node *node_get(unsign
 		return NULL;
 	}
 
+	node_count++;
+
 	return node;
 }
 
@@ -405,6 +416,7 @@ static int ctrl_cmd_bye(struct sockaddr_
 delete_node:
 	xa_erase(&nodes, from->sq_node);
 	kfree(node);
+	node_count--;
 
 	return ret;
 }


