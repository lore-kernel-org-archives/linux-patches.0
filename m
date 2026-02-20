Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC570344025;
	Fri, 20 Feb 2026 12:38:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591093; cv=none; b=XBad5nv0FBQP7PPnqKquJi2Y4SX4nMbdFpQKWUHp4hKk4v1GRjLf6gwIENDTvXd8TKsNUB03J8zEd6MJsJ64xVGIigIuMpAWjOKe5NepEQCb/jbiy/kj2di1zwV/IJR4XykzyPlEpZAt7yY+t7N0b/pmKL/i1w1skov1lqu0DNw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591093; c=relaxed/simple;
	bh=JCQIO+38b7kX1zydRreP6mW2WWXVI7BBpn3fdnoMbuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NTZ77KACos50dyyHK0v6E3iAfjYF8lG8pVQW+SbJXOfC5duZzwCLGfFLWTObSi/g5Ymj/Pg7VuEiHXFrJDAHz66+pW9MeWJ6TICsp5HDf3idCzbbcFiAXPooUrGCH2fUvt1Yt+TrerMGgWq3Dhk9oAP6D5pOg3IRQzEN6qfMZuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ikNDpmg/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ikNDpmg/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C13D2C2BC9E;
	Fri, 20 Feb 2026 12:38:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771591092;
	bh=JCQIO+38b7kX1zydRreP6mW2WWXVI7BBpn3fdnoMbuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ikNDpmg/gq/YNDltyErzZHefhMs3k2HAnKrel3Oouz2tcqPpqzCwG8VuP6wG80mWa
	 V4qlcmf58QO5WyLN2t+Oy5Zz4jzbxkxLeE4qhqrNwBi9Kv8YuGh4XB5/lz7KkRSJ0n
	 p/+nVf+owsuhCeEPxyemV8HfkQ5T/4G08gboSC7bAkVDCdju1/ulRYEfiVVqCiiV1E
	 Raceb8YO4TMEQEvwqh0mx/FdbhcTUpgDQg3UDwxc/PTWVwfhaGiNNH45GB7O0TCRkk
	 bUQsM4Sfv9BT2WioAnKBOcSRQt6YaHHJzOGcvJAucKVNbJBR1m8n3PH3n5FyTHgU+6
	 9ygYMtjAQz16Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jaehun Gou <p22gone@gmail.com>,
	Seunghun Han <kkamagui@gmail.com>,
	Jihoon Kwon <kjh010315@gmail.com>,
	Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] fs: ntfs3: check return value of indx_find to avoid infinite loop
Date: Fri, 20 Feb 2026 07:37:53 -0500
Message-ID: <20260220123805.3371698-4-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260220123805.3371698-1-sashal@kernel.org>
References: <20260220123805.3371698-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.19.3
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jaehun Gou <p22gone@gmail.com>

[ Upstream commit 1732053c8a6b360e2d5afb1b34fe9779398b072c ]

We found an infinite loop bug in the ntfs3 file system that can lead to a
Denial-of-Service (DoS) condition.

A malformed dentry in the ntfs3 filesystem can cause the kernel to hang
during the lookup operations. By setting the HAS_SUB_NODE flag in an
INDEX_ENTRY within a directory's INDEX_ALLOCATION block and manipulating the
VCN pointer, an attacker can cause the indx_find() function to repeatedly
read the same block, allocating 4 KB of memory each time. The kernel lacks
VCN loop detection and depth limits, causing memory exhaustion and an OOM
crash.

This patch adds a return value check for fnd_push() to prevent a memory
exhaustion vulnerability caused by infinite loops. When the index exceeds the
size of the fnd->nodes array, fnd_push() returns -EINVAL. The indx_find()
function checks this return value and stops processing, preventing further
memory allocation.

Co-developed-by: Seunghun Han <kkamagui@gmail.com>
Signed-off-by: Seunghun Han <kkamagui@gmail.com>
Co-developed-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jaehun Gou <p22gone@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This is the original ntfs3 driver introduction commit (v5.15-rc1 era).
The bug has been present since ntfs3 was first added.

Now let me verify what happens when `fnd_push` fails but its return
value is ignored:

When `fnd_push` returns `-EINVAL` (because `fnd->level >=
ARRAY_SIZE(fnd->nodes)`, i.e., >= 20), the current code at line 1193
ignores this return value. The loop continues iterating:
1. `fnd_push` fails — the node is NOT added to the `fnd->nodes` array,
   so `fnd->level` stays at 20
2. The loop continues, reading more index blocks via `indx_read`,
   allocating memory each time
3. Since the node isn't tracked in `fnd->nodes`, it's never freed
   (memory leak)
4. A crafted filesystem with circular VCN references will cause an
   infinite loop, each iteration allocating 4KB, leading to OOM

This is a clear DoS vulnerability via crafted filesystem.

## Analysis

### 1. COMMIT MESSAGE ANALYSIS
- **Clear bug description**: Infinite loop in ntfs3 leading to DoS / OOM
  crash
- **Attack vector**: Malformed NTFS filesystem image with manipulated
  VCN pointers and HAS_SUB_NODE flag
- **Mechanism**: `fnd_push()` return value is ignored; when array is
  full, the node is leaked and the loop continues infinitely
- **Severity**: DoS / memory exhaustion / OOM kill — this is a security-
  relevant bug

### 2. CODE CHANGE ANALYSIS
The fix is minimal and surgical:
- Changes `fnd_push(fnd, node, e);` to `err = fnd_push(fnd, node, e);`
- Adds error checking: if `fnd_push` fails, properly cleans up
  (`put_indx_node(node)`) and returns the error
- Only 5 lines of new code added (plus removal of 1 line)
- No functional changes beyond the error handling

### 3. CLASSIFICATION
- **Bug fix**: Yes — fixes an infinite loop / memory exhaustion
  vulnerability
- **Security**: Yes — DoS via crafted filesystem (mountable by
  unprivileged user in many configs, e.g., USB automount)
- **Stable criteria met**: Obviously correct, fixes a real bug, small
  and contained, no new features

### 4. SCOPE AND RISK
- **Lines changed**: ~6 lines net
- **Files changed**: 1 (fs/ntfs3/index.c)
- **Risk**: Extremely low — the only behavioral change is that an
  already-defined error path is now properly taken instead of being
  silently ignored
- **Could break something**: No — `fnd_push` already returned an error;
  it was just ignored. Now that error propagates correctly.

### 5. USER IMPACT
- Affects any system that can mount NTFS filesystems (common for USB
  drives, dual-boot systems)
- A crafted USB drive could trigger OOM on any system with ntfs3 enabled
- Impact: System hang / OOM kill — HIGH severity

### 6. STABILITY
- Signed off by the ntfs3 maintainer (Konstantin Komarov)
- The fix pattern (check return value, propagate error) is a well-
  understood and safe pattern

### 7. DEPENDENCY CHECK
- `fnd_push()` already returns `int` with proper bounds checking since
  it was introduced
- The fix only adds the return value check in the caller — no
  dependencies on other commits
- The affected code (`indx_find` and `fnd_push`) has been present since
  ntfs3 was first merged (commit 82cae269cfa95, v5.15-rc1)
- This fix applies cleanly to all stable trees that have ntfs3 (5.15+)

### Verification

- **git blame** confirmed the vulnerable code at line 1193 has been
  present since commit 82cae269cfa95 ("fs/ntfs3: Add initialization of
  super block") — the original ntfs3 introduction
- **Read of fnd_push()** at lines 673-684 confirms it already returns
  `-EINVAL` when `i >= ARRAY_SIZE(fnd->nodes)` (which is 20), verifying
  the commit message's claim
- **Read of struct ntfs_fnd** (from agent exploration) confirms
  `nodes[20]` — hardcoded array of 20 entries, so the depth limit is
  real
- **Current code at lines 1173-1198** confirms `fnd_push` return value
  is currently ignored on line 1193 (the bug)
- **git log history** shows no prior fix for this specific issue (no
  `fnd_push` return value check commits found)

This is a textbook stable backport candidate: a small, obviously correct
fix for a security-relevant DoS vulnerability in a filesystem accessible
from user space, present in all stable trees with ntfs3 support.

**YES**

 fs/ntfs3/index.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/fs/ntfs3/index.c b/fs/ntfs3/index.c
index 7157cfd70fdcb..75b94beac1613 100644
--- a/fs/ntfs3/index.c
+++ b/fs/ntfs3/index.c
@@ -1190,7 +1190,12 @@ int indx_find(struct ntfs_index *indx, struct ntfs_inode *ni,
 			return -EINVAL;
 		}
 
-		fnd_push(fnd, node, e);
+		err = fnd_push(fnd, node, e);
+
+		if (err) {
+			put_indx_node(node);
+			return err;
+		}
 	}
 
 	*entry = e;
-- 
2.51.0

