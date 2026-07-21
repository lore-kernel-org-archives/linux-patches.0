Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 826B2379C48;
	Tue, 21 Jul 2026 15:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784649560; cv=none; b=qMgsFS1hSF+SILuepqF2fc06wAt3z7R6BNKSA1tP6Z5+EPWg/ZVstjkk88/h5nCPqadT4TWHEdA9vh8eTPGgJUMwA+HHpTFYlWij9pzLg2boPqqNdYRgCV4eJyRa9/B1NnGPu88551/fcY4la1SlsdPLr2CAMfPykO/UzOfsXtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784649560; c=relaxed/simple;
	bh=zhViAOcGpGdnJQpyF8ioJLdotYO7k5zWsdsVb7VY9eI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dDMJ1zezDKZodYVjzJIo4sOBZPwMLNm0/jFvbZ9ih7DNIf9BhKXqSfXdRZ0RH24/I0w7OAIocs0QSJ5HuqdszvEbmbu2gQHJXhw7dDhj3Vtrz3UH6cH3WoDILZAuPMsCGxbU6cNlCYVBx+4ZXxG6rAQsYLVNkjxIHHcljTrhwEg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FYEZ22AI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FYEZ22AI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B48621F000E9;
	Tue, 21 Jul 2026 15:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784649559;
	bh=ZMBZDXghDI+K/XWaPtEds86bghzApyO6YGw12gQSO90=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FYEZ22AI3npKU82DDNyrSUeJRrCiHgQbwXhGQWwS4r/ym3fyklpG/KGGVXYcRZ2cx
	 U5EW2QXu9vbJib80D2aP7KgdwKxHV9mtz/8yy/bfABznK098TnRW64G3FgFCRda89k
	 RDGn5abtiw4UTM+p2RXg4bVtPxTXuuogClQWsOHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0623/2077] lockd: Avoid hashing uninitialized bytes in nlm4svc_lookup_file()
Date: Tue, 21 Jul 2026 17:04:56 +0200
Message-ID: <20260721152607.499559616@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 6e4c62caecf792e8a15ad9bc7f371e57c17e3302 ]

file_hash() digests the first LOCKD_FH_HASH_SIZE bytes of
nfs_fh.data when bucketing nlm_files[], independent of fh.size.
Commit 3de744ee4e45 ("lockd: Use xdrgen XDR functions for the
NLMv4 TEST procedure") set .pc_argzero to zero for the converted
procedures and moved file-handle population into
nlm4svc_lookup_file(), which copies only xdr_lock->fh.len bytes
into lock->fh.data.

When an NLMv4 client presents a file handle shorter than
LOCKD_FH_HASH_SIZE, bytes fh.len..31 retain whatever the argument
buffer held from an earlier request.  The same wire handle then
hashes to different buckets across calls; nlm_lookup_file() misses
the existing nlm_file entry, and lock-state lookups fail.

Zero only the tail bytes that file_hash() would otherwise consume.
Handles of LOCKD_FH_HASH_SIZE or larger already populate every byte
that file_hash() reads.

Reported-by: Jeff Layton <jlayton@kernel.org>
Closes: https://lore.kernel.org/r/5229a9746d723a3f830120c0b966510f75badfc2.camel@kernel.org
Fixes: 3de744ee4e45 ("lockd: Use xdrgen XDR functions for the NLMv4 TEST procedure")
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/lockd/lockd.h    | 8 ++++++++
 fs/lockd/svc4proc.c | 3 +++
 fs/lockd/svcsubs.c  | 3 +--
 3 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/fs/lockd/lockd.h b/fs/lockd/lockd.h
index 1db6cb3525425d..9aa6acb43f9a4d 100644
--- a/fs/lockd/lockd.h
+++ b/fs/lockd/lockd.h
@@ -52,6 +52,14 @@
  */
 #define LOCKD_DFLT_TIMEO	10
 
+/*
+ * Number of leading bytes of nfs_fh.data that file_hash()
+ * digests when bucketing nlm_files[]. Sized for historical
+ * NFSv2 handles; nfs_fh.data must be initialized at least
+ * this far before lookup, regardless of fh.size.
+ */
+#define LOCKD_FH_HASH_SIZE	32
+
 /* error codes new to NLMv4 */
 #define	nlm4_deadlock		cpu_to_be32(NLM_DEADLCK)
 #define	nlm4_rofs		cpu_to_be32(NLM_ROFS)
diff --git a/fs/lockd/svc4proc.c b/fs/lockd/svc4proc.c
index ca1d165e0d8606..3bf6cccae56858 100644
--- a/fs/lockd/svc4proc.c
+++ b/fs/lockd/svc4proc.c
@@ -157,6 +157,9 @@ nlm4svc_lookup_file(struct svc_rqst *rqstp, struct nlm_host *host,
 		return nlm_lck_denied_nolocks;
 	lock->fh.size = xdr_lock->fh.len;
 	memcpy(lock->fh.data, xdr_lock->fh.data, xdr_lock->fh.len);
+	if (xdr_lock->fh.len < LOCKD_FH_HASH_SIZE)
+		memset(lock->fh.data + xdr_lock->fh.len, 0,
+		       LOCKD_FH_HASH_SIZE - xdr_lock->fh.len);
 
 	lock->oh.len = xdr_lock->oh.len;
 	lock->oh.data = xdr_lock->oh.data;
diff --git a/fs/lockd/svcsubs.c b/fs/lockd/svcsubs.c
index 9da9d6e0b42e25..95a499940daf2f 100644
--- a/fs/lockd/svcsubs.c
+++ b/fs/lockd/svcsubs.c
@@ -17,7 +17,6 @@
 #include <linux/sunrpc/addr.h>
 #include <linux/module.h>
 #include <linux/mount.h>
-#include <uapi/linux/nfs2.h>
 
 #include "lockd.h"
 #include "share.h"
@@ -67,7 +66,7 @@ static inline unsigned int file_hash(struct nfs_fh *f)
 {
 	unsigned int tmp=0;
 	int i;
-	for (i=0; i<NFS2_FHSIZE;i++)
+	for (i = 0; i < LOCKD_FH_HASH_SIZE; i++)
 		tmp += f->data[i];
 	return tmp & (FILE_NRHASH - 1);
 }
-- 
2.53.0



