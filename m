Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAAAB1A9B46;
	Tue,  9 Dec 2025 00:16:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239403; cv=none; b=VL78H2BMFm6gXDZIxTfs5lQtCmfnTzugb08v6mNV89iQzqsggRFF/gRhDzdhSSICDxVfFgN9roV/LGfcQ2eP0ennuJ6fhU6rUUhwU64utaulaY2BrtL9nY1hQGl5rtmqoO9T8CD5ekLlJfvPF0DQAzPhP/drlgP5HQ/NZAAmlRk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239403; c=relaxed/simple;
	bh=rDKXhX40ReJRbywUnv8rG+cnHN9DentNd7Q3ZfvGmMs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ls2WmzYB4YYE6a/Bfn3nRn0c6H+pRUTT6xrfplOiYYhzGpejuvZlhaZzyHyio4bzeZOIUkG+0Tg7Ehm2vdPfIzyVZeInpn9TYRabSoQda8Fstm75ZF4Wl5C1nyRpH93chFuRW0xNLig6Aq6heIXLB0s1VubtnC6QKLIh+FaZIYE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=atK5l4F5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="atK5l4F5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F8D2C4CEF1;
	Tue,  9 Dec 2025 00:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239402;
	bh=rDKXhX40ReJRbywUnv8rG+cnHN9DentNd7Q3ZfvGmMs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=atK5l4F5LhjX3BcmDzjoNoKV73uyUCV4tyRwbKc/gA9nFtpzCEjjoBkxbrQA3WieP
	 2l81RlDrporZBBwOYRi6pnp8UY77H2qGr+LFUdaAhntgoxcfqgRxyoDVjmpXwuGUNn
	 Ddo0pZaivK1J5+jiLFHIZhARv563vr4WZKJ9AqjafERAekWsCWHpKU3qFpr+n9ZJ7Q
	 +OF0Z1U09Ya6DpQlYO/hRX/gdg89l0d+hDA7ChC5YIbc1rZMMgHQ39wrO8cgyCJXXb
	 hTWGUewOKTUaS5gtosHpXcfkJwlmV0b3fxnqKIkaTPrkqGTl2FvmmlltJHqD9EYxdm
	 mjUfelrR9qKuQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Nirbhay Sharma <nirbhay.lkd@gmail.com>,
	syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.6] fs/ntfs3: fix KMSAN uninit-value in ni_create_attr_list
Date: Mon,  8 Dec 2025 19:14:57 -0500
Message-ID: <20251209001610.611575-5-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251209001610.611575-1-sashal@kernel.org>
References: <20251209001610.611575-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.18
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Nirbhay Sharma <nirbhay.lkd@gmail.com>

[ Upstream commit 5f33da04e6ceee849e76e6592cc283c72fef7af9 ]

The call to kmalloc() to allocate the attribute list buffer is given a
size of al_aligned(rs). This size can be larger than the data
subsequently copied into the buffer, leaving trailing bytes uninitialized.

This can trigger a KMSAN "uninit-value" warning if that memory is
later accessed.

Fix this by using kzalloc() instead, which ensures the entire
allocated buffer is zero-initialized, preventing the warning.

Reported-by: syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=83c9dd5c0dcf6184fdbf
Signed-off-by: Nirbhay Sharma <nirbhay.lkd@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a complete understanding. Let me summarize my analysis:

---

## Detailed Analysis

### 1. COMMIT MESSAGE ANALYSIS

**Subject**: `fs/ntfs3: fix KMSAN uninit-value in ni_create_attr_list`

**Keywords identified**:
- "fix" - clearly a bug fix
- "KMSAN uninit-value" - refers to Kernel Memory Sanitizer detecting
  uninitialized memory access

**Tags present**:
- `Reported-by: syzbot+83c9dd5c0dcf6184fdbf@syzkaller.appspotmail.com` -
  bug was found by automated fuzzer syzkaller
- `Closes: https://syzkaller.appspot.com/bug?extid=83c9dd5c0dcf6184fdbf`
  - links to original bug report
- `Signed-off-by`: Two sign-offs from the author and ntfs3 maintainer

**Missing tags**:
- No `Cc: stable@vger.kernel.org` tag (though this doesn't preclude
  backporting)
- No `Fixes:` tag pointing to the original buggy commit

### 2. CODE CHANGE ANALYSIS

**The Bug**: In `ni_create_attr_list()` at line 770:

```c
le = kmalloc(al_aligned(rs), GFP_NOFS);
```

**Problem mechanism**:
1. `al_aligned(rs)` rounds up `rs` (record_size, typically 1024 or 4096
   bytes) to the nearest 1024-byte boundary: `(size + 1023) & ~1023`
2. The allocated buffer can be larger than the actual data populated
   into it
3. The loop copies attribute list entries into the buffer, and the
   actual used size is computed as `lsize = PtrOffset(ni->attr_list.le,
   le)`
4. The trailing bytes between `lsize` and `al_aligned(rs)` remain
   uninitialized
5. KMSAN detects when these uninitialized bytes are later accessed (even
   for comparison checks)

**The Fix**:
```c
le = kzalloc(al_aligned(rs), GFP_NOFS);
```

This changes to `kzalloc()` which zero-initializes the entire buffer,
eliminating any uninitialized memory concerns.

**Why it works**: Zero-initialization ensures all bytes in the allocated
buffer have known values, preventing KMSAN warnings even if the unused
trailing bytes are accessed during boundary checks or other operations.

### 3. CLASSIFICATION

- **Bug fix**: Yes, this fixes a real bug (KMSAN uninit-value warning)
- **Device ID/quirk**: No
- **Build fix**: No
- **Security**: Not directly a security vulnerability, but uninitialized
  memory issues can sometimes have security implications (information
  disclosure)

### 4. SCOPE AND RISK ASSESSMENT

**Lines changed**: 1 line
**Files touched**: 1 file (`fs/ntfs3/frecord.c`)
**Complexity**: Minimal - simple `kmalloc` → `kzalloc` change

**Subsystem**: NTFS3 filesystem driver
- This is a relatively mature filesystem driver (introduced in v5.15)
- Used for reading/writing NTFS-formatted storage devices

**Risk assessment**: **VERY LOW**
- The change only adds initialization, cannot introduce new bugs
- `kzalloc()` is a standard, well-tested kernel API
- Zero-initialization is always safe - at worst it's slightly slower
  (negligible for this use case)
- No functional changes to the logic

### 5. USER IMPACT

**Who is affected**:
- Any user mounting NTFS filesystems
- Operations that create attribute lists (complex NTFS files with many
  attributes)

**Severity of original bug**:
- KMSAN warnings indicate potential undefined behavior
- While this may not cause crashes in production (KMSAN is typically
  only enabled in test builds), it indicates a code quality issue
- Could potentially cause intermittent data corruption if the
  uninitialized data is ever written to disk (though the code appears to
  bound writes by `attr_list.size`)

**Likelihood**:
- Medium - attribute list creation is a common operation in NTFS
- The bug was found by syzkaller fuzzing, indicating it's triggerable

### 6. STABILITY INDICATORS

- **Reported-by**: syzkaller (automated fuzzer with good track record)
- **Maintainer Sign-off**: Yes, signed off by Konstantin Komarov (NTFS3
  maintainer)
- Commit has been in mainline since v6.18-rc1

### 7. DEPENDENCY CHECK

- **Dependencies**: None - this is a self-contained one-line fix
- **Code exists in stable trees**: Yes, `ni_create_attr_list()` and the
  `kmalloc()` call exist in all stable kernels since v5.15 (when ntfs3
  was introduced)
- **Clean backport**: Should apply cleanly to any kernel 5.15+

### Summary

This commit is an excellent candidate for stable backporting because:

1. **Fixes a real bug**: KMSAN uninit-value warning triggered by
   syzkaller
2. **Minimal and surgical**: Single-line change from `kmalloc` to
   `kzalloc`
3. **Obviously correct**: Zero-initialization is always safe
4. **Zero risk**: Cannot introduce regressions - only adds
   initialization
5. **Reported by automated testing**: syzkaller found this, indicating
   it's triggerable
6. **Maintainer approved**: Signed off by ntfs3 maintainer
7. **Applicable to all stable trees**: The buggy code exists since ntfs3
   was introduced in v5.15
8. **No dependencies**: Completely self-contained fix

The only minor concern is the lack of an explicit `Cc: stable` tag and
`Fixes:` tag, but this is not a hard requirement. The commit clearly
fixes a bug in filesystem code that affects users mounting NTFS drives.

**YES**

 fs/ntfs3/frecord.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/ntfs3/frecord.c b/fs/ntfs3/frecord.c
index 8f9fe1d7a6908..4fe8da7fc0343 100644
--- a/fs/ntfs3/frecord.c
+++ b/fs/ntfs3/frecord.c
@@ -767,7 +767,7 @@ int ni_create_attr_list(struct ntfs_inode *ni)
 	 * Skip estimating exact memory requirement.
 	 * Looks like one record_size is always enough.
 	 */
-	le = kmalloc(al_aligned(rs), GFP_NOFS);
+	le = kzalloc(al_aligned(rs), GFP_NOFS);
 	if (!le)
 		return -ENOMEM;
 
-- 
2.51.0

