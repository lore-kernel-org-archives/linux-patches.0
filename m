Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 55DC4471255;
	Tue, 21 Jul 2026 18:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657572; cv=none; b=jehyXi/Q77DITdjvPqfl5xzKLcJepNJVe2optofBws6Fm5kdhd3lvAUq+y2zTxkWtLoaFORAt0m1TMmz8Zwzj8MDj490eEW3MU/aCZMoXYRzwRqEyfAnOkwxTqIy3UKEWiJnHKjmDso2aYZxXazDc5lxt2LmnFDMjz5ir5H8TJs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657572; c=relaxed/simple;
	bh=aWrvkhUTvs93IfKhaqL8HbvxghBbzArJgvrfzya3huA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uDeL/QGi04LcFlemaLh0KBSX0R1OnlxrlaWiWdoPQIOGUByTtnVAU5AJ8W3MiuOoNipMnljqtDSvu4KgZuJerdcEr5NowW9ClewcVa9x2U3tLi6lj0X/ahsV9Z+rTHyWWR8Uz+DFE97hq4Va0vzxzL/4aIL2QMk6ucQ5vYdb+u4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=o/TtUU9t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o/TtUU9t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA9431F000E9;
	Tue, 21 Jul 2026 18:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657571;
	bh=lqjPXeq8GpHWcLDheL0Cl3a5VRueghnKM0sE41v3ZhU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=o/TtUU9ta/D02x08O7OokuMFEd46+O1yw5kEZVABBY150W2Xpy1VI3lXIqr1bNEPQ
	 dHfSiNh3fo0552Ko5NZid5HokAvXxpHKqK5NQMBcaUmel9cPUnPuJIUll00E9az9Qx
	 v9vdAMM/7Z9+faT85pOwivonNLbrOcct7+9E9ngk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0815/1611] devlink: Fix parent ref leak in devl_rate_node_create()
Date: Tue, 21 Jul 2026 17:15:31 +0200
Message-ID: <20260721152533.721647931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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
index d157a8419bcad4..3eaf1af3b59cf1 100644
--- a/net/devlink/rate.c
+++ b/net/devlink/rate.c
@@ -724,11 +724,6 @@ devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
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
@@ -739,6 +734,11 @@ devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
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



