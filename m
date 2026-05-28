Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E24224677F;
	Thu, 28 May 2026 20:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998572; cv=none; b=We4sKfbwCMiKwSgL6AjL6+PAZ5HK8gaI3CzFCgZ99QR3uoqzujYeqxQAbWU7YZlQlPGcBo+d3ikNciWs1JlZa9fr7AFQOJiOJOpW4tSSm5vxJn3D1J1I9kmNSVtCEwELZ6NrngXzuhSQzJeTH9oFW3zHQjWTmTAMDLl1NIh0sOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998572; c=relaxed/simple;
	bh=V8r3IuN2Oxu3+svLjrBDMsJ2JTBODDvdUFlzbrUht6U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z9ElCzc/PHkO+oAKvXWdTC3hdxuBvmxoQdPE3DJ8wS/NkhMfQCOnM/ocWAO6BQuYe2K99W56X3JN/GR6KGTAZvWRP1OzKF8XoNmahvgy6sYGNOOD4rw5KKeDeZ3onpfE74J3jJ6NfpymiYeO0bIAM60yVrYIOFSo2/eQTiz1g/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qrJCfKVf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qrJCfKVf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ECA171F000E9;
	Thu, 28 May 2026 20:02:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998571;
	bh=WTMvisilVcXVDKs3U9QGMaIqXx9jBAiok1iIlI3Hc08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qrJCfKVfvptPk61BQn6+y+JEr20wqJ2a0wkGyuh6fHf+VOIsMVuF9xAYrcmc0pAN7
	 bnGLrBrNnXXPE5dacUB9mYLE2leF1W6kXisW8Lbp+6qshogitRbhRTDWZyHmvP9Irr
	 CD54rt5JCvt2HF8ZZmMVkqQziFgVaHsmM/o8XncE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mohsin Bashir <hmohsin@meta.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 221/461] net: shaper: Reject reparenting of existing nodes
Date: Thu, 28 May 2026 21:45:50 +0200
Message-ID: <20260528194653.529108946@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mohsin Bashir <hmohsin@meta.com>

[ Upstream commit a77d5a069d959dc45f5f472d48cba37d8cba0f1c ]

When an existing node-scope shaper is moved to a different parent
via the group operation, the framework fails to update the leaves
count on both the old and new parent shapers. Only newly created
nodes (handle.id == NET_SHAPER_ID_UNSPEC) trigger the parent
leaves increment at line 1039.

This causes the parent's leaves counter to diverge from the
actual number of children in the xarray. When the node is later
deleted, pre_del_node() allocates an array sized by the stale
leaves count, but the xarray iteration finds more children than
expected, hitting the WARN_ON_ONCE guard and returning -EINVAL.

Rather than adding reparenting support with complex leaves count
bookkeeping, reject group calls that attempt to change an existing
node's parent. Updates to an existing node's rate or leaves under
the same parent remain permitted. We expect that for any modification
of the topology user should always create new groups and let the
kernel garbage collect the leaf-less nodes.

Fixes: 5d5d4700e75d ("net-shapers: implement NL group operation")
Signed-off-by: Mohsin Bashir <hmohsin@meta.com>
Link: https://patch.msgid.link/20260506233745.111895-1-mohsin.bashr@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/shaper/shaper.c | 30 +++++++++++++++++++++++-------
 1 file changed, 23 insertions(+), 7 deletions(-)

diff --git a/net/shaper/shaper.c b/net/shaper/shaper.c
index 94bc9c7382ea6..1069fa4eb9f60 100644
--- a/net/shaper/shaper.c
+++ b/net/shaper/shaper.c
@@ -964,15 +964,22 @@ static int __net_shaper_group(struct net_shaper_binding *binding,
 	int i, ret;
 
 	if (node->handle.scope == NET_SHAPER_SCOPE_NODE) {
+		struct net_shaper *cur = NULL;
+
 		new_node = node->handle.id == NET_SHAPER_ID_UNSPEC;
 
-		if (!new_node && !net_shaper_lookup(binding, &node->handle)) {
-			/* The related attribute is not available when
-			 * reaching here from the delete() op.
-			 */
-			NL_SET_ERR_MSG_FMT(extack, "Node shaper %d:%d does not exists",
-					   node->handle.scope, node->handle.id);
-			return -ENOENT;
+		if (!new_node) {
+			cur = net_shaper_lookup(binding, &node->handle);
+			if (!cur) {
+				/* The related attribute is not available
+				 * when reaching here from the delete() op.
+				 */
+				NL_SET_ERR_MSG_FMT(extack,
+						   "Node shaper %d:%d does not exist",
+						   node->handle.scope,
+						   node->handle.id);
+				return -ENOENT;
+			}
 		}
 
 		/* When unspecified, the node parent scope is inherited from
@@ -986,6 +993,15 @@ static int __net_shaper_group(struct net_shaper_binding *binding,
 				return ret;
 		}
 
+		if (cur && net_shaper_handle_cmp(&cur->parent,
+						 &node->parent)) {
+			NL_SET_ERR_MSG_FMT(extack,
+					   "Cannot reparent node shaper %d:%d",
+					   node->handle.scope,
+					   node->handle.id);
+			return -EOPNOTSUPP;
+		}
+
 	} else {
 		net_shaper_default_parent(&node->handle, &node->parent);
 	}
-- 
2.53.0



