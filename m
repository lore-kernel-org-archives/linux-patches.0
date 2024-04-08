Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFDE26EB72;
	Mon,  8 Apr 2024 13:55:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584547; cv=none; b=FU6GpD8C2Eg7LahTC25HIKAiPpnsg9xLYRIH4mDge6XCx2VyF4T1OBo8NJqF3Zf8KI6RagTFM1fO/nxobLEuwz84Hj9uyFatjnFJDd5G9zz6kgVUQjLT4/649UYwpJigiYCUVZgclCFeyq2a9WnMs5Lpct32b6TV8B1bnAFQzgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584547; c=relaxed/simple;
	bh=HoKkFo0Yi+wS2qyj3Czdb1N0QLv5Gz3WKen2p8b7lMQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DQQf5EKW+lgkuaNLiQLvmigcj0SrnHT7lGBKCT3CmvBL2miJh518AjCJyv4lARfQyQu2OWkNXyxxmmA9h1sWCSYbmqUt+wLFkWaviRG4AKaJ2RJg1e6pDdaXWhj1DkyudxoFK6s2+gnVPmX/B+c1I/GKGv62NhdgM7/VR7+gjes=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xg57SRYO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xg57SRYO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49D1DC433F1;
	Mon,  8 Apr 2024 13:55:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584547;
	bh=HoKkFo0Yi+wS2qyj3Czdb1N0QLv5Gz3WKen2p8b7lMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xg57SRYOSVVCTfxn2PbfRnTvbVmBe+RRHv+cUWUd/7epb6sAgJMh6tRREfwNldNNz
	 qBshqwcwTWAJvnyv4/1JT8zXn8PHiemO676pVxLtBLEYmi86eZE6AK+oC6besGxSdZ
	 DIaESJZGgbilMDr0rRLH5P91zqO9ndMmzTBNh0Og=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Tom Talpey <tom@talpey.com>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 475/690] nfsd: allow disabling NFSv2 at compile time
Date: Mon,  8 Apr 2024 14:55:41 +0200
Message-ID: <20240408125416.813466803@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
---
 fs/nfsd/Kconfig  | 19 +++++++++++++++----
 fs/nfsd/Makefile |  5 +++--
 fs/nfsd/nfsctl.c |  2 ++
 fs/nfsd/nfsd.h   |  3 +--
 fs/nfsd/nfssvc.c |  6 ++++++
 5 files changed, 27 insertions(+), 8 deletions(-)

diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index b83a6e3bf8080..7f071519fb2e0 100644
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



