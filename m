Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1265B248878;
	Tue, 29 Apr 2025 17:15:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745946954; cv=none; b=MRURzJy+539L7BSNLGK59KZlpGEjOh7fCH8aEsnhJxLOlQNILG9qFQyY56oWFfmVD/OGlV2hOV2m4nwvnEXdB0T/aJ4+UpSQ23dH1OxPv+qYE1ok3dr5gACEsVNUchEE7t1ymO68PXUKNmTiLohEN15T08VzEHv6yaop+5S77/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745946954; c=relaxed/simple;
	bh=/BR4imJ0yZHN/QzR6UXOFWA9ZZFR3/hw7Z08lsJoK2M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FRYEX6YeFZBvghq9Y36X3iKcquQSLJyawLDZJNhHLRjq09JbJCw9Ro8mawozpF+EPfZqyAAFqJ0u13gaiDxnKRQf+rkaz/Z6MZIGnQ4w/GGQAwDF3TIba0QBDiH7RJUyIQ8yCj11wYztVErQuajNCd8yFuuVjziGkfkba/Ca54w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=m/6xoUOL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="m/6xoUOL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91DF8C4CEE3;
	Tue, 29 Apr 2025 17:15:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745946954;
	bh=/BR4imJ0yZHN/QzR6UXOFWA9ZZFR3/hw7Z08lsJoK2M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=m/6xoUOLMFII2dT2a9HcG57qRvXREAN38bXIPxlCUPq0ryooXnxMyFzrqDOD6iHMb
	 uPFk4GszwRlHMC0jtzowfURIaM5Yqe7sgLXq3gFBcOqtFYQDJsxPCCPv3zPbB5qvei
	 6qU0/7fA2G2mrwEtle/MX1wmam3sIv6aHXYLMXI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 123/286] nfs: move nfs_fhandle_hash to common include file
Date: Tue, 29 Apr 2025 18:40:27 +0200
Message-ID: <20250429161112.914965431@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250429161107.848008295@linuxfoundation.org>
References: <20250429161107.848008295@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 394a82d470d55..05e807a0ba225 100644
--- a/fs/nfs/internal.h
+++ b/fs/nfs/internal.h
@@ -776,27 +776,12 @@ u64 nfs_timespec_to_change_attr(const struct timespec64 *ts)
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



