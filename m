Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E652342CBA;
	Fri, 20 Feb 2026 12:38:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591089; cv=none; b=B7gkHxM3dtitKp7qr9y0/n2t06QsSRHTR+32SPepl5ineUN9NuR6o8TQQgh/ij4iHcbmFkUURbQba2Qn7eEWD0qgmtK4ebayblMdXiwZsg9odac3LsDnhIuS001Uia9M4n7U7PQwoHMkyUaRYaqh98VuNKYbatcWpaM0lLf1e9k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591089; c=relaxed/simple;
	bh=IYPAHfLni5Se3ZY3AX7DBwUzIDFXGTjdDBDhNJgNb3U=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=gpz0TytorCWO8f7Y0sWyqoAaPsvsBxYi+7uN79uRa2AFOyaCmq+O3rQeMakbm1yDNuMQo+6v6Yk9fNqtgxVLG1jabgTcEYLaDMC9wn7P7C9ti3cJIr5iNaV4EgIxEQrNSYYLDFwuFswx+N/zr+J7skdVGXjXho3W5qViZ3bt/B4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BDx6U4Lb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BDx6U4Lb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B703C19423;
	Fri, 20 Feb 2026 12:38:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771591089;
	bh=IYPAHfLni5Se3ZY3AX7DBwUzIDFXGTjdDBDhNJgNb3U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BDx6U4Lbmwn+KpuPVmgniX+RpDgcIrkb8YrN7WD35Vcvtpe8kpaFmldp92KEkeSuY
	 I2AbqCKEdBRAB9X93IOTI4kmGaIaD1VViv5fpVUrWvmVlVFc6al2Lp3RqrNPim0M93
	 QVL68eItPcIEZgmk57XKwvc8Q1GPRTS+RL4IfI+j9TTxxQD9TIBTnVyPatGhCwS+EK
	 lE9jDEK9M6cUGYV6wxNcuvqxLE3rX3sLnHc4U5lsTdVQOZR1AXCKdYe9icp1FHdz9S
	 wdDi2DUNwG87wWldetYF5BEs898ZmsCBNCbO6xxJ6SbPfiR98CZoRh0Kf9oqQPFAr2
	 KX3aP0Hg5Kp0Q==
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
Subject: [PATCH AUTOSEL 6.19-5.15] fs: ntfs3: fix infinite loop triggered by zero-sized ATTR_LIST
Date: Fri, 20 Feb 2026 07:37:51 -0500
Message-ID: <20260220123805.3371698-2-sashal@kernel.org>
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

[ Upstream commit 06909b2549d631a47fcda249d34be26f7ca1711d ]

We found an infinite loop bug in the ntfs3 file system that can lead to a
Denial-of-Service (DoS) condition.

A malformed NTFS image can cause an infinite loop when an ATTR_LIST attribute
indicates a zero data size while the driver allocates memory for it.

When ntfs_load_attr_list() processes a resident ATTR_LIST with data_size set
to zero, it still allocates memory because of al_aligned(0). This creates an
inconsistent state where ni->attr_list.size is zero, but ni->attr_list.le is
non-null. This causes ni_enum_attr_ex to incorrectly assume that no attribute
list exists and enumerates only the primary MFT record. When it finds
ATTR_LIST, the code reloads it and restarts the enumeration, repeating
indefinitely. The mount operation never completes, hanging the kernel thread.

This patch adds validation to ensure that data_size is non-zero before memory
allocation. When a zero-sized ATTR_LIST is detected, the function returns
-EINVAL, preventing a DoS vulnerability.

Co-developed-by: Seunghun Han <kkamagui@gmail.com>
Signed-off-by: Seunghun Han <kkamagui@gmail.com>
Co-developed-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jaehun Gou <p22gone@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have a comprehensive understanding. Let me write up the analysis.

## Analysis

### 1. Commit Message Analysis

The commit explicitly describes an **infinite loop bug** (DoS
vulnerability) in the ntfs3 filesystem. A malformed NTFS image with a
zero-sized `ATTR_LIST` attribute causes the mount operation to hang
indefinitely, consuming a kernel thread. The commit message is detailed
and explains the exact mechanism clearly.

### 2. Code Change Analysis

The fix adds **two simple zero-size validation checks** — one for
resident and one for non-resident `ATTR_LIST` attributes:

- **Resident path** (line ~54): After reading `lsize =
  le32_to_cpu(attr->res.data_size)`, if `lsize == 0`, return `-EINVAL`.
- **Non-resident path** (line ~71): After reading `lsize =
  le64_to_cpu(attr->nres.data_size)`, if `lsize == 0`, return `-EINVAL`.

Both checks use the existing `goto out` error path and follow the
existing error handling pattern.

### 3. Root Cause (Verified)

The subagent analysis confirmed the exact mechanism:

1. `al_aligned(0)` returns 1024 (not 0), so memory gets allocated even
   for zero-size data.
2. `ni->attr_list.size` is set to 0, but `ni->attr_list.le` becomes non-
   NULL.
3. `ni_enum_attr_ex()` in `fs/ntfs3/frecord.c:259` checks `if
   (!ni->attr_list.size)` — this is true, so it only enumerates the
   primary MFT record.
4. Finding `ATTR_LIST` in the primary record triggers a reload via
   `ntfs_load_attr_list()`, which returns 0 early (size already set to 0
   but le is allocated), creating an infinite loop.

### 4. Stable Criteria Assessment

| Criterion | Assessment |
|-----------|-----------|
| Obviously correct | **YES** — A zero-sized attribute list is invalid;
rejecting it with -EINVAL is the right thing to do |
| Fixes a real bug | **YES** — Infinite loop / kernel hang on mount
(DoS) |
| Important issue | **YES** — DoS vulnerability from crafted filesystem
image |
| Small and contained | **YES** — Only adds 8 lines (two 4-line checks)
in a single file |
| No new features | **YES** — Pure input validation |
| Applies cleanly | **Likely** — The surrounding code has been stable;
minor context changes from kvmalloc/kvfree patches may need checking |

### 5. Risk Assessment

- **Risk: VERY LOW** — Two simple `if (!lsize)` checks that return an
  error. Cannot introduce regressions because a zero-sized ATTR_LIST is
  inherently invalid on a well-formed NTFS volume.
- **Benefit: HIGH** — Prevents a kernel hang (DoS) from a crafted NTFS
  image. This is security-relevant as NTFS images can come from
  untrusted sources (USB drives, network shares, etc.).

### 6. Affected Versions

The ntfs3 driver was introduced in v5.15 (commit `be71b5cba2e6`). The
vulnerable `ntfs_load_attr_list()` function has existed since the
driver's introduction. All stable trees with ntfs3 (5.15.y, 6.1.y,
6.6.y, 6.12.y) are affected.

### 7. Dependencies

The fix is self-contained — no dependencies on other patches. It uses
only existing error handling patterns (`goto out` with `err = -EINVAL`).

### Verification

- **git log** confirmed `attrlist.c` has been in the tree since commit
  `be71b5cba2e6` ("fs/ntfs3: Add attrib operations")
- **git merge-base** verified ntfs3 is present in v5.15, confirming all
  current stable trees are affected
- **Subagent analysis** of `al_aligned()` in
  `fs/ntfs3/ntfs_fs.h:484-487` confirmed `al_aligned(0)` returns 1024
- **Subagent analysis** of `ni_enum_attr_ex()` in
  `fs/ntfs3/frecord.c:259` confirmed the infinite loop mechanism via the
  `.size == 0` check
- **Subagent analysis** of `ntfs_load_attr_list()` callers confirmed
  it's called from `fs/ntfs3/inode.c:187-192` during inode loading
- **git show 06909b2549d63** confirmed the commit exists and matches the
  described fix
- The claim that this is a DoS vulnerability is verified by the code
  analysis showing the infinite loop mechanism

This is a textbook stable backport candidate: a small, surgical fix for
a DoS vulnerability (infinite loop / kernel hang) triggered by a
malformed filesystem image, with zero risk of regression.

**YES**

 fs/ntfs3/attrlist.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ntfs3/attrlist.c b/fs/ntfs3/attrlist.c
index a4d74bed74fab..098bd7e8c3d64 100644
--- a/fs/ntfs3/attrlist.c
+++ b/fs/ntfs3/attrlist.c
@@ -52,6 +52,11 @@ int ntfs_load_attr_list(struct ntfs_inode *ni, struct ATTRIB *attr)
 
 	if (!attr->non_res) {
 		lsize = le32_to_cpu(attr->res.data_size);
+		if (!lsize) {
+			err = -EINVAL;
+			goto out;
+		}
+
 		/* attr is resident: lsize < record_size (1K or 4K) */
 		le = kvmalloc(al_aligned(lsize), GFP_KERNEL);
 		if (!le) {
@@ -66,6 +71,10 @@ int ntfs_load_attr_list(struct ntfs_inode *ni, struct ATTRIB *attr)
 		u16 run_off = le16_to_cpu(attr->nres.run_off);
 
 		lsize = le64_to_cpu(attr->nres.data_size);
+		if (!lsize) {
+			err = -EINVAL;
+			goto out;
+		}
 
 		run_init(&ni->attr_list.run);
 
-- 
2.51.0

