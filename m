Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF7DD38F629
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:09:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772302143; cv=none; b=iqhgXs0r6rFmcDmbgeVaFWFtqMaRJomlbIbfBOAZfE+yHUlzG3bydLe8jLV3tyIPN/wpgS2mG0G3udBJLKXNp1vqPsUitIVZnrGuMsfv/h2fN1L9AJmpO+J8CPH+3xlscwngwLnU+tVZ2KN1yp0MK2jyG+HJTrTpf1s+yjvWTNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772302143; c=relaxed/simple;
	bh=oh6XrtqArh0O971U74hGmJ9jcvIEuj87+cYIgiGnrV0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IEp/g7Q9dItpiX8/g61CMMm6xZ66aqbz9MTSiKbAuhkpvpOk+LnFMSy3zN+TpgTntZua8IUArATP3y35ZlgrXb3B91J+SIED46Lm7Jh1GRS7B11pwy1Wyyp2JMtRMjm0lJzBi1HJdaqXBj+PC0x5C8ceyV7AbbycwR5mlgQpNUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ioe3dvWV; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ioe3dvWV"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E8677C19425;
	Sat, 28 Feb 2026 18:09:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772302143;
	bh=oh6XrtqArh0O971U74hGmJ9jcvIEuj87+cYIgiGnrV0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ioe3dvWVXE6A21FPXFxzIoCM655LJ0W0Tk2TLd2HjblcXr6nSX5j9ySMzNOmTjCR0
	 gGBNVNTZxSofzwVnE+6sseFe5XtTPzy9AylqKBbi4XlPFpp14Gpfn24AtYP/ghx2oN
	 6Fb9Ro9F7GVAIl0UXhdTiZ4OTy2LQ3bwpynjSLkvjlt/lwNElOZ7TR92/OsLz4F77g
	 rERzusV/7DL8uzUfsek61CApuYs4b2xX80MP9/UmH7FCKAbpVaEr90MZ1ym75zw9Nj
	 djR281blDu+7MIcjvKEd3iYOicIF/9oPyt6+72vK+9QEhAWuAaxmGnou14kjsJl5kF
	 47nuhxMAOXEKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Ondrej Mosnacek <omosnace@redhat.com>,
	Alexey Gladkov <legion@kernel.org>,
	Serge Hallyn <serge@hallyn.com>,
	Serge Hallyn <sergeh@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 137/283] ipc: don't audit capability check in ipc_permissions()
Date: Sat, 28 Feb 2026 13:04:39 -0500
Message-ID: <20260228180709.1583486-137-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180709.1583486-1-sashal@kernel.org>
References: <20260228180709.1583486-1-sashal@kernel.org>
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
index b2f39a86f4734..22b12a482ba91 100644
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

