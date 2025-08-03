Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E52204592;
	Sun,  3 Aug 2025 21:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256072; cv=none; b=iYNTg3QrRj6+ndb6GbZPggxm8tRV9VIVDoyuzLjPJ1pW5n1yYY7iLpycL9Z0v6XzN82CmGD29TBN5FdOZaX7y517HsgZzz4eMlwl5wkxnVJ0/GMnX33t4fKw53L/E8wDcVBmH0CDtLnY8c4IwqyEU8U9XYhJnmshgLmk6fShIZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256072; c=relaxed/simple;
	bh=MCDw1tFkmmuK7PxLu0ogP8/EZdtaHMb2KGA8IgJQUuU=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HK/DooVps+s7XKRiBEef1BgEqGxIpwMx6dGYvi86b77KtHFT2NzDk/E2DyKaXLq2bADrX2S1BtVT+vPR3EAHYtgc1lbZkkTSPQWk0Hhim/WFCYPKJVSh2jaGan6zfE+mwYWyG1MRFuGYOO+3gRoBJCFCKyjMBVVhYuD8oU1lH2s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fde1G272; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fde1G272"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C436DC4CEEB;
	Sun,  3 Aug 2025 21:21:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256072;
	bh=MCDw1tFkmmuK7PxLu0ogP8/EZdtaHMb2KGA8IgJQUuU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fde1G272GJ6xOAZ8gd6hB4v2Vn0IxpnBMd5R6O54IkV5OJ2sBfOs1yHZIn/t/k74C
	 udTi5zk0n2DFgjSnl/rrsYNpJW91GtZdDQyRU+Gv5nvSMx1LDSJMjN/UrOZR5ZlMcq
	 QTud1jal2kJmrrHyaOx7xlb50bn3pBqn1glBMv9KuXqN5DKvnauZPBcHy82sqlZRpk
	 2yP5iTzj8wPO3QwEyOM4ZhgVPp3mjnXgFzrA7kZvki4Oh8xEI/yd8od5v20aaSRZie
	 Yj/BskCt6H3TPW+AWn7fGihC5nQoWNQBXfpGbYiNJUTsdtDbrU1VU0GpKIqlmDLbH3
	 EvzYlmHHBCZEA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Xu <lizhi.xu@windriver.com>,
	syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.6 17/23] fs/ntfs3: Add sanity check for file name
Date: Sun,  3 Aug 2025 17:20:24 -0400
Message-Id: <20250803212031.3547641-17-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212031.3547641-1-sashal@kernel.org>
References: <20250803212031.3547641-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.101
Content-Transfer-Encoding: 8bit

From: Lizhi Xu <lizhi.xu@windriver.com>

[ Upstream commit e841ecb139339602bc1853f5f09daa5d1ea920a2 ]

The length of the file name should be smaller than the directory entry size.

Reported-by: syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=598057afa0f49e62bd23
Signed-off-by: Lizhi Xu <lizhi.xu@windriver.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Looking at the code context and the patch, I can now provide my
analysis.

**Backport Status: YES**

This commit should be backported to stable kernel trees. Here's my
extensive analysis:

## Security Impact Analysis

The commit adds a critical bounds check that prevents a potential out-
of-bounds read vulnerability in the NTFS3 filesystem driver. The
vulnerability occurs in the `ntfs_dir_emit()` function at
fs/ntfs3/dir.c:307-308.

## Technical Details of the Fix

The patch adds this sanity check:
```c
if (fname->name_len + sizeof(struct NTFS_DE) > le16_to_cpu(e->size))
    return true;
```

This check validates that the file name length doesn't exceed the
directory entry size before attempting to read the file name data.
Without this check, the code at line 307-308:
```c
name_len = ntfs_utf16_to_nls(sbi, fname->name, fname->name_len, name,
PATH_MAX);
```

Could read beyond the allocated memory for the directory entry if a
malformed NTFS filesystem contains a `fname->name_len` value that
extends past the actual directory entry boundary.

## Why This Should Be Backported

1. **Security Fix**: This fixes a syzbot-reported security vulnerability
   that could lead to out-of-bounds memory reads, potentially exposing
   kernel memory contents or causing crashes.

2. **Small and Contained**: The fix is just 2 lines of code - a simple
   bounds check that returns early if the condition is violated. This
   minimizes the risk of introducing regressions.

3. **Clear Bug Fix**: This is not a feature addition or architectural
   change - it's a straightforward security hardening fix that adds
   missing input validation.

4. **Filesystem Data Validation**: The fix validates untrusted
   filesystem data, which is critical since malformed filesystem images
   could be mounted by unprivileged users in some configurations.

5. **No Side Effects**: The fix simply causes the code to skip malformed
   directory entries rather than processing them, which is the safe and
   expected behavior.

6. **Follows Stable Rules**: This meets the stable kernel criteria:
   - Fixes a real bug (out-of-bounds read)
   - Small change (2 lines)
   - Obviously correct (simple bounds check)
   - Already tested (reported and fixed via syzbot)

The commit follows a pattern of similar NTFS3 sanity checks that have
been backported, as shown by the git log search revealing multiple
validation fixes like "Validate buffer length while parsing index",
"Validate data run offset", etc.

 fs/ntfs3/dir.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/ntfs3/dir.c b/fs/ntfs3/dir.c
index e1b856ecce61..6b93c909bdc9 100644
--- a/fs/ntfs3/dir.c
+++ b/fs/ntfs3/dir.c
@@ -304,6 +304,9 @@ static inline bool ntfs_dir_emit(struct ntfs_sb_info *sbi,
 	if (sbi->options->nohidden && (fname->dup.fa & FILE_ATTRIBUTE_HIDDEN))
 		return true;
 
+	if (fname->name_len + sizeof(struct NTFS_DE) > le16_to_cpu(e->size))
+		return true;
+
 	name_len = ntfs_utf16_to_nls(sbi, fname->name, fname->name_len, name,
 				     PATH_MAX);
 	if (name_len <= 0) {
-- 
2.39.5

