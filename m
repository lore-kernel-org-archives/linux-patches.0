Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18CAD823A9;
	Wed,  7 Aug 2024 15:07:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043224; cv=none; b=P5+Z1zmz9uCk2evf3EGZyMUz22zz0vmy9sC/oQerCRKwK8ysv31mTjn0b7HMMORKeeh1GQB+ulQvJYesPYvHwfKT9xNnTVS3H7avhLsxbKvowF9JUNvyW9xzDAHxIF6u/DD04trctes55D1yH0AHPy44uy3KO69WyePh3m0jaMw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043224; c=relaxed/simple;
	bh=QoUOJlb+uHnzku92O9QD+nZXJ9KQ/oaNLXqkJM43W6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fSdcxhz+6NBwSrRKLzpnRgYJC/nL+csyOAtcDjuLEE8h+c3+N/Zj56eaCNhL16sDGXiV1Prl01tfLM2Ak4LxqQKIoYojb0WLbA1TJXfFOoSylwcrWQAmnnwXa1YLTGTOc8bbK5c/hXzfmNPB+6+AvtiSwzRHkkaK54AqeQ+IhYY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZKPw8yg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZKPw8yg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 44A3FC32781;
	Wed,  7 Aug 2024 15:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043223;
	bh=QoUOJlb+uHnzku92O9QD+nZXJ9KQ/oaNLXqkJM43W6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZKPw8ygB951yS+L32LqrPr/knzp/zjTKkYN932sQa4bCFGkSc++qtwA3xM3MPj5c
	 4VAZpLfjqfiEGU0P+R/zI1M5KNq0Je9HdVQ8QBO/jh2j0KriEuTd3Y7b0HF2kPGuer
	 zo5HcMOkStLd3dVFZAzkr/UAf2bsSuv7Y/7Nk9Lw=
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
Subject: [PATCH 6.6 013/121] sysctl: allow change system v ipc sysctls inside ipc namespace
Date: Wed,  7 Aug 2024 16:59:05 +0200
Message-ID: <20240807150019.807652669@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240807150019.412911622@linuxfoundation.org>
References: <20240807150019.412911622@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 8c62e443f78b3..01c4a50d22b2d 100644
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



