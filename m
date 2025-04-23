Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7216A269B07;
	Wed, 23 Apr 2025 15:25:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421950; cv=none; b=Rms6oAl8bseaGN04mFDD8CRhskR/CMPLwCsc9PKGDJdlUF54Eo/c2ks5reiTfXZ2ma7yuD0j5pB8RI8BcjW7ZhIHzL0XHjKsXv5+abXCuDQMaphcvcmm1XqpBuyPpAMiCv9WdBpSMvCk43vJfwADu6S3mBjPwft+6oGGp7B9FK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421950; c=relaxed/simple;
	bh=xPW8SwA1toEMYHevC3NrCrl9g6aLqy+Yt44Y+LD3ZVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rQwXCCZsdRlUZO/roGQY+agMIrbQkmVYek47VF72zriiGkEa4q9Qg+8uMbNFxKTONVfENXuaOOoMXI43plQloo91ts06ReS8Dt7U5ZZCUqwaNtjLblJThHVD8caE0cEP5f29839TGc/mhW19XT8l77MGnRfkP0m9S9jYZoS/138=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BfgU1oRm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BfgU1oRm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D658C4CEE8;
	Wed, 23 Apr 2025 15:25:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421949;
	bh=xPW8SwA1toEMYHevC3NrCrl9g6aLqy+Yt44Y+LD3ZVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BfgU1oRm5noND73+mg1G53nEFkQIROc0bAV0Z4VOXuwLRHpPsd9/5t0F524DG/RY7
	 e41MGd6SyygQ7nJk0+p90b2MJ3v57HUFNX2GfbqDqyH0847K5JW8pKIuTAua1gCoLL
	 MQOHIn6t+vODN/9/qL4J9jxd5yikBLrgV64h8fQ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 204/291] nfs: add missing selections of CONFIG_CRC32
Date: Wed, 23 Apr 2025 16:43:13 +0200
Message-ID: <20250423142632.717812250@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Biggers <ebiggers@google.com>

[ Upstream commit cd35b6cb46649750b7dbd0df0e2d767415d8917b ]

nfs.ko, nfsd.ko, and lockd.ko all use crc32_le(), which is available
only when CONFIG_CRC32 is enabled.  But the only NFS kconfig option that
selected CONFIG_CRC32 was CONFIG_NFS_DEBUG, which is client-specific and
did not actually guard the use of crc32_le() even on the client.

The code worked around this bug by only actually calling crc32_le() when
CONFIG_CRC32 is built-in, instead hard-coding '0' in other cases.  This
avoided randconfig build errors, and in real kernels the fallback code
was unlikely to be reached since CONFIG_CRC32 is 'default y'.  But, this
really needs to just be done properly, especially now that I'm planning
to update CONFIG_CRC32 to not be 'default y'.

Therefore, make CONFIG_NFS_FS, CONFIG_NFSD, and CONFIG_LOCKD select
CONFIG_CRC32.  Then remove the fallback code that becomes unnecessary,
as well as the selection of CONFIG_CRC32 from CONFIG_NFS_DEBUG.

Fixes: 1264a2f053a3 ("NFS: refactor code for calculating the crc32 hash of a filehandle")
Signed-off-by: Eric Biggers <ebiggers@google.com>
Acked-by: Anna Schumaker <anna.schumaker@oracle.com>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/Kconfig           | 1 +
 fs/nfs/Kconfig       | 2 +-
 fs/nfs/internal.h    | 7 -------
 fs/nfs/nfs4session.h | 4 ----
 fs/nfsd/Kconfig      | 1 +
 fs/nfsd/nfsfh.h      | 7 -------
 include/linux/nfs.h  | 7 -------
 7 files changed, 3 insertions(+), 26 deletions(-)

diff --git a/fs/Kconfig b/fs/Kconfig
index 703a1cea0fc09..7104e3eb38eb4 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -347,6 +347,7 @@ config GRACE_PERIOD
 config LOCKD
 	tristate
 	depends on FILE_LOCKING
+	select CRC32
 	select GRACE_PERIOD
 
 config LOCKD_V4
diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index 14a72224b6571..899e25e9b4eb5 100644
--- a/fs/nfs/Kconfig
+++ b/fs/nfs/Kconfig
@@ -2,6 +2,7 @@
 config NFS_FS
 	tristate "NFS client support"
 	depends on INET && FILE_LOCKING && MULTIUSER
+	select CRC32
 	select LOCKD
 	select SUNRPC
 	select NFS_ACL_SUPPORT if NFS_V3_ACL
@@ -194,7 +195,6 @@ config NFS_USE_KERNEL_DNS
 config NFS_DEBUG
 	bool
 	depends on NFS_FS && SUNRPC_DEBUG
-	select CRC32
 	default y
 
 config NFS_DISABLE_UDP_SUPPORT
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index d511d66bd8a3a..ece517ebcca0b 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -826,18 +826,11 @@ u64 nfs_timespec_to_change_attr(const struct timespec64 *ts)
 	return ((u64)ts->tv_sec << 30) + ts->tv_nsec;
 }
 
-#ifdef CONFIG_CRC32
 static inline u32 nfs_stateid_hash(const nfs4_stateid *stateid)
 {
 	return ~crc32_le(0xFFFFFFFF, &stateid->other[0],
 				NFS4_STATEID_OTHER_SIZE);
 }
-#else
-static inline u32 nfs_stateid_hash(nfs4_stateid *stateid)
-{
-	return 0;
-}
-#endif
 
 static inline bool nfs_error_is_fatal(int err)
 {
diff --git a/fs/nfs/nfs4session.h b/fs/nfs/nfs4session.h
index 351616c61df54..f9c291e2165cd 100644
--- a/fs/nfs/nfs4session.h
+++ b/fs/nfs/nfs4session.h
@@ -148,16 +148,12 @@ static inline void nfs4_copy_sessionid(struct nfs4_sessionid *dst,
 	memcpy(dst->data, src->data, NFS4_MAX_SESSIONID_LEN);
 }
 
-#ifdef CONFIG_CRC32
 /*
  * nfs_session_id_hash - calculate the crc32 hash for the session id
  * @session - pointer to session
  */
 #define nfs_session_id_hash(sess_id) \
 	(~crc32_le(0xFFFFFFFF, &(sess_id)->data[0], sizeof((sess_id)->data)))
-#else
-#define nfs_session_id_hash(session) (0)
-#endif
 #else /* defined(CONFIG_NFS_V4_1) */
 
 static inline int nfs4_init_session(struct nfs_client *clp)
diff --git a/fs/nfsd/Kconfig b/fs/nfsd/Kconfig
index 7c441f2bd4440..4f704f868d9c9 100644
--- a/fs/nfsd/Kconfig
+++ b/fs/nfsd/Kconfig
@@ -4,6 +4,7 @@ config NFSD
 	depends on INET
 	depends on FILE_LOCKING
 	depends on FSNOTIFY
+	select CRC32
 	select LOCKD
 	select SUNRPC
 	select EXPORTFS
diff --git a/fs/nfsd/nfsfh.h b/fs/nfsd/nfsfh.h
index 513e028b0bbee..40aee06ebd952 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -263,7 +263,6 @@ static inline bool fh_fsid_match(const struct knfsd_fh *fh1,
 	return true;
 }
 
-#ifdef CONFIG_CRC32
 /**
  * knfsd_fh_hash - calculate the crc32 hash for the filehandle
  * @fh - pointer to filehandle
@@ -275,12 +274,6 @@ static inline u32 knfsd_fh_hash(const struct knfsd_fh *fh)
 {
 	return ~crc32_le(0xFFFFFFFF, fh->fh_raw, fh->fh_size);
 }
-#else
-static inline u32 knfsd_fh_hash(const struct knfsd_fh *fh)
-{
-	return 0;
-}
-#endif
 
 /**
  * fh_clear_pre_post_attrs - Reset pre/post attributes
diff --git a/include/linux/nfs.h b/include/linux/nfs.h
index ceb70a926b95e..095a95c1fae82 100644
--- a/include/linux/nfs.h
+++ b/include/linux/nfs.h
@@ -46,7 +46,6 @@ enum nfs3_stable_how {
 	NFS_INVALID_STABLE_HOW = -1
 };
 
-#ifdef CONFIG_CRC32
 /**
  * nfs_fhandle_hash - calculate the crc32 hash for the filehandle
  * @fh - pointer to filehandle
@@ -58,10 +57,4 @@ static inline u32 nfs_fhandle_hash(const struct nfs_fh *fh)
 {
 	return ~crc32_le(0xFFFFFFFF, &fh->data[0], fh->size);
 }
-#else /* CONFIG_CRC32 */
-static inline u32 nfs_fhandle_hash(const struct nfs_fh *fh)
-{
-	return 0;
-}
-#endif /* CONFIG_CRC32 */
 #endif /* _LINUX_NFS_H */
-- 
2.39.5



