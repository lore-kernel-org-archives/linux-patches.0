Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B28B54E324F;
	Fri,  9 Oct 2026 14:38:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556733; cv=none; b=Qd+osxWFWGyyxCBNlriEay9LYoVaKucYymCh3IbD86ZlIOWu79iNgvnAMlov43DIcQxveiGE6PqNoNAU0EJxKOTGcOrNoCRH2QW6+xgkWfv0MPW/7bwMU3lm+QYYwpHG7TdNiFVM18hZfI8o32oPbD5Cm5kImQu4rnLa1XP+F0A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556733; c=relaxed/simple;
	bh=AOq/4niK7oRlYLQ/B0sq4zHeU22htDHiZpWv0EIeZQA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t6Ly1OLfxLoqdVsBX+V0Qifv/pXGRaZmz4dfIHavD3lv7mtvTickyRVGAFzhMavZK5v6rhP8KfS0rQjTsFCifbM4OKMhWhOB64FXooag+XQbcmHFeDWqgnkDZWnTYDjEyNuNPLBReX16nW1q7Enbsps/xmTS6zxkKzzr6718rtc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=n+mxOs5R; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="n+mxOs5R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CACE51F000FF;
	Fri,  9 Oct 2026 14:38:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556732;
	bh=oflK8y+4ocUyhNmzFmg4wsyRKrcBv39GAA3SYgucxtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n+mxOs5RkmW4AzYhyX8ohEmB8OP09hm1rIOFgwN8vlYNawlf/MWG54q2Oy3I7sZa1
	 gbn2zG28JSmWouP1wqBbdhZiqDAMtXG6kG4DPqIvMBLt4LKqG9pdjQSAmYiKP06nqU
	 FD6Wd30znxa5OdDs5KXlkS5Pey8De44QmzSb415U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Prashanth K <prashanth.k@oss.qualcomm.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH 7.2 233/428] usb: typec: ucsi: Get the connector fwnode based on reg value
Date: Fri,  9 Oct 2026 16:09:30 +0200
Message-ID: <20261009140951.230733971@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140946.008206689@linuxfoundation.org>
References: <20261009140946.008206689@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1801,10 +1801,21 @@ static struct fwnode_handle *ucsi_find_f
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
 


