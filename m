Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B3BB918B0A;
	Wed, 25 Feb 2026 01:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983241; cv=none; b=o6YceYKASev87qoFxi5p3xDnE/r+H01agpCl7AkJdfDE41SMuXwv0gffkJzn8P3l1PesZAAADJhN8iUqXba2EQIiEOdbHRiSiQocDU7TwjnhgrinjDrxV8rQKck+v+81yeq0cPqg0+aCQ+JVQfn4oKyojcIyGFickoGP3phlraY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983241; c=relaxed/simple;
	bh=3N2V08y9txo+u9k2F9mteB4vKcRRYS64SiEeswXBrGE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VHV1Kkw11VEYYvgvi5kfyFOd8nmD5pSnuke7dKEU44clLR0YF6b5t/jDUz2UyfkP97L0jvtbhwz6KCllDSjDbQSXh+Ta9wTXiDxGeiXju1DqH9EBJdp+Wy4Cd/VGx0DRca1acFW3qYW061vfH+R/9jQMrCoAGaLZQn+vmeOPnnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=J83Unwwo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="J83Unwwo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A9FCC19423;
	Wed, 25 Feb 2026 01:34:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983241;
	bh=3N2V08y9txo+u9k2F9mteB4vKcRRYS64SiEeswXBrGE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J83Unwwo9ItXZKPygnHyS9F2vXjVvnYiGRc5oPWbB+nwR8Fisd0tHXeUT2qMexNc2
	 h5j2u1nDfybnAFzTfgyUlbAQAyrGVdvE7VuLpnCqluQckV9UQflX910NQEbU9ei/KF
	 UmV6c61cWq8PcD9dosAES7Ug5od4j2mdIZjaUMXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ondrej Mosnacek <omosnace@redhat.com>,
	Alexey Gladkov <legion@kernel.org>,
	Serge Hallyn <serge@hallyn.com>,
	Eric Biederman <ebiederm@xmission.com>,
	Paul Moore <paul@paul-moore.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 383/781] ipc: dont audit capability check in ipc_permissions()
Date: Tue, 24 Feb 2026 17:18:12 -0800
Message-ID: <20260225012409.091437416@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

From: Ondrej Mosnacek <omosnace@redhat.com>

[ Upstream commit 8924336531e21b187d724b5fdf5277269c9ec22c ]

The IPC sysctls implement the ctl_table_root::permissions hook and they
override the file access mode based on the CAP_CHECKPOINT_RESTORE
capability, which is being checked regardless of whether any access is
actually denied or not, so if an LSM denies the capability, an audit
record may be logged even when access is in fact granted.

It wouldn't be viable to restructure the sysctl permission logic to only
check the capability when the access would be actually denied if it's not
granted.  Thus, do the same as in net_ctl_permissions() (net/sysctl_net.c)
- switch from ns_capable() to ns_capable_noaudit(), so that the check
never emits an audit record.

Link: https://lkml.kernel.org/r/20260122141303.241133-1-omosnace@redhat.com
Fixes: 0889f44e2810 ("ipc: Check permissions for checkpoint_restart sysctls at open time")
Signed-off-by: Ondrej Mosnacek <omosnace@redhat.com>
Acked-by: Alexey Gladkov <legion@kernel.org>
Acked-by: Serge Hallyn <serge@hallyn.com>
Cc: Eric Biederman <ebiederm@xmission.com>
Cc: Paul Moore <paul@paul-moore.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/capability.h | 6 ++++++
 ipc/ipc_sysctl.c           | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/include/linux/capability.h b/include/linux/capability.h
index 1fb08922552c7..37db92b3d6f89 100644
--- a/include/linux/capability.h
+++ b/include/linux/capability.h
@@ -203,6 +203,12 @@ static inline bool checkpoint_restore_ns_capable(struct user_namespace *ns)
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
index 15b17e86e198c..9b087ebeb643b 100644
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



