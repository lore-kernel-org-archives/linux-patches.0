Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7323F343D83;
	Fri, 20 Feb 2026 12:38:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591103; cv=none; b=LSXbRJ/cYH9rf7xL6kfXvz1/64TOnniLebBs6w7VCgttGezSeObvE4mjp7IVqlnKA7xwOjccjWRDPI1d+J5dcWCDmiKKoFtdNMz3BgcDR844eBdmMREammszQkBJLdcfKePSyuukwrHTJWnK0jekJaI5vJSFHitgHsXQ8KHcdJw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591103; c=relaxed/simple;
	bh=kvpOnPUV0DmLkneoyI6XI9qQet3OhXzZyF6gbVsW0hs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UKoCg1o9fcOED/XVwOM5xP8I9Cgm40Q8ELFkbv7fX5JkP2OTyjC4H7eeJeswBSOKDh8U41E4r+ydhRhjCPzA9V+7sx0uq1qHkQnrPRQGJLswJLmFHpRiW9AsKRFOsaaOK+iS8TFWUh7cPDzeO6snqE2boSNapAN+4nCIzK18uPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sIihn3lw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sIihn3lw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30CC4C116D0;
	Fri, 20 Feb 2026 12:38:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771591103;
	bh=kvpOnPUV0DmLkneoyI6XI9qQet3OhXzZyF6gbVsW0hs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sIihn3lwkRKNsBybA9Ly3Dzm4OfsIfv1U5ynlaTJnC0kY+hN93/jkJiM7Gc3x0r3j
	 Laft5Fxje2hfSi86KekXxya76Rd+9VCQGi3V3hVNQdhB2bCadf8XzOe03LhfTBzU0y
	 Aj0eSgYmbgWN9GZrBwX3XJfFT5EUkGoW2jEY/PIfTUpHF0XrDVBVVYvw1yYLOQ3LN1
	 2ZnualHbcJJC4aCAZJRxUj/WqpAvN9J+GpIaepvIVtRPyTa5f7l18BRzffPTJ/Eune
	 EFr9vZ7UDfhZRopS2nO60qmBkYjo6hNkjl2ZESCda5BmspHJWhZlOn7ka+JPAIekhD
	 UnyxKSRom20Jw==
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
Subject: [PATCH AUTOSEL 6.19-5.15] fs: ntfs3: fix infinite loop in attr_load_runs_range on inconsistent metadata
Date: Fri, 20 Feb 2026 07:38:00 -0500
Message-ID: <20260220123805.3371698-11-sashal@kernel.org>
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

[ Upstream commit 4b90f16e4bb5607fb35e7802eb67874038da4640 ]

We found an infinite loop bug in the ntfs3 file system that can lead to a
Denial-of-Service (DoS) condition.

A malformed NTFS image can cause an infinite loop when an attribute header
indicates an empty run list, while directory entries reference it as
containing actual data. In NTFS, setting evcn=-1 with svcn=0 is a valid way
to represent an empty run list, and run_unpack() correctly handles this by
checking if evcn + 1 equals svcn and returning early without parsing any run
data. However, this creates a problem when there is metadata inconsistency,
where the attribute header claims to be empty (evcn=-1) but the caller
expects to read actual data. When run_unpack() immediately returns success
upon seeing this condition, it leaves the runs_tree uninitialized with
run->runs as a NULL. The calling function attr_load_runs_range() assumes
that a successful return means that the runs were loaded and sets clen to 0,
expecting the next run_lookup_entry() call to succeed. Because runs_tree
remains uninitialized, run_lookup_entry() continues to fail, and the loop
increments vcn by zero (vcn += 0), leading to an infinite loop.

This patch adds a retry counter to detect when run_lookup_entry() fails
consecutively after attr_load_runs_vcn(). If the run is still not found on
the second attempt, it indicates corrupted metadata and returns -EINVAL,
preventing the Denial-of-Service (DoS) vulnerability.

Co-developed-by: Seunghun Han <kkamagui@gmail.com>
Signed-off-by: Seunghun Han <kkamagui@gmail.com>
Co-developed-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jihoon Kwon <kjh010315@gmail.com>
Signed-off-by: Jaehun Gou <p22gone@gmail.com>
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

This confirms the key detail: `run_unpack()` (called via
`run_unpack_ex()`) at line 940-941 returns 0 (success) when `evcn + 1 ==
svcn` — the "empty run" condition. This means `attr_load_runs_vcn()`
returns success even when no runs are actually loaded into the
`runs_tree`.

Let me now verify the infinite loop mechanism more carefully:

1. `attr_load_runs_range()` enters the loop, `run_lookup_entry()` fails
   (returns false) because `run->runs` is NULL
2. `attr_load_runs_vcn()` is called, which calls `run_unpack_ex()` →
   `run_unpack()`, which returns 0 (success) for the empty run case
   without adding any entries
3. `clen` is set to 0
4. Loop iterates: `vcn += clen` → `vcn += 0` — no progress
5. `run_lookup_entry()` fails again → infinite loop

The fix adds a `retry` counter. If `run_lookup_entry()` fails after
`attr_load_runs_vcn()` has already been called once for the same VCN, it
returns `-EINVAL` instead of looping forever.

## Analysis

### 1. COMMIT MESSAGE ANALYSIS
- **Subject**: Clearly states "fix infinite loop" — this is a bug fix
- **Body**: Excellent description of the root cause, trigger mechanism,
  and DoS impact
- **Impact**: Denial-of-Service via crafted NTFS image — security
  relevant
- **Tags**: Multiple Co-developed-by/Signed-off-by, signed by ntfs3
  maintainer (Konstantin Komarov)

### 2. CODE CHANGE ANALYSIS
The patch is small and surgical (~20 lines changed in a single
function):
- Adds a `retry` counter initialized to 0
- After `attr_load_runs_vcn()` succeeds but `run_lookup_entry()` still
  fails on the next iteration, returns `-EINVAL`
- Resets `retry` to 0 on successful lookup
- Changes `return err` to `break` for consistency with the new error
  path
- All changes are self-contained within `attr_load_runs_range()`

### 3. BUG CLASSIFICATION
- **Type**: Infinite loop / DoS from inconsistent metadata on malformed
  NTFS image
- **Trigger**: Mounting/reading a crafted NTFS image where attribute
  header claims empty run list (evcn=-1, svcn=0) but directory entries
  reference it as containing data
- **Severity**: HIGH — causes complete system hang (infinite loop in
  kernel)
- **Security**: This is a DoS vulnerability triggerable by mounting a
  malicious filesystem image (e.g., USB stick)

### 4. SCOPE AND RISK
- **Lines changed**: ~20, single function, single file
- **Risk**: Very low — only adds early termination for a detected
  inconsistency condition
- **Side effects**: None — the retry counter only triggers when metadata
  is already corrupt
- **Regression risk**: Minimal — legitimate NTFS images won't trigger
  the retry mechanism because `run_lookup_entry()` will succeed after
  loading runs

### 5. USER IMPACT
- Affects anyone who mounts NTFS volumes (very common: USB drives, dual-
  boot, data exchange)
- A malicious NTFS image on a USB drive could hang the kernel
- Multiple callers of `attr_load_runs_range()` are affected: xattr,
  index, frecord, WOF operations

### 6. STABLE CRITERIA
- **Obviously correct**: Yes — if loading runs succeeded but lookup
  still fails, metadata is corrupt
- **Fixes a real bug**: Yes — infinite loop / DoS
- **Small and contained**: Yes — ~20 lines in one function
- **No new features**: Correct — only adds error detection
- **Tested**: Signed by ntfs3 maintainer, merged to mainline

### Verification

- **Verified** the `run_unpack()` early return at line 940-941: `if
  (evcn + 1 == svcn) return 0;` — this is the empty run case that
  returns success without populating runs_tree
- **Verified** `run_lookup_entry()` at line 201: `if (!run->runs) return
  false;` — confirms it returns false when runs_tree is uninitialized
- **Verified** the infinite loop mechanism: `vcn += clen` with `clen =
  0` causes no progress, leading to infinite re-entry into the same
  lookup failure path
- **Verified** callers via grep: `attr_load_runs_range` is called from
  xattr.c:127, xattr.c:498, index.c:1080, frecord.c:2529, and
  attrib.c:1463 — multiple code paths are affected
- **Verified** the fix is self-contained: only changes
  `attr_load_runs_range()` in attrib.c, no dependencies on other commits
- **Verified** via git log that this code has been present in ntfs3
  since its inclusion (the function structure is unchanged), meaning all
  stable trees with ntfs3 are affected
- **Could not verify** specific CVE assignment (none mentioned in
  commit), but the DoS nature makes it security-relevant regardless

This is a textbook stable backport candidate: a small, surgical fix for
a DoS-triggering infinite loop in a filesystem driver, caused by
inconsistent metadata on crafted images. The fix is obviously correct,
contained, low-risk, and signed off by the subsystem maintainer.

**YES**

 fs/ntfs3/attrib.c | 15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

diff --git a/fs/ntfs3/attrib.c b/fs/ntfs3/attrib.c
index 980ae9157248d..c45880ab23912 100644
--- a/fs/ntfs3/attrib.c
+++ b/fs/ntfs3/attrib.c
@@ -1354,19 +1354,28 @@ int attr_load_runs_range(struct ntfs_inode *ni, enum ATTR_TYPE type,
 	CLST vcn;
 	CLST vcn_last = (to - 1) >> cluster_bits;
 	CLST lcn, clen;
-	int err;
+	int err = 0;
+	int retry = 0;
 
 	for (vcn = from >> cluster_bits; vcn <= vcn_last; vcn += clen) {
 		if (!run_lookup_entry(run, vcn, &lcn, &clen, NULL)) {
+			if (retry != 0) { /* Next run_lookup_entry(vcn) also failed. */
+				err = -EINVAL;
+				break;
+			}
 			err = attr_load_runs_vcn(ni, type, name, name_len, run,
 						 vcn);
 			if (err)
-				return err;
+				break;
+
 			clen = 0; /* Next run_lookup_entry(vcn) must be success. */
+			retry++;
 		}
+		else
+			retry = 0;
 	}
 
-	return 0;
+	return err;
 }
 
 #ifdef CONFIG_NTFS3_LZX_XPRESS
-- 
2.51.0

