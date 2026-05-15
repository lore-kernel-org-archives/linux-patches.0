Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83E0B39B971;
	Fri, 15 May 2026 16:00:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860859; cv=none; b=EBbOC6OGzthajdxG0q9Y47TXw27Cobk30FGoAt5DzO4RiTQVT165CRXclqUQaogw4EBuClCmSH35jSKuOoaR+OUSKYkzUzkeCO5kYl59pgmYNKKB0vl0BPeJzuQgB+8g8cdxSRofchwmBRG+Ams1ot0sYsZMOM5ylu7+Fu38VDo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860859; c=relaxed/simple;
	bh=XWkNoZ9146MuWTt1DO+Og6cjP5+YxBzSgXbU5nITfDs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BjaNffDaNpUjOWdP8RwE1HijFbu5LC0vyKPlLryFCxAxMlJ8R4HiZ3yJE7mXRmK24KzH4totWTnpLVfiTY7ahl6Oa8RuntpKqoYPvanvrObYb1JOJmzCodTlIILQZ+D3qLXsnuud7sHLuj3pu+4tWYXL2akRG9mGidESFXrkjHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R0zIDY0N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R0zIDY0N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15756C2BCB0;
	Fri, 15 May 2026 16:00:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860859;
	bh=XWkNoZ9146MuWTt1DO+Og6cjP5+YxBzSgXbU5nITfDs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R0zIDY0NrNFpP65bgmPl4VAqXTtE20rBUXKE5mVRYCVuWX92+/SxsyApspa02uDoe
	 +7p3X3yO2JwMSFotprUWacVH4+41fuctdu8C81RG77Lgt3ARUOxWAM0O/ENeVShNyc
	 Wt/+LWFCVB5IoFFzq/iJdyGdyZdyeuIFJjCg3abo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 069/474] net: qrtr: ns: Free the node during ctrl_cmd_bye()
Date: Fri, 15 May 2026 17:42:58 +0200
Message-ID: <20260515154716.535908379@linuxfoundation.org>
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

commit 68efba36446a7774ea5b971257ade049272a07ac upstream.

A node sends the BYE packet when it is about to go down. So the nameserver
should advertise the removal of the node to all remote and local observers
and free the node finally. But currently, the nameserver doesn't free the
node memory even after processing the BYE packet. This causes the node
memory to leak.

Hence, remove the node from Xarray list and free the node memory during
both success and failure case of ctrl_cmd_bye().

Cc: stable@vger.kernel.org
Fixes: 0c2204a4ad71 ("net: qrtr: Migrate nameservice to kernel from userspace")
Signed-off-by: Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>
Link: https://patch.msgid.link/20260409-qrtr-fix-v3-3-00a8a5ff2b51@oss.qualcomm.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/ns.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -339,7 +339,7 @@ static int ctrl_cmd_bye(struct sockaddr_
 	struct qrtr_node *node;
 	unsigned long index;
 	struct kvec iv;
-	int ret;
+	int ret = 0;
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -354,8 +354,10 @@ static int ctrl_cmd_bye(struct sockaddr_
 
 	/* Advertise the removal of this client to all local servers */
 	local_node = node_get(qrtr_ns.local_node);
-	if (!local_node)
-		return 0;
+	if (!local_node) {
+		ret = 0;
+		goto delete_node;
+	}
 
 	memset(&pkt, 0, sizeof(pkt));
 	pkt.cmd = cpu_to_le32(QRTR_TYPE_BYE);
@@ -372,10 +374,18 @@ static int ctrl_cmd_bye(struct sockaddr_
 		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
 		if (ret < 0) {
 			pr_err("failed to send bye cmd\n");
-			return ret;
+			goto delete_node;
 		}
 	}
-	return 0;
+
+	/* Ignore -ENODEV */
+	ret = 0;
+
+delete_node:
+	xa_erase(&nodes, from->sq_node);
+	kfree(node);
+
+	return ret;
 }
 
 static int ctrl_cmd_del_client(struct sockaddr_qrtr *from,


