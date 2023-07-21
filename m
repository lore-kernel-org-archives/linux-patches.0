Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7224520F8F
	for <patches@lists.linux.dev>; Fri, 21 Jul 2023 19:22:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB4FBC433C8;
	Fri, 21 Jul 2023 19:22:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689967372;
	bh=m4xvG7VFHe0Lw5vYmCBDncicCFG0EE9jzmO8pylEd78=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dHAOAVGVct7e2ZEoPuCgBSv7t15IwVrq9yDY9q+JmyttsbBDBQ8RbLYzkqz2BBY2R
	 bFCLwuYI4sMOWE8MDNXLT5nnBieF3K6EG08pZuXPaRPrl0Ve/eYS9yo/UnctLibihZ
	 +V4f/yloIv93lg5xtZ0yRuY87Rteze6vI65cgWT8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>
Subject: [PATCH 6.1 111/223] fs: dlm: revert check required context while close
Date: Fri, 21 Jul 2023 18:06:04 +0200
Message-ID: <20230721160525.601103162@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230721160520.865493356@linuxfoundation.org>
References: <20230721160520.865493356@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

commit c6b6d6dcc7f32767d57740e0552337c8de40610b upstream.

This patch reverts commit 2c3fa6ae4d52 ("dlm: check required context
while close"). The function dlm_midcomms_close(), which will call later
dlm_lowcomms_close(), is called when the cluster manager tells the node
got fenced which means on midcomms/lowcomms layer to disconnect the node
from the cluster communication. The node can rejoin the cluster later.
This patch was ensuring no new message were able to be triggered when we
are in the close() function context. This was done by checking if the
lockspace has been stopped. However there is a missing check that we
only need to check specific lockspaces where the fenced node is member
of. This is currently complicated because there is no way to easily
check if a node is part of a specific lockspace without stopping the
recovery. For now we just revert this commit as it is just a check to
finding possible leaks of stopping lockspaces before close() is called.

Cc: stable@vger.kernel.org
Fixes: 2c3fa6ae4d52 ("dlm: check required context while close")
Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/dlm/lockspace.c |   12 ------------
 fs/dlm/lockspace.h |    1 -
 fs/dlm/midcomms.c  |    3 ---
 3 files changed, 16 deletions(-)

--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -958,15 +958,3 @@ void dlm_stop_lockspaces(void)
 		log_print("dlm user daemon left %d lockspaces", count);
 }
 
-void dlm_stop_lockspaces_check(void)
-{
-	struct dlm_ls *ls;
-
-	spin_lock(&lslist_lock);
-	list_for_each_entry(ls, &lslist, ls_list) {
-		if (WARN_ON(!rwsem_is_locked(&ls->ls_in_recovery) ||
-			    !dlm_locking_stopped(ls)))
-			break;
-	}
-	spin_unlock(&lslist_lock);
-}
--- a/fs/dlm/lockspace.h
+++ b/fs/dlm/lockspace.h
@@ -27,7 +27,6 @@ struct dlm_ls *dlm_find_lockspace_local(
 struct dlm_ls *dlm_find_lockspace_device(int minor);
 void dlm_put_lockspace(struct dlm_ls *ls);
 void dlm_stop_lockspaces(void);
-void dlm_stop_lockspaces_check(void);
 int dlm_new_user_lockspace(const char *name, const char *cluster,
 			   uint32_t flags, int lvblen,
 			   const struct dlm_lockspace_ops *ops,
--- a/fs/dlm/midcomms.c
+++ b/fs/dlm/midcomms.c
@@ -136,7 +136,6 @@
 #include <net/tcp.h>
 
 #include "dlm_internal.h"
-#include "lockspace.h"
 #include "lowcomms.h"
 #include "config.h"
 #include "memory.h"
@@ -1458,8 +1457,6 @@ int dlm_midcomms_close(int nodeid)
 	if (nodeid == dlm_our_nodeid())
 		return 0;
 
-	dlm_stop_lockspaces_check();
-
 	idx = srcu_read_lock(&nodes_srcu);
 	/* Abort pending close/remove operation */
 	node = nodeid2node(nodeid, 0);


