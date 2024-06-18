Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96B2B15FCF5;
	Tue, 18 Jun 2024 12:51:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718715076; cv=none; b=qgqbTs7zo+Kk2+pf1f9k4kiaIJU825VmMC9X6sDqj0o/6na3GJn26ivbs+veeWIPzLT1TgUUlPtkzS6VVSldyTozUYQm+YbNN5J6UyinIIG2R4y5ZrXP8bKzIwmc8ceJelJzfUwXvOkGUKJ0eIb6CIBpm9K4UjjkdV7na3oPNo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718715076; c=relaxed/simple;
	bh=cGzKphcW0C3OiXe67w2dmlPYIXMHjKJpgPUq8EJ76gE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KErR/Q1l9jIr8S0BRepg7m5OCLRt8yWWqCv5+O9OxGA93fbdvw6FQBV3ed+AOACTRaXTo8W379JeHNoeLh6qTQa5Xbm1dK/gkQQL1c6PaBKAW0yNpoFJQLmbz7iwk4OSZVKCerpCY/7pKqh/BaBgSvAxEgOMyXObuPI9wqTz/nU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h//LoU2T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h//LoU2T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15DE6C3277B;
	Tue, 18 Jun 2024 12:51:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718715076;
	bh=cGzKphcW0C3OiXe67w2dmlPYIXMHjKJpgPUq8EJ76gE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h//LoU2TuN5ZbJKvCKhACsGdkwxf5EcBemUEe9Lbr3gj3db9e2q6qCGCA5vRO67PD
	 JeBM4Tv2ebJjCC4Zs4T+VFeZ5GFFwz3IsaeJEhTTJekfLmTfWtk04pjhv4ILTvFMET
	 q7TJCal41KR9VDU1/bwZd9eECAk8pYhTQwbB2Xe8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dai Ngo <dai.ngo@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 187/770] NFSv4_2: SSC helper should use its own config.
Date: Tue, 18 Jun 2024 14:30:40 +0200
Message-ID: <20240618123414.491666121@linuxfoundation.org>
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

From: Dai Ngo <dai.ngo@oracle.com>

[ Upstream commit 02591f9febd5f69bb4c266a4abf899c4cf21964f ]

Currently NFSv4_2 SSC helper, nfs_ssc, incorrectly uses GRACE_PERIOD
as its config. Fix by adding new config NFS_V4_2_SSC_HELPER which
depends on NFS_V4_2 and is automatically selected when NFSD_V4 is
enabled. Also removed the file name from a comment in nfs_ssc.c.

Signed-off-by: Dai Ngo <dai.ngo@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/Kconfig              |  4 ++++
 fs/nfs/nfs4file.c       |  4 ++++
 fs/nfs/super.c          | 12 ++++++++++++
 fs/nfs_common/Makefile  |  2 +-
 fs/nfs_common/nfs_ssc.c |  2 --
 fs/nfsd/Kconfig         |  1 +
 6 files changed, 22 insertions(+), 3 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index da524c4d7b7e0..462253ae483a3 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -333,6 +333,10 @@ config NFS_COMMON
 	depends on NFSD || NFS_FS || LOCKD
 	default y
 
+config NFS_V4_2_SSC_HELPER
+	tristate
+	default y if NFS_V4=y || NFS_FS=y
+
 source "net/sunrpc/Kconfig"
 source "fs/ceph/Kconfig"
 source "fs/cifs/Kconfig"
diff --git a/fs/nfs/nfs4file.c b/fs/nfs/nfs4file.c
index 70cd0d764c447..5ad57ad89fb1e 100644
--- a/fs/nfs/nfs4file.c
+++ b/fs/nfs/nfs4file.c
@@ -430,7 +430,9 @@ static const struct nfs4_ssc_client_ops nfs4_ssc_clnt_ops_tbl = {
  */
 void nfs42_ssc_register_ops(void)
 {
+#ifdef CONFIG_NFSD_V4
 	nfs42_ssc_register(&nfs4_ssc_clnt_ops_tbl);
+#endif
 }
 
 /**
@@ -441,7 +443,9 @@ void nfs42_ssc_register_ops(void)
  */
 void nfs42_ssc_unregister_ops(void)
 {
+#ifdef CONFIG_NFSD_V4
 	nfs42_ssc_unregister(&nfs4_ssc_clnt_ops_tbl);
+#endif
 }
 #endif /* CONFIG_NFS_V4_2 */
 
diff --git a/fs/nfs/super.c b/fs/nfs/super.c
index b3fcc27b95648..7179d59d73ca4 100644
--- a/fs/nfs/super.c
+++ b/fs/nfs/super.c
@@ -86,9 +86,11 @@ const struct super_operations nfs_sops = {
 };
 EXPORT_SYMBOL_GPL(nfs_sops);
 
+#ifdef CONFIG_NFS_V4_2
 static const struct nfs_ssc_client_ops nfs_ssc_clnt_ops_tbl = {
 	.sco_sb_deactive = nfs_sb_deactive,
 };
+#endif
 
 #if IS_ENABLED(CONFIG_NFS_V4)
 static int __init register_nfs4_fs(void)
@@ -111,15 +113,21 @@ static void unregister_nfs4_fs(void)
 }
 #endif
 
+#ifdef CONFIG_NFS_V4_2
 static void nfs_ssc_register_ops(void)
 {
+#ifdef CONFIG_NFSD_V4
 	nfs_ssc_register(&nfs_ssc_clnt_ops_tbl);
+#endif
 }
 
 static void nfs_ssc_unregister_ops(void)
 {
+#ifdef CONFIG_NFSD_V4
 	nfs_ssc_unregister(&nfs_ssc_clnt_ops_tbl);
+#endif
 }
+#endif /* CONFIG_NFS_V4_2 */
 
 static struct shrinker acl_shrinker = {
 	.count_objects	= nfs_access_cache_count,
@@ -148,7 +156,9 @@ int __init register_nfs_fs(void)
 	ret = register_shrinker(&acl_shrinker);
 	if (ret < 0)
 		goto error_3;
+#ifdef CONFIG_NFS_V4_2
 	nfs_ssc_register_ops();
+#endif
 	return 0;
 error_3:
 	nfs_unregister_sysctl();
@@ -168,7 +178,9 @@ void __exit unregister_nfs_fs(void)
 	unregister_shrinker(&acl_shrinker);
 	nfs_unregister_sysctl();
 	unregister_nfs4_fs();
+#ifdef CONFIG_NFS_V4_2
 	nfs_ssc_unregister_ops();
+#endif
 	unregister_filesystem(&nfs_fs_type);
 }
 
diff --git a/fs/nfs_common/Makefile b/fs/nfs_common/Makefile
index fa82f5aaa6d95..119c75ab9fd08 100644
--- a/fs/nfs_common/Makefile
+++ b/fs/nfs_common/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_NFS_ACL_SUPPORT) += nfs_acl.o
 nfs_acl-objs := nfsacl.o
 
 obj-$(CONFIG_GRACE_PERIOD) += grace.o
-obj-$(CONFIG_GRACE_PERIOD) += nfs_ssc.o
+obj-$(CONFIG_NFS_V4_2_SSC_HELPER) += nfs_ssc.o
diff --git a/fs/nfs_common/nfs_ssc.c b/fs/nfs_common/nfs_ssc.c
index f43bbb3739134..7c1509e968c81 100644
--- a/fs/nfs_common/nfs_ssc.c
+++ b/fs/nfs_common/nfs_ssc.c
@@ -1,7 +1,5 @@
 // SPDX-License-Identifier: GPL-2.0-only
 /*
- * fs/nfs_common/nfs_ssc_comm.c
- *
  * Helper for knfsd's SSC to access ops in NFS client modules
  *
  * Author: Dai Ngo <dai.ngo@oracle.com>
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 248f1459c0399..d6cff5fbe705b 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -77,6 +77,7 @@ config NFSD_V4
 	select CRYPTO_MD5
 	select CRYPTO_SHA256
 	select GRACE_PERIOD
+	select NFS_V4_2_SSC_HELPER if NFS_V4_2
 	help
 	  This option enables support in your system's NFS server for
 	  version 4 of the NFS protocol (RFC 3530).
-- 
2.43.0



