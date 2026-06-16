Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCC4E32A3C9;
	Tue, 16 Jun 2026 17:48:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781632119; cv=none; b=h+Z3wlyRChh6hrQlRAVKjWy5kSHiC+JyKKcGsQH1nQj/sRyiL9eIwdFZvzlZ5ipQI+9nmEKEtJ3gopzx2wZgJ1nztghVfljrIXygaiW6ulUlDJs2RL0E5ORL7RZ+IXzAttd1UHO0LOuJFn+mj/BXOKHIZR3s1J4kiknCod1Zeyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781632119; c=relaxed/simple;
	bh=AADYYVnV8I5shql0q74u3qHb3zpiFyFJpH5o19mv8Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=enrPmhiTQOHRomkX+5RucwO8BdfxD0sUlOkKul7wKouOV49DsZVnEUnsAjzYdxI9U556tv6s3uhVjoi0EE/1Ixzxq4m4KWTTRyjV4pJUGFJr1aLRB6YL+lEmKXTUHAXaPnMPbAQKeFhLcQEiwPs9FT9DmwD6U+Z35MJ34Zl6lks=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xB1DYT0A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xB1DYT0A"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AFB31F000E9;
	Tue, 16 Jun 2026 17:48:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781632118;
	bh=GcgiAI68WIChFcMxzIYXOR3o5M13ceokSe3NDLvY/oY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xB1DYT0AVqZeYlrMJuIG1nyA/LvX86eUTsNPMSz6W/HoY0ZeG6gfBJQJvIvrJI5fb
	 LbTn4MAsLYwvm+A6OBfC+WAGjR5LpBe38P60dJdDqcxFstvQnasYZLeahKHlaSn94p
	 BO5p9gGMMDCevyaiTBVPzzZMsD9swREUeMHzw8Ms=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@oss.qualcomm.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 351/522] net: qrtr: ns: Free the node during ctrl_cmd_bye()
Date: Tue, 16 Jun 2026 20:28:18 +0530
Message-ID: <20260616145142.219322131@linuxfoundation.org>
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

[ Upstream commit 68efba36446a7774ea5b971257ade049272a07ac ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/qrtr/ns.c |   20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

--- a/net/qrtr/ns.c
+++ b/net/qrtr/ns.c
@@ -344,7 +344,7 @@ static int ctrl_cmd_bye(struct sockaddr_
 	struct qrtr_node *node;
 	unsigned long index;
 	struct kvec iv;
-	int ret;
+	int ret = 0;
 
 	iv.iov_base = &pkt;
 	iv.iov_len = sizeof(pkt);
@@ -359,8 +359,10 @@ static int ctrl_cmd_bye(struct sockaddr_
 
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
@@ -377,10 +379,18 @@ static int ctrl_cmd_bye(struct sockaddr_
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


