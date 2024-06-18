Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C97A15990E;
	Tue, 18 Jun 2024 13:17:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718716658; cv=none; b=K1+krQg6B48l39NkL5iFQ8ClOy+TIsZZSx+vjLezFKuXvU19UfroIh48jl0H4mY0YhqY1Zk1T2HIK2OAVhq+t0RKqxV6+4mRE5C7zWX39ck83I+h7pFamE6gduDJVHx1jauP2mOlCFf1AvFA3I/Ckj+yASti2MxjSIAyFGxJMd8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718716658; c=relaxed/simple;
	bh=XR+m84evx/H0Ea7cw257XiQR9ADLRzaN61mhAOxt3D0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPOgADiKOLCaofzdzXsCzgPReIXO8ZhYug7eOQ/Id5a74CDfftiCoqysRsLWXB/Wt0G4OpK8WEW7rzbQi47CMKwPSOeSo/dYuH45PUdMGKOiEpMLjhUaAYbfG96XltoXsxFerPJemgCGdEHZ37O8ItGLb+alzP34OxLFr7amB/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rMxYFC9Q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rMxYFC9Q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9F90C3277B;
	Tue, 18 Jun 2024 13:17:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718716658;
	bh=XR+m84evx/H0Ea7cw257XiQR9ADLRzaN61mhAOxt3D0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rMxYFC9QL3OcxCo2PLI41beUk2Npw3l9Eh/9ys5jgzqT/Kl2Yi0DZNw9I+qO48Zqi
	 CxjFUJrBpkV7SCJIqeL2xPKeZuCJk/kvxQpiH5SUtfDZkr231MflaSwaXXiFUSwIwj
	 oTT7Np6M72VuuMWH9f6tyfSGxkRNIDrjQTtqnlos=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 688/770] nfsd: allow disabling NFSv2 at compile time
Date: Tue, 18 Jun 2024 14:39:01 +0200
Message-ID: <20240618123433.836068544@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240618123407.280171066@linuxfoundation.org>
References: <20240618123407.280171066@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit 2f3a4b2ac2f28b9be78ad21f401f31e263845214 ]

rpc.nfsd stopped supporting NFSv2 a year ago. Take the next logical
step toward deprecating it and allow NFSv2 support to be compiled out.

Add a new CONFIG_NFSD_V2 option that can be turned off and rework the
CONFIG_NFSD_V?_ACL option dependencies. Add a description that
discourages enabling it.

Also, change the description of CONFIG_NFSD to state that the always-on
version is now 3 instead of 2.

Finally, add an #ifdef around "case 2:" in __write_versions. When NFSv2
is disabled at compile time, this should make the kernel ignore attempts
to disable it at runtime, but still error out when trying to enable it.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Tom Talpey <tom@talpey.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfsd/Kconfig  | 19 +++++++++++++++----
 fs/nfsd/Makefile |  5 +++--
 fs/nfsd/nfsctl.c |  2 ++
 fs/nfsd/nfsd.h   |  3 +--
 fs/nfsd/nfssvc.c |  6 ++++++
 5 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 887af7966b032..6d2d498a59573 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -8,6 +8,7 @@ config NFSD
 	select SUNRPC
 	select EXPORTFS
 	select NFS_ACL_SUPPORT if NFSD_V2_ACL
+	select NFS_ACL_SUPPORT if NFSD_V3_ACL
 	depends on MULTIUSER
 	help
 	  Choose Y here if you want to allow other computers to access
@@ -26,19 +27,29 @@ config NFSD
 
 	  Below you can choose which versions of the NFS protocol are
 	  available to clients mounting the NFS server on this system.
-	  Support for NFS version 2 (RFC 1094) is always available when
+	  Support for NFS version 3 (RFC 1813) is always available when
 	  CONFIG_NFSD is selected.
 
 	  If unsure, say N.
 
-config NFSD_V2_ACL
-	bool
+config NFSD_V2
+	bool "NFS server support for NFS version 2 (DEPRECATED)"
 	depends on NFSD
+	default n
+	help
+	  NFSv2 (RFC 1094) was the first publicly-released version of NFS.
+	  Unless you are hosting ancient (1990's era) NFS clients, you don't
+	  need this.
+
+	  If unsure, say N.
+
+config NFSD_V2_ACL
+	bool "NFS server support for the NFSv2 ACL protocol extension"
+	depends on NFSD_V2
 
 config NFSD_V3_ACL
 	bool "NFS server support for the NFSv3 ACL protocol extension"
 	depends on NFSD
-	select NFSD_V2_ACL
 	help
 	  Solaris NFS servers support an auxiliary NFSv3 ACL protocol that
 	  never became an official part of the NFS version 3 protocol.
diff --git a/fs/nfsd/Makefile b/fs/nfsd/Makefile
index 805c06d5f1b4b..6fffc8f03f740 100644
--- a/fs/nfsd/Makefile
+++ b/fs/nfsd/Makefile
@@ -10,9 +10,10 @@ obj-$(CONFIG_NFSD)	+= nfsd.o
 # this one should be compiled first, as the tracing macros can easily blow up
 nfsd-y			+= trace.o
 
-nfsd-y 			+= nfssvc.o nfsctl.o nfsproc.o nfsfh.o vfs.o \
-			   export.o auth.o lockd.o nfscache.o nfsxdr.o \
+nfsd-y 			+= nfssvc.o nfsctl.o nfsfh.o vfs.o \
+			   export.o auth.o lockd.o nfscache.o \
 			   stats.o filecache.o nfs3proc.o nfs3xdr.o
+nfsd-$(CONFIG_NFSD_V2) += nfsproc.o nfsxdr.o
 nfsd-$(CONFIG_NFSD_V2_ACL) += nfs2acl.o
 nfsd-$(CONFIG_NFSD_V3_ACL) += nfs3acl.o
 nfsd-$(CONFIG_NFSD_V4)	+= nfs4proc.o nfs4xdr.o nfs4state.o nfs4idmap.o \
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index 68ed42fd29fc8..d1e581a60480c 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -581,7 +581,9 @@ static ssize_t __write_versions(struct file *file, char *buf, size_t size)
 
 			cmd = sign == '-' ? NFSD_CLEAR : NFSD_SET;
 			switch(num) {
+#ifdef CONFIG_NFSD_V2
 			case 2:
+#endif
 			case 3:
 				nfsd_vers(nn, num, cmd);
 				break;
diff --git a/fs/nfsd/nfsd.h b/fs/nfsd/nfsd.h
index 09726c5b9a317..93b42ef9ed91b 100644
--- a/fs/nfsd/nfsd.h
+++ b/fs/nfsd/nfsd.h
@@ -64,8 +64,7 @@ struct readdir_cd {
 
 
 extern struct svc_program	nfsd_program;
-extern const struct svc_version	nfsd_version2, nfsd_version3,
-				nfsd_version4;
+extern const struct svc_version	nfsd_version2, nfsd_version3, nfsd_version4;
 extern struct mutex		nfsd_mutex;
 extern spinlock_t		nfsd_drc_lock;
 extern unsigned long		nfsd_drc_max_mem;
diff --git a/fs/nfsd/nfssvc.c b/fs/nfsd/nfssvc.c
index 8b1afde192118..429f38c986280 100644
--- a/fs/nfsd/nfssvc.c
+++ b/fs/nfsd/nfssvc.c
@@ -91,8 +91,12 @@ unsigned long	nfsd_drc_mem_used;
 #if defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL)
 static struct svc_stat	nfsd_acl_svcstats;
 static const struct svc_version *nfsd_acl_version[] = {
+# if defined(CONFIG_NFSD_V2_ACL)
 	[2] = &nfsd_acl_version2,
+# endif
+# if defined(CONFIG_NFSD_V3_ACL)
 	[3] = &nfsd_acl_version3,
+# endif
 };
 
 #define NFSD_ACL_MINVERS            2
@@ -116,7 +120,9 @@ static struct svc_stat	nfsd_acl_svcstats = {
 #endif /* defined(CONFIG_NFSD_V2_ACL) || defined(CONFIG_NFSD_V3_ACL) */
 
 static const struct svc_version *nfsd_version[] = {
+#if defined(CONFIG_NFSD_V2)
 	[2] = &nfsd_version2,
+#endif
 	[3] = &nfsd_version3,
 #if defined(CONFIG_NFSD_V4)
 	[4] = &nfsd_version4,
-- 
2.43.0



