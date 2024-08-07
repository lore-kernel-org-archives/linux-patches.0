Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE5D77F7F5;
	Wed,  7 Aug 2024 15:13:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723043586; cv=none; b=KwmlMt7SBxVQhbPETvxPsKzCMypp26/ULTWJhhjueQdvO+yZTSQZH4fMarXB5wXWqmHqgzxfCDO75q5eURvGfHsnSBgHwqRdop+L3xt9GhsgLkB/dgv28rljBaLZxK/ArjUaqTO/7JDc9k4qzcW1kklhqbS/p52Vz3SknC1KkT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723043586; c=relaxed/simple;
	bh=UGxlVpYWLhWxNkVPmcYuagv/U7x23ZE/qTxLHRklWLc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mKXlw9gcqfNAERnF32uKkH5iSEQ/sTbfH7V+x5r7PJqQTnQ1+3AjCtRwFlhjzsQYPdFhwFODeMXMOk4LogKCSACKayFbkONR4YH8D5qH0lblZ3NlXEtxGDx36eM05shV9v+QSYtsKRqT2pBPDsopATtafcTDEMyhJzX2127ZfsE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DItz94cT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DItz94cT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D493C32781;
	Wed,  7 Aug 2024 15:13:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723043585;
	bh=UGxlVpYWLhWxNkVPmcYuagv/U7x23ZE/qTxLHRklWLc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DItz94cTpOPGslWLfkTBSOMB+JU80N4ZSmRyRIJxhpLHhOU+suybsDAZS2FjZ5XoD
	 k0Wte7yam64EDCuSHymMDJGLhEG5BpluCF1/deGLOWHccDfGVuxNW7citYJ3J0ilyP
	 ySqjvaafcERjw2pHiLfNDCMR2BM+fsV8A6n5os7U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexey Gladkov <legion@kernel.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Christian Brauner <brauner@kernel.org>,
	Davidlohr Bueso <dave@stgolabs.net>,
	Joel Granados <joel.granados@gmail.com>,
	Kees Cook <keescook@chromium.org>,
	Luis Chamberlain <mcgrof@kernel.org>,
	Manfred Spraul <manfred@colorfullife.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 05/86] sysctl: allow to change limits for posix messages queues
Date: Wed,  7 Aug 2024 16:59:44 +0200
Message-ID: <20240807150039.428878191@linuxfoundation.org>
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

[ Upstream commit f9436a5d0497f759330d07e1189565edd4456be8 ]

All parameters of posix messages queues (queues_max/msg_max/msgsize_max)
end up being limited by RLIMIT_MSGQUEUE.  The code in mqueue_get_inode is
where that limiting happens.

The RLIMIT_MSGQUEUE is bound to the user namespace and is counted
hierarchically.

We can allow root in the user namespace to modify the posix messages
queues parameters.

Link: https://lkml.kernel.org/r/6ad67f23d1459a4f4339f74aa73bac0ecf3995e1.1705333426.git.legion@kernel.org
Signed-off-by: Alexey Gladkov <legion@kernel.org>
Signed-off-by: Eric W. Biederman <ebiederm@xmission.com>
Link: https://lkml.kernel.org/r/7eb21211c8622e91d226e63416b1b93c079f60ee.1663756794.git.legion@kernel.org
Cc: Christian Brauner <brauner@kernel.org>
Cc: Davidlohr Bueso <dave@stgolabs.net>
Cc: Joel Granados <joel.granados@gmail.com>
Cc: Kees Cook <keescook@chromium.org>
Cc: Luis Chamberlain <mcgrof@kernel.org>
Cc: Manfred Spraul <manfred@colorfullife.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 98ca62ba9e2b ("sysctl: always initialize i_uid/i_gid")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 ipc/mq_sysctl.c | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/ipc/mq_sysctl.c b/ipc/mq_sysctl.c
index fbf6a8b93a265..ce03930aced55 100644
--- a/ipc/mq_sysctl.c
+++ b/ipc/mq_sysctl.c
@@ -12,6 +12,7 @@
 #include <linux/stat.h>
 #include <linux/capability.h>
 #include <linux/slab.h>
+#include <linux/cred.h>
 
 static int msg_max_limit_min = MIN_MSGMAX;
 static int msg_max_limit_max = HARD_MSGMAX;
@@ -76,8 +77,43 @@ static int set_is_seen(struct ctl_table_set *set)
 	return &current->nsproxy->ipc_ns->mq_set == set;
 }
 
+static void mq_set_ownership(struct ctl_table_header *head,
+			     struct ctl_table *table,
+			     kuid_t *uid, kgid_t *gid)
+{
+	struct ipc_namespace *ns =
+		container_of(head->set, struct ipc_namespace, mq_set);
+
+	kuid_t ns_root_uid = make_kuid(ns->user_ns, 0);
+	kgid_t ns_root_gid = make_kgid(ns->user_ns, 0);
+
+	*uid = uid_valid(ns_root_uid) ? ns_root_uid : GLOBAL_ROOT_UID;
+	*gid = gid_valid(ns_root_gid) ? ns_root_gid : GLOBAL_ROOT_GID;
+}
+
+static int mq_permissions(struct ctl_table_header *head, struct ctl_table *table)
+{
+	int mode = table->mode;
+	kuid_t ns_root_uid;
+	kgid_t ns_root_gid;
+
+	mq_set_ownership(head, table, &ns_root_uid, &ns_root_gid);
+
+	if (uid_eq(current_euid(), ns_root_uid))
+		mode >>= 6;
+
+	else if (in_egroup_p(ns_root_gid))
+		mode >>= 3;
+
+	mode &= 7;
+
+	return (mode << 6) | (mode << 3) | mode;
+}
+
 static struct ctl_table_root set_root = {
 	.lookup = set_lookup,
+	.permissions = mq_permissions,
+	.set_ownership = mq_set_ownership,
 };
 
 bool setup_mq_sysctls(struct ipc_namespace *ns)
-- 
2.43.0



