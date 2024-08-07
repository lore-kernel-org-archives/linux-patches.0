Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D70982C8E;
	Wed,  7 Aug 2024 15:13:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043583; cv=none; b=UZVzCKzd1RNe5StZury3t0CczvuVJEWt4CDejc2IAjnE9tCmpKsIEThDzaHHeqy4mKZXA92TR4CZrh71K1gYOcU4+GwA6IvJ0HHgd2YYWeq1kyMQFMcieSSL6lhOrv5fgYOgBOxkYrbi2kayE/VBlAvmVhse6DXGzy+vSGFSWj0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043583; c=relaxed/simple;
	bh=JXbAkbGDK8BfpX6Biw0/HSBX4mUR4bhrkjpjD/f5E+c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ky4jk62OAZdQyRuc+h9kVP/33COJO+BafwulFlaAZuFWCtF7BKLOg5EnwqmUMTDK+kGRw4UJuN0Alc0xCgfoj4Le6BEVGZzDvRb4A6E4xAwIwKaJhz3DDBW1n4D6yYVNp2LLvLTsVn4/IkO9IdWeP/MXaPR8APGT+n/eDhmPcms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gVlvHFJi; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gVlvHFJi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B65EC32781;
	Wed,  7 Aug 2024 15:13:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043583;
	bh=JXbAkbGDK8BfpX6Biw0/HSBX4mUR4bhrkjpjD/f5E+c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gVlvHFJisuYLSXAUeQr/9j5vG2dNf2DBvwPXcFCM7almvwAST/5gANJSFKepneGg+
	 /Ylqvn0RjeiM/NST/UqKNOEzIUd6R9VYSFXsU6YIT6ZrJha0UIonaZj/Ng75wLkYCI
	 zhzcahMf3Gt6oLL2xkmNPzzYp5YKbnxylSDktkUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christian Brauner <brauner@kernel.org>,
	Joel Granados <joel.granados@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 04/86] sysctl: allow change system v ipc sysctls inside ipc namespace
Date: Wed,  7 Aug 2024 16:59:43 +0200
Message-ID: <20240807150039.393129140@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150039.247123516@linuxfoundation.org>
References: <20240807150039.247123516@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexey Gladkov <legion@kernel.org>

[ Upstream commit 50ec499b9a43e46200c9f7b7d723ab2e4af540b3 ]

Patch series "Allow to change ipc/mq sysctls inside ipc namespace", v3.

Right now ipc and mq limits count as per ipc namespace, but only real root
can change them.  By default, the current values of these limits are such
that it can only be reduced.  Since only root can change the values, it is
impossible to reduce these limits in the rootless container.

We can allow limit changes within ipc namespace because mq parameters are
limited by RLIMIT_MSGQUEUE and ipc parameters are not limited to anything
other than cgroups.

This patch (of 3):

Rootless containers are not allowed to modify kernel IPC parameters.

All default limits are set to such high values that in fact there are no
limits at all.  All limits are not inherited and are initialized to
default values when a new ipc_namespace is created.

For new ipc_namespace:

size_t       ipc_ns.shm_ctlmax = SHMMAX; // (ULONG_MAX - (1UL << 24))
size_t       ipc_ns.shm_ctlall = SHMALL; // (ULONG_MAX - (1UL << 24))
int          ipc_ns.shm_ctlmni = IPCMNI; // (1 << 15)
int          ipc_ns.shm_rmid_forced = 0;
unsigned int ipc_ns.msg_ctlmax = MSGMAX; // 8192
unsigned int ipc_ns.msg_ctlmni = MSGMNI; // 32000
unsigned int ipc_ns.msg_ctlmnb = MSGMNB; // 16384

The shm_tot (total amount of shared pages) has also ceased to be global,
it is located in ipc_namespace and is not inherited from anywhere.

In such conditions, it cannot be said that these limits limit anything.
The real limiter for them is cgroups.

If we allow rootless containers to change these parameters, then it can
only be reduced.

Link: https://lkml.kernel.org/r/cover.1705333426.git.legion@kernel.org
Link: https://lkml.kernel.org/r/d2f4603305cbfed58a24755aa61d027314b73a45.1705333426.git.legion@kernel.org
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Link: https://lkml.kernel.org/r/e2d84d3ec0172cfff759e6065da84ce0cc2736f8.1663756794.git.legion@kernel.org
Cc: Christian Brauner <brauner@kernel.org>
Cc: Joel Granados <joel.granados@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 98ca62ba9e2b ("sysctl: always initialize i_uid/i_gid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/ipc_sysctl.c | 37 +++++++++++++++++++++++++++++++++++--
 1 file changed, 35 insertions(+), 2 deletions(-)

diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index ef313ecfb53a1..29c1d3ae2a5c8 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -14,6 +14,7 @@
 #include <linux/ipc_namespace.h>
 #include <linux/msg.h>
 #include <linux/slab.h>
+#include <linux/cred.h>
 #include "util.h"
 
 static int proc_ipc_dointvec_minmax_orphans(struct ctl_table *table, int write,
@@ -190,25 +191,57 @@ static int set_is_seen(struct ctl_table_set *set)
 	return &current->nsproxy->ipc_ns->ipc_set == set;
 }
 
+static void ipc_set_ownership(struct ctl_table_header *head,
+			      struct ctl_table *table,
+			      kuid_t *uid, kgid_t *gid)
+{
+	struct ipc_namespace *ns =
+		container_of(head->set, struct ipc_namespace, ipc_set);
+
+	kuid_t ns_root_uid = make_kuid(ns->user_ns, 0);
+	kgid_t ns_root_gid = make_kgid(ns->user_ns, 0);
+
+	*uid = uid_valid(ns_root_uid) ? ns_root_uid : GLOBAL_ROOT_UID;
+	*gid = gid_valid(ns_root_gid) ? ns_root_gid : GLOBAL_ROOT_GID;
+}
+
 static int ipc_permissions(struct ctl_table_header *head, struct ctl_table *table)
 {
 	int mode = table->mode;
 
 #ifdef CONFIG_CHECKPOINT_RESTORE
-	struct ipc_namespace *ns = current->nsproxy->ipc_ns;
+	struct ipc_namespace *ns =
+		container_of(head->set, struct ipc_namespace, ipc_set);
 
 	if (((table->data == &ns->ids[IPC_SEM_IDS].next_id) ||
 	     (table->data == &ns->ids[IPC_MSG_IDS].next_id) ||
 	     (table->data == &ns->ids[IPC_SHM_IDS].next_id)) &&
 	    checkpoint_restore_ns_capable(ns->user_ns))
 		mode = 0666;
+	else
 #endif
-	return mode;
+	{
+		kuid_t ns_root_uid;
+		kgid_t ns_root_gid;
+
+		ipc_set_ownership(head, table, &ns_root_uid, &ns_root_gid);
+
+		if (uid_eq(current_euid(), ns_root_uid))
+			mode >>= 6;
+
+		else if (in_egroup_p(ns_root_gid))
+			mode >>= 3;
+	}
+
+	mode &= 7;
+
+	return (mode << 6) | (mode << 3) | mode;
 }
 
 static struct ctl_table_root set_root = {
 	.lookup = set_lookup,
 	.permissions = ipc_permissions,
+	.set_ownership = ipc_set_ownership,
 };
 
 bool setup_ipc_sysctls(struct ipc_namespace *ns)
-- 
2.43.0



