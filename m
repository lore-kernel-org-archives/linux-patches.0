Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88B50344D88;
	Tue, 13 Oct 2026 12:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791895082; cv=none; b=KRFeW6D/BMGqb/ORv1cD5r9o6ACDD0+fQDsLxICHjafIsWqBamNO+dl9LwCL2mY5CpGdWwLJkCbJLYrANVc9Ini04HBPGOP0RNh5OUii3zDaubzptuPQOXE9VTFV1Q16FRKEcsao34Sj36aCzoj7mA3caXc6kNvucwN5GHlyjTw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791895082; c=relaxed/simple;
	bh=o75F/NJrrS59A1J8fHdwNdOSyDotw68x4+u93a7nYkc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=r1z+RNDO1/O3Wl8S8xrr2Uxha8dClUQvt/qHUqR4dfXXjyKp0A9NfbfYBnGd2vwzPEmQQvoNfV2EhYSFqhXhi4P8lbufB8+J4c8eeuerDDrILC3tCejl7poEIiDnM2P/kA0UElcAUH/AYEb+uXH7m6JxBGxtEz3vPlaCGKRUXlU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=spPL54zY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="spPL54zY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9AE41F0089B;
	Tue, 13 Oct 2026 12:38:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791895081;
	bh=Y9JueEWkjlT9QBCnr2NOMvrRuDkBzT39pXHLnihE/Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=spPL54zYz28TLTuwsLlnT3IkK8LAjEtSXShcrMnQa+PWhNgQ8o0/gUwgxdQdD6ai0
	 xcjmMasr2lcJDREYOPTWXGpRCQR5kmYjkn7+kUF0/B60+wyMkmGYA3OvEBqyChiHDH
	 r7Nppbul+Y6ialyLH2rv8uQXj3JYzAjYFyfXYJ+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.12 155/497] usb: typec: ucsi: Get the connector fwnode based on reg value
Date: Tue, 13 Oct 2026 13:35:22 +0200
Message-ID: <20261013112911.566865824@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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

From: Prashanth K <prashanth.k@oss.qualcomm.com>

commit 6c51f09c6db5868a5090e8dd4d7764660c87f1ad upstream.

ucsi_find_fwnode() currently maps UCSI connectors to Device tree
connector nodes based on the order in which connector child nodes
are described in DT.

This can fail because the ordering of child nodes isn't guaranteed
in Device-tree. For example, DTB may contain connector@1 before
connector@0, causing connector numbers to be associated with the wrong
fwnode. As a result, role switch and Type-C notifications can be
delivered to the wrong remote endpoints.

Fix this by using the "reg" property of each connector to match
its corresponding fwnode. While at it, if the reg property isn't
present, then fall back to the old method.

Fixes: c1b0bc2dabfa ("usb: typec: Add support for UCSI interface")
Cc: stable <stable@kernel.org>
Signed-off-by: Prashanth K <prashanth.k@oss.qualcomm.com>
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Link: https://patch.msgid.link/20260916042808.2879079-1-prashanth.k@oss.qualcomm.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/ucsi/ucsi.c |   17 ++++++++++++++---
 1 file changed, 14 insertions(+), 3 deletions(-)

--- a/drivers/usb/typec/ucsi/ucsi.c
+++ b/drivers/usb/typec/ucsi/ucsi.c
@@ -1542,10 +1542,21 @@ static struct fwnode_handle *ucsi_find_f
 {
 	struct fwnode_handle *fwnode;
 	int i = 1;
+	int ret;
+	u32 port;
 
-	device_for_each_child_node(con->ucsi->dev, fwnode)
-		if (i++ == con->num)
-			return fwnode;
+	device_for_each_child_node(con->ucsi->dev, fwnode) {
+		ret = fwnode_property_read_u32(fwnode, "reg", &port);
+		if (ret < 0) {
+			if (i == con->num)
+				return fwnode;
+		} else {
+			if (port == con->num - 1)
+				return fwnode;
+		}
+
+		i++;
+	}
 	return NULL;
 }
 


