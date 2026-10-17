Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1CEFC38424C;
	Sat, 17 Oct 2026 17:02:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792256557; cv=none; b=eI5PTj4G5DGS/4P6s0GbuVtcFMM4qnLmdU5H5cjLUVt1P+r9SSTVGS31TR7gK4QmZdzPICRQLugOP78y6dCNJQagTAsJBQRiwsKhhG7sQc2h1pOSdo9vonCaihBmTlBNNhc7uqDAlSi497AMlj4S7PvPQJYZPjG07WRwsNJTthg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792256557; c=relaxed/simple;
	bh=eslpfZxU6u7qShLeSGAUjpIIG5UTWsVCZ7sSNOzw6KM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uRfajWOLdcp+9YrhOoMWG15QpSlzTQzlN1/LYIxb714UaHLx+nMzGn1mnzK5syNzihGC1bH5SYTAD5S5Bhgj+Xxr3qr+gpVulrw5nICuESOGWUhSqxfgQjLU6VnsvWCtjKhn5IHdWP2hYidk8dkdwvzQ8uTyyUIuBEe6KtUmNCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vqZ69rKG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vqZ69rKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67A5D1F000C4;
	Sat, 17 Oct 2026 17:02:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792256556;
	bh=FGIzEVXSF/dnsz41MyPAaR5KCdgN/ILTK6UtR7Y/NBk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vqZ69rKGFDmyCmKeQLP07IJxRva1Z8cGtLTHYy8J4fkVNEHSthmumcQInoz4Zjr2a
	 F92JG/hy1hFDycQFkkyZcVVy423+pPVRa6loNtlea9l+X3cPEDW3MQlwHRwxOlzf7z
	 FxgS1SZATqVpW2PPEXX4+sAjSDvEO/Mgq8lv7904=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 6.6 0275/1674] usb: typec: ucsi: Get the connector fwnode based on reg value
Date: Sat, 17 Oct 2026 17:42:27 +0200
Message-ID: <20261017160438.176905257@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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
@@ -1190,10 +1190,21 @@ static struct fwnode_handle *ucsi_find_f
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
 


