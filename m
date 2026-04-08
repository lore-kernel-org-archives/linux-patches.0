Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EF65C3D903F;
	Wed,  8 Apr 2026 18:55:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775674536; cv=none; b=X4YqgBCY5HKREEaaY90uJ3CxkUkmkVcjfwRUg+78ns+WLmg197Y3HpO2xN4LcBcjfTTpSfJ1S8Q89P+U7HhVUmE0dyLona60EwAgUlviB1l81JRnHQDUVDdDmE2mSwA8+2QV4SWlz+l83LlPAdlZmeB6lmvdtwBcqptOnzg0XtA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775674536; c=relaxed/simple;
	bh=2ai167v6h4M3yl7d8vxSKyfNrtaDd/mHe34hyeaFyVg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e2vAh8uXZad5clltZxNDj4JyQwJWqaKfP56gIXNWqt3PxG+TQCH6gxim5vd1o1W7SjhWVftQcvbM4lPkHcgfjxWmEWAQ3kZs02geX9gRD7lbVe+hQL+LL9vqR9UGa103SeBtB1Dhy6GQXJolUyok+vOd7KKlm0uQ23KvlxXewbM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hiQH5JmD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hiQH5JmD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 862A1C19421;
	Wed,  8 Apr 2026 18:55:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1775674535;
	bh=2ai167v6h4M3yl7d8vxSKyfNrtaDd/mHe34hyeaFyVg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hiQH5JmDQDGWmGBmDFSjF+dDDGL6DXAuWtsQd9KdRE6ezDwDiTJM06Aqk3pODrGvP
	 2eeNUFV/VzZ+3V9B66fqmNZM1VaRT5NowabFXc+7YEKEpEeGECSsSyJxp2O/KmmfnH
	 1k7ftrk2Cg1154ybS/cT/d/F/ZwKT7xnNQzGJ7aE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Ying <victor.liu@nxp.com>,
	Luca Ceresoli <luca.ceresoli@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 134/311] drm/bridge: Fix refcount shown via debugfs for encoder_bridges_show()
Date: Wed,  8 Apr 2026 20:02:14 +0200
Message-ID: <20260408175944.420164801@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260408175939.393281918@linuxfoundation.org>
References: <20260408175939.393281918@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Ying <victor.liu@nxp.com>

[ Upstream commit f078634c184a9b5ccaa056e8b8d6cd32f7bff1b6 ]

A typical bridge refcount value is 3 after a bridge chain is formed:
- devm_drm_bridge_alloc() initializes the refcount value to be 1.
- drm_bridge_add() gets an additional reference hence 2.
- drm_bridge_attach() gets the third reference hence 3.

This typical refcount value aligns with allbridges_show()'s behaviour.
However, since encoder_bridges_show() uses
drm_for_each_bridge_in_chain_scoped() to automatically get/put the
bridge reference while iterating, a bogus reference is accidentally
got when showing the wrong typical refcount value as 4 to users via
debugfs.  Fix this by caching the refcount value returned from
kref_read() while iterating and explicitly decreasing the cached
refcount value by 1 before showing it to users.

Fixes: bd57048e4576 ("drm/bridge: use drm_for_each_bridge_in_chain_scoped()")
Signed-off-by: Liu Ying <victor.liu@nxp.com>
Reviewed-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Tested-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Link: https://patch.msgid.link/20260318-drm-misc-next-2026-03-05-fix-encoder-bridges-refcount-v3-1-147fea581279@nxp.com
Signed-off-by: Luca Ceresoli <luca.ceresoli@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/drm_bridge.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/drm_bridge.c b/drivers/gpu/drm/drm_bridge.c
index 8f355df883d8a..250bf8fa51677 100644
--- a/drivers/gpu/drm/drm_bridge.c
+++ b/drivers/gpu/drm/drm_bridge.c
@@ -1465,11 +1465,17 @@ EXPORT_SYMBOL(devm_drm_put_bridge);
 static void drm_bridge_debugfs_show_bridge(struct drm_printer *p,
 					   struct drm_bridge *bridge,
 					   unsigned int idx,
-					   bool lingering)
+					   bool lingering,
+					   bool scoped)
 {
+	unsigned int refcount = kref_read(&bridge->refcount);
+
+	if (scoped)
+		refcount--;
+
 	drm_printf(p, "bridge[%u]: %ps\n", idx, bridge->funcs);
 
-	drm_printf(p, "\trefcount: %u%s\n", kref_read(&bridge->refcount),
+	drm_printf(p, "\trefcount: %u%s\n", refcount,
 		   lingering ? " [lingering]" : "");
 
 	drm_printf(p, "\ttype: [%d] %s\n",
@@ -1503,10 +1509,10 @@ static int allbridges_show(struct seq_file *m, void *data)
 	mutex_lock(&bridge_lock);
 
 	list_for_each_entry(bridge, &bridge_list, list)
-		drm_bridge_debugfs_show_bridge(&p, bridge, idx++, false);
+		drm_bridge_debugfs_show_bridge(&p, bridge, idx++, false, false);
 
 	list_for_each_entry(bridge, &bridge_lingering_list, list)
-		drm_bridge_debugfs_show_bridge(&p, bridge, idx++, true);
+		drm_bridge_debugfs_show_bridge(&p, bridge, idx++, true, false);
 
 	mutex_unlock(&bridge_lock);
 
@@ -1521,7 +1527,7 @@ static int encoder_bridges_show(struct seq_file *m, void *data)
 	unsigned int idx = 0;
 
 	drm_for_each_bridge_in_chain_scoped(encoder, bridge)
-		drm_bridge_debugfs_show_bridge(&p, bridge, idx++, false);
+		drm_bridge_debugfs_show_bridge(&p, bridge, idx++, false, true);
 
 	return 0;
 }
-- 
2.53.0



