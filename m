Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6917F32F765;
	Mon, 13 Apr 2026 17:04:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776099847; cv=none; b=oJv+gO2zJ5m52DBkzU0qEKr3PZ3PKozDJ6SfXc3aqNx0uy3F0XxisU0pyHaUCwhAfXXk2srnIaJ9wXYtEvRdguEIoJOf1KEs/DQ0+Uy7UiC7nxMNCY33BehjfV5oECneVLAVPyTwGcZ27QKzTL+PeDLYTQCsDcJv02BZoDSORik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776099847; c=relaxed/simple;
	bh=YCr5wqXnuMWxYvYalQFqcQUQ2vW6YcoabkhYlp/cjr4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HpPTDwr1Xugm98Gt7EnODyLvWP788+AF4HSwpg0za+hKeXR2+2Jkj9fJp8G1hET6jk2NbxsrSbcsPf5FOl3ycsMJqr+MbEK4591AYSs+Li748jZWoPk9qNZ0ooVBpNP198U5BzbX8A00hOqFSe6sOZqybkDsYKsH+Mm8g0ko57s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oVTP/z7s; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oVTP/z7s"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC289C2BCAF;
	Mon, 13 Apr 2026 17:04:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776099847;
	bh=YCr5wqXnuMWxYvYalQFqcQUQ2vW6YcoabkhYlp/cjr4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oVTP/z7sVvudpT72xbB2CetocALjjfAEpO21k/rZicRkWy7BmcxQ3r6fPdiJr2yj6
	 RiuOlZVvkSj1aZcrd9MmiUPEF4HopVeYckSzMTJPgrkSiVCYmzwiHnfNwXnfpXgFYb
	 PFPAsn0E57JeLnyE94JQRp3HnHyR5lOMzk89VBng=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Daniel Scally <djrscally@gmail.com>
Subject: [PATCH 5.10 489/491] device property: fix of node refcount leak in fwnode_graph_get_next_endpoint()
Date: Mon, 13 Apr 2026 18:02:14 +0200
Message-ID: <20260413155837.362599157@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260413155819.042779211@linuxfoundation.org>
References: <20260413155819.042779211@linuxfoundation.org>
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

From: Yang Yingliang <yangyingliang@huawei.com>

commit 39af728649b05e88a2b40e714feeee6451c3f18e upstream.

The 'parent' returned by fwnode_graph_get_port_parent()
with refcount incremented when 'prev' is not NULL, it
needs be put when finish using it.

Because the parent is const, introduce a new variable to
store the returned fwnode, then put it before returning
from fwnode_graph_get_next_endpoint().

Fixes: b5b41ab6b0c1 ("device property: Check fwnode->secondary in fwnode_graph_get_next_endpoint()")
Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Reviewed-and-tested-by: Daniel Scally <djrscally@gmail.com>
Link: https://lore.kernel.org/r/20221123022542.2999510-1-yangyingliang@huawei.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/property.c |   18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1054,26 +1054,32 @@ struct fwnode_handle *
 fwnode_graph_get_next_endpoint(const struct fwnode_handle *fwnode,
 			       struct fwnode_handle *prev)
 {
+	struct fwnode_handle *ep, *port_parent = NULL;
 	const struct fwnode_handle *parent;
-	struct fwnode_handle *ep;
 
 	/*
 	 * If this function is in a loop and the previous iteration returned
 	 * an endpoint from fwnode->secondary, then we need to use the secondary
 	 * as parent rather than @fwnode.
 	 */
-	if (prev)
-		parent = fwnode_graph_get_port_parent(prev);
-	else
+	if (prev) {
+		port_parent = fwnode_graph_get_port_parent(prev);
+		parent = port_parent;
+	} else {
 		parent = fwnode;
+	}
 	if (IS_ERR_OR_NULL(parent))
 		return NULL;
 
 	ep = fwnode_call_ptr_op(parent, graph_get_next_endpoint, prev);
 	if (ep)
-		return ep;
+		goto out_put_port_parent;
 
-	return fwnode_graph_get_next_endpoint(parent->secondary, NULL);
+	ep = fwnode_graph_get_next_endpoint(parent->secondary, NULL);
+
+out_put_port_parent:
+	fwnode_handle_put(port_parent);
+	return ep;
 }
 EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
 


