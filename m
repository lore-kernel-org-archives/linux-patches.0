Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141702222C0;
	Wed, 28 May 2025 21:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748469365; cv=none; b=HeoF477AVeMVzmSoO9TPK2sWSShb51MP8jv+fyPzNsevlEElCBiH38SVGGDcwP9BqGdIcDsdOYJE/G7wWqsLYRiC1345l3/GxCl0e51ytwybuAz1MCAf2azyfy+gOqghlBgrvE8DutBmvsuw3mpE75xlbmXd4lors9Bt/8nw3kM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748469365; c=relaxed/simple;
	bh=RE/1u9tgyzo2KmhB5zxVsYLNwK17EEod+lDT8ZsXa8k=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=HzZjWim2a1KMIl6p5pX9IGfd3ibIrdcK1Ncr0AtX1PewD1S7AgeHXdCcsU08zSAzJiqWe2lQF6JWtGpxwAmoR9gS3FjtLL4PzUTcVewQVxQj2EjIaV4ylVCkhSh2XwgFMJeXx+YVSk5hU9+QOXALdfekiHZy33BHZkynj9NX6b8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gaT9g+Hn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gaT9g+Hn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B730C4CEE3;
	Wed, 28 May 2025 21:56:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1748469364;
	bh=RE/1u9tgyzo2KmhB5zxVsYLNwK17EEod+lDT8ZsXa8k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gaT9g+HnhSGj452TVJsCGck0LZRFyib/sd92rr+qkutBtZZzzi0ZtknfrysqZepzO
	 mCGA3pUhsP7HazrsiqRVkJdiKL+lBWrpkNvnHuzDPtGZkMGAp8JhD1vFQ9PAJftIcl
	 UTK1mcNzk6C2WFprjleuS8caDQxBv+8e31TYJx03I7hj4MOdXdjaQxZqWv6I5QJM01
	 jAUaJ10SWIHndFsT+OH6eyEblUEreaJflXCnyoG2W4pJu+BXWiZ6jGAQLqdjprdXIJ
	 v63lotYp5auvb2EaLO8DF7X13BPeFZvVCdQTPMu6g+BJjJFCzIsNmpvzISP5/lfRtr
	 e/a4uyYQtZMJw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	rpeterso@redhat.com,
	agruenba@redhat.com,
	cluster-devel@redhat.com,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 6.15 4/9] gfs2: pass through holder from the VFS for freeze/thaw
Date: Wed, 28 May 2025 17:55:54 -0400
Message-Id: <20250528215559.1983214-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250528215559.1983214-1-sashal@kernel.org>
References: <20250528215559.1983214-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.15
Content-Transfer-Encoding: 8bit

From: Christian Brauner <brauner@kernel.org>

[ Upstream commit 62a2175ddf7e72941868f164b7c1f92e00f213bd ]

The filesystem's freeze/thaw functions can be called from contexts where
the holder isn't userspace but the kernel, e.g., during systemd
suspend/hibernate. So pass through the freeze/thaw flags from the VFS
instead of hard-coding them.

Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---

**YES** This commit should be backported to stable kernel trees.
**Extensive explanation:** **1. Fixes a real user-affecting bug:** The
commit addresses a concrete functional issue where GFS2 filesystems
could malfunction during system suspend/hibernate operations. When
systemd or other kernel components initiate freeze/thaw operations with
`FREEZE_HOLDER_KERNEL`, but GFS2 internally hard-codes
`FREEZE_HOLDER_USERSPACE`, this creates a mismatch that can cause
freeze/thaw operations to fail or behave incorrectly. **2. Small and
contained change:** The fix is minimal and surgical: - Only changes
parameter passing through the call chain - No algorithmic or
architectural changes - Changes are confined to the GFS2 subsystem -
Simply replaces hard-coded `FREEZE_HOLDER_USERSPACE` with the correct
`who` parameter **3. Low regression risk:** - The change maintains exact
same behavior for userspace-initiated freezes (the most common case) -
Only affects the less common kernel-initiated freeze scenarios - No
changes to core logic, just parameter propagation - All existing
userspace freeze/thaw workflows remain unchanged **4. Critical subsystem
impact:** Freeze/thaw operations are fundamental to system
suspend/hibernate functionality. A broken implementation can prevent
proper system power management, which is a critical feature for laptops
and mobile devices. **5. Follows stable tree criteria:** - **Fixes
important functionality**: System suspend/hibernate with GFS2
filesystems - **Minimal scope**: Changes only parameter passing, no new
features - **Well-contained**: Limited to fs/gfs2/super.c - **Clear
purpose**: Explicitly described fix for kernel vs userspace freeze
holder mismatch **6. Comparison with reference commits:** This matches
the pattern of **Similar Commit #1** and **Similar Commit #5** which
were marked YES: - Simple functional fix - Small, targeted change - No
architectural modifications - Addresses specific user-visible issue
Unlike the NO commits which involved more complex structural changes,
cleanups, or major refactoring, this is a straightforward bug fix. **7.
Evidence from kernel context:** The examination of
`/home/sasha/linux/include/linux/fs.h` confirms that
`FREEZE_HOLDER_KERNEL` is a legitimate and expected freeze holder type
used by kernel components, making this fix necessary for correct
operation.

 fs/gfs2/super.c | 14 ++++++++------
 1 file changed, 8 insertions(+), 6 deletions(-)

diff --git a/fs/gfs2/super.c b/fs/gfs2/super.c
index 44e5658b896c8..a3fe95e519cbc 100644
--- a/fs/gfs2/super.c
+++ b/fs/gfs2/super.c
@@ -674,7 +674,7 @@ static int gfs2_sync_fs(struct super_block *sb, int wait)
 	return sdp->sd_log_error;
 }
 
-static int gfs2_do_thaw(struct gfs2_sbd *sdp)
+static int gfs2_do_thaw(struct gfs2_sbd *sdp, enum freeze_holder who)
 {
 	struct super_block *sb = sdp->sd_vfs;
 	int error;
@@ -682,7 +682,7 @@ static int gfs2_do_thaw(struct gfs2_sbd *sdp)
 	error = gfs2_freeze_lock_shared(sdp);
 	if (error)
 		goto fail;
-	error = thaw_super(sb, FREEZE_HOLDER_USERSPACE);
+	error = thaw_super(sb, who);
 	if (!error)
 		return 0;
 
@@ -710,7 +710,7 @@ void gfs2_freeze_func(struct work_struct *work)
 	gfs2_freeze_unlock(sdp);
 	set_bit(SDF_FROZEN, &sdp->sd_flags);
 
-	error = gfs2_do_thaw(sdp);
+	error = gfs2_do_thaw(sdp, FREEZE_HOLDER_USERSPACE);
 	if (error)
 		goto out;
 
@@ -728,6 +728,7 @@ void gfs2_freeze_func(struct work_struct *work)
 /**
  * gfs2_freeze_super - prevent further writes to the filesystem
  * @sb: the VFS structure for the filesystem
+ * @who: freeze flags
  *
  */
 
@@ -744,7 +745,7 @@ static int gfs2_freeze_super(struct super_block *sb, enum freeze_holder who)
 	}
 
 	for (;;) {
-		error = freeze_super(sb, FREEZE_HOLDER_USERSPACE);
+		error = freeze_super(sb, who);
 		if (error) {
 			fs_info(sdp, "GFS2: couldn't freeze filesystem: %d\n",
 				error);
@@ -758,7 +759,7 @@ static int gfs2_freeze_super(struct super_block *sb, enum freeze_holder who)
 			break;
 		}
 
-		error = gfs2_do_thaw(sdp);
+		error = gfs2_do_thaw(sdp, who);
 		if (error)
 			goto out;
 
@@ -796,6 +797,7 @@ static int gfs2_freeze_fs(struct super_block *sb)
 /**
  * gfs2_thaw_super - reallow writes to the filesystem
  * @sb: the VFS structure for the filesystem
+ * @who: freeze flags
  *
  */
 
@@ -814,7 +816,7 @@ static int gfs2_thaw_super(struct super_block *sb, enum freeze_holder who)
 	atomic_inc(&sb->s_active);
 	gfs2_freeze_unlock(sdp);
 
-	error = gfs2_do_thaw(sdp);
+	error = gfs2_do_thaw(sdp, who);
 
 	if (!error) {
 		clear_bit(SDF_FREEZE_INITIATOR, &sdp->sd_flags);
-- 
2.39.5

