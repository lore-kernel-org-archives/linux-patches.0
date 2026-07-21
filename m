Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 16686399036;
	Tue, 21 Jul 2026 19:06:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660810; cv=none; b=QrQ/yAaPgVWRwctXg9ReqOONErvKzC6iwjLxFGyHMRiPDu45dt/5mLFZuxR6kXObgBULTiWr3Jvadbjc50R+zs8ZhpzxfW171TNkOp4i8pVhUvnrELkBpIwN1HNK32HFJSG2o0swuSMJkqZvRjRxf98c9t9+oGM9sZgBb+9/ug8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660810; c=relaxed/simple;
	bh=5p7uwkT1f+QNKgcGpIAkC02ce40ZDj6dZAHZOtyqD0U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Orp3HFaCpGjNHPuforhK0Xmzd7I3i/F8Z7CT4wgJMwZPHFsheT/G1y/1TcPeAweWBGLPYScheLGXaYutL/W1QqyTojFkBV9vQ3ECFnoKB09yjHxk5y/XHc+Qsafjggmee3UUsGnQDek7tfUWIaWd6h5vJGFvmH8rOjcObbPL/FM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kSL5vqfJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kSL5vqfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2611F000E9;
	Tue, 21 Jul 2026 19:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660809;
	bh=blGWWEmg2k3gzWPNB/Xy1AHDzIpulOPoIuTlhkIbQ8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kSL5vqfJLVPACrfAicWxxt4y6RRYZiEnuqgV9aErxlTtV5F3EUnw5SDAZJH0zPEL5
	 vXnnSOPbZU1kI+Ue41bRwMqe5B7nw/1lna0sTAeheLeczMgDD3tnaPhMzs2qS9a/wP
	 Vw2ZN5DEs8RMZEkHDKuE0xPX6EQQjNakNoHThUKI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1121/2077] devlink: Fix parent ref leak in devl_rate_node_create()
Date: Tue, 21 Jul 2026 17:13:14 +0200
Message-ID: <20260721152619.258968580@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 41be2d6c2954e9..210e26c6cfa04c 100644
--- a/net/devlink/rate.c
+++ b/net/devlink/rate.c
@@ -725,11 +725,6 @@ devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
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
@@ -740,6 +735,11 @@ devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
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



