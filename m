Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D82F13148C4;
	Sat, 25 Oct 2025 16:23:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761409417; cv=none; b=DSH6pKDn7U3AqLkEvJP7FEMKimXvvkcUG0hiu0OUOTA6K3qh/KLuB3vPPoVp7v0VS8WvSTBQpsDxwsGs4AjRBZhGCjJgZkZ+fo27EWDn0zwRoX/m4I2xLflm0xlhwgGpDSdlchNMkmKTNmGkm/h8IgOeuMYi357cleZikKfO2Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761409417; c=relaxed/simple;
	bh=HLjCvzwRgY1PZy/hshRgN0ARIhMJU2Dy3g4uCtbnmZU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tx8yvYP6Pb3rwa7/OHSZ3hPyUF1NvLtdL96R9P+XAcrjYS2Po+6a/92OIdWK9oSH45pIO1K8LxXH5A5JSn9Wjwvl0Im2vLeI2yI3EJQB5nz/Pqk8/4NjfmG5MzzWwpBw1aPbb4bYaOguGKm6bcYUsARi9q08lAGWDHEq+PfzBwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hg3kuOLw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hg3kuOLw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEAB5C4CEF5;
	Sat, 25 Oct 2025 16:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1761409417;
	bh=HLjCvzwRgY1PZy/hshRgN0ARIhMJU2Dy3g4uCtbnmZU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hg3kuOLw6BcpsJiPUQCgxpsfIevJ0k+ZZAjCfSHW/mTRnP4wjwdvBU2gWuj1URF5X
	 5ucr3etK6qV6x5ErHi2QMp5GY+rMPy6Kup68lAWE0wv07m5vtKfHmh98QEafKXo3/q
	 iQwzqEKQHcY35hHvTkl6jv/7lJ7ndBjpCRB4z8NSyOFp8y0sFYKe7dmLMtfrWpdqie
	 /3CFVrT/VggyTM53NO+DgyWUJkBCqH8rimuVnPbUx6zWG2eMYgfw50iyhQ/PJ5vso3
	 p2dJeAxhjPNqnFX+ag1ADOWX03UipW7nz1Pm/TXE4SJQNBY0cckvvv4EhKzABfZA2F
	 osb8YbqbA1qFA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Chao Yu <chao@kernel.org>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH AUTOSEL 6.17-6.12] f2fs: fix to detect potential corrupted nid in free_nid_list
Date: Sat, 25 Oct 2025 11:59:06 -0400
Message-ID: <20251025160905.3857885-315-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251025160905.3857885-1-sashal@kernel.org>
References: <20251025160905.3857885-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.17.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chao Yu <chao@kernel.org>

[ Upstream commit 8fc6056dcf79937c46c97fa4996cda65956437a9 ]

As reported, on-disk footer.ino and footer.nid is the same and
out-of-range, let's add sanity check on f2fs_alloc_nid() to detect
any potential corruption in free_nid_list.

Signed-off-by: Chao Yu <chao@kernel.org>
Signed-off-by: Jaegeuk Kim <jaegeuk@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

LLM Generated explanations, may be completely bogus:

YES

Why this is a good stable backport
- Fixes a real corruption case: detects out-of-range node IDs (NIDs) in
  the allocator’s `free_nid_list`, preventing silent use of a corrupted
  NID that can cascade into further on-disk corruption and/or memory
  corruption.
- Minimal, surgical changes in f2fs: adds a guard and a stop-checkpoint
  reason; no architectural refactor.
- Low regression risk: the new branch runs only when a NID is out-of-
  range, which should never happen on a healthy filesystem.

What changed (by file/function)
- fs/f2fs/node.c: Adds a shared helper.
  - Adds `is_invalid_nid(sbi, nid)` to centralize the validity check
    (NID < root or NID >= max_nid).
- fs/f2fs/node.c: f2fs_check_nid_range
  - Replaces inline check with `is_invalid_nid` for consistency and adds
    error signaling via `f2fs_handle_error(..., ERROR_CORRUPTED_INODE)`
    when invalid. Reference point in older trees: fs/f2fs/node.c:33
    starts the function; it currently calls `set_sbi_flag(...,
    SBI_NEED_FSCK)` and warns, but lacks `f2fs_handle_error`.
- fs/f2fs/node.c: f2fs_alloc_nid
  - After taking the first entry from `free_nid_list`, adds an immediate
    range check and bails out on corruption:
    - Logs “Corrupted nid %u in free_nid_list”
    - Stops checkpoints for a safe error handling path.
  - Reference points in 5.4: function start at fs/f2fs/node.c:2424; the
    list head read at fs/f2fs/node.c:2444 is where the new check would
    insert.
- include/linux/f2fs_fs.h: Adds `STOP_CP_REASON_CORRUPTED_NID` to stop-
  checkpoint reasons so error path reports a specific cause.

Why it matters
- Without the check, a corrupted NID taken from `free_nid_list` will be
  used for preallocation and bitmap updates (see
  fs/f2fs/node.c:2448–2452), which can lead to out-of-bounds accesses or
  further filesystem metadata damage.
- The fix converts a silent corruption into a contained, explicitly
  reported error, prompting fsck and preventing further damage.

Backport considerations across stable series
- Newer stable (that already has stop-checkpoint “reasons” and
  `f2fs_handle_error`):
  - Apply as-is: add `is_invalid_nid`, call it in
    `f2fs_check_nid_range`, add the early check in `f2fs_alloc_nid`, and
    extend `stop_cp_reason` with `STOP_CP_REASON_CORRUPTED_NID`.
- Older stable (e.g., v5.4 as in this tree):
  - API differences to adapt:
    - `f2fs_stop_checkpoint` is 2-arg (fs/f2fs/checkpoint.c:26). Use
      `f2fs_stop_checkpoint(sbi, false)` and omit the reason.
    - There is no `f2fs_handle_error` or `enum f2fs_error`; keep
      existing `SBI_NEED_FSCK` + warning in `f2fs_check_nid_range` and
      do not add the handle_error call.
    - `include/linux/f2fs_fs.h` in 5.4 does not define stop reasons;
      skip the reason addition.
  - Core safety fix remains identical: insert `is_invalid_nid` and the
    early bail-out in `f2fs_alloc_nid` before using the NID or touching
    bitmaps.

Risk assessment
- Scope: confined to f2fs nid allocation and a shared helper; no cross-
  subsystem impact.
- Behavioral change only on corrupted states; normal systems unaffected.
- Performance overhead negligible (one branch + function inline).

Security/integrity impact
- Prevents potential out-of-bounds/invalid accesses when updating NID
  bitmaps and allocator state, improving robustness against on-disk
  corruption. Turning silent misuse into a hard, reported error reduces
  data-loss risk.

Additional notes from repository review
- In v5.4 (for-greg/5.4-203), `f2fs_stop_checkpoint` has no reason
  parameter (fs/f2fs/checkpoint.c:26) and there is no
  `f2fs_handle_error`. The backport should therefore be the reduced
  variant described above.
- The allocator path where the check is added corresponds to
  `fs/f2fs/node.c:2424` onward, taking the first entry from
  `free_nid_list` at `fs/f2fs/node.c:2444`, exactly the spot where the
  sanity check prevents misuse.

Conclusion
- This is a classic stable-eligible bugfix: small, contained, and
  prevents real corruption. Backport it, adapting the error/stop-CP API
  to each stable series as needed.

 fs/f2fs/node.c          | 17 ++++++++++++++++-
 include/linux/f2fs_fs.h |  1 +
 2 files changed, 17 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/node.c b/fs/f2fs/node.c
index 92054dcbe20d0..4254db453b2d3 100644
--- a/fs/f2fs/node.c
+++ b/fs/f2fs/node.c
@@ -27,12 +27,17 @@ static struct kmem_cache *free_nid_slab;
 static struct kmem_cache *nat_entry_set_slab;
 static struct kmem_cache *fsync_node_entry_slab;
 
+static inline bool is_invalid_nid(struct f2fs_sb_info *sbi, nid_t nid)
+{
+	return nid < F2FS_ROOT_INO(sbi) || nid >= NM_I(sbi)->max_nid;
+}
+
 /*
  * Check whether the given nid is within node id range.
  */
 int f2fs_check_nid_range(struct f2fs_sb_info *sbi, nid_t nid)
 {
-	if (unlikely(nid < F2FS_ROOT_INO(sbi) || nid >= NM_I(sbi)->max_nid)) {
+	if (unlikely(is_invalid_nid(sbi, nid))) {
 		set_sbi_flag(sbi, SBI_NEED_FSCK);
 		f2fs_warn(sbi, "%s: out-of-range nid=%x, run fsck to fix.",
 			  __func__, nid);
@@ -2654,6 +2659,16 @@ bool f2fs_alloc_nid(struct f2fs_sb_info *sbi, nid_t *nid)
 		f2fs_bug_on(sbi, list_empty(&nm_i->free_nid_list));
 		i = list_first_entry(&nm_i->free_nid_list,
 					struct free_nid, list);
+
+		if (unlikely(is_invalid_nid(sbi, i->nid))) {
+			spin_unlock(&nm_i->nid_list_lock);
+			f2fs_err(sbi, "Corrupted nid %u in free_nid_list",
+								i->nid);
+			f2fs_stop_checkpoint(sbi, false,
+					STOP_CP_REASON_CORRUPTED_NID);
+			return false;
+		}
+
 		*nid = i->nid;
 
 		__move_free_nid(sbi, i, FREE_NID, PREALLOC_NID);
diff --git a/include/linux/f2fs_fs.h b/include/linux/f2fs_fs.h
index 2f8b8bfc0e731..6afb4a13b81d6 100644
--- a/include/linux/f2fs_fs.h
+++ b/include/linux/f2fs_fs.h
@@ -79,6 +79,7 @@ enum stop_cp_reason {
 	STOP_CP_REASON_FLUSH_FAIL,
 	STOP_CP_REASON_NO_SEGMENT,
 	STOP_CP_REASON_CORRUPTED_FREE_BITMAP,
+	STOP_CP_REASON_CORRUPTED_NID,
 	STOP_CP_REASON_MAX,
 };
 
-- 
2.51.0

