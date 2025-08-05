Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A067276056;
	Tue,  5 Aug 2025 13:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754399438; cv=none; b=uhlRNReoD0N6UFTzE4/FgvWfzu6x4cWMPYYuF9SvnMmIzG84oIfxxemvAbRxrKMzL0Y9EUJCDLPm9gYZwHMMpbc3pkwQyNvrQXqNip1p8T4yqHmBLnP+n3vRwZHEDC0f17svnV4IG6H/fpnx/E0vXnwAAdSyKZQLCVEmurKvjKA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754399438; c=relaxed/simple;
	bh=z7LNaQ4tyu216+74LWSLJMCyamCBabku8nxlOeWGwdQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=fNnW0UhxP1AacXmjW0gVrzicslX3JBYA8RDD6NuVvLf6j7mZYXf56af7NIJfXElEMj8eNmWccr9GE4g6W5bfza1w7NgA2OTsSONgvLkIHTmJDv2fVKjcsluDpfVbAJBlDVZRIAIMHarbqOg3jGA/EfLvPR7LJkZHSZk6RGKqxLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=PDzG3Zc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="PDzG3Zc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43DF8C4CEF4;
	Tue,  5 Aug 2025 13:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1754399438;
	bh=z7LNaQ4tyu216+74LWSLJMCyamCBabku8nxlOeWGwdQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PDzG3Zc1C11ZY1BIV0xQJ96T9Bxl0KL13XlE8r/nBub5kvkCVaqZOFVna6Kxns2OF
	 nWqTaQiMlq7JcoKk62hIpktlNairDppcDA6LL3igDUEmV3L3uv6ytuEVVm0zgDn6/5
	 OysAkuUG60Q6CIc57GCRxlXQZRp0Ub3t7fOYw4eTCrwbqCRRpnCjOYwKbhIfb1vjYc
	 FfqJt9yep1+t8Zsx/06MAu0BvejqMFrpGYDJ47C3tRgwahVZw7cIwLp8C7d/p0t/AZ
	 0rdqKD6Sl9qVVlkMxj8uvtGZ2qM7Lj94N8fZZ9X86nmdKWzRoer0ntQBpAZ9sPp4iZ
	 ZsFx4Tkm5wyxQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>,
	Mike Marshall <hubcap@omnibond.com>,
	Sasha Levin <sashal@kernel.org>,
	devel@lists.orangefs.org
Subject: [PATCH AUTOSEL 6.16-5.4] fs/orangefs: use snprintf() instead of sprintf()
Date: Tue,  5 Aug 2025 09:08:58 -0400
Message-Id: <20250805130945.471732-23-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250805130945.471732-1-sashal@kernel.org>
References: <20250805130945.471732-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.16
Content-Transfer-Encoding: 8bit

From: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>

[ Upstream commit cdfa1304657d6f23be8fd2bb0516380a3c89034e ]

sprintf() is discouraged for use with bounded destination buffers
as it does not prevent buffer overflows when the formatted output
exceeds the destination buffer size. snprintf() is a safer
alternative as it limits the number of bytes written and ensures
NUL-termination.

Replace sprintf() with snprintf() for copying the debug string
into a temporary buffer, using ORANGEFS_MAX_DEBUG_STRING_LEN as
the maximum size to ensure safe formatting and prevent memory
corruption in edge cases.

EDIT: After this patch sat on linux-next for a few days, Dan
Carpenter saw it and suggested that I use scnprintf instead of
snprintf. I made the change and retested.

Signed-off-by: Amir Mohammad Jahangirzad <a.jahangirzad@gmail.com>
Signed-off-by: Mike Marshall <hubcap@omnibond.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Based on my analysis, I can now provide a determination on whether this
commit should be backported.

**Backport Status: YES**

## Extensive Explanation:

This commit should be backported to stable kernel trees for the
following reasons:

### 1. **Security Fix for Potential Buffer Overflow**
The code change addresses a classic buffer overflow vulnerability in
`/home/sasha/linux/fs/orangefs/orangefs-debugfs.c:357`. The original
code uses `sprintf()` to copy data from `file->private_data` into a
heap-allocated buffer of fixed size (`ORANGEFS_MAX_DEBUG_STRING_LEN` =
2048 bytes). The problematic line:
```c
sprintf_ret = sprintf(buf, "%s", (char *)file->private_data);
```

### 2. **Real Security Impact**
- The `file->private_data` is set to `inode->i_private` in
  `orangefs_debug_open()` (line 331)
- This points to either `k_buffer` or `c_buffer` which are static
  buffers defined with `ORANGEFS_MAX_DEBUG_STRING_LEN`
- While these buffers are also bounded to the same size, using
  `sprintf()` without bounds checking is inherently unsafe as it trusts
  that the source data is properly null-terminated and within expected
  bounds
- If the source buffer gets corrupted or manipulated (e.g., through
  other vulnerabilities), `sprintf()` could write beyond the allocated
  buffer

### 3. **Recent History of Similar Issues**
The git history shows a very recent OOB (out-of-bounds) fix in the same
file (commit `2b84a231910c` - "orangefs: fix a oob in
orangefs_debug_write") that was already backported to stable. This
indicates:
- The OrangeFS debugfs code has had boundary checking issues
- Security researchers (syzbot) are actively finding issues in this
  subsystem
- The maintainers are actively fixing security issues

### 4. **Simple and Contained Fix**
The change is minimal and low-risk:
- Single line change from `sprintf()` to `scnprintf()`
- The fix is contained to one function in the debugfs interface
- No architectural changes or new features added
- The `scnprintf()` function guarantees null-termination and prevents
  buffer overflow by limiting writes to the specified size

### 5. **Follows Stable Tree Rules**
- **Important bugfix**: Prevents potential memory corruption/security
  vulnerability
- **Minimal risk**: Simple function substitution with well-understood
  semantics
- **Small change**: Single line modification
- **No new features**: Pure safety improvement
- **Confined to subsystem**: Only affects OrangeFS debugfs interface

### 6. **Best Practice Security Hardening**
The commit message explicitly states this is a security hardening
measure following modern kernel coding standards. The kernel community
has been systematically replacing unsafe string functions (`sprintf`,
`strcpy`, etc.) with their bounded equivalents (`snprintf`/`scnprintf`,
`strncpy`, etc.) to eliminate entire classes of vulnerabilities.

### 7. **Evolution from snprintf to scnprintf**
The commit message notes that after review, the patch was updated from
`snprintf()` to `scnprintf()`. This is important because `scnprintf()`
returns the actual number of bytes written (excluding the terminating
null), while `snprintf()` returns the number of bytes that would have
been written if there was enough space. This makes `scnprintf()` the
correct choice for the subsequent `simple_read_from_buffer()` call which
needs the actual written length.

This commit represents a proactive security hardening that eliminates a
potential attack vector in the OrangeFS filesystem debugfs interface,
making it an excellent candidate for stable backporting.

 fs/orangefs/orangefs-debugfs.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/orangefs/orangefs-debugfs.c b/fs/orangefs/orangefs-debugfs.c
index f7095c91660c..e463d3c73533 100644
--- a/fs/orangefs/orangefs-debugfs.c
+++ b/fs/orangefs/orangefs-debugfs.c
@@ -396,7 +396,7 @@ static ssize_t orangefs_debug_read(struct file *file,
 		goto out;
 
 	mutex_lock(&orangefs_debug_lock);
-	sprintf_ret = sprintf(buf, "%s", (char *)file->private_data);
+	sprintf_ret = scnprintf(buf, ORANGEFS_MAX_DEBUG_STRING_LEN, "%s", (char *)file->private_data);
 	mutex_unlock(&orangefs_debug_lock);
 
 	read_ret = simple_read_from_buffer(ubuf, count, ppos, buf, sprintf_ret);
-- 
2.39.5

