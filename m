Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942282FABE7;
	Sat,  6 Dec 2025 14:02:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765029778; cv=none; b=n/2S+4v3NLwnGhi3vpM6d7REKn1ZmlZ44Z8YiPJWr5EGFcFL/cN37gKfJmHAmuaSu99kNV1MmbIXGmcrhWIiSYQHSp2SxUnJzZJG3Xt7YFRTbUbx4a7sbeREENtxOtwy2VhhnUc4irGtu8Qewi0TMIY4mrOQjNaUf7+QQ7knOE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765029778; c=relaxed/simple;
	bh=cHLGrinxjH0Mob8lQc7FeiUHYQJExk2+7wmYKJZ8SNM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OUoIpbm/s0F5im3OcQ48QDiQcV3qRr8J2OkJ/o/ctWxPO2wxjESKlUeYoaC3FBFZybmN0/nAMc79DeowWvq9eNcD77Jwe2HReNzMbKylqlS70k6n1RLqK5oDnyYpJptno8QBSv9RzERKPUDzv/5HSsGTEPx9KF3jrc42fh4y7h4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OCRPwW+T; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OCRPwW+T"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D818C116D0;
	Sat,  6 Dec 2025 14:02:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765029778;
	bh=cHLGrinxjH0Mob8lQc7FeiUHYQJExk2+7wmYKJZ8SNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OCRPwW+TpRdcDdJ2tsQEbqgpyCualVAbPlLDjnd4/H2IM4ZxzwXgRVFqM3CaS+JKB
	 Eo+IL7lAYNAu2sMNsm7l7TkCiH/QijRi4f0lDcZIVH/bDRtuRmlOcqySRZmRSNpjPP
	 u7z3tyFuu6X6YWxpA7xLLVMvkY+U0CjT20b2yJFD27n1LZcVn1SV4xNDjx17Li+4m9
	 v4A0gPFFtB4olTU1Nc/myvLyHWhZ1pJ5xIpSr/kcv4mm94fnCFYtszSkEcdzGLw5XO
	 6vIp/iAoIqd8PAkYYookveT29cEMJviMfaHHdYgGyMMIasWCHFAihf9gLSWmU/M8WL
	 uvEpBGSOJuVFg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.12] fs/ntfs3: check for shutdown in fsync
Date: Sat,  6 Dec 2025 09:02:07 -0500
Message-ID: <20251206140252.645973-2-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251206140252.645973-1-sashal@kernel.org>
References: <20251206140252.645973-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Transfer-Encoding: 8bit

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit 1b2ae190ea43bebb8c73d21f076addc8a8c71849 ]

Ensure fsync() returns -EIO when the ntfs3 filesystem is in forced
shutdown, instead of silently succeeding via generic_file_fsync().

Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis Summary

### What the commit does:
Adds a new wrapper function `ntfs_file_fsync()` that checks if the ntfs3
filesystem is in forced shutdown state before calling
`generic_file_fsync()`. If the filesystem is shutting down, it returns
`-EIO` instead of silently succeeding.

### Technical mechanism:
The fix is straightforward:
1. Get the inode from the file
2. Call `ntfs3_forced_shutdown(inode->i_sb)` to check if filesystem is
   in error state
3. Return `-EIO` if true, otherwise delegate to `generic_file_fsync()`

### Is this a real bug fix?
**Yes** - this fixes a data integrity semantics issue. When a filesystem
is in forced shutdown (typically after critical I/O errors), fsync()
should return an error to inform applications their data was not synced.
Silently succeeding could cause data loss without applications knowing.

### Stable kernel criteria evaluation:

| Criteria | Assessment |
|----------|------------|
| Fixes real bug | Yes - data integrity semantics issue |
| Small/contained | Yes - ~10 lines, single function |
| Obviously correct | Yes - follows existing pattern in ntfs3 |
| Stable tag | **NO** - maintainer didn't request stable |
| Fixes: tag | **NO** - no indication of when bug was introduced |

### Critical dependency issue:
The `ntfs3_forced_shutdown()` function was introduced in **kernel 6.8**
(commit 6c3684e703837). My verification shows:
- **v6.6**: Does NOT have `ntfs3_forced_shutdown` (0 occurrences)
- **v6.8+**: Has the shutdown infrastructure

This means:
- Stable trees **6.6.y**, **6.1.y**, **5.15.y**, etc. cannot use this
  fix without first backporting the entire shutdown feature (~75 lines
  across 7 files)
- Only newer stable trees (if any exist based on 6.8+) would benefit

### Risk vs Benefit:
- **Benefit**: Correct fsync() error handling during filesystem shutdown
- **Risk**: Low for applicable kernels - simple logic, well-tested
  pattern
- **Applicability**: Very limited - only affects recent kernels with
  shutdown support

### Conclusion:
While this is a legitimate fix for a data integrity issue, several
factors argue against backporting:

1. **No maintainer request**: No "Cc: stable@vger.kernel.org" tag
   indicates the maintainer didn't consider this critical for stable
2. **Dependency on new feature**: Requires the shutdown infrastructure
   from 6.8, which is not in most active stable trees (6.6.y, 6.1.y,
   5.15.y)
3. **Limited impact scope**: Only applies to the relatively recent
   kernel versions that have the shutdown feature
4. **The shutdown feature itself is new**: The forced shutdown
   functionality only existed for a short time before this fix, meaning
   the exposure window is small

This fix would require significant infrastructure backporting to be
useful in most stable trees, making it unsuitable as-is for stable
backporting.

**NO**

 fs/ntfs3/file.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/file.c b/fs/ntfs3/file.c
index 4c90ec2fa2eae..83f0072f0896c 100644
--- a/fs/ntfs3/file.c
+++ b/fs/ntfs3/file.c
@@ -1375,6 +1375,18 @@ static ssize_t ntfs_file_splice_write(struct pipe_inode_info *pipe,
 	return iter_file_splice_write(pipe, file, ppos, len, flags);
 }
 
+/*
+ * ntfs_file_fsync - file_operations::fsync
+ */
+static int ntfs_file_fsync(struct file *file, loff_t start, loff_t end, int datasync)
+{
+	struct inode *inode = file_inode(file);
+	if (unlikely(ntfs3_forced_shutdown(inode->i_sb)))
+		return -EIO;
+
+	return generic_file_fsync(file, start, end, datasync);
+}
+
 // clang-format off
 const struct inode_operations ntfs_file_inode_operations = {
 	.getattr	= ntfs_getattr,
@@ -1397,7 +1409,7 @@ const struct file_operations ntfs_file_operations = {
 	.splice_write	= ntfs_file_splice_write,
 	.mmap_prepare	= ntfs_file_mmap_prepare,
 	.open		= ntfs_file_open,
-	.fsync		= generic_file_fsync,
+	.fsync		= ntfs_file_fsync,
 	.fallocate	= ntfs_fallocate,
 	.release	= ntfs_file_release,
 };
-- 
2.51.0

