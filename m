Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD41D23C8C7;
	Tue,  9 Dec 2025 00:17:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765239445; cv=none; b=YrufaNBhGsshv//E7DZcQNTJrxlI6V9b6L+7qbRS6ZqAro54zm98qWydQstblkhpV2XaCZ3jt80o5di2OFB+W7dP5IRODgcqlebLRDOd2G15CHwqagXBbljQVrKJQe576iyNV8lwFo5rcbjclk5xv0v/r+XsXcqkwkFRKPp5v0c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765239445; c=relaxed/simple;
	bh=zJDUZJLStca6AOH5tUlUpjNsJ+2vLrqieI6DgNVKTC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iAxlcoItdiXFMN6ErdUpLo6wlxFYKs1eTujQThCIggbEXjz5y2sWv/esBCrBJGP5quVDvMj8OVoTKvb7fEXuzWnKRcmDLXmsFe6ik138nftfswWgnm2yciIr8aKmU2+aN3tzbP952EXCgEtuWvKFCnBfaJfTSe5x7YppiUBgLpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKVBdvYY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKVBdvYY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93D2C19421;
	Tue,  9 Dec 2025 00:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765239444;
	bh=zJDUZJLStca6AOH5tUlUpjNsJ+2vLrqieI6DgNVKTC0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VKVBdvYYoKYEWFRggfdzHmgI/xL7t3P0MB6mMukFv6exTK33gXmbRMZva96zmiPYS
	 XK7TGbthkndzoRqQ6dBuAPdFCTCt66uHZiCTTuGq/aYA32DBwrSaq71v9sHcB5i4/5
	 CBHQR4pYl26ey/+lTaVmbd3vK6y5QJixiuGmoQ7jyGJdvqFnK3jOliIxfieSR7pY8A
	 FrNXZ2v3GCJ/p1VOuw+O8DmkWv4zuNsMnzWn6rKaFaxy/Xo2NZgPfI/DdI26jBSFUJ
	 ionFY3sU4gIj6oEa8uN9ZkIE4i+LlCiUQD/tJ5GCXesOqvcNzyobFzhxuqQc7J/KrH
	 CydU/NKY7ZoZg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Andreas Gruenbacher <agruenba@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	gfs2@lists.linux.dev
Subject: [PATCH AUTOSEL 6.18-6.6] gfs2: fix remote evict for read-only filesystems
Date: Mon,  8 Dec 2025 19:15:15 -0500
Message-ID: <20251209001610.611575-23-sashal@kernel.org>
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

From: Andreas Gruenbacher <agruenba@redhat.com>

[ Upstream commit 64c10ed9274bc46416f502afea48b4ae11279669 ]

When a node tries to delete an inode, it first requests exclusive access
to the iopen glock.  This triggers demote requests on all remote nodes
currently holding the iopen glock.  To satisfy those requests, the
remote nodes evict the inode in question, or they poke the corresponding
inode glock to signal that the inode is still in active use.

This behavior doesn't depend on whether or not a filesystem is
read-only, so remove the incorrect read-only check.

Signed-off-by: Andreas Gruenbacher <agruenba@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Analysis: gfs2: fix remote evict for read-only filesystems

### 1. COMMIT MESSAGE ANALYSIS

**Subject:** Uses "fix" keyword, indicating a bug fix
**Description:** Explains a cluster coordination bug in GFS2 where the
read-only check was incorrectly preventing remote inode eviction
**Tags:**
- Signed-off-by from Andreas Gruenbacher (GFS2 maintainer)
- No explicit "Cc: stable@vger.kernel.org" tag
- No "Fixes:" tag

### 2. CODE CHANGE ANALYSIS

The change is extremely minimal - removing a single condition from
`iopen_go_callback()`:

**Before:**
```c
if (!remote || sb_rdonly(sdp->sd_vfs) ||
    test_bit(SDF_KILL, &sdp->sd_flags))
    return;
```

**After:**
```c
if (!remote || test_bit(SDF_KILL, &sdp->sd_flags))
    return;
```

**Technical mechanism of the bug:**
- GFS2 is a clustered filesystem where multiple nodes access shared
  storage
- When Node A wants to delete an inode, it requests exclusive access to
  the iopen glock
- This triggers demote requests to all remote nodes (Node B, C, etc.)
  holding that glock
- Remote nodes must respond by either evicting the inode or signaling
  it's still in use
- The bug: The `sb_rdonly()` check caused read-only mounted nodes to
  skip this coordination entirely
- This breaks cluster protocol because Node A waits for Node B to
  release the glock, but Node B ignores the request

**Why the fix is correct:**
Cluster coordination for glock demotes must work regardless of mount
mode. A read-only node still participates in the cluster and must
properly respond to glock callbacks. The read-only check was logically
incorrect and could cause:
- Stale inode issues across the cluster
- Potential hangs where nodes wait indefinitely for glock release
- Cluster coordination failures

### 3. CLASSIFICATION

- **Bug type:** Logic error - incorrect early return preventing required
  cluster coordination
- **Not a feature:** Removing an incorrect check doesn't add
  functionality
- **Security impact:** Not directly security-related, but could cause
  availability issues

### 4. SCOPE AND RISK ASSESSMENT

| Metric | Assessment |
|--------|------------|
| Lines changed | 2 lines (trivial) |
| Files touched | 1 file |
| Complexity | Very low |
| Subsystem | GFS2 (clustered filesystem) |
| Regression risk | Very low |

The change is extremely surgical - it only removes an erroneous
condition. The remaining code path already exists and has been tested;
this fix just ensures it executes when it should.

### 5. USER IMPACT

- **Affected users:** GFS2 users in clustered environments with read-
  only mounts
- **Use case:** Enterprise clusters (Red Hat, etc.) that use GFS2
- **Severity:** Could cause cluster coordination failures, stale inodes,
  or hangs
- **Frequency:** Affects all read-only GFS2 mounts in cluster mode

### 6. STABILITY INDICATORS

- Written by Andreas Gruenbacher, the GFS2 maintainer who deeply
  understands the subsystem
- The fix logic is obviously correct based on the documented behavior
- Small change means easy to verify correctness

### 7. DEPENDENCY CHECK

- No dependencies on other commits
- The `iopen_go_callback()` function and `sb_rdonly()` exist in all
  stable kernels with GFS2 support
- Clean backport expected (simple line removal)

### Risk vs Benefit Analysis

**Benefits:**
- Fixes a real bug affecting cluster coordination
- Prevents potential hangs and stale inode issues
- Restores correct cluster protocol behavior

**Risks:**
- Extremely low - the change simply allows existing, tested code to run
- Only affects GFS2, a specialized filesystem
- The maintainer clearly understands the impact

### Conclusion

Despite the lack of explicit "Cc: stable" tag, this commit:
1. ✅ Is obviously correct (removing incorrect logic)
2. ✅ Fixes a real bug affecting cluster coordination
3. ✅ Is small and contained (2 lines)
4. ✅ Does not introduce new features
5. ✅ Will apply cleanly to stable trees
6. ✅ Has minimal regression risk

The fix addresses a genuine bug that can cause cluster coordination
failures in GFS2. The change is trivially small, written by the
subsystem maintainer, and the logic is clearly correct - read-only
status should not prevent a node from properly responding to cluster
glock demote requests.

**YES**

 fs/gfs2/glops.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/gfs2/glops.c b/fs/gfs2/glops.c
index 0c0a80b3bacab..0c68ab4432b08 100644
--- a/fs/gfs2/glops.c
+++ b/fs/gfs2/glops.c
@@ -630,8 +630,7 @@ static void iopen_go_callback(struct gfs2_glock *gl, bool remote)
 	struct gfs2_inode *ip = gl->gl_object;
 	struct gfs2_sbd *sdp = gl->gl_name.ln_sbd;
 
-	if (!remote || sb_rdonly(sdp->sd_vfs) ||
-	    test_bit(SDF_KILL, &sdp->sd_flags))
+	if (!remote || test_bit(SDF_KILL, &sdp->sd_flags))
 		return;
 
 	if (gl->gl_demote_state == LM_ST_UNLOCKED &&
-- 
2.51.0

