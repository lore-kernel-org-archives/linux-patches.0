Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3785333A9FC;
	Tue, 21 Jul 2026 20:42:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666571; cv=none; b=T/w6TmV5Pd5kYg3JptawC3F6+voafNli/bY9kiWUNwz6Gyi6wTERXMXGVk4OGnxsPXLSuJ94Cei89eImEXoYhX059NqyLBe5j3z85lu49dMtfkPRCEiYMhAVoHCikrLZXAPD3yoOlSO9TtM0NG2TDTAdFzDtJ+vZpMqBaCrLr1A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666571; c=relaxed/simple;
	bh=PZXincLurhWfU5SzHfZjZnFBlfWo4SAEy2BBPTr8Edo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CEyMi47SCoUBUdglQuS4C84g5otOLojPuWLvDexSV2Z5quMVJvUR40FMu9PRZm1fizQKvzlPitgGXRM9fsgZ8bwt4a9s8O1PlzeNfqYtGLvxD9WBVC1By4ZzL9IA0qxRWy2ppWkAwRp7tRmBAWyz+hmHPB56IiAXNavEi+s0iqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hKFkcqZv; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hKFkcqZv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C4921F000E9;
	Tue, 21 Jul 2026 20:42:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666570;
	bh=46zAsk4fl3SD/IaY9avznnbrOT5az97MnUbldLe8pDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hKFkcqZv2o58OOpmqWyiAmLMJSRjrhizOGP5vyibTGc6kepOy/paiNHI1HfmVLUVq
	 4o56/Jti9S6MgWdObh8sJJYNLhQ6mQyZdiDhDqYHSuK4tI2s8N8tmmPcxV7mRyxvSu
	 L+4AhsTpqStBABS2tR0oHz+HSpksdpBGFfdx/gEE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0731/1266] devlink: Fix parent ref leak in devl_rate_node_create()
Date: Tue, 21 Jul 2026 17:19:28 +0200
Message-ID: <20260721152458.229312283@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index e7e80af4abaf65..b4d13b5ef9b624 100644
--- a/net/devlink/rate.c
+++ b/net/devlink/rate.c
@@ -598,11 +598,6 @@ devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
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
@@ -613,6 +608,11 @@ devl_rate_node_create(struct devlink *devlink, void *priv, char *node_name,
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



