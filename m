Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1A5534252B
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301804; cv=none; b=H90gs3ITqzYwOwKc1dQeCPLfJPiSMd9r3qXSjaEHNY525UUOgPTL2ehMq09j2DKujlOf3wQ/jdjwAC2+AEkPNYBYrdQ6905PoBZ1NTd7+5PPyiHmg9COjRkPbpQMeku/1aFihd656mo4F+2Hl5BYf3H9gNRjORM0yhurmA+UseQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301804; c=relaxed/simple;
	bh=Ew+pgQ5B8gR7kuIbrD70SBL0gvj4ugMSiDTtzFtSaUc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DXrO+WHc1cau9ldSp1i6Nkadf1FgRxHS5GVRFGtM5aW82R1SE4YQtt/Gq3Lt6qsOUQXiceFWzNu+SRTBe/S24TDZUspDuXg8XUvuC5sCd4N18m/dBS0TkMQtZ42h4t6xp0rgwfS81hZRZB1pj/Gch6UNwWDBskEd2TNBrK3avX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QOaqydTR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QOaqydTR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33AAAC116D0;
	Sat, 28 Feb 2026 18:03:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301803;
	bh=Ew+pgQ5B8gR7kuIbrD70SBL0gvj4ugMSiDTtzFtSaUc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QOaqydTRmHy2YEY9LyTn2ZqWbH8qKV7GU+uDQRWcB4O4nJiJNRL+RIHnB0PhK08Uq
	 x8XsAg5082LyyrMbZuChg5xHBeijD2JiVl2DB/UIRQ5ov7p0hnenLtYnAY+x9cFt3r
	 vdRxMqnr0CecpGDyctKe4vtkhx1mTgQuBpZTEfOGpwAGYRMNMmeTYZX+1W2R1N1fGc
	 84hOZZNARI9qFGNdCheGE0l8oqdHxTf8tFeBq80H3qymZ+/g7YE8ssY+ooIIL/Dxmx
	 NbkrExRzFBgvTK/5YP7Wa18GFE4speiMinzRCV5kk3a5knfbRaD7c3O+Gt7fOtsOKO
	 O0YTvsxhDePMg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	Alexey Gladkov <legion@kernel.org>,
	Serge Hallyn <serge@hallyn.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 216/385] ipc: don't audit capability check in ipc_permissions()
Date: Sat, 28 Feb 2026 12:57:18 -0500
Message-ID: <20260228180011.1568201-216-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 071588136007482d70fd2667b827036bc60b1f8f ]

The IPC sysctls implement the ctl_table_root::permissions hook and
they override the file access mode based on the CAP_CHECKPOINT_RESTORE
capability, which is being checked regardless of whether any access is
actually denied or not, so if an LSM denies the capability, an audit
record may be logged even when access is in fact granted.

It wouldn't be viable to restructure the sysctl permission logic to only
check the capability when the access would be actually denied if it's
not granted. Thus, do the same as in net_ctl_permissions()
(net/sysctl_net.c) - switch from ns_capable() to ns_capable_noaudit(),
so that the check never emits an audit record.

Fixes: 0889f44e2810 ("ipc: Check permissions for checkpoint_restart sysctls at open time")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Acked-by: Serge Hallyn <serge@hallyn.com>
Signed-off-by: Serge Hallyn <sergeh@kernel.org>
Stable-dep-of: 8924336531e2 ("ipc: don't audit capability check in ipc_permissions()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/capability.h | 6 ++++++
 ipc/ipc_sysctl.c           | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 0c356a5179917..767c535dbd38e 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -208,6 +208,12 @@ static inline bool checkpoint_restore_ns_capable(struct user_namespace *ns)
 		ns_capable(ns, CAP_SYS_ADMIN);
 }
 
+static inline bool checkpoint_restore_ns_capable_noaudit(struct user_namespace *ns)
+{
+	return ns_capable_noaudit(ns, CAP_CHECKPOINT_RESTORE) ||
+		ns_capable_noaudit(ns, CAP_SYS_ADMIN);
+}
+
 /* audit system wants to get cap info from files as well */
 int get_vfs_caps_from_disk(struct mnt_idmap *idmap,
 			   const struct dentry *dentry,
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index 54318e0b45578..61ce52ce30530 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -214,7 +214,7 @@ static int ipc_permissions(struct ctl_table_header *head, const struct ctl_table
 	if (((table->data == &ns->ids[IPC_SEM_IDS].next_id) ||
 	     (table->data == &ns->ids[IPC_MSG_IDS].next_id) ||
 	     (table->data == &ns->ids[IPC_SHM_IDS].next_id)) &&
-	    checkpoint_restore_ns_capable(ns->user_ns))
+	    checkpoint_restore_ns_capable_noaudit(ns->user_ns))
 		mode = 0666;
 	else
 #endif
-- 
2.51.0

