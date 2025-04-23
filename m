Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9EE728DEE8;
	Wed, 23 Apr 2025 15:25:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421944; cv=none; b=Z3GpR9dpDQ3i1lXEPSU1VlyDMEK3PTYu9ZwcSbYlNB7H7hFLD7rrUuHb3010zrHalUnqDfK3r3BJGliZBrJSSp2YR+b/fRNagiODx61KLkLnJbTFZUInKMtFgkeeRR500ghXkmt5/8KDM5yCubTjyAuuToWw6br/6L7isKvkXqE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421944; c=relaxed/simple;
	bh=IQvhQghjGW1Qm08KQlqtcwpc3oG75fjiO+/niCGB9p4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SF2sh5yPaLRilFSrA4Dt/HJh0cP2uaKWRKGDI41C8BcI+4ifj5q1GExTQX6t7a0HoHkXkxfXzEqI82vQgt1zxoiU5mzMcHf0OP3U91TZth6Yn7ECwXgW47/r43saytIiYk1Fe0+4SUG9ouTRNDBgi4Y81JIWOAA+0S25S0SjsNk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afuukwiT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afuukwiT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A611C4CEE3;
	Wed, 23 Apr 2025 15:25:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421944;
	bh=IQvhQghjGW1Qm08KQlqtcwpc3oG75fjiO+/niCGB9p4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afuukwiTFFKcAg+R2nl0Yl889rf7xYKOK7EI+rlovPUNoI18tXR0RMl5HYcdvFbYX
	 PqRDMvtLLnxSCav/0YzcvWJSECUH4epQoaH8D6DVASOqZCFYcGi30wOqsoGzojeyIL
	 VaFdiiDfzgOl/FKccQcg6KwP0lTtZcoamUVJCbvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 203/291] nfs: move nfs_fhandle_hash to common include file
Date: Wed, 23 Apr 2025 16:43:12 +0200
Message-ID: <20250423142632.672922156@linuxfoundation.org>
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

From: Jeff Layton <jlayton@kernel.org>

[ Upstream commit e59fb6749ed833deee5b3cfd7e89925296d41f49 ]

lockd needs to be able to hash filehandles for tracepoints. Move the
nfs_fhandle_hash() helper to a common nfs include file.

Signed-off-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Stable-dep-of: cd35b6cb4664 ("nfs: add missing selections of CONFIG_CRC32")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/internal.h   | 15 ---------------
 include/linux/nfs.h | 20 ++++++++++++++++++++
 2 files changed, 20 insertions(+), 15 deletions(-)

diff --git a/fs/nfs/internal.h b/fs/nfs/internal.h
index 7fa23a6368e0b..d511d66bd8a3a 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -827,27 +827,12 @@ u64 nfs_timespec_to_change_attr(const struct timespec64 *ts)
 }
 
 #ifdef CONFIG_CRC32
-/**
- * nfs_fhandle_hash - calculate the crc32 hash for the filehandle
- * @fh - pointer to filehandle
- *
- * returns a crc32 hash for the filehandle that is compatible with
- * the one displayed by "wireshark".
- */
-static inline u32 nfs_fhandle_hash(const struct nfs_fh *fh)
-{
-	return ~crc32_le(0xFFFFFFFF, &fh->data[0], fh->size);
-}
 static inline u32 nfs_stateid_hash(const nfs4_stateid *stateid)
 {
 	return ~crc32_le(0xFFFFFFFF, &stateid->other[0],
 				NFS4_STATEID_OTHER_SIZE);
 }
 #else
-static inline u32 nfs_fhandle_hash(const struct nfs_fh *fh)
-{
-	return 0;
-}
 static inline u32 nfs_stateid_hash(nfs4_stateid *stateid)
 {
 	return 0;
diff --git a/include/linux/nfs.h b/include/linux/nfs.h
index b06375e88e589..ceb70a926b95e 100644
--- a/include/linux/nfs.h
+++ b/include/linux/nfs.h
@@ -10,6 +10,7 @@
 
 #include <linux/sunrpc/msg_prot.h>
 #include <linux/string.h>
+#include <linux/crc32.h>
 #include <uapi/linux/nfs.h>
 
 /*
@@ -44,4 +45,23 @@ enum nfs3_stable_how {
 	/* used by direct.c to mark verf as invalid */
 	NFS_INVALID_STABLE_HOW = -1
 };
+
+#ifdef CONFIG_CRC32
+/**
+ * nfs_fhandle_hash - calculate the crc32 hash for the filehandle
+ * @fh - pointer to filehandle
+ *
+ * returns a crc32 hash for the filehandle that is compatible with
+ * the one displayed by "wireshark".
+ */
+static inline u32 nfs_fhandle_hash(const struct nfs_fh *fh)
+{
+	return ~crc32_le(0xFFFFFFFF, &fh->data[0], fh->size);
+}
+#else /* CONFIG_CRC32 */
+static inline u32 nfs_fhandle_hash(const struct nfs_fh *fh)
+{
+	return 0;
+}
+#endif /* CONFIG_CRC32 */
 #endif /* _LINUX_NFS_H */
-- 
2.39.5



