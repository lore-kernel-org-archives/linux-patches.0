Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF6D624336D;
	Tue, 29 Apr 2025 16:49:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745945395; cv=none; b=FlGj9IEP1Aqgd0AT0CMi84AqEx2598g4umsfGKP0wyIGXfLioK7/ZvWfaIJqgL0Tfhyj7FWB2P3yx8Z8wk2/SBj2JrfUiJ2m7D/twFastyAV4/CXkp78aK+8N3jwHflbJnIpvl7Dv9++71bhMJKCYqoubHDsw8gNt6i7+9NVE6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745945395; c=relaxed/simple;
	bh=0JXadE2OZuxqtDXcnHU5bEKXR4Ixr2bcMjOgqHgAgTg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FsKeOUCBOUwuaqYtzN31wZfR5LavxbDcGilrkZ7M+0T2WuNI45IV6nTA6Lh4uh4miaEXXczqLsuCtbucKeVE1qNnfpmz7UVgtZivjOejDGRax+faJwXeyzGwv8pHR0kHurjp/pMJIYpzDsNT4hqZyVanFXhLaNGvTzWXhFkawQc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OxePev6C; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OxePev6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 690EBC4CEE3;
	Tue, 29 Apr 2025 16:49:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745945394;
	bh=0JXadE2OZuxqtDXcnHU5bEKXR4Ixr2bcMjOgqHgAgTg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OxePev6CHorpzdFeIppwbAyLZPzh+vdgk4/wFZJhWF76JtCA3LD81Clm98RsiDADf
	 bGr2uSCPhMVlK1akj5IOGv/3O8Rxmu27MawJ2N1ILIl8FB3qju/7TDoHyOm5ipv6M0
	 jvtisJ1ZFh/kWJ+vYDNSx/101iBDrPm9t0hw2PzA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eric Biggers <ebiggers@google.com>,
	Anna Schumaker <anna.schumaker@oracle.com>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 098/179] nfs: add missing selections of CONFIG_CRC32
Date: Tue, 29 Apr 2025 18:40:39 +0200
Message-ID: <20250429161053.362420234@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161049.383278312@linuxfoundation.org>
References: <20250429161049.383278312@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 2501e6f1f9655..52853cf5d7dab 100644
--- a/fs/Kconfig
+++ b/fs/Kconfig
@@ -292,6 +292,7 @@ config GRACE_PERIOD
 config LOCKD
 	tristate
 	depends on FILE_LOCKING
+	select CRC32
 	select GRACE_PERIOD
 
 config LOCKD_V4
diff --git a/fs/nfs/Kconfig b/fs/nfs/Kconfig
index e84c187d942e8..1a5bfd42443f9 100644
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
@@ -194,5 +195,4 @@ config NFS_USE_KERNEL_DNS
 config NFS_DEBUG
 	bool
 	depends on NFS_FS && SUNRPC_DEBUG
-	select CRC32
 	default y
diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 5c9166357ae7c..bfb53756654d9 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -720,18 +720,11 @@ u64 nfs_timespec_to_change_attr(const struct timespec *ts)
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
index b996ee23f1bae..8ad99938aae18 100644
--- a/fs/nfs/nfs4session.h
+++ b/fs/nfs/nfs4session.h
@@ -147,16 +147,12 @@ static inline void nfs4_copy_sessionid(struct nfs4_sessionid *dst,
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
index 4d6e71335bce2..45fc2fcb8fe49 100644
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
index 42c168ac6b934..5001c134b8eb6 100644
--- a/fs/nfsd/nfsfh.h
+++ b/fs/nfsd/nfsfh.h
@@ -208,7 +208,6 @@ static inline bool fh_fsid_match(struct knfsd_fh *fh1, struct knfsd_fh *fh2)
 	return true;
 }
 
-#ifdef CONFIG_CRC32
 /**
  * knfsd_fh_hash - calculate the crc32 hash for the filehandle
  * @fh - pointer to filehandle
@@ -220,12 +219,6 @@ static inline u32 knfsd_fh_hash(const struct knfsd_fh *fh)
 {
 	return ~crc32_le(0xFFFFFFFF, (unsigned char *)&fh->fh_base, fh->fh_size);
 }
-#else
-static inline u32 knfsd_fh_hash(const struct knfsd_fh *fh)
-{
-	return 0;
-}
-#endif
 
 #ifdef CONFIG_NFSD_V3
 /*
diff --git a/include/linux/nfs.h b/include/linux/nfs.h
index a8b62a08e784f..5746acd066457 100644
--- a/include/linux/nfs.h
+++ b/include/linux/nfs.h
@@ -54,7 +54,6 @@ enum nfs3_stable_how {
 	NFS_INVALID_STABLE_HOW = -1
 };
 
-#ifdef CONFIG_CRC32
 /**
  * nfs_fhandle_hash - calculate the crc32 hash for the filehandle
  * @fh - pointer to filehandle
@@ -66,10 +65,4 @@ static inline u32 nfs_fhandle_hash(const struct nfs_fh *fh)
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



