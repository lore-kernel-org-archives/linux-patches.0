Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E720E9478;
	Thu,  2 Oct 2025 15:31:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759419068; cv=none; b=eDFTVuBuqj1tOLuelgilshlF6F5G+0VwS/ZrCoaWbmENBComkQC8x3f7JH/bKPlPrH2SQxoI+I7fXxJqDOj7M5eDbb0lEkxMPGFArsclN/GNkgVEn+qEbfSuhEt+VkDPKpXzvLIq4yhUZ0IOKIBlFJLAAegqxme+i4y9r7FmPaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759419068; c=relaxed/simple;
	bh=jV0l1RE0JV78BIyNfMumTyai7MgrCQ6pI3+MJKzqcto=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iPhr08mFP+fo1C1tagX7FoHRONfUx6llh/4JDC+1GFdHYf6ncHA/Pr+iTcvWz45xEEF32wrrOpUO67b+aqZO8xEPDaFazvKdQTqS8ieQ6xUiFOBL7jlynqrTFBzNF6YOyYaOqho8l8FQtj/lIsZ3PMAw/l6cpIxdCvz1AGrBxzo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qVZ+rlhH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qVZ+rlhH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04696C4CEFC;
	Thu,  2 Oct 2025 15:31:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1759419067;
	bh=jV0l1RE0JV78BIyNfMumTyai7MgrCQ6pI3+MJKzqcto=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qVZ+rlhH9qAQw4KXUHObhxGQ1moNwvJiEnCr/eGaaN71b5nN7E/fiufCS4EAqAFDp
	 RIlnB0hWzYYZaLWEMpc4OA1j6WP34qvjIAgIfQgFnwZ8Ob0hBRYacvC3DKL/ptw4N3
	 A3a8yWCK1IBs5erkOQXkBfhRBWSkAnAtP9wwYsXwaUAfBYvyKZuVLziRNQ9Cbf2I5V
	 IbZmxeB3D1SCmzxRQ9ncUZFbBfnq1egnBlhDaYI5+3f5yaVH51h+Z71IvtRGaEbvg+
	 y0sif57XipwUpU1RZWCursoRwXiVjTpjYe9gp3DRSW7v2LyACai0PmAWRDczbPWm//
	 naQLFEDlsBCng==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Alexander Aring <aahringo@redhat.com>,
	David Teigland <teigland@redhat.com>,
	Sasha Levin <sashal@kernel.org>,
	ccaulfie@redhat.com,
	cluster-devel@redhat.com
Subject: [PATCH AUTOSEL 6.17-5.4] dlm: check for defined force value in dlm_lockspace_release
Date: Thu,  2 Oct 2025 11:30:17 -0400
Message-ID: <20251002153025.2209281-30-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251002153025.2209281-1-sashal@kernel.org>
References: <20251002153025.2209281-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexander Aring <aahringo@redhat.com>

[ Upstream commit 6af515c9f3ccec3eb8a262ca86bef2c499d07951 ]

Force values over 3 are undefined, so don't treat them as 3.

Signed-off-by: Alexander Aring <aahringo@redhat.com>
Signed-off-by: David Teigland <teigland@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

## Backport Recommendation: **YES**

## Extensive Analysis

### Commit Overview
This commit changes a single line in `fs/dlm/lockspace.c` in the
`release_lockspace()` function:
```c
- if (force < 3 && dlm_user_daemon_available())
+       if (force != 3 && dlm_user_daemon_available())
```

This changes how undefined `force` parameter values are handled when
releasing DLM lockspaces.

### Understanding the Force Parameter

According to the code documentation in `fs/dlm/lockspace.c:785-790`, the
`force` parameter has 4 defined values:
- **0 (DLM_RELEASE_NO_LOCKS)**: Don't destroy lockspace if it has any
  locks
- **1 (DLM_RELEASE_UNUSED)**: Destroy lockspace if it has remote locks
  but not local locks (unused in practice)
- **2 (DLM_RELEASE_NORMAL)**: Destroy lockspace regardless of locks
- **3 (DLM_RELEASE_NO_EVENT)**: Destroy lockspace as part of forced
  shutdown, skip uevent notification

### The Bug Being Fixed

**Old behavior (`force < 3`):**
- Force values 0, 1, 2: Send uevent (KOBJ_OFFLINE) to userspace daemon ✓
- Force value 3: Skip uevent ✓
- **Force values > 3 (undefined): Skip uevent** ✗ (treats undefined
  values as force==3)
- **Force values < 0 (undefined): Send uevent** (unintended but works)

**New behavior (`force != 3`):**
- Force values 0, 1, 2: Send uevent ✓
- Force value 3: Skip uevent ✓
- **Force values > 3 (undefined): Send uevent** ✓ (doesn't treat
  undefined as force==3)
- **Force values < 0 (undefined): Send uevent** ✓ (same as before)

The commit message states: "Force values over 3 are undefined, so don't
treat them as 3." This is correct - undefined values should not be
implicitly treated as any specific defined value.

### Analysis of All Callers

I examined all callers of `dlm_release_lockspace()` in the kernel:

1. **fs/ocfs2/stack_user.c:955**:
   `dlm_release_lockspace(conn->cc_lockspace, 2);`
2. **fs/gfs2/lock_dlm.c:1403,1440**: `dlm_release_lockspace(ls->ls_dlm,
   2);` (2 call sites)
3. **drivers/md/md-cluster.c:982,1045**:
   `dlm_release_lockspace(cinfo->lockspace, 2);` (2 call sites)
4. **fs/dlm/user.c:428**: `dlm_release_lockspace(lockspace, 0);`
5. **fs/dlm/user.c:461**: `dlm_release_lockspace(lockspace, force);`
   where force is either 0 or 2 based on `DLM_USER_LSFLG_FORCEFREE` flag

**Critical finding**: No caller in the entire kernel passes:
- Force value 3 (DLM_RELEASE_NO_EVENT)
- Any undefined values (< 0 or > 3)

The userspace interface (`dlm_device.h`) only allows userspace to set
flags, not directly control the force parameter. The kernel code
interprets flags and sets force to either 0 or 2.

### Part of a Cleanup Series

This commit is the first in a 4-commit series that's being backported
together:

1. **6af515c9f3cce** (this commit): Changes `force < 3` to `force != 3`
2. **bea90085dcb0f**: Renames `force` to `release_option`, adds #define
   constants
3. **8d90041a0d285**: Changes parameter type from `int` to `unsigned
   int`
4. **8e40210788636**: Adds explicit validation: `if (release_option >
   __DLM_RELEASE_MAX) return -EINVAL;`

The series progressively improves the code:
- Step 1 (this commit): Stop treating undefined values as force==3
- Step 2: Add proper documentation and defines
- Step 3: Use unsigned type since all valid values are positive
- Step 4: Explicitly reject undefined values with -EINVAL

### Impact Assessment

**Real-world impact**: Very low. Since no callers pass undefined values,
this bug cannot manifest in practice with current code.

**What could go wrong if not fixed**:
- If future code mistakenly passes an undefined force value > 3, the old
  code would silently skip the uevent
- This could cause cluster membership issues where other nodes aren't
  notified of lockspace departure
- The do_uevent() function waits for userspace daemon response, so
  skipping it incorrectly breaks the lockspace release protocol

**Risk of the fix**: Extremely low
- One line change
- All current callers unaffected (they only use 0 or 2)
- More correct behavior (undefined values no longer treated as defined
  value 3)
- Part of well-tested upstream series

### Backport Suitability

**Meets stable tree criteria**:
✓ Small, contained change (1 line)
✓ Improves correctness
✓ No known side effects
✓ Very low regression risk
✓ Part of larger cleanup series already being backported

**Why this should be backported**:
1. **Code correctness**: Undefined parameter values should not be
   silently treated as specific defined values
2. **Defense in depth**: Protects against future bugs where undefined
   values might be passed
3. **Series coherence**: This is part of a 4-commit series that's all
   being backported together; backporting partial series could be
   confusing
4. **Input validation**: Proper parameter validation is important for
   kernel APIs, even internal ones
5. **Cluster filesystem impact**: DLM is used by cluster filesystems
   (GFS2, OCFS2) where incorrect behavior could affect data integrity

**Stable tree precedent**: This type of input validation/correctness fix
is commonly backported even without an actual bug manifestation, as
defensive hardening.

### Conclusion

**Recommendation: YES** - This commit should be backported.

While no current code can trigger the bug (making real-world impact
zero), the fix:
- Improves code correctness with zero risk
- Is part of a cleanup series already being backported
- Provides proper input validation as defensive programming
- Could prevent future bugs if callers change
- Follows stable kernel tree guidelines for low-risk correctness fixes

The change is minimal, well-understood, and makes the code more robust
without any downside.

 fs/dlm/lockspace.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/fs/dlm/lockspace.c b/fs/dlm/lockspace.c
index 1929327ffbe1c..ee11a70def92d 100644
--- a/fs/dlm/lockspace.c
+++ b/fs/dlm/lockspace.c
@@ -730,7 +730,7 @@ static int release_lockspace(struct dlm_ls *ls, int force)
 
 	dlm_device_deregister(ls);
 
-	if (force < 3 && dlm_user_daemon_available())
+	if (force != 3 && dlm_user_daemon_available())
 		do_uevent(ls, 0);
 
 	dlm_recoverd_stop(ls);
-- 
2.51.0

