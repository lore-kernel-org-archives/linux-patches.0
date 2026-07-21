Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28840430CF4;
	Tue, 21 Jul 2026 19:40:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662802; cv=none; b=GN9SHwmLFvDTAKBhurOZP76j3aY+AjPv6GFOAfdyN1gfIPhSSkn5qFKzjiL1+1ZfGlAtKSw9UIdquFFPdbPTNDGrx3aGuWIIY2apbHEODJSPvDTXqgV3ZfePxQtfKOt4n7ncw6nV+F7wLEbMu3dwdUQRXAAhsNdYaRxqPneeC3E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662802; c=relaxed/simple;
	bh=ujpFfK+0k0+TfcXXKcOBY4Cy/RDrJz8sxL4KGPfshZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XXP3fWem6hDVFulYYHrUw344H4aPeWFTOJZb3SPsS9SLbn56PY2aTCM2ZhIOAtNA2Q24Ju7WKCxII2nHfqQRLHzNYYKwdJvgq2DMHvzm4xHTAgBoM5G98crAywng51Ld5NrOF1N7yLjwKegXru5wKww43gpFoCqxWZxWNEqPdoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lz0I0J6L; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lz0I0J6L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B476E1F000E9;
	Tue, 21 Jul 2026 19:40:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662801;
	bh=vg1ps6PK5HROaunFwYjjgKQM1U01sHtu742rnzrHGBQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lz0I0J6LMnRdtgDP0qkw5/apBAGej9HAI1l6hvrDu7R3RBbwaWcv+55SoI06z+0+p
	 W2qV0v6Ll0mXPyGZuAlOtpdoRyZc+rnFnJwpdtMICS2yhwnXDKY0wnbaAYKjnnvkHU
	 /bUez16IGyCMq0klsZDZmWq4LEpCyJsLtBiUEsa8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0581/1276] devlink: Fix parent ref leak in devl_rate_node_create()
Date: Tue, 21 Jul 2026 17:17:04 +0200
Message-ID: <20260721152459.116242245@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit ba45106342bbdd905651cb9fcefb8c11871d4c25 ]

In the original commit the function bails out on kstrdup failure,
forgetting to decrement the refcnt of the parent.

Fix that by moving the parent refcnt setting after kstrdup.

Fixes: caba177d7f4d ("devlink: Enable creation of the devlink-rate nodes from the driver")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260616110633.1449432-2-cratiu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/devlink/rate.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/devlink/rate.c b/net/devlink/rate.c
index adb5267d377cfd..f3b234f356f38c 100644
--- a/net/devlink/rate.c
+++ b/net/devlink/rate.c
@@ -597,11 +597,6 @@ devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
 	if (!rate_node)
 		return ERR_PTR(-ENOMEM);
 
-	if (parent) {
-		rate_node->parent = parent;
-		refcount_inc(&rate_node->parent->refcnt);
-	}
-
 	rate_node->type = DEVLINK_RATE_TYPE_NODE;
 	rate_node->devlink = devlink;
 	rate_node->priv = priv;
@@ -612,6 +607,11 @@ devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
 		return ERR_PTR(-ENOMEM);
 	}
 
+	if (parent) {
+		rate_node->parent = parent;
+		refcount_inc(&rate_node->parent->refcnt);
+	}
+
 	refcount_set(&rate_node->refcnt, 1);
 	list_add(&rate_node->list, &devlink->rate_list);
 	devlink_rate_notify(rate_node, DEVLINK_CMD_RATE_NEW);
-- 
2.53.0



