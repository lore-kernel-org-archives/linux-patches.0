Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8680228EB
	for <patches@lists.linux.dev>; Mon, 30 Jan 2023 14:13:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4E3C433EF;
	Mon, 30 Jan 2023 14:13:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1675088004;
	bh=cqeljc2y9BBh0qXOJF3nZltjJK8MLA/hNEUU0CozMlg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ziBUm1w0aK+jMuBZYn+5YsDkKNLNHtwdd+u+h3LXQ8ezcYflUwiGRdo/kdE8zDJM1
	 l+Ca9hMtleWHTBumt/fsDZvC6Uq8BayC70L8ws9enyJpOJtIkkqnJo6hNGB9IpBdvT
	 4DhjZg/hOe3iNoCSeLjfJJmvUM1pSWbno8VkvyDM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yang Yingliang <yangyingliang@huawei.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>,
	Daniel Scally <djrscally@gmail.com>
Subject: [PATCH 5.15 083/204] device property: fix of node refcount leak in fwnode_graph_get_next_endpoint()
Date: Mon, 30 Jan 2023 14:50:48 +0100
Message-Id: <20230130134319.985249588@linuxfoundation.org>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230130134316.327556078@linuxfoundation.org>
References: <20230130134316.327556078@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yang Yingliang <yangyingliang@huawei.com>

[ Upstream commit 39af728649b05e88a2b40e714feeee6451c3f18e ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/base/property.c | 18 ++++++++++++------
 1 file changed, 12 insertions(+), 6 deletions(-)

diff --git a/drivers/base/property.c b/drivers/base/property.c
index 735a23db1b5e..17a648d64356 100644
--- a/drivers/base/property.c
+++ b/drivers/base/property.c
@@ -1055,26 +1055,32 @@ struct fwnode_handle *
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
+
+	ep = fwnode_graph_get_next_endpoint(parent->secondary, NULL);
 
-	return fwnode_graph_get_next_endpoint(parent->secondary, NULL);
+out_put_port_parent:
+	fwnode_handle_put(port_parent);
+	return ep;
 }
 EXPORT_SYMBOL_GPL(fwnode_graph_get_next_endpoint);
 
-- 
2.39.0



