Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F228E3451D7;
	Fri, 20 Feb 2026 12:38:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771591096; cv=none; b=FoL0JuI6Ld+9J+9xh49hOMEqAyK4HUcGYHFLbdEUOKvgVS0WE+xsi9WgJUOdNcR1nsiHa2+un2VU0jsEUmMeNsGfYAXNJmTx9vy9+K1q+beJDmPDJ9yF+1eeLpTo87iUwu7MhWvUs9jpEhxHZx/6KB4AvqCEi/FKG9tOGxGvVMU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771591096; c=relaxed/simple;
	bh=tzvL8dU6MqNQWZTHv5gFQ2d3Y3+gb4kIrR5EOchILO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=GyQBQJzGcKFz3mLHIci3g2kntFgbO67HEhRw5zGVm86Y7TjI0fZZyFLEkbQ73pRjlBKaonJpMRfa+EramRJ1ug6qv+ZgsnUKP8tNTL6xzTJUu/6Kj1HA8XlWAVQTPVTqkHy0Fz118qajsNQ63HU+44X5XhINOTHVTueDkhEwlf4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SRC+1om3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SRC+1om3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEE92C19425;
	Fri, 20 Feb 2026 12:38:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1771591095;
	bh=tzvL8dU6MqNQWZTHv5gFQ2d3Y3+gb4kIrR5EOchILO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SRC+1om3rx9+Zhob6+tZoQUNyQocD1J7t9uG3/JpmDNYO0kyHeoODlIBoVBWZnEfF
	 l9ITfhvI+JVaRfLILMYfOs6XrvkuGCLSnPiAL/HfpwyQUEu9VAS34Dl8+b+GvJ5KjV
	 /unNHn/txYcKn0Jd7ZwyfyfHfJju88N+r4U+acfPNDbvnQFaI4KO/OTOh0HpDP2z+0
	 lWgIWiGNNtS2cpX9tDefWEeRGFGQndfuCtYMd1+vpoxi5Jg+QKmmu/hESTLF8mUZt6
	 45/s4rZ0GSIy1tJiMMHqyGkz1iy5gz/1f6OJTOS2lBjGzERIJX+dZ3wHUiTVfvYQLp
	 TjRWFiA5skUjg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>,
	kernel test robot <lkp@intel.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>,
	ntfs3@lists.linux.dev,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.19-5.15] fs/ntfs3: avoid calling run_get_entry() when run == NULL in ntfs_read_run_nb_ra()
Date: Fri, 20 Feb 2026 07:37:55 -0500
Message-ID: <20260220123805.3371698-6-sashal@kernel.org>
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

From: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>

[ Upstream commit c5226b96c08a010ebef5fdf4c90572bcd89e4299 ]

When ntfs_read_run_nb_ra() is invoked with run == NULL the code later
assumes run is valid and may call run_get_entry(NULL, ...), and also
uses clen/idx without initializing them. Smatch reported uninitialized
variable warnings and this can lead to undefined behaviour. This patch
fixes it.

Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@linaro.org>
Closes: https://lore.kernel.org/r/202512230646.v5hrYXL0-lkp@intel.com/
Signed-off-by: Konstantin Komarov <almaz.alexandrovich@paragon-software.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

Now I have all the information needed for a thorough analysis.

## Analysis

### 1. Commit Message Analysis

The commit clearly describes a bug fix: when `ntfs_read_run_nb()`
(renamed to `ntfs_read_run_nb_ra()` in the commit being analyzed) is
invoked with `run == NULL`, the code can later call `run_get_entry(NULL,
...)` and use uninitialized variables `clen` and `idx`. This was
reported by the kernel test robot and Dan Carpenter (a well-known static
analysis expert using Smatch).

### 2. Code Change Analysis

**The bug mechanism:**

At `fs/ntfs3/fsntfs.c:1186-1207`, when `run == NULL`, the function uses
the absolute boot MFT location:
- `lbo` and `len` are set from boot info (lines 1194-1195)
- **But `clen`, `idx`, and `vcn` are NOT initialized** — they are only
  set via `run_lookup_entry()` on the `run != NULL` path (line 1196)

The function then enters a `for(;;)` loop (line 1215) containing an
inner `do { } while (len32)` loop. If the requested `bytes` exceeds the
initial `len` (i.e., the read spans more than one record), the inner
loop completes, and execution falls through to line 1255 where:

1. `vcn_next = vcn + clen;` — **uses uninitialized `clen`** (undefined
   behavior)
2. `run_get_entry(run, ++idx, ...)` — **dereferences NULL `run`** (crash
   at `run->count` in `run.c:608`)
3. `++idx` — **uses uninitialized `idx`** (undefined behavior)

**What `run_get_entry()` does with NULL:**
Looking at `fs/ntfs3/run.c:608`, the very first thing it does is `if
(index >= run->count)`, which immediately dereferences the NULL pointer
→ **kernel oops/panic**.

**The fix:** Adds a simple `if (!run)` check before reaching the
`run_get_entry()` call, returning `-EINVAL` and going to error cleanup.
This is exactly 4 lines of code and is obviously correct — if we entered
the loop via the `run == NULL` path and need another fragment, we can't
get one, so returning an error is the right behavior.

### 3. Classification

This is a **bug fix** that prevents:
- NULL pointer dereference (crash/oops)
- Use of uninitialized variables (undefined behavior, potential data
  corruption)

### 4. Scope and Risk

- **Lines changed:** 4 lines of actual code added (NULL check + goto)
- **Files touched:** 1 (`fs/ntfs3/fsntfs.c`)
- **Risk:** Extremely low — adds a defensive check that can only trigger
  on an error path, returning `-EINVAL` which callers already handle
- **No behavioral change** for the normal case where `run != NULL`

### 5. User Impact

NTFS3 is used by anyone mounting NTFS filesystems on Linux (common for
dual-boot systems, external drives). While the `run == NULL` path is
specific to early MFT reading during mount, the uninitialized variable
use means the code is technically invoking undefined behavior, which
compilers can exploit in unexpected ways.

### 6. Stability Indicators

- Reported by kernel test robot and Dan Carpenter (Smatch static
  analysis) — two highly reputable sources
- The fix is authored by the NTFS3 maintainer (Konstantin Komarov)
- Extremely small and contained change

### 7. Dependency Check

The fix is self-contained — it just adds a NULL check. It applies to the
existing `ntfs_read_run_nb()` function which has been in the kernel
since NTFS3 was merged in v5.15.

## Verification

- **Read `ntfs_read_run_nb()` at fsntfs.c:1171-1282**: Confirmed `clen`,
  `idx` are only initialized via `run_lookup_entry()` on line 1196,
  which is skipped when `run == NULL`
- **Read `run_get_entry()` at run.c:603-623**: Confirmed line 608
  immediately dereferences `run->count`, which would crash if `run ==
  NULL`
- **Searched callers of `ntfs_read_run_nb()`**: Found 12 call sites; the
  `run == NULL` path is designed for early MFT reading (per comment at
  line 1187)
- **Checked `oa->run1` initialization in fslog.c**: All paths through
  `fake_attr` (line 4749) and normal flow (line 4801) set `oa->run1`, so
  the fslog caller is unlikely to pass NULL — but the function's design
  explicitly handles `run == NULL` at its entry
- **Confirmed ntfs3 present since v5.15**: The filesystem was merged in
  Linux 5.15, present in all active stable trees
- **git log confirmed recent ntfs3 activity**: Active maintenance by the
  NTFS3 maintainer

This is a textbook stable backport candidate: small, surgical fix for a
NULL pointer dereference and uninitialized variable use, authored by the
subsystem maintainer, reported by trusted automated tools.

**YES**

 fs/ntfs3/fsntfs.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/ntfs3/fsntfs.c b/fs/ntfs3/fsntfs.c
index 5f138f7158357..ac99c5613284a 100644
--- a/fs/ntfs3/fsntfs.c
+++ b/fs/ntfs3/fsntfs.c
@@ -1252,6 +1252,12 @@ int ntfs_read_run_nb(struct ntfs_sb_info *sbi, const struct runs_tree *run,
 
 		} while (len32);
 
+		if (!run) {
+			err = -EINVAL;
+			goto out;
+		}
+
+		/* Get next fragment to read. */
 		vcn_next = vcn + clen;
 		if (!run_get_entry(run, ++idx, &vcn, &lcn, &clen) ||
 		    vcn != vcn_next) {
-- 
2.51.0

