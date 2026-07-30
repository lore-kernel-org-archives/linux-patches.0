Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83A3D44A739;
	Thu, 30 Jul 2026 16:11:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785427904; cv=none; b=sO9vVcRKnwSQEQqtJ9kFELXPLfbNiWaYASYhKY+oeAUNdhydpBm6OjOX9RXdI0JywX1JWd712oSMs8ubceUwhD0BNEac/dgT9t3y/8QfBmtHJ+mAYzAwICVy9XK0sxiQmT8VC7S2HRXW5jwmf1wONzX/wAwYOgqYEy5DxN1E2Gk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785427904; c=relaxed/simple;
	bh=A9eCN95LsXpSGSZQaVA5kKMTXrtsfHF7mxnpaR2imnY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eYlTzMizFR98ZkWCod2TBbOYr6oeQio293ngsSDEWhNN6S/OvAitEucD+ibzo1OjPIC0HB5FRk9yYhqp8F/6qCQ3XP5Wk5iAUh16yT+w/2sfrpm0lMjRROEMNkXf4oVr1E3vJ6mItx1PtnwHgSL4RalFGixLNYgReO+OhRhoL6s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q0ERqMAb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q0ERqMAb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE0081F000E9;
	Thu, 30 Jul 2026 16:11:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785427903;
	bh=vfhGXcymeKuaJVDOUnHcMi+xwBRhpmvKyLXqaJCIU/k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q0ERqMAbYxjLEyUNCAufzX2pSt4BAQ4GFLehcefK4wInap2HeT8zNzPwXPDWhoOpw
	 +fpHVK/vT+Sv/B8Usm9SfCsI0eO4LBK5oDeG3ZPbq+WyedAL6W+zYsg9oVLiiN6kYp
	 XwbYD0+qhsdrBHirkjMiH+31fdYBxCwa3dwIskDY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	James Raphael Tiovalen <jamestiotio@gmail.com>,
	Ido Schimmel <idosch@nvidia.com>,
	Antoine Tenart <atenart@kernel.org>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 335/484] vxlan: mdb: Fix source list corruption on a failed replace
Date: Thu, 30 Jul 2026 16:13:52 +0200
Message-ID: <20260730141430.761619393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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

From: James Raphael Tiovalen <jamestiotio@gmail.com>

commit dcd9b465965422b9654f6026e8a2fa8984f74c3c upstream.

When replacing the source list of an MDB remote entry, all existing
sources are first marked for deletion and vxlan_mdb_remote_srcs_add()
is then called to add the new source list. Sources present in the new
list have their deletion mark cleared, and any sources left marked
afterwards are removed.

If vxlan_mdb_remote_srcs_add() fails partway through, its error path
deletes all entries on the remote's source list. That rollback is only
correct for its other caller, vxlan_mdb_remote_add(), where the remote
was just allocated and the list contains solely entries added during
the call. On the replace path the list also holds pre-existing sources,
so a failed replace tears them down together with their (S, G)
forwarding entries instead of leaving the entry unchanged.

This is reachable from an existing (*, G) remote. An EXCLUDE filter
that loses sources starts forwarding traffic that should be blocked,
while an INCLUDE filter that loses sources drops traffic that should be
forwarded.

Mark entries created during the current pass with a new
VXLAN_SGRP_F_NEW flag. On failure, delete only those entries and clear
the deletion mark on the pre-existing ones, so a failed replace leaves
the source list untouched. Retain the flag until the whole operation
succeeds and then clear it. Also stop vxlan_mdb_remote_src_add() from
deleting a pre-existing entry it only looked up when adding that
entry's forwarding entry fails.

Fixes: a3a48de5eade ("vxlan: mdb: Add MDB control path support")
Cc: stable@vger.kernel.org
Signed-off-by: James Raphael Tiovalen <jamestiotio@gmail.com>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Reviewed-by: Antoine Tenart <atenart@kernel.org>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Link: https://patch.msgid.link/20260720160428.249356-1-jamestiotio@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vxlan/vxlan_mdb.c |   30 ++++++++++++++++++------------
 1 file changed, 18 insertions(+), 12 deletions(-)

--- a/drivers/net/vxlan/vxlan_mdb.c
+++ b/drivers/net/vxlan/vxlan_mdb.c
@@ -42,6 +42,7 @@ struct vxlan_mdb_remote {
 };
 
 #define VXLAN_SGRP_F_DELETE	BIT(0)
+#define VXLAN_SGRP_F_NEW	BIT(1)
 
 struct vxlan_mdb_src_entry {
 	struct hlist_node node;
@@ -838,6 +839,7 @@ vxlan_mdb_remote_src_add(const struct vx
 		ent = vxlan_mdb_remote_src_entry_add(remote, &src->addr);
 		if (!ent)
 			return -ENOMEM;
+		ent->flags |= VXLAN_SGRP_F_NEW;
 	} else if (!(cfg->nlflags & NLM_F_REPLACE)) {
 		NL_SET_ERR_MSG_MOD(extack, "Source entry already exists");
 		return -EEXIST;
@@ -847,15 +849,16 @@ vxlan_mdb_remote_src_add(const struct vx
 	if (err)
 		goto err_src_del;
 
-	/* Clear flags in case source entry was marked for deletion as part of
-	 * replace flow.
+	/* Clear the deletion mark so the entry survives the replace sweep.
+	 * The new mark is retained until the whole operation succeeds.
 	 */
-	ent->flags = 0;
+	ent->flags &= ~VXLAN_SGRP_F_DELETE;
 
 	return 0;
 
 err_src_del:
-	vxlan_mdb_remote_src_entry_del(ent);
+	if (ent->flags & VXLAN_SGRP_F_NEW)
+		vxlan_mdb_remote_src_entry_del(ent);
 	return err;
 }
 
@@ -883,11 +886,19 @@ static int vxlan_mdb_remote_srcs_add(con
 			goto err_src_del;
 	}
 
+	hlist_for_each_entry(ent, &remote->src_list, node)
+		ent->flags &= ~VXLAN_SGRP_F_NEW;
+
 	return 0;
 
 err_src_del:
-	hlist_for_each_entry_safe(ent, tmp, &remote->src_list, node)
-		vxlan_mdb_remote_src_del(cfg->vxlan, &cfg->group, remote, ent);
+	hlist_for_each_entry_safe(ent, tmp, &remote->src_list, node) {
+		if (ent->flags & VXLAN_SGRP_F_NEW)
+			vxlan_mdb_remote_src_del(cfg->vxlan, &cfg->group, remote,
+						 ent);
+		else
+			ent->flags &= ~VXLAN_SGRP_F_DELETE;
+	}
 	return err;
 }
 
@@ -1053,7 +1064,7 @@ vxlan_mdb_remote_srcs_replace(const stru
 
 	err = vxlan_mdb_remote_srcs_add(cfg, remote, extack);
 	if (err)
-		goto err_clear_delete;
+		return err;
 
 	hlist_for_each_entry_safe(ent, tmp, &remote->src_list, node) {
 		if (ent->flags & VXLAN_SGRP_F_DELETE)
@@ -1062,11 +1073,6 @@ vxlan_mdb_remote_srcs_replace(const stru
 	}
 
 	return 0;
-
-err_clear_delete:
-	hlist_for_each_entry(ent, &remote->src_list, node)
-		ent->flags &= ~VXLAN_SGRP_F_DELETE;
-	return err;
 }
 
 static int vxlan_mdb_remote_replace(const struct vxlan_mdb_config *cfg,


