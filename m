Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C162CCC0;
	Sun,  3 Aug 2025 21:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754256155; cv=none; b=TNQs/SpJ5CNfMlb7uTvQo+5v65VYNlhpl1B69VU9XcSVwcJVMd143TAjGF156fkV2o4c6CRRoz5nLzw+erL/xLoBY2Ve0k8oXNKwVsYL7/ZOC5hd+na8X65Q99AzHLYD5pzszEdnpoNYkZI1VH/cbXwJWTznzlq6ORgXXJaEd4Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754256155; c=relaxed/simple;
	bh=6qTtMk/WPHori2c/WkAz9AzRa8r1GGuo+omtanBgrr8=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=RZmsZMH0dRs3wgAiwxMZyUa/iNZS0F6EO2PWvuWhN7mZ/IVgnFS3BYSg/3wmqPPN3U/r3sE105kJTltDKAB5S1LFuXxTPkhcP8x/VOkvMkaaJ+K7yBFRNQLjgD6JESW+o2jBS5oTSpu6MvxKwNGMME6mp1NrVsH49VvPfBt55bw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eZi4slrc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eZi4slrc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8EB2CC4CEF0;
	Sun,  3 Aug 2025 21:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754256155;
	bh=6qTtMk/WPHori2c/WkAz9AzRa8r1GGuo+omtanBgrr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eZi4slrcLn0yBkphB1NA6ZisqG54xQ0ZdgCZjYC7lDaSslCLfi6VnGvuSxRDEOLD2
	 IZu5ojMJPntwy+ruEmCRVCh//8M0bfxksuA6bQsEj27CCAjLcAyCdeI6xDQLPDOd+J
	 jpwcqIl4fPKL0je/iMxxnHYdcE9vb7VLnj1N8M7fbEC/RlREEwJjGzWSuYAcorwsiU
	 JsfrrygZyYeJa3tW0MiHTxqiFnAzqtlsWvVl6YSQTz7wU4rC8Jy+62Pa3r2X0Ve+wO
	 ezITvM6jX/6Dho4mVDqxsD7/deZcL7Mxt7LrE0LLmAjueQKUayOfxB/u5Y8y03rLf3
	 QIurQlRU0Jaxg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Lizhi Xu <lizhi.xu@windriver.com>,
	syzbot+598057afa0f49e62bd23@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 5.15 12/15] fs/ntfs3: Add sanity check for file name
Date: Sun,  3 Aug 2025 17:22:02 -0400
Message-Id: <20250803212206.3548990-12-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250803212206.3548990-1-sashal@kernel.org>
References: <20250803212206.3548990-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.189
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
index a4ab0164d150..c49e64ebbd0a 100644
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

