Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 89EC23D5645;
	Mon,  4 May 2026 14:12:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777903938; cv=none; b=cMJyq7ZIKlovac8uKT0c4+jyjiCADXOqR1aoRZ+36bBSU1Pc6wuYuHmXC0Y79timaUG6r9UuCumHijiP37XfVVJfzsQCrFaw2fNPaxsO34EgpbkPXvGk+M31Bale4orm2UQlWG1Cm0eD3K0VTvaPOYI84b5/yKSTk4ddBE8F05g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777903938; c=relaxed/simple;
	bh=cTaefWwwkyuauyjuWEXsPMylvGNkjvhlHrpCM6TqndY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Em9ZERaTgA6lzZyrkqWZlbIK7hTJSMElSxLbgIfBgLr8z3x0yuijOlzSYdWwN2iliciAZ0bAZ0Lx+6lDtb8t1aJCY4FMHuCyA5HThYpxkKje1BeuaKNeR4BKOCXzMHQ/Km1EW5bf8NFCTw64VajnHKZmNqTBFCCs8cVc9GX+Ia0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=onCpgN+J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="onCpgN+J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FBB3C2BCB8;
	Mon,  4 May 2026 14:12:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777903938;
	bh=cTaefWwwkyuauyjuWEXsPMylvGNkjvhlHrpCM6TqndY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=onCpgN+JxpuH8tZW8ofMhw4Fw/jC9wNeMeg3ycjvc/ig0DEfzSNGkkrWZlQjBGEP6
	 PT/ciBjqdflBZwxPtJVfQ8tBAyOQcemLswma2neuu1rvTj1SOYE+CdolI4dwLDAXm5
	 LpdgI5tU8uag20QDhVuJf3V4LT0qR8suiT391ISQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 119/275] net: qrtr: ns: Free the node during ctrl_cmd_bye()
Date: Mon,  4 May 2026 15:50:59 +0200
Message-ID: <20260504135147.327677801@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -342,7 +342,7 @@ static int ctrl_cmd_bye(struct sockaddr_
 	struct qrtr_node *node;
 	unsigned long index;
 	struct kvec iv;
-	int ret;
+	int ret = 0;
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -357,8 +357,10 @@ static int ctrl_cmd_bye(struct sockaddr_
 
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
@@ -375,10 +377,18 @@ static int ctrl_cmd_bye(struct sockaddr_
 		ret = kernel_sendmsg(qrtr_ns.sock, &msg, &iv, 1, sizeof(pkt));
 		if (ret < 0 && ret != -ENODEV) {
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


