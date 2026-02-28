Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2689B36C9F9
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:13:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302382; cv=none; b=I9bxjTpfAlr9XkcYwwKAG63AtpUMEbLLvvA54/9n1F3Hy1p9uO56rPOKZAQBHPHqXao8KmeX3y3H9wHzDpb0FxPa06e25xEfm/Kf4kmNkOthMQtfdI2bAK4RlnjXhh9siMOeqqOQCe8oGe06ns2vLc+eXVmZmb7KJdkz+Y0xWz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302382; c=relaxed/simple;
	bh=pwDOSfqiBigWAj+0EQJ/OTvvqBwxFySXV8AcnYccKRg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IjK0sKiAGskl5Urr4qfcuVZxFcSqGJIPpo/XWNyZK2WnpcqWB/by6Btrasb2fDo4AKLUrJMKomKoiKR/JZo+9o3gKSVh58EMKkIjsXVeMt3k0g4WzJFpdl2URI0A/lawnza88mhRhEmxnkSgtI7SKaew3lV1tvhbnJpx04iMr9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=W2ZBkfwk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="W2ZBkfwk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5F86CC2BC87;
	Sat, 28 Feb 2026 18:13:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302382;
	bh=pwDOSfqiBigWAj+0EQJ/OTvvqBwxFySXV8AcnYccKRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=W2ZBkfwkPl9IN+wkkao53SWQC/Q1JuuCeIBsJuaDYVH1UiVAPqKqg41QX9PejxoWx
	 iRP1VWBoEcxFsVz9SbkTHWItUhYsU01/Ev4PCLMUE8+573LTMnl7sX9Id63muYqs92
	 291uiy3X8is3UXb2EQZL5oWeyrGSIPWXP/QWytINtcpT3W90ETWgKss35A5U8YS1yb
	 e7z9UnzSYjJ/ZhlZcJDDjl1YJ6iuXT/BFxIwCUS/NzeTo75duoBMNsW/wBNIFkAtNB
	 xeGremnigpt0brYNeL+QQZz1ctyn8FY/noh1pfOMPKm9eNm35rXaPPgVmov2NWBnwB
	 43G92vWvmkxMQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	Alexey Gladkov <legion@kernel.org>,
	Serge Hallyn <serge@hallyn.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 110/232] ipc: don't audit capability check in ipc_permissions()
Date: Sat, 28 Feb 2026 13:09:23 -0500
Message-ID: <20260228181127.1592657-110-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228181127.1592657-1-sashal@kernel.org>
References: <20260228181127.1592657-1-sashal@kernel.org>
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
index 65efb74c3585d..d5973c2898b83 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -270,6 +270,12 @@ static inline bool checkpoint_restore_ns_capable(struct user_namespace *ns)
 		ns_capable(ns, CAP_SYS_ADMIN);
 }
 
+static inline bool checkpoint_restore_ns_capable_noaudit(struct user_namespace *ns)
+{
+	return ns_capable_noaudit(ns, CAP_CHECKPOINT_RESTORE) ||
+		ns_capable_noaudit(ns, CAP_SYS_ADMIN);
+}
+
 /* audit system wants to get cap info from files as well */
 int get_vfs_caps_from_disk(struct user_namespace *mnt_userns,
 			   const struct dentry *dentry,
diff --git a/ipc/ipc_sysctl.c b/ipc/ipc_sysctl.c
index d7ca2bdae9e82..9ca2f9f4f16ca 100644
--- a/ipc/ipc_sysctl.c
+++ b/ipc/ipc_sysctl.c
@@ -215,7 +215,7 @@ static int ipc_permissions(struct ctl_table_header *head, struct ctl_table *tabl
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

